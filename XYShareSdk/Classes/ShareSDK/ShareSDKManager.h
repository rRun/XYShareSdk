//
//  ShareSDKManager.h
//  Pods
//
//  Created by 何霞雨 on 16/9/23.
//
//

#import <Foundation/Foundation.h>
#import "ShareDataModel.h"
#import "ShareModule.h"


@interface ShareSDKManager : NSObject

//支持分享的分享组件
@property (nonatomic,strong,readonly) NSArray<ShareModule *>* shareModules;

#pragma mark - Public

//初始化单例
+(instancetype)sharedManager;

//添加分享组件是否成功
-(BOOL)addModule:(ShareModule *)module withSchema:(NSString *)moduleName;

//分享
-(void)share:(NSString*)schemaName Data:(ShareDataModel *) model SuccessBlock:(SharedSuccessBlock)successBlock FailBlock:(SharedFailBlock)failBlock;

#pragma mark - Private
//需要在appdelegate 回调中实现<- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url >
-(void)handleShareUrl:(NSURL *)url;

@end
