//
//  ShareButton.m
//  Pods
//
//  Created by lixu on 16/9/23.
//
//

#import "ShareButton.h"

@implementation ShareButton

- (id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		self.titleLabel.textAlignment = NSTextAlignmentCenter;
		self.titleLabel.font = [UIFont systemFontOfSize:11];
		[self setTitleColor:[UIColor colorWithRed:0.44f green:0.44f blue:0.44f alpha:1.00f] forState:UIControlStateNormal];
		[self setTitleColor:[UIColor colorWithRed:0.64f green:0.64f blue:0.64f alpha:1.00f] forState:UIControlStateHighlighted];
	}
	return self;
}


//取消按钮的高亮状态
- (void)setHighlighted:(BOOL)highlighted{
	
}

-(void)layoutSubviews {
	[super layoutSubviews];
	
	// Center image
	CGPoint center = self.imageView.center;
	center.x = self.frame.size.width/2;
	center.y = self.imageView.frame.size.height/2+5;
	self.imageView.center = center;
	
	//Center text
	CGRect newFrame = [self titleLabel].frame;
	newFrame.origin.x = 0;
	newFrame.origin.y = self.imageView.frame.size.height + 10;
	newFrame.size.width = self.frame.size.width;
	
	self.titleLabel.frame = newFrame;
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
