//
//  WeiboShareModule.m
//  Pods
//
//  Created by 何霞雨 on 16/9/23.
//
//

#import "WeiboShareModule.h"

//微博分享的插件
@interface WeiboShareModule()

@end

@implementation WeiboShareModule

//每一个module需要重写,初始化分享的组件
-(BOOL)setUp{
    //TODO:
    
    return YES;
}
//每一个module需要重写,根据model分享
-(void)share:(ShareDataModel *)model{
    //TODO:
}
//每一个module需要重写,处理回调
-(void)handleUrl:(NSURL *)url SuccessBlock:(SharedSuccessBlock)successBlock FailBlock:(SharedFailBlock)failBolck {
    //TODO:
}

@end
