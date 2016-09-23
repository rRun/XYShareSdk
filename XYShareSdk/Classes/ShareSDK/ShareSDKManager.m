//
//  ShareSDKManager.m
//  Pods
//
//  Created by 何霞雨 on 16/9/23.
//
//

#import "ShareSDKManager.h"


@interface ShareSDKManager()

@property (nonatomic,copy)SharedSuccessBlock successBlock;
@property (nonatomic,copy)SharedFailBlock failBlock;

@end

@implementation ShareSDKManager

#pragma mark - Public

//初始化单例
static ShareSDKManager* _instance = nil;
+(instancetype)sharedManager{
    
    static dispatch_once_t onceToken ;
    
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    
    return _instance ;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//添加分享组件是否成功
-(BOOL)addModule:(ShareModule *)module withSchema:(NSString *)moduleName{
    if (!module || [moduleName length]<=0) {
        return NO;
    }
    NSMutableArray * temp = [NSMutableArray new];
    if ([self.shareModules count]>0) {
        [temp addObjectsFromArray:self.shareModules];
    }
    
    for (ShareModule *module in temp) {
        if ([module.shcema isEqualToString:moduleName]) {
            return NO;
        }
    }
    
    [module setShareModuleSchema:moduleName];
    
    if (![module respondsToSelector:@selector(setUp)]) {
        return NO;
    }
    if (![module setUp]) {
        return NO;
    }
    _shareModules = [NSArray arrayWithArray:temp];
    
    return YES;
}

//分享
-(void)share:(NSString*)schemaName Data:(ShareDataModel *) model SuccessBlock:(SharedSuccessBlock)successBlock FailBlock:(SharedFailBlock)failBlock{
    
    self.successBlock = successBlock;
    self.failBlock = failBlock;
    
    if ([schemaName length]<=0 || [_shareModules count]==0) {
        return;
    }
    
    ShareModule *shareModule = nil;
    for (ShareModule *module in _shareModules) {
        if ([module.shcema isEqualToString:schemaName]) {
            shareModule = module;
            break;
        }
    }
    
    if (shareModule == nil) {
        return;
    }
    
    [shareModule share:model];
}

#pragma mark - Private
//需要在appdelegate 回调中实现<- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url >
-(void)handleShareUrl:(NSURL *)url{
    NSString *urlSchame = url.scheme;
    
    if ([urlSchame length]<=0 || [_shareModules count]==0) {
        return;
    }
    
    ShareModule *shareModule = nil;
    for (ShareModule *module in _shareModules) {
        if ([module.shcema isEqualToString:urlSchame]) {
            shareModule = module;
            break;
        }
    }
    
    if (shareModule == nil) {
        return;
    }
    
    [shareModule handleUrl:url SuccessBlock:self.successBlock FailBlock:self.failBlock];
    
}

@end
