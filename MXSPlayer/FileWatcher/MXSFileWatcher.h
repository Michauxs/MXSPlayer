//
//  FileWatcher.h
//  GetLocalVideo
//
//  Created by Charles.Yao on 2016/11/11.
//  Copyright © 2016年 Charles.Yao All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SandBoxHelper.h"
#import "Notifications.h"
#import "VideoModel.h"

@interface MXSFileWatcher : NSObject

+ (MXSFileWatcher *)shared;

@property (nonatomic, assign) BOOL isFinishedCopy;
@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)startManager;
- (void)stopManager;
- (void)deleteiTunesVideo:(NSArray *)array;

@end
