//
//  MXSHomeVC.m
//  MXSTest
//
//  Created by Alfred Yang on 21/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSHomeVC.h"
#import "MXSTableView.h"
#import "MXSFileWatcher.h"
#import "VideoModel.h"
#import "MXSVideoPlayerVC.h"

@implementation MXSHomeVC {
	MXSTableView *fileTableView;
	NSMutableArray *dataModelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [Tools whiteColor];
	
	fileTableView = [[MXSTableView alloc] initWithFrame:CGRectMake(0, kSTATUSANDNAVHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - kSTATUSANDNAVHEIGHT) style:UITableViewStylePlain andDelegate:nil];
	[self.view addSubview:fileTableView];
	
	[fileTableView registerClsaaWithName:@"MXSHomeCell"];
	
	fileTableView.dlg.controller = self;
	
	[[MXSFileWatcher shared] startManager];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:RefreshiTunesUINotification object:nil];
}

- (void)refreshUI {
	[self getiTunesVideo];
}

- (void)getiTunesVideo { //根据数据有无，判断控件的显示
	
	dispatch_async(dispatch_get_main_queue(), ^{
		dataModelArray = [[NSMutableArray alloc] initWithArray:[MXSFileWatcher shared].dataSource];
		NSLog(@"videos:%@", dataModelArray);
		
		fileTableView.dlg.dlgData = [dataModelArray copy];
		[fileTableView reloadData];
	});
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)didSelectedFunc:(NSString*)funcName andArgs:(id)args {
	
	SEL sel = NSSelectorFromString(funcName);
	Method m = class_getInstanceMethod([self class], sel);
	if (m) {
		IMP imp = method_getImplementation(m);
		id (*func)(id, SEL, id) = (id (*)(id, SEL, id))imp;
		func(self, sel, args);
	}
	
//	SEL sel = NSSelectorFromString(message_name);
//	Method m = class_getInstanceMethod([controller class], sel);
//	if (m) {
//		id (*func)(id, SEL, id) = (id(*)(id, SEL, id))method_getImplementation(m);
//		func(controller, sel, args);
//	}
}

- (id)tableViewDidSelectRowAtIndexPath:(id)args {
	NSNumber *row = args;
	NSLog(@"%ld", row.integerValue);
	
	VideoModel *model = [dataModelArray objectAtIndex:row.integerValue];
	MXSVideoPlayerVC *playVC = [[MXSVideoPlayerVC alloc] init];
	playVC.videoPath = model.videoPath;
	
//	[self.navigationController pushViewController:playVC animated:YES];
	[self presentViewController:playVC animated:YES completion:nil];
	
	return nil;
}

@end
