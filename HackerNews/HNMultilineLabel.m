//
//  MultilineLabel.m
//  IncorrectHeight
//
//  Created by Jeff Nouwen on 10/15/2014.
//  Copyright (c) 2014 Jeff Nouwen. All rights reserved.
//

#import "HNMultilineLabel.h"

@implementation HNMultilineLabel

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if( self )
	{
		[self commonInit];
	}
	
	return self;
}

- (instancetype)init
{
	return [self initWithFrame:CGRectZero];
}

- (void)awakeFromNib
{
	[self commonInit];
}

- (void)commonInit
{
	self.numberOfLines = 0;
	self.lineBreakMode = NSLineBreakByWordWrapping;
}

#pragma mark -

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.preferredMaxLayoutWidth = CGRectGetWidth( self.frame );
}

@end
