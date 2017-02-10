//
//  MYCustomKeyboard.h
//  HeXun-zixuan
//
//  Created by 范名扬 on 16/3/4.
//  Copyright © 2016年 com.hztc. All rights reserved.
//
//  ****************** 自定义键盘 ******************

#import <UIKit/UIKit.h>

#import "MYCustomKeyboardTextField.h"

typedef void (^CustomKeyboardOnclickButton)(NSString *btnTitle);
typedef void(^CustomKeyboardCancelButton)();

@interface MYCustomKeyboard : UIView
@property (nonatomic, copy)CustomKeyboardOnclickButton    CustomKeyboardOnclickButtonBack;
@property (nonatomic, copy)CustomKeyboardCancelButton     CustomKeyboardCancelButtonBack;
/*!
 * 设置自定义键盘类型
 */
- (void)setCustomKeyboardType:(KMYCustomKeyboardType)keyboardType;
/*!
 * 键盘按钮回调
 */
- (void)addCustomKeyboardOnClickButtonCallBack:(CustomKeyboardOnclickButton)buttonCallBack;
/*!
 * 键盘取消按钮回调
 */
- (void)addCustomKeyboardOnClickCancelButtonCallBack:(CustomKeyboardCancelButton)cancleButtonCallBack;
@end
