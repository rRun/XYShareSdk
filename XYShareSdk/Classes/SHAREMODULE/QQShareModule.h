//
//  QQShareModule.h
//  Pods
//
//  Created by 何霞雨 on 16/9/23.
//
//

#import "ShareModule.h"

//modeluName
static NSString * const QQ_FRIEND = @"QQ_FRIEND";//qq朋友
static NSString * const QQ_SPACE = @"QQ_SPACE";//qq朋友圈

//腾讯分享的插件
@interface QQShareModule : ShareModule
-(instancetype)initWithKey:(NSString *)key;
@end
