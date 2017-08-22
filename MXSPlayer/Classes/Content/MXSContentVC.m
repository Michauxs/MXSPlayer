//
//  MXSContentVC.m
//  MXSTest
//
//  Created by Alfred Yang on 21/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSContentVC.h"
#import <objc/runtime.h>
#import "MXSWebDianpingHandle.h"

@implementation MXSContentVC {
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIButton *ComeOnBtn = [Tools creatUIButtonWithTitle:@"GO!" andTitleColor:[Tools whiteColor] andFontSize:14.f andBackgroundColor:[Tools themeColor]];
	ComeOnBtn.layer.cornerRadius = 20.f;
	ComeOnBtn.clipsToBounds = YES;
	[self.view addSubview:ComeOnBtn];
	[ComeOnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(80, 40));
	}];
	[ComeOnBtn addTarget:self action:@selector(didComeOnBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
}
	
- (void)didComeOnBtnClick {
	
	
	
//	[MXSFileHandle transPlistToJsonWithPlistFile:@"courses_nursery" andJsonFile:@"courses_nursery"];
}

- (void)getWebDZNode {
	
	NSString *urlStr;
	//教育
	//	NSString *categaryUrlStr = @"https://www.dianping.com/search/category/2/70/g188";
	//	NSString *fileName = @"urlList_education";
	
	//	//托班
	NSString *categaryUrlStr = @"http://www.dianping.com/search/category/2/70/g20009";
	NSString *fileName = @"urlList_nursery";
	fileName = @"urlList_nap";
	
	//才艺
	//	NSString *categaryUrlStr = @"http://www.dianping.com/search/category/2/70/g27763";
	//	NSString *fileName = @"urlList_art";
	
	NSMutableArray *courseList = [NSMutableArray array];
	for (int i = 1; i < 11; ++i) {
		urlStr = [NSString stringWithFormat:@"%@p%d", categaryUrlStr, i];
		NSArray *subServArr_p = [MXSWebDianpingHandle handUrlListFromCategoryUrl:urlStr];
		[courseList addObjectsFromArray:subServArr_p];
	}
	
	[MXSFileHandle writeToPlistFile:courseList withFileName:fileName];
	
	//待存入课程 arr
	NSMutableArray *coursesArr = [NSMutableArray array];
	
	for (NSDictionary *course in courseList) {
		NSString *course_href = [course valueForKey:@"href"];
		
		//课程参数 ：需mutable 追加参数
		NSMutableDictionary *course_args = [[MXSWebDianpingHandle handNodeWithServiceUrl:course_href] mutableCopy];
		NSArray *promoteArr = [course_args objectForKey:@"promotes"];
		
		if (promoteArr.count != 0) {	//没/有推荐课
			
			NSMutableArray *promoteCourseArgsArr = [NSMutableArray array];
			for (NSDictionary *promote in promoteArr) {
				NSString *promote_href = [promote objectForKey:@"promote_href"];
				NSDictionary *promote_course_args = [MXSWebDianpingHandle handNodeWithPromoteUrl:promote_href];
				[promoteCourseArgsArr addObject:promote_course_args];
			}
			
			[course_args setValue:promoteCourseArgsArr forKey:@"promotes_args"];
		} // end .count == 0 ?
		
		[coursesArr addObject:[course_args copy]];
		
	}
	
	[MXSFileHandle writeToPlistFile:[coursesArr copy] withFileName:[NSString stringWithFormat:@"courses_%@", [[fileName componentsSeparatedByString:@"_"] lastObject]]];
	
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	
//	[self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	UITouch *touch = [[touches allObjects] firstObject];
	
	UIImageView *readView = [[UIImageView alloc] init];
	readView.image = IMGRESOURE(@"is_read");
	[self.view addSubview:readView];
	readView.bounds = CGRectMake(0, 0, 120, 120);
	readView.center = [touch locationInView:self.view];
	
	CASpringAnimation * ani = [CASpringAnimation animationWithKeyPath:@"bounds"];
	ani.mass = 10.0; //质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大
	ani.stiffness = 5000; //刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快
	ani.damping = 100.0;//阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快
	ani.initialVelocity = 5.f;//初始速率，动画视图的初始速度大小;速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反
	ani.duration = ani.settlingDuration;
	ani.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 60, 60)];
	ani.removedOnCompletion = NO;
	ani.fillMode = kCAFillModeForwards;
	ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[readView.layer addAnimation:ani forKey:@"boundsAni"];
	
	self.tabBarItem.badgeValue = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end