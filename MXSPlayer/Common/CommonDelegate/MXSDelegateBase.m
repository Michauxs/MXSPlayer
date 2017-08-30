//
//  MXSDelagateBase.m
//  MXSPlayer
//
//  Created by Alfred Yang on 29/8/17.
//  Copyright © 2017年 MXS. All rights reserved.
//

#import "MXSDelegateBase.h"

@implementation MXSDelegateBase {
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if ([_dlgData isKindOfClass:[NSArray class]]) {
		return ((NSArray*)_dlgData).count;
	} else if ([_dlgData isKindOfClass:[NSNumber class]]) {
		return ((NSNumber*)_dlgData).integerValue;
	} else {
		return 1;
	}
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
//	Class c = NSClassFromString(factoryName);
//	Method m = class_getClassMethod(c, @selector(factoryInstance));//获取类方法
//	IMP im = method_getImplementation(m);
//	fac = im(c, @selector(factoryInstance));
	
	MXSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellName forIndexPath:indexPath];
	
	cell.cellInfo = [_dlgData objectAtIndex:indexPath.row];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 64.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id args = [NSNumber numberWithInteger:indexPath.row];
	
	SEL sel = NSSelectorFromString(@"tableViewDidSelectRowAtIndexPath:");
	Method m = class_getInstanceMethod([_controller class], sel);
	if (m) {
		IMP imp = method_getImplementation(m);
		id (*func)(id, SEL, id) = (id (*)(id, SEL, id))imp;
		func(_controller, sel, args);
	}
}

@end
