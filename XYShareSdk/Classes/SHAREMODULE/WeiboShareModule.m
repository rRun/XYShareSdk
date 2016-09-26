//
//  WeiboShareModule.m
//  Pods
//
//  Created by 何霞雨 on 16/9/23.
//
//

#define IOS9 ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)

#import "WeiboShareModule.h"
#import <Weibo/WeiboSDK.h>
#import <Aspects.h>

//微博分享的插件
@interface WeiboShareModule()<WeiboSDKDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)NSString *key;

@end

@implementation WeiboShareModule

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
    
    if (IOS9) {//修复Sina微博iOS9崩溃问题´
        [NSDictionary aspect_hookSelector:NSSelectorFromString(@"weibosdk_WBSDKJSONString")
                              withOptions:AspectPositionInstead
                               usingBlock:^(id<AspectInfo> info)
         {
             
             return  [self dictionaryToJson:[info instance]];
             
         }
                                    error:nil];
    }
    
    [WeiboSDK enableDebugMode:NO];
    [WeiboSDK registerApp:self.key];
    
    return YES;
}
//每一个module需要重写,根据model分享
-(void)share:(NSString*)modueleName Model:(ShareDataModel *)model{
    //TODO:
    if (![WeiboSDK isWeiboAppInstalled]) {
        
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲！你还没有安装微博" delegate:self cancelButtonTitle:@"好" otherButtonTitles:@"马上安装", nil] show];
        
        return;
    }
    
    self.currentModuleName = modueleName;
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = model.url;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare:model]];
    request.userInfo = @{@"ShareMessageFrom": @"cdfortis",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    
    [WeiboSDK sendRequest:request];
    
}
//每一个module需要重写,处理回调 ,返回值：代表是否是该回调处理
-(BOOL)handleUrl:(NSURL *)url SuccessBlock:(SharedSuccessBlock)successBlock FailBlock:(SharedFailBlock)failBolck {
    //TODO:
    
    if ([WeiboSDK handleOpenURL:url delegate:self]) {
        self.successBlock = successBlock;
        self.failBolck = failBolck;
        return YES;
    }
    
    return NO;
}

#pragma mark - Tool
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

//没有安装qq 跳转到qq安装
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *downPath;
    if(buttonIndex == 1){
        NSLog(@"%@",[WeiboSDK getWeiboAppInstallUrl]);
        downPath = [WeiboSDK getWeiboAppInstallUrl];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:downPath]];
    }
}

#pragma mark - Model
-(WBMessageObject *)messageToShare:(ShareDataModel *)model{
    WBMessageObject *message = [WBMessageObject message];
    WBWebpageObject *webpage = [WBWebpageObject object];
    
    NSString *str = [NSString stringWithFormat:@"%@" ,model.descript];
    message.text = str;
    
    NSInteger size = 32 * 1024;
    NSData *imageData = UIImagePNGRepresentation(model.image);
    if ([imageData length] > size) {
        WBImageObject *img = [WBImageObject object];
        img.imageData = imageData;
        message.imageObject = img;
        message.text = [NSString stringWithFormat:@"%@%@",model.descript,model.url];
    }else{
        webpage.objectID = @"identifier1";
        webpage.title = NSLocalizedString(model.title, nil);
        webpage.description = [NSString stringWithFormat:@"%@%@",model.descript,model.url];
        webpage.thumbnailData = imageData;
        webpage.webpageUrl = model.url;
        message.mediaObject = webpage;
    }
    
    return message;
}

#pragma mark - WeiboSDKDelegate
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response;
{    
    if (response.statusCode == 0) {
        if (self.successBlock) {
            self.successBlock(self,self.currentModuleName);
        }
    }else{
        NSDictionary *userInfo = response.userInfo;
        NSError *error = [[NSError alloc]initWithDomain:@"com.cdfortis.share" code:response.statusCode userInfo:userInfo];
        
        if (self.failBolck) {
            self.failBolck(self,error);
        }
    }
}

@end
