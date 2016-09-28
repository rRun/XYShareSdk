//
//  ShareSDKManager.h
//  Pods
//
//  Created by 何霞雨 on 16/9/23.
//
//

#import <Foundation/Foundation.h>

//主框架
#import "ShareDataModel.h"
#import "ShareModule.h"

//子组件
//#import "QQShareModule.h"
#import "WeiboShareModule.h"
#import "WeChatShareModule.h"

//ui框架
#import "ShareView.h"


@interface ShareSDKManager : NSObject

//支持分享的分享组件
@property (nonatomic,strong,readonly) NSArray<ShareModule *>* shareModules;
//默认支持的分享界面
@property (nonatomic,strong)ShareView * shareView;

#pragma mark - Public

//初始化单例
+(instancetype)sharedManager;

//添加分享组件是否成功
-(BOOL)addModule:(ShareModule *)module withModuleName:(NSString *)moduleName;

//分享
-(void)share:(NSString*)moduleName Data:(ShareDataModel *) model SuccessBlock:(SharedSuccessBlock)successBlock FailBlock:(SharedFailBlock)failBlock;

#pragma mark - Private
//需要在appdelegate 回调中实现<- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url >
-(void)handleShareUrl:(NSURL *)url;

#pragma mark - UI
//初始化完后，添加组件后，可以设置默认的分享页面
-(void)setDefaultShareViewWithModuleNames:(NSArray *)moduleNames TitleArray:(NSArray *)titleArray ImageArry:(NSArray *)imageArr ProTitle:(NSString *)protitle;
//分享的时候调用，显示分享页面
-(void)showShareViewWithData:(ShareDataModel *) model SuccessBlock:(SharedSuccessBlock)successBlock FailBlock:(SharedFailBlock)failBlock;
@end
