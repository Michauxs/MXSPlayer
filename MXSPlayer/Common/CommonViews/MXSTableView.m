//
//  MXSTableView.m
//  MXSPlayer
//
//  Created by Alfred Yang on 29/8/17.
//  Copyright © 2017年 MXS. All rights reserved.
//

#import "MXSTableView.h"

@implementation MXSTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style andDelegate:(MXSDelegateBase *)dlg {
	self = [super initWithFrame:frame style:style];
	if (self) {
		self.dlg = dlg ? dlg : [[MXSDelegateBase alloc] init];
		self.delegate = self.dlg;
		self.dataSource = self.dlg;
		
		self.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
	return self;
}

- (void)registerClsaaWithName:(NSString *)class_name {
	[self registerClass:NSClassFromString(class_name) forCellReuseIdentifier:class_name];
	self.dlg.cellName = class_name;
}

@end
