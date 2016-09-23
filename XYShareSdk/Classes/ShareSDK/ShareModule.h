//
//  ShareModule.h
//  Pods
//
//  Created by 何霞雨 on 16/9/23.
//
//

#import <Foundation/Foundation.h>

@class ShareSDKManager;
@class ShareModule;
@class ShareDataModel;

typedef void (^SharedSuccessBlock)(ShareModule *module);//分享成功回调
typedef void (^SharedFailBlock)(ShareModule *module,NSError *error);//分享失败回调

//分享组件的父亲
@interface ShareModule : NSObject
//组件的url跳转的shcema
@property (nonatomic,strong,readonly)NSString *shcema;


//每一个module需要重写,初始化分享的组件
-(BOOL)setUp;
//每一个module需要重写,根据model分享
-(void)share:(ShareDataModel *)model;
//每一个module需要重写,处理回调
-(void)handleUrl:(NSURL *)url SuccessBlock:(SharedSuccessBlock)successBlock FailBlock:(SharedFailBlock)failBolck ;

//private : 不需要重写或改写
-(void)setShareModuleSchema:(NSString *)name;

@end
