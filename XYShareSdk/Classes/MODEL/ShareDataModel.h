//
//  ShareDataModel.h
//  Pods
//
//  Created by 何霞雨 on 16/9/23.
//
//

#import <Foundation/Foundation.h>

//分享MDL
@interface ShareDataModel : NSObject

//标题
@property(strong,nonatomic) NSString *title;
//描述
@property(strong,nonatomic) NSString *descript;
//跳转的url
@property(strong,nonatomic) NSString *url;

//图片url
@property(strong,nonatomic) NSString *imageUrl;
//图片［大］
@property(strong,nonatomic) UIImage *image;
//预览图［小］
@property(strong,nonatomic) UIImage *preImage;


@end
