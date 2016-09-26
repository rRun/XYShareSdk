//
//  ShareSDKManager.m
//  Pods
//
//  Created by 何霞雨 on 16/9/23.
//
//

#import "ShareSDKManager.h"


@interface ShareSDKManager(){
    BOOL isShowedShareView;
}

@property (nonatomic,copy)SharedSuccessBlock successBlock;
@property (nonatomic,copy)SharedFailBlock failBlock;

@property (nonatomic,strong)ShareModule *currentModule;
@property (nonatomic,strong)ShareDataModel *currentModel;

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
-(BOOL)addModule:(ShareModule *)module withModuleName:(NSString *)moduleName{
    if (!module || [moduleName length]<=0) {
        return NO;
    }
    NSMutableArray * temp = [NSMutableArray new];
    if ([self.shareModules count]>0) {
        [temp addObjectsFromArray:self.shareModules];
    }
    
    for (ShareModule *module in temp) {
        if ([module.moduleNames containsObject:moduleName]) {
            return NO;
        }
    }
    
    [module setShareModuleName:moduleName];
    
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
-(void)share:(NSString*)moduleName Data:(ShareDataModel *) model SuccessBlock:(SharedSuccessBlock)successBlock FailBlock:(SharedFailBlock)failBlock{
    
    self.successBlock = successBlock;
    self.failBlock = failBlock;
    
    if ([moduleName length]<=0 || [_shareModules count]==0) {
        return;
    }
    
    ShareModule *shareModule = nil;
    for (ShareModule *module in _shareModules) {
        if ([module.moduleNames containsObject:moduleName]) {
            shareModule = module;
            break;
        }
    }
    
    if (shareModule == nil) {
        return;
    }
    
    self.currentModule = shareModule;
    
    [shareModule share:moduleName Model:model];
}

#pragma mark - Private
//需要在appdelegate 回调中实现<- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url >
-(void)handleShareUrl:(NSURL *)url{
   
    if (self.currentModule) {
        if ([self.currentModule handleUrl:url SuccessBlock:self.successBlock FailBlock:self.failBlock]) {
            return;
        }
    }
    
    NSString *urlSchame = url.scheme;
    if ([urlSchame length]<=0 || [_shareModules count]==0) {
        return;
    }
    
    ShareModule *shareModule = nil;
    for (ShareModule *module in _shareModules) {
        if ([module handleUrl:url SuccessBlock:self.successBlock FailBlock:self.failBlock]) {
            shareModule = module;
            break;
        }
    }
    
    if (shareModule == nil) {
        NSLog(@"未找到分享的组件");
        return;
    }
    
}

#pragma mark - UI
-(void)setDefaultShareViewWithModuleNames:(NSArray *)moduleNames TitleArray:(NSArray *)titleArray ImageArry:(NSArray *)imageArr ProTitle:(NSString *)protitle{
    
    ShareView *shareView = [[ShareView alloc] initShareViewWithTitleArray:titleArray ImageArry:imageArr ProTitle:protitle];
    
    [shareView setBtnClick:^(NSInteger btnTag) {
        NSLog(@"\n点击分享了第%ld个\n%@",btnTag,titleArray[btnTag]);
        NSString *moduleName = moduleNames[btnTag];
        if (!self.currentModel) {
            return ;
        }
        [self share:moduleName Data:self.currentModel SuccessBlock:^(ShareModule *module, NSString *moduleName) {
            if (self.successBlock) {
                self.successBlock(module,moduleName);
            }
        } FailBlock:^(ShareModule *module, NSError *error) {
            if (self.failBlock) {
                self.failBlock(module,error);
            }
        }];
        
        isShowedShareView = NO;
    }];
    
    _shareView = shareView;
}

-(void)showShareViewWithData:(ShareDataModel *) model SuccessBlock:(SharedSuccessBlock)successBlock FailBlock:(SharedFailBlock)failBlock{
    if (!self.shareView) {
        return;
    }
    
    if (isShowedShareView) {
        return;
    }
    isShowedShareView = YES;
    
    self.currentModel = model;
    self.successBlock = successBlock;
    self.failBlock = failBlock;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.shareView];
}
@end
