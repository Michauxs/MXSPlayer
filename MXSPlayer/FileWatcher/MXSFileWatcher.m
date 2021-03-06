//
//  FileWatcher.m
//  GetLocalVideo
//
//  Created by Charles.Yao on 2016/11/11.
//  Copyright © 2016年 Charles.Yao All rights reserved.
//

#import "MXSFileWatcher.h"

dispatch_queue_t fileWatcher_queue() {
    static dispatch_queue_t as_fileWatcher_queue;
    static dispatch_once_t onceToken_fileWatcher;
    dispatch_once(&onceToken_fileWatcher, ^{
        as_fileWatcher_queue = dispatch_queue_create("fileWatcher.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return as_fileWatcher_queue;
}

@interface MXSFileWatcher ()

@property (nonatomic, strong) dispatch_source_t source;
@property (nonatomic, strong) NSMutableArray *videoNameArr;
@property (nonatomic, assign) BOOL isConvenientFinished; //遍历完成

@property (nonatomic, strong) NSArray *suffixArr;
@end

@implementation MXSFileWatcher

static MXSFileWatcher *_instance;

+ (id)allocWithZone:(NSZone *)zone {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_instance = [super allocWithZone:zone];
	});
	return _instance;
}

+ (MXSFileWatcher *)shared {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_instance = [[self alloc] init];
	});
	return _instance;
}

- (NSArray*)suffixArr {
	if (!_suffixArr) {
		_suffixArr = @[@"mp4", @"mov", @"m4v", @"rmvb", @"rmv"];
	}
	return _suffixArr;
}

- (void)startManager {
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.videoNameArr = [[NSMutableArray alloc] init];
    
    self.isFinishedCopy = YES;  //此标识是监听
    self.isConvenientFinished = YES;
    
    [self getiTunesVideo];
    [self startMonitorFile];
    
}

- (void)stopManager {
    dispatch_cancel(self.source);
}

- (void)startMonitorFile {  //监听Document文件夹的变化
    
    NSURL *directoryURL = [NSURL URLWithString:[SandBoxHelper docPath]]; //添加需要监听的目录
    int const fd = open([[directoryURL path] fileSystemRepresentation], O_EVTONLY);
    if (fd < 0) {
        NSLog(@"Unable to open the path = %@", [directoryURL path]);
        return;
    }
    
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, fd,
													  DISPATCH_VNODE_WRITE,
													  DISPATCH_TARGET_QUEUE_DEFAULT);
    dispatch_source_set_event_handler(source, ^() {
        unsigned long const type = dispatch_source_get_data(source);
        switch (type) {
            case DISPATCH_VNODE_WRITE: {
                NSLog(@"Document目录内容发生变化!!!");
                if (self.isConvenientFinished) {
                    self.isConvenientFinished = NO;
                    [self directoryDidChange];
                }
                break;
            }
            default:
                break;
        }
    });
    
    dispatch_source_set_cancel_handler(source, ^{
        close(fd);
    });
    
    self.source = source;
    dispatch_resume(self.source);
}

#pragma mark 检索是不是通过iTunes导入视频引起的调用
- (void)directoryDidChange {
    [self getiTunesVideo];
}

- (void)getiTunesVideo {
    
    dispatch_async(fileWatcher_queue(), ^{
		
        NSFileManager *fileManager = [NSFileManager defaultManager];
		
        //在这里获取应用程序Documents文件夹里的文件及文件夹列表
        NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
		
        NSError *error = nil;
		//fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
        NSArray *fileNameList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:documentDir error:&error]];
		
		for (NSString *fileName in fileNameList) {
			if ([self.suffixArr containsObject:[[fileName componentsSeparatedByString:@"."] lastObject]]) {
				
				NSString *videoPath = [documentDir stringByAppendingPathComponent:fileName];
				NSArray *lyricArr = [videoPath componentsSeparatedByString:@"/"];
				NSString *nameStr = [lyricArr lastObject];
				
				if (![self.videoNameArr containsObject:nameStr]) {
					[self.videoNameArr addObject:nameStr];
					
					/*==============循环判断是否复制完成==============*/
					NSInteger lastSize = 0;
					NSDictionary *fileAttrs = [fileManager attributesOfItemAtPath:videoPath error:nil];
					NSInteger fileSize = [[fileAttrs objectForKey:NSFileSize] intValue];
					do {
						lastSize = fileSize;
						[NSThread sleepForTimeInterval:0.5];
						self.isFinishedCopy = NO;
						
						fileAttrs = [fileManager attributesOfItemAtPath:videoPath error:nil];
						fileSize = [[fileAttrs objectForKey:NSFileSize] intValue];
						NSLog(@"正在复制文件:%@", nameStr);
					} while (lastSize != fileSize);
					
					self.isFinishedCopy = YES;
					NSLog(@"文件复制完成:%@", nameStr);
					
					VideoModel *model = [[VideoModel alloc] init];
					model.videoPath = videoPath;
					model.videoName = nameStr;
					model.videoSize = [SandBoxHelper fileSizeForPath:videoPath];
					model.videoImgPath = [self saveImg:nil withVideoMid:nameStr];
					model.videoAsset = nil;
//					model.videoImgPath = [self saveImg:[UIImage getThumbnailImage:videoPath] withVideoMid:[NSString stringWithFormat:@"%lld", model.videoSize]];
					
					[self.dataSource addObject:model];
					
				}
				[[NSNotificationCenter defaultCenter] postNotificationName:RefreshiTunesUINotification object:nil];
			}
		}
		//		 *模拟器：查看log日志前往APP／Documents文件夹 拖入.mp4，即可自动检测导入table
		//		 *真机：在iTunes中找到APP添加video文件
		
        self.isConvenientFinished = YES;
    });
}

- (void)deleteiTunesVideo:(NSArray *)array {
    
    for (VideoModel *item in array) {
        [self.dataSource removeObject:item];
        [SandBoxHelper deleteFile:item.videoPath];
        [SandBoxHelper deleteFile:item.videoImgPath];
        [self.videoNameArr removeObject:item.videoName];
    }
}

- (NSString *)saveImg:(UIImage *)image withVideoMid:(NSString *)videoMid{
    
    if (!image) {
        image = [UIImage imageNamed:@"posters_default_horizontal"];
    }
    if (!videoMid) {
        videoMid = [Tools getUUIDString];
    }
	
    NSData *imagedata = UIImagePNGRepresentation(image);	//png格式
	NSString *imageName = [NSString stringWithFormat:@"%@.png", videoMid];
    NSString *savedImagePath = [[SandBoxHelper iTunesVideoImagePath] stringByAppendingPathComponent:imageName];
    
    [imagedata writeToFile:savedImagePath atomically:YES];
    
    return savedImagePath;
    
}


@end
