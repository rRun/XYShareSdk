//
//  QQShareModule.m
//  Pods
//
//  Created by 何霞雨 on 16/9/23.
//
//

#import "QQShareModule.h"
#import <TencentOpenAPIV2_3/TencentOpenAPI/TencentOAuth.h>


//腾讯分享的插件
@interface QQShareModule()<TencentSessionDelegate,UIAlertViewDelegate>{
    TencentOAuth *_tencentOAuth;
}

@property (nonatomic,strong)NSString *key;

@end

@implementation QQShareModule

-(instancetype)initWithKey:(NSString *)key{
    self = [super init];
    if (self) {
        self.key = key;
    }
    return self;
}
//每一个module需要重写,初始化分享的组件
-(BOOL)setUp{
    //TODO:
    if ([self.key length]<=0) {
        return NO;
    }
    
    _tencentOAuth = [[TencentOAuth alloc]initWithAppId:self.key andDelegate:self];
    
    return YES;
}
//每一个module需要重写,根据model分享
-(void)share:(NSString*)modueleName Model:(ShareDataModel *)model{
    //TODO:
    if(![QQApiInterface isQQInstalled]){
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲！你还没有安装手Q" delegate:self cancelButtonTitle:@"好" otherButtonTitles:@"马上安装", nil] show];
        return;
    }
    if([QQApiInterface isQQSupportApi]){
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲！当前qq版本过低" delegate:self cancelButtonTitle:@"好" otherButtonTitles:@"安装最新手Q", nil] show];
        return;
    }
    
    self.currentModuleName = modueleName;
    
    NSString *urlPath = [model.url stringByAppendingString:@"?type=1"];
    if ([model.url length]<=0) {
        urlPath = [@"http://www.cdfortis.com" stringByAppendingString:@"?type=1"];
    }
    NSString *title = model.title ? model.title :@"";
    NSString *description = model.descript ? model.descript : @"";
    NSData *imageData = UIImagePNGRepresentation(model.image);
    NSData *preImageData = UIImagePNGRepresentation(model.preImage);
    
    SendMessageToQQReq *req = nil;
    QQApiSendResultCode sent = -1;
    if([modueleName isEqualToString:QQ_SPACE]){
        
        QQApiURLObject *newObj = [[QQApiURLObject alloc] initWithURL:[NSURL URLWithString:urlPath] title:title description:description previewImageData:imageData targetContentType:QQApiURLTargetTypeNews];
        
        req = [SendMessageToQQReq reqWithContent:newObj];
        sent = [QQApiInterface SendReqToQZone:req];
        
    }else{
        
        if ([imageData length] > 32 * 1024) {
            QQApiImageObject *img = [QQApiImageObject objectWithData:imageData previewImageData:preImageData title:title description:description];
            req = [SendMessageToQQReq reqWithContent:img];
        }else{
            QQApiURLObject *newObj = [[QQApiURLObject alloc] initWithURL:[NSURL URLWithString:urlPath] title:title description:description previewImageData:imageData targetContentType:QQApiURLTargetTypeNews];
            req = [SendMessageToQQReq reqWithContent:newObj];
        }
        
        sent = [QQApiInterface sendReq:req];
        
    }
}
//每一个module需要重写,处理回调
-(BOOL)handleUrl:(NSURL *)url SuccessBlock:(SharedSuccessBlock)successBlock FailBlock:(SharedFailBlock)failBolck {
    //TODO:
    
    if ([TencentOAuth HandleOpenURL:url]) {
        self.successBlock = successBlock;
        self.failBolck = failBolck;
        return YES;
    }
    
    return NO;
}

#pragma mark - Tool
//没有安装qq 跳转到qq安装
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *downPath;
    if(buttonIndex == 1){
        NSLog(@"%@",[QQApiInterface getQQInstallUrl]);
        downPath = [QQApiInterface getQQInstallUrl];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:downPath]];
    }
    
}

#pragma mark - TencentSessionDelegate
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    NSLog(@"error:1");
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    NSLog(@"error:2");
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    NSLog(@"error:3");
}

- (void)responseDidReceived:(APIResponse*)response forMessage:(NSString *)message{
    if (response.detailRetCode == 0) {
        if (self.successBlock) {
            self.successBlock(self,self.currentModuleName);
        }else{
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:response.errorMsg, NSLocalizedDescriptionKey, nil];
            NSError *error = [[NSError alloc]initWithDomain:@"com.cdfortis.share" code:response.detailRetCode userInfo:userInfo];
            
            if (self.failBolck) {
                self.failBolck(self,error);
            }
        }
    }
}
@end
