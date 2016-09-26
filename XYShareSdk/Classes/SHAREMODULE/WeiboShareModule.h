//
//  WeiboShareModule.h
//  Pods
//
//  Created by 何霞雨 on 16/9/23.
//
//

#import "ShareModule.h"

//modeluName
static NSString * const WeiboShare = @"WeChatShare";//微信朋友


//微博分享的插件
@interface WeiboShareModule : ShareModule

-(instancetype)initWithSecrtKey:(NSString *)key;

@end
