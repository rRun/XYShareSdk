//
//  WeChatShareModule.m
//  Pods
//
//  Created by 何霞雨 on 16/9/23.
//
//

#import "WeChatShareModule.h"
#import <WeChatSDK/WXApi.h>

//微信分享的插件
@interface WeChatShareModule()<WXApiDelegate>

@property (nonatomic,strong)NSString *key;
@property (nonatomic,strong)NSString *currentModuleName;

@property (nonatomic,copy)SharedSuccessBlock successBlock;
@property (nonatomic,copy)SharedFailBlock failBolck;


@end

@implementation WeChatShareModule

-(instancetype)initWithSecrtKey:(NSString *)key{
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
    
    return [WXApi registerApp:self.key];
    
}

//每一个module需要重写,根据model分享
-(void)share:(NSString*)modueleName Model:(ShareDataModel *)model{
    //TODO:
    
    if (![WXApi isWXAppInstalled]) {
        
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"" message:@"没有安装微信，请安装后再分享！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerView show];
        
        return;
    }
    
    //分享流程
    WXMediaMessage *message = [WXMediaMessage message];
    if (model.preImage) {
        [message setThumbImage:model.preImage];//缩略图
    }
    
    WXImageObject *imageObject = [WXImageObject object];
    if (model.image) {
        imageObject.imageData =  UIImagePNGRepresentation(model.image);
    }
    message.mediaObject = imageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = model.description;
    
    if ([modueleName isEqualToString:WeChatSpaceShare]) {
        req.scene = WXSceneTimeline;
    }else{
        req.scene = WXSceneSession;
    }
    
    self.currentModuleName = modueleName;
    
    [WXApi sendReq:req];
}

//每一个module需要重写,处理回调
-(BOOL)handleUrl:(NSURL *)url SuccessBlock:(SharedSuccessBlock)successBlock FailBlock:(SharedFailBlock)failBolck {
    //TODO:
    if ([WXApi handleOpenURL:url delegate:self]) {
        self.successBlock = successBlock;
        self.failBolck = failBolck;
        return YES;
    }
   
    return NO;
}

#pragma mark - 

/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req{
    
}


/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp{
    if (resp.errCode == 0) {
        if (self.successBlock) {
            self.successBlock(self,self.currentModuleName);
        }
    }else{
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:resp.errStr, NSLocalizedDescriptionKey, nil];
        NSError *error = [[NSError alloc]initWithDomain:@"com.cdfortis.share" code:resp.errCode userInfo:userInfo];
        
        if (self.failBolck) {
            self.failBolck(self,error);
        }
    }
}
@end
