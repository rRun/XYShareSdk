//
//  ShareView.m
//  Pods
//
//  Created by lixu on 16/9/23.
//
//

#import "ShareView.h"
#import "ShareButton.h"

#define SHAREVIEW_BACKGROUNDCOLOR     [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1]
#define WINDOW_COLOR                  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define ANIMATE_DURATION              0.25f

#define ShareViewWidth		[[UIScreen mainScreen] bounds].size.width
#define ShareViewHeight		[[UIScreen mainScreen] bounds].size.height

@interface ShareView ()
@property (nonatomic,assign) CGFloat LXActionSheetHeight;
@property (nonatomic,strong) NSArray *shareBtnTitleArray;
@property (nonatomic,strong) NSArray *shareBtnImgArray;

@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,strong) UIView *topsheetView;
@property (nonatomic,strong) UIButton *cancelBtn;

//头部提示文字Label
@property (nonatomic,strong) UILabel *proL;

@property (nonatomic,copy) NSString *protext;

@end


@implementation ShareView

-(id)initShareViewWithTitleArray:(NSArray *)titleArray ImageArry:(NSArray *)imageArr ProTitle:(NSString *)protitle{
	self = [super init]; 
	if (self) {
		self.shareBtnImgArray = imageArr;
		self.shareBtnTitleArray = titleArray;
		_protext = protitle;
		
		self.frame = CGRectMake(0, 0, ShareViewWidth, ShareViewHeight);
		self.backgroundColor = WINDOW_COLOR;
		self.userInteractionEnabled = YES;
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
		[self addGestureRecognizer:tapGesture];
		
		[self loadUiConfig];
	}
	return self;
}

-(void)loadUiConfig{
	[self addSubview:self.backGroundView];
	[_backGroundView addSubview:self.topsheetView];
	[_backGroundView addSubview:self.cancelBtn];
	
	_LXActionSheetHeight = CGRectGetHeight(_proL.frame)+7;
	
	for (NSInteger i = 0; i<_shareBtnImgArray.count; i++){
		ShareButton *button = [ShareButton buttonWithType:UIButtonTypeCustom];
		if (_shareBtnImgArray.count%3 == 0) {
			button.frame = CGRectMake(_backGroundView.bounds.size.width/3*(i%3), _LXActionSheetHeight+(i/3)*76, _backGroundView.bounds.size.width/3, 70);
		}else{
			button.frame = CGRectMake(_backGroundView.bounds.size.width/4*(i%4), _LXActionSheetHeight+(i/4)*76, _backGroundView.bounds.size.width/4, 70);
		}
		
		[button setTitle:_shareBtnTitleArray[i] forState:UIControlStateNormal];
		[button setImage:[UIImage imageNamed:_shareBtnImgArray[i]] forState:UIControlStateNormal];
		button.tag = 200+i;
		[button addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
		[self.topsheetView addSubview:button];
	}
	
	[UIView animateWithDuration:ANIMATE_DURATION animations:^{
		_backGroundView.frame = CGRectMake(7, ShareViewHeight-CGRectGetHeight(_backGroundView.frame), ShareViewWidth-14, CGRectGetHeight(_backGroundView.frame));
	}];
}

- (void)BtnClick:(UIButton *)btn{
	[self tappedCancel];
	_btnClick(btn.tag - 200);
}

- (void)tappedCancel{
	[UIView animateWithDuration:ANIMATE_DURATION animations:^{
		[self.backGroundView setFrame:CGRectMake(0, ShareViewHeight, ShareViewWidth, 0)];
		self.alpha = 0;
	} completion:^(BOOL finished) {
		if (finished) {
			[self removeFromSuperview];
		}
	}];
}

- (void)noTap{

}

#pragma -mark -getter and setter
- (void)setCancelBtnColor:(UIColor *)cancelBtnColor{
	[_cancelBtn setTitleColor:cancelBtnColor forState:UIControlStateNormal];
}
- (void)setProStr:(NSString *)proStr{
	_proL.text = proStr;
}

- (void)setOtherBtnColor:(UIColor *)otherBtnColor{
	for (id res in _backGroundView.subviews) {
		if ([res isKindOfClass:[UIButton class]]) {
			UIButton *button = (UIButton *)res;
			if (button.tag >= 100) {
				[button setTitleColor:otherBtnColor forState:UIControlStateNormal];
			}
		}
	}
}

- (void)setOtherBtnFont:(NSInteger)otherBtnFont{
	for (id res in _backGroundView.subviews) {
		if ([res isKindOfClass:[UIButton class]]) {
			UIButton *button = (UIButton *)res;
			if (button.tag >= 100) {
				button.titleLabel.font = [UIFont systemFontOfSize:otherBtnFont];
			}
		}
	}
}

-(void)setProFont:(NSInteger)proFont{
	_proL.font = [UIFont systemFontOfSize:proFont];
}

- (void)setCancelBtnFont:(NSInteger)cancelBtnFont{
	_cancelBtn.titleLabel.font = [UIFont systemFontOfSize:cancelBtnFont];
}

- (void)setDuration:(CGFloat)duration{
	self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:duration];
}

- (UIView *)backGroundView{
	if (_backGroundView == nil) {
		_backGroundView = [[UIView alloc] init];
		
		if (_shareBtnImgArray.count<5) {
			_backGroundView.frame = CGRectMake(7, ShareViewHeight, ShareViewWidth-14, 64+(_protext.length==0?0:45)+76+14);
		}else{
			NSInteger index;
			if (_shareBtnTitleArray.count%4 == 0) {
				index =_shareBtnTitleArray.count/4;
			}else{
				index = _shareBtnTitleArray.count/4 + 1;
			}
			_backGroundView.frame = CGRectMake(7, ShareViewHeight, ShareViewWidth-14, 64+(_protext.length==0?0:45)+76*index+14);
		}
		
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noTap)];
		[_backGroundView addGestureRecognizer:tapGesture];
	}
	return _backGroundView;
}


- (UIView *)topsheetView{
	if (_topsheetView == nil) {
		_topsheetView = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(_backGroundView.frame),CGRectGetHeight(_backGroundView.frame)-64)];
		_topsheetView.backgroundColor = [UIColor whiteColor];
		_topsheetView.layer.cornerRadius = 4;
		_topsheetView.clipsToBounds = YES;
		if (_protext.length) {
			[_topsheetView addSubview:self.proL];
		}
	}
	return _topsheetView;
}

- (UILabel *)proL{
	if (_proL == nil) {
		_proL = [[UILabel alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(_backGroundView.frame),45)];
		_proL.text = _protext;
		_proL.textColor = [UIColor grayColor];
		_proL.backgroundColor = [UIColor whiteColor];
		_proL.textAlignment = NSTextAlignmentCenter;
	}
	return _proL;
}

- (UIButton *)cancelBtn{
	if (_cancelBtn == nil) {
		_cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		
		_cancelBtn.frame = CGRectMake(0, CGRectGetHeight(_backGroundView.frame)-57, CGRectGetWidth(_backGroundView.frame), 50);
		_cancelBtn.layer.cornerRadius = 4;
		_cancelBtn.clipsToBounds = YES;
		
		[_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
		_cancelBtn.backgroundColor = [UIColor whiteColor];
		[_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[_cancelBtn addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
	}
	return _cancelBtn;
}

@end
