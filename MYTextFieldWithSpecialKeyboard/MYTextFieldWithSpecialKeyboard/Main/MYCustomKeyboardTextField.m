//
//  MYCustomKeyboardTextField.m
//  HeXun-zixuan
//
//  Created by 范名扬 on 16/3/7.
//  Copyright © 2016年 com.hztc. All rights reserved.
//

#import "MYCustomKeyboardTextField.h"

#import "MYCustomKeyboard.h"

//十六进制转grb
#define KMYHexToRGB(i,a) [UIColor colorWithRed:(i>>16&0xFF)/255.0 green:(i>>8&0xFF)/255.0 blue:(i&0xFF)/255.0 alpha:a]

@interface MYCustomKeyboardTextField ()
@property (nonatomic, strong)MYCustomKeyboard           *pCustomKeyboard;
@end

@implementation MYCustomKeyboardTextField

- (MYCustomKeyboard *)pCustomKeyboard
{
    if (!_pCustomKeyboard) {
        _pCustomKeyboard = [[MYCustomKeyboard alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 215)];
    }
    return _pCustomKeyboard;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setOriginalViews];
    }
    return self;
}

- (void)setOriginalViews
{
    //默认模式和类型
    [self setCustomKeyboardMode:KMYKeyboard_Custom_Mode];
    [self setCustomKeyboardType:KMYCustomKeyboard_Number_Type];
    _pCustomKeyboard.layer.borderWidth = 0.5;
    _pCustomKeyboard.layer.borderColor = [KMYHexToRGB(0xbbbbbb, 1) CGColor];
    
    __weak MYCustomKeyboardTextField *weakSelf = self;
    [_pCustomKeyboard addCustomKeyboardOnClickButtonCallBack:^(NSString *btnTitle) {
        weakSelf.text = [NSString stringWithFormat:@"%@%@",weakSelf.text,btnTitle];
        [weakSelf sendActionsForControlEvents:UIControlEventValueChanged];
    }];
    [_pCustomKeyboard addCustomKeyboardOnClickCancelButtonCallBack:^{
        if (weakSelf.text.length < 1) {
            return;
        }
        weakSelf.text = [weakSelf.text substringToIndex:weakSelf.text.length - 1];
        [weakSelf sendActionsForControlEvents:UIControlEventValueChanged];
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *dict = noti.userInfo;
    CGFloat keyboardH = [[dict valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    _pCustomKeyboard.frame = CGRectMake(_pCustomKeyboard.frame.origin.x, _pCustomKeyboard.frame.origin.y, _pCustomKeyboard.frame.size.width, keyboardH);
}

- (void)setCustomKeyboardMode:(KMYKeyboardMode)keyboardMode
{
    switch (keyboardMode) {
        case KMYKeyboard_System_Mode:
        {
            self.inputView = nil;
        }
            break;
        case KMYKeyboard_Custom_Mode:
        {
            self.inputView = self.pCustomKeyboard;
            self.inputAccessoryView = nil;
        }
            break;
            
        default:
            break;
    }
}

- (void)setCustomKeyboardType:(KMYCustomKeyboardType)keyboardType
{
    [self.pCustomKeyboard setCustomKeyboardType:keyboardType];
}

//重写
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
  [UIMenuController sharedMenuController].menuVisible = NO;
  if (action == @selector(copy:)) {
    return NO;
  } else if (action == @selector(selectAll:)) {
    return NO;
  }
  
  return NO;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
