//
//  ShareView.h
//  Pods
//
//  Created by lixu on 16/9/23.
//
//

#import <UIKit/UIKit.h>

@interface ShareView : UIView

//点击按钮block回调
@property (nonatomic,copy) void(^btnClick)(NSInteger);

//头部提示文字
@property (nonatomic,copy) NSString *proStr;

//头部提示文字的字体大小
@property (nonatomic,assign) NSInteger proFont;

//取消按钮的颜色
@property (nonatomic,strong) UIColor *cancelBtnColor;

//取消按钮的字体大小
@property (nonatomic,assign) NSInteger cancelBtnFont;

//除了取消按钮其他按钮的颜色
@property (nonatomic,strong) UIColor *otherBtnColor;

//除了取消按钮其他按钮的字体大小
@property (nonatomic,assign) NSInteger otherBtnFont;

//设置弹窗背景蒙板灰度(0~1)
@property (nonatomic,assign) CGFloat duration;

/**
 *  初始化ShareView
 *  @param titleArray 标题数组
 *  @param imageArr   图片数组
 *  @param protitle   最顶部的标题
 *  @return
 */

- (id)initShareViewWithTitleArray:(NSArray *)titleArray ImageArry:(NSArray *)imageArr ProTitle:(NSString *)protitle;

@end
