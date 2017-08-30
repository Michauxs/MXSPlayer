//
//  MXSTableViewCell.m
//  MXSPlayer
//
//  Created by Alfred Yang on 29/8/17.
//  Copyright © 2017年 MXS. All rights reserved.
//

#import "MXSTableViewCell.h"

@implementation MXSTableViewCell {
	
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
	}
	return self;
}

- (void)setCellInfo:(id)cellInfo {
	_cellInfo = cellInfo;
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	
}

@end
