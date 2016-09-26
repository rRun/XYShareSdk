//
//  XYViewController.m
//  XYShareSdk
//
//  Created by hexy on 09/22/2016.
//  Copyright (c) 2016 hexy. All rights reserved.
//

#import "XYViewController.h"
#import <XYShareSdk/ShareView.h>

@interface XYViewController ()

@end

@implementation XYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showShareViewAction:(id)sender {
	NSArray *titleArray = @[@"QQ",@"QQ空间",@"微信好友",@"微信朋友圈",@"新浪微博"];
	NSArray *imageArray = @[@"tcentQQ",@"tcentkongjian",@"wechat",@"wechatquan",@"sinaweibo"];
	
	ShareView *shareView = [[ShareView alloc] initShareViewWithTitleArray:titleArray ImageArry:imageArray ProTitle:@"分享到"];
	
	[shareView setBtnClick:^(NSInteger btnTag) {
		NSLog(@"\n点击了第%ld个\n%@",btnTag,titleArray[btnTag]);
		NSString *message = [NSString stringWithFormat:@"\n点击了第%ld个\n%@",btnTag,titleArray[btnTag]];
		[[[UIAlertView alloc]initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
	}];
	[[UIApplication sharedApplication].keyWindow addSubview:shareView];
	
}

@end
