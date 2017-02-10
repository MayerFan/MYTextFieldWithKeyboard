//
//  MYCustomKeyboardTextField.h
//  HeXun-zixuan
//
//  Created by 范名扬 on 16/3/7.
//  Copyright © 2016年 com.hztc. All rights reserved.
//
//*************** 输入框弹出自定义键盘 ***************

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,KMYCustomKeyboardType){
    KMYCustomKeyboard_Number_Type = 1,         //数字键盘
    KMYCustomKeyboard_Letter_Type              //字母键盘
};

typedef NS_ENUM(NSInteger,KMYKeyboardMode){
    KMYKeyboard_System_Mode = 1,               //系统键盘
    KMYKeyboard_Custom_Mode                    //自定义键盘
};

@interface MYCustomKeyboardTextField : UITextField
/*!
 * 设置自定义键盘模式
 */
- (void)setCustomKeyboardMode:(KMYKeyboardMode)keyboardMode;
/*!
 * 设置自定义键盘类型
 */
- (void)setCustomKeyboardType:(KMYCustomKeyboardType)keyboardType;
@end
