//
//  MXSTabBarController.m
//  MXSTest
//
//  Created by Alfred Yang on 21/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSTabBarController.h"
#import "MXSHomeVC.h"
#import "MXSContentVC.h"
#import "MXSSettingVC.h"
#import "MXSProfileVC.h"

@interface MXSTabBarController ()

@end

@implementation MXSTabBarController

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	UINavigationController *nav_home = [[UINavigationController alloc]init];
	UINavigationController *nav_con = [[UINavigationController alloc]init];
	UINavigationController *nav_set = [[UINavigationController alloc]init];
	UINavigationController *nav_prof = [[UINavigationController alloc]init];
	
	MXSHomeVC *vc_home = [[MXSHomeVC alloc]init];
	MXSContentVC *vc_con = [[MXSContentVC alloc]init];
	MXSSettingVC *vc_set = [[MXSSettingVC alloc]init];
	MXSProfileVC *vc_prof = [[MXSProfileVC alloc] init];
	
	[nav_home pushViewController:vc_home animated:NO];
	[nav_con pushViewController:vc_con animated:NO];
	[nav_set pushViewController:vc_set animated:NO];
	[nav_prof pushViewController:vc_prof animated:NO];
	
	[self controller:vc_home Title:@"Home" tabBarItemImage:@"tab_icon_0"];
	[self controller:vc_con Title:@"CONT" tabBarItemImage:@"tab_icon_1"];
	[self controller:vc_set Title:@"CENT" tabBarItemImage:@"tab_icon_2"];
	[self controller:vc_prof Title:@"PROF" tabBarItemImage:@"tab_icon_3"];
	
	vc_con.tabBarItem.badgeColor = [UIColor redColor];
	
	self.viewControllers = @[nav_home, nav_con, nav_set, nav_prof];
	
//	self.selectedIndex = 3;
	
}

- (void)controller:(UIViewController *)controller Title:(NSString *)title tabBarItemImage:(NSString *)imageName {
	controller.tabBarItem = [[UITabBarItem alloc] init];
	
	[controller.tabBarItem setTitle:title];
	NSDictionary *attr_color_normal = @{NSFontAttributeName:[UIFont systemFontOfSize:10.f], NSForegroundColorAttributeName:[Tools garyColor]};
	[controller.tabBarItem setTitleTextAttributes:attr_color_normal forState:UIControlStateNormal];
	
	NSDictionary *attr_color_select = @{NSFontAttributeName:[UIFont systemFontOfSize:10.f], NSForegroundColorAttributeName:[Tools themeColor]};
	[controller.tabBarItem setTitleTextAttributes:attr_color_select forState:UIControlStateSelected];
	
	UIImage *image = [UIImage imageNamed:imageName];
	image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	[controller.tabBarItem setImage:image];
	
	UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_select", imageName]];
	selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	[controller.tabBarItem setSelectedImage:selectedImage];
	
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
