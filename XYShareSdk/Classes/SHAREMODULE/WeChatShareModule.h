//
//  WeChatShareModule.h
//  Pods
//
//  Created by 何霞雨 on 16/9/23.
//
//

#import "ShareModule.h"

//modeluName
static NSString * const WeChatShare = @"WeChatShare";//微信朋友
static NSString * const WeChatSpaceShare = @"WeChatSpaceShare";//微信朋友圈

//微信分享的插件
@interface WeChatShareModule : ShareModule
-(instancetype)initWithSecrtKey:(NSString *)key;
@end
