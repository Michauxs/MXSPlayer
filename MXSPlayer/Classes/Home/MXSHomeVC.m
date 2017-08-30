//
//  MXSHomeVC.m
//  MXSTest
//
//  Created by Alfred Yang on 21/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSHomeVC.h"
#import "MXSTableView.h"

@implementation MXSHomeVC {
	MXSTableView *fileTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [Tools whiteColor];
	NSArray *querydata = @[@"110", @"120", @"114", @"119"];
	
	fileTableView = [[MXSTableView alloc] initWithFrame:CGRectMake(0, kSTATUSANDNAVHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - kSTATUSANDNAVHEIGHT) style:UITableViewStylePlain andDelegate:nil];
	[self.view addSubview:fileTableView];
	
	[fileTableView registerClsaaWithName:@"MXSHomeCell"];
	
	fileTableView.dlg.dlgData = querydata;
	fileTableView.dlg.controller = self;
	
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
	
	return nil;
}

@end
