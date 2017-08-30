//
//  MXSHomeCell.m
//  MXSPlayer
//
//  Created by Alfred Yang on 29/8/17.
//  Copyright © 2017年 MXS. All rights reserved.
//

#import "MXSHomeCell.h"
#import "VideoModel.h"

@implementation MXSHomeCell {
	UILabel *titleLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		titleLabel = [Tools creatUILabelWithText:nil andTextColor:[Tools blackColor] andFontSize:313.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(self).offset(20);
		}];
		
		[Tools addBtmLineWithMargin:0 andAlignment:NSTextAlignmentCenter andColor:[Tools garyLineColor] inSuperView:self];
	}
	return self;
}

- (void)setCellInfo:(id)cellInfo {
	[super setCellInfo:cellInfo];
	
	titleLabel.text = ((VideoModel*)cellInfo).videoName;
	
}
	
@end
