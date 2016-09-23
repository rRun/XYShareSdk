//
//  ShareModule.m
//  Pods
//
//  Created by 何霞雨 on 16/9/23.
//
//

#import "ShareModule.h"
#import "ShareSDKManager.h"
#import "ShareDataModel.h"

@implementation ShareModule

-(BOOL)setUp{
    //TODO: 
    return NO;
}

-(void)share:(ShareDataModel *)model{
    
}

-(void)handleUrl:(NSURL *)url SuccessBlock:(SharedSuccessBlock)successBlock FailBlock:(SharedFailBlock)failBolck {
    
}

-(void)setShareModuleSchema:(NSString *)name{
    if ([name length]>0) {
        _shcema = name;
    }
}

@end
