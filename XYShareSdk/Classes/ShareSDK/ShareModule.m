//
//  ShareModule.m
//  Pods
//
//  Created by 何霞雨 on 16/9/23.
//
//

#import "ShareModule.h"
#import "ShareSDKManager.h"


@implementation ShareModule

-(BOOL)setUp{
    //TODO: 
    return NO;
}

-(void)share:(NSString*)modueleName Model:(ShareDataModel *)model{
    
}

-(BOOL)handleUrl:(NSURL *)url SuccessBlock:(SharedSuccessBlock)successBlock FailBlock:(SharedFailBlock)failBolck {
    return NO;
}

-(void)setShareModuleName:(NSString *)name{
    if ([name length]>0) {
        if ([self.moduleNames count]<=0) {
            _moduleNames = [NSMutableArray new];
        }
        [self.moduleNames addObject:name];
    }
}

@end
