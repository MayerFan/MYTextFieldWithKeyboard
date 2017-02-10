//
//  MYCustomKeyboard.m
//  HeXun-zixuan
//
//  Created by 范名扬 on 16/3/4.
//  Copyright © 2016年 com.hztc. All rights reserved.
//

#import "MYCustomKeyboard.h"

#define KMYSmallMargin 5
#define KMYBigMargin 10
#define KMYLetterEdgeMargin 3
//十六进制转grb
#define KMYHexToRGB(i,a) [UIColor colorWithRed:(i>>16&0xFF)/255.0 green:(i>>8&0xFF)/255.0 blue:(i&0xFF)/255.0 alpha:a]

@interface MYCustomKeyboard ()
@property (nonatomic, strong)UIImageView            *pBackgroudImageView;
@property (nonatomic, strong)NSMutableArray         *pThreeNumberButtonArray; //左侧三个数字的数组
@property (nonatomic, strong)NSMutableArray         *pRightNumberButtonArray;
@property (nonatomic, strong)NSMutableArray         *pLetterButtonArray;
@property (nonatomic, strong)NSMutableArray         *pNewAddedButtonArray;//新添加的按钮数组
@end

@implementation MYCustomKeyboard

- (UIImageView *)pBackgroudImageView
{
    if (!_pBackgroudImageView) {
        _pBackgroudImageView = [[UIImageView alloc] init];
    }
    return _pBackgroudImageView;
}
- (NSMutableArray *)pThreeNumberButtonArray
{
    if (!_pThreeNumberButtonArray) {
        _pThreeNumberButtonArray = [NSMutableArray arrayWithCapacity:5];
    }
    return _pThreeNumberButtonArray;
}
- (NSMutableArray *)pRightNumberButtonArray
{
    if (!_pRightNumberButtonArray) {
        _pRightNumberButtonArray = [NSMutableArray arrayWithCapacity:20];
    }
    return _pRightNumberButtonArray;
}
- (NSMutableArray *)pLetterButtonArray
{
    if (!_pLetterButtonArray) {
        _pLetterButtonArray = [NSMutableArray arrayWithCapacity:30];
    }
    return _pLetterButtonArray;
}
- (NSMutableArray *)pNewAddedButtonArray
{
  if (!_pNewAddedButtonArray) {
    _pNewAddedButtonArray = [NSMutableArray arrayWithCapacity:2];
  }
  return _pNewAddedButtonArray;
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
    [self.pRightNumberButtonArray removeAllObjects];
    [self.pThreeNumberButtonArray removeAllObjects];
    [self.pLetterButtonArray removeAllObjects];
    [self.pNewAddedButtonArray removeAllObjects];
    
    self.backgroundColor = KMYHexToRGB(0xdddddd, 1);
    self.pBackgroudImageView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.pBackgroudImageView];
    
//    _CustomKeyboardOnclickButtonBack = ^(NSString *btnTitle){};
//    _CustomKeyboardCancelButtonBack = ^(){};
    
    
    //创建数字键盘
    for (int i = 0; i < 12; i++) {
        UIButton *rightBtn = [[UIButton alloc] init];
        rightBtn.tag = i;
        
        [rightBtn addTarget:self action:@selector(numberButtonOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
        [_pRightNumberButtonArray addObject:rightBtn];
    }
    for (int j = 12; j < 17; j++) {
        UIButton *leftBtn = [[UIButton alloc] init];
        leftBtn.tag = j;
        
        [leftBtn addTarget:self action:@selector(numberButtonOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBtn];
        [_pThreeNumberButtonArray addObject:leftBtn];
    }
    
    //创建字母键盘
    for (int m = 0; m < 29; m++) {
        UIButton *letterBtn = [[UIButton alloc] init];
        letterBtn.tag = m;
        
        [letterBtn addTarget:self action:@selector(letterButtonOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:letterBtn];
        [_pLetterButtonArray addObject:letterBtn];
    }
    //创建大小写切换按钮
  UIButton *upperBtn = [[UIButton alloc] init];
  upperBtn.tag = 100;
  
  [upperBtn addTarget:self action:@selector(upperButtonOnclick:) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:upperBtn];
  [_pNewAddedButtonArray addObject:upperBtn];
  
}

- (void)numberButtonOnclick:(UIButton *)btn
{
    NSString *title = btn.titleLabel.text;
    if ([title isEqualToString:@"ABC"]) {
        [self setCustomKeyboardType:KMYCustomKeyboard_Letter_Type];
        return;
    }
    if (/*[title isEqualToString:@"取消"]*/!title) {
        if (_CustomKeyboardCancelButtonBack) {
            _CustomKeyboardCancelButtonBack();
        }
        return;
    }
    if (_CustomKeyboardOnclickButtonBack) {
        _CustomKeyboardOnclickButtonBack(title);
    }
}

- (void)letterButtonOnclick:(UIButton *)btn
{
    NSString *title = btn.titleLabel.text;
    if ([title isEqualToString:@"123"]) {
        [self setCustomKeyboardType:KMYCustomKeyboard_Number_Type];
        return;
    }
    if (!title) {
        if (_CustomKeyboardCancelButtonBack) {
            _CustomKeyboardCancelButtonBack();
        }
        return;
    }
    if ([title isEqualToString:@"空格"]) {
        if (_CustomKeyboardOnclickButtonBack) {
            _CustomKeyboardOnclickButtonBack(@" ");
        }
        return;
    }
    if (_CustomKeyboardOnclickButtonBack) {
        _CustomKeyboardOnclickButtonBack(title);
    }
}

- (void)upperButtonOnclick:(UIButton *)btn
{//切换大小写
  NSString *title = btn.titleLabel.text;
  if ([title isEqualToString:@"大"]) {
    [self setLetterKeyboardPorpertyWithisUpper:NO];
  }else {
    [self setLetterKeyboardPorpertyWithisUpper:YES];
  }
}

- (void)addCustomKeyboardOnClickButtonCallBack:(CustomKeyboardOnclickButton)buttonCallBack{
    self.CustomKeyboardOnclickButtonBack = buttonCallBack;
}

- (void)addCustomKeyboardOnClickCancelButtonCallBack:(CustomKeyboardCancelButton)cancleButtonCallBack{
    self.CustomKeyboardCancelButtonBack = cancleButtonCallBack;
}

- (void)setCustomKeyboardType:(KMYCustomKeyboardType)keyboardType
{
    for (UIButton *letterBtn in _pLetterButtonArray) {
        letterBtn.hidden = NO;
    }
    for (UIButton *leftBtn in _pThreeNumberButtonArray) {
        leftBtn.hidden = NO;
    }
    for (UIButton *rightBtn in _pRightNumberButtonArray) {
        rightBtn.hidden = NO;
    }
  for (UIButton *upperBtn in _pNewAddedButtonArray) {
    upperBtn.hidden = NO;
  }
    
    switch (keyboardType) {
        case KMYCustomKeyboard_Number_Type:
        {
            //隐藏字母键盘所有按钮
            for (UIButton *letterBtn in _pLetterButtonArray) {
                letterBtn.hidden = YES;
            }
          for (UIButton *upperBtn in _pNewAddedButtonArray) {
            upperBtn.hidden = YES;
          }
            //设置数字键盘其他属性
            [self setNumberKeyboardPorperty];
        }
            break;
        case KMYCustomKeyboard_Letter_Type:
        {
            //隐藏数字键盘所有按钮
            for (UIButton *leftBtn in _pThreeNumberButtonArray) {
                leftBtn.hidden = YES;
            }
            for (UIButton *rightBtn in _pRightNumberButtonArray) {
                rightBtn.hidden = YES;
            }
            //设置字母键盘其他属性
            [self setLetterKeyboardPorperty];
        }
            break;
            
        default:
            break;
    }
}

- (void)setNumberKeyboardPorperty
{
    for (UIButton *rightBtn in _pRightNumberButtonArray) {
        [self setNumberKeyboardPorpertyWithTag:rightBtn];
    }
    for (UIButton *leftBtn in _pThreeNumberButtonArray) {
        [self setNumberKeyboardPorpertyWithTag:leftBtn];
    }
}

- (void)setLetterKeyboardPorperty
{
  [self setLetterKeyboardPorpertyWithisUpper:YES];
}

- (void)setLetterKeyboardPorpertyWithisUpper:(BOOL)isUpper
{
  for (UIButton *letterBtn in _pLetterButtonArray) {
    [self setLetterKeyboardPorpertyWithTag:letterBtn isUpper:isUpper];
  }
  for (UIButton *upperBtn in _pNewAddedButtonArray) {
    [self setLetterKeyboardPorpertyWithTag:upperBtn isUpper:isUpper];
  }
}

- (void)setNumberKeyboardPorpertyWithTag:(UIButton *)Btn
{
    Btn.layer.cornerRadius = 5;
    Btn.layer.masksToBounds = YES;
    [Btn setBackgroundImage:[self imageWithColor:KMYHexToRGB(0xcccccc, 1)] forState:UIControlStateHighlighted];
    
    switch (Btn.tag) {
        case 0:
        {
            [Btn setTitle:@"1" forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
            Btn.titleLabel.font = [UIFont systemFontOfSize:20];
        }
            break;
        case 1:
        {
            [Btn setTitle:@"2" forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
            Btn.titleLabel.font = [UIFont systemFontOfSize:20];
        }
            break;
        case 2:
        {
            [Btn setTitle:@"3" forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
            Btn.titleLabel.font = [UIFont systemFontOfSize:20];
        }
            break;
        case 3:
        {
            [Btn setTitle:@"4" forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
            Btn.titleLabel.font = [UIFont systemFontOfSize:20];
        }
            break;
        case 4:
        {
            [Btn setTitle:@"5" forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
            Btn.titleLabel.font = [UIFont systemFontOfSize:20];
        }
            break;
        case 5:
        {
            [Btn setTitle:@"6" forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
            Btn.titleLabel.font = [UIFont systemFontOfSize:20];
        }
            break;
        case 6:
        {
            [Btn setTitle:@"7" forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
            Btn.titleLabel.font = [UIFont systemFontOfSize:20];
        }
            break;
        case 7:
        {
            [Btn setTitle:@"8" forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
            Btn.titleLabel.font = [UIFont systemFontOfSize:20];
        }
            break;
        case 8:
        {
            [Btn setTitle:@"9" forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
            Btn.titleLabel.font = [UIFont systemFontOfSize:20];
        }
            break;
        case 9:
        {
            [Btn setTitle:@"ABC" forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Btn setBackgroundColor:KMYHexToRGB(0xe8e8e8, 1)];
            Btn.titleLabel.font = [UIFont systemFontOfSize:17];
        }
            break;
        case 10:
        {
            [Btn setTitle:@"0" forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
            Btn.titleLabel.font = [UIFont systemFontOfSize:20];
        }
            break;
        case 11:
        {
//            [Btn setTitle:@"取消" forState:UIControlStateNormal];
//            [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Btn setImage:[UIImage imageNamed:@"backspace"] forState:UIControlStateNormal];
            [Btn setBackgroundColor:KMYHexToRGB(0xe8e8e8, 1)];
        }
            break;
        case 12:
        {
            [Btn setTitle:@"600" forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Btn setBackgroundColor:KMYHexToRGB(0xe8e8e8, 1)];
            Btn.titleLabel.font = [UIFont systemFontOfSize:17];
        }
            break;
        case 13:
        {
            [Btn setTitle:@"601" forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Btn setBackgroundColor:[UIColor whiteColor]];
            [Btn setBackgroundColor:KMYHexToRGB(0xe8e8e8, 1)];
            Btn.titleLabel.font = [UIFont systemFontOfSize:17];
        }
            break;
        case 14:
        {
            [Btn setTitle:@"000" forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Btn setBackgroundColor:[UIColor whiteColor]];
            [Btn setBackgroundColor:KMYHexToRGB(0xe8e8e8, 1)];
            Btn.titleLabel.font = [UIFont systemFontOfSize:17];
        }
            break;
        case 15:
        {
            [Btn setTitle:@"300" forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Btn setBackgroundColor:[UIColor whiteColor]];
            [Btn setBackgroundColor:KMYHexToRGB(0xe8e8e8, 1)];
            Btn.titleLabel.font = [UIFont systemFontOfSize:17];
        }
            break;
        case 16:
        {
            [Btn setTitle:@"002" forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Btn setBackgroundColor:[UIColor whiteColor]];
            [Btn setBackgroundColor:KMYHexToRGB(0xe8e8e8, 1)];
            Btn.titleLabel.font = [UIFont systemFontOfSize:17];
        }
            break;
            
        default:
            break;
    }
}

- (void)setLetterKeyboardPorpertyWithTag:(UIButton *)Btn
{
  [self setLetterKeyboardPorpertyWithTag:Btn isUpper:YES];
}

- (void)setLetterKeyboardPorpertyWithTag:(UIButton *)Btn isUpper:(BOOL)isUpper
{
  Btn.layer.cornerRadius = 5;
  Btn.layer.masksToBounds = YES;
  Btn.titleLabel.font = [UIFont systemFontOfSize:20];
  [Btn setBackgroundImage:[self imageWithColor:KMYHexToRGB(0xcccccc, 1)] forState:UIControlStateHighlighted];
  
  switch (Btn.tag) {
    case 0:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"Q" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 1:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"W" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 2:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"E" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 3:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"R" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 4:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"T" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 5:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"Y" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 6:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"U" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 7:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"I" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 8:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"O" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 9:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"P" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 10:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"A" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 11:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"S" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 12:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"D" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 13:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"F" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 14:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"G" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 15:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"H" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 16:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"J" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 17:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"K" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 18:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"L" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 19:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"Z" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 20:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"X" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 21:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"C" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 22:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"V" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 23:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"B" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 24:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"N" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 25:
    {
      NSString *text = [self getLowerOrUpperStringWithText:@"M" isUpper:isUpper];
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 26:
    {
      [Btn setTitle:@"123" forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xe8e8e8, 1)];
    }
      break;
    case 27:
    {
      [Btn setTitle:@"空格" forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xf5f5f5, 1)];
    }
      break;
    case 28:
    {
      [Btn setImage:[UIImage imageNamed:@"backspace"] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xe8e8e8, 1)];
    }
      break;
    case 100:
    {
      NSString *text = @"大";
      if (!isUpper) {
        text = @"小";
      }
      [Btn setTitle:text forState:UIControlStateNormal];
      [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [Btn setBackgroundColor:KMYHexToRGB(0xe8e8e8, 1)];
    }
      break;
      
    default:
      break;
  }
}
//获取字母大写或小写字符串
- (NSString *)getLowerOrUpperStringWithText:(NSString *)text isUpper:(BOOL)isUpper
{
  NSString *tempStr = text;
  if (!isUpper) {//小写
    tempStr = [tempStr lowercaseString];
  }else{
    tempStr = [tempStr uppercaseString];
  }
  return tempStr;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
  
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
  
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  
    return image;
}

- (void)layoutSubviews{
  
    CGFloat nNumberItemW = (self.frame.size.width - 4*KMYSmallMargin)/4;
    CGFloat nNumberRightItemH = (self.frame.size.height - 5*KMYSmallMargin)/4;
    CGFloat nNumberLeftItemH = (self.frame.size.height - 6*KMYSmallMargin)/5;
  
    for (int i = 0; i < _pRightNumberButtonArray.count; i++) {
        UIButton *rightBtn = _pRightNumberButtonArray[i];
      
        CGFloat nRightBtnX = nNumberItemW + KMYSmallMargin + (KMYSmallMargin + nNumberItemW)*(i%3);
        CGFloat nRightBtnY = KMYSmallMargin + (KMYSmallMargin + nNumberRightItemH)*(i/3);
        rightBtn.frame = CGRectMake(nRightBtnX, nRightBtnY, nNumberItemW, nNumberRightItemH);
    }
    
    for (int j = 0; j < _pThreeNumberButtonArray.count; j++) {
        UIButton *leftBtn = _pThreeNumberButtonArray[j];
        
        CGFloat nLeftBtnY = KMYSmallMargin + (KMYSmallMargin + nNumberLeftItemH)*j;
        leftBtn.frame = CGRectMake(KMYSmallMargin, nLeftBtnY, nNumberItemW - KMYSmallMargin, nNumberLeftItemH);
    }
    
    //字母
    CGFloat nLetterItemW = (self.frame.size.width - 2*KMYLetterEdgeMargin - 9*KMYSmallMargin)/10;
    CGFloat nLetterItemH = (self.frame.size.height - 4*KMYBigMargin - KMYLetterEdgeMargin)/4;
    CGFloat nTwoRowLeftRightGapW = (self.frame.size.width - 9*nLetterItemW - 8*KMYSmallMargin)/2;
    CGFloat nThreeRowLeftRightGapW = (self.frame.size.width - 7*nLetterItemW - 6*KMYSmallMargin)/2;
    CGFloat nFourLeftRightBtnW = (self.frame.size.width - 2*KMYLetterEdgeMargin - 2*KMYSmallMargin)/4;
    
    for (int m = 0; m < 10; m++) {
        UIButton *oneRowLetterBtn = _pLetterButtonArray[m];
        CGFloat oneRowletterBtnX = KMYLetterEdgeMargin + (nLetterItemW + KMYSmallMargin)*m;
        oneRowLetterBtn.frame = CGRectMake(oneRowletterBtnX, KMYBigMargin, nLetterItemW, nLetterItemH);
    }
    UIButton *Qbtn = _pLetterButtonArray[0];
    for (int n = 10; n < 19; n++) {
        UIButton *twoRowLetterBtn = _pLetterButtonArray[n];
        CGFloat twoRowletterBtnX = nTwoRowLeftRightGapW + (nLetterItemW + KMYSmallMargin)*(n - 10);
        twoRowLetterBtn.frame = CGRectMake(twoRowletterBtnX, CGRectGetMaxY(Qbtn.frame)+KMYBigMargin, nLetterItemW, nLetterItemH);
    }
    UIButton *Abtn = _pLetterButtonArray[10];
    for (int k = 19; k < 26; k++) {
        UIButton *threeRowLetterBtn = _pLetterButtonArray[k];
        CGFloat threeRowletterBtnX = nThreeRowLeftRightGapW + (nLetterItemW + KMYSmallMargin)*(k - 19);
        threeRowLetterBtn.frame = CGRectMake(threeRowletterBtnX, CGRectGetMaxY(Abtn.frame)+KMYBigMargin, nLetterItemW, nLetterItemH);
    }
    UIButton *Zbtn = _pLetterButtonArray[19];
    UIButton *letterToNumberBtn = _pLetterButtonArray[26];
    letterToNumberBtn.frame = CGRectMake(KMYLetterEdgeMargin, CGRectGetMaxY(Zbtn.frame)+KMYBigMargin, nFourLeftRightBtnW, nLetterItemH);
    UIButton *spaceBtn = _pLetterButtonArray[27];
    spaceBtn.frame = CGRectMake(CGRectGetMaxX(letterToNumberBtn.frame)+KMYSmallMargin, letterToNumberBtn.frame.origin.y, 2*nFourLeftRightBtnW, nLetterItemH);
    UIButton *cancleBtn = _pLetterButtonArray[28];
    cancleBtn.frame = CGRectMake(CGRectGetMaxX(spaceBtn.frame)+KMYSmallMargin, letterToNumberBtn.frame.origin.y, nFourLeftRightBtnW, nLetterItemH);
  //大小写切换按钮
  CGFloat upperBtnW = nThreeRowLeftRightGapW - KMYSmallMargin - KMYLetterEdgeMargin;
  if (_pNewAddedButtonArray.count > 0) {
    UIButton *upperBtn = _pNewAddedButtonArray[0];
    upperBtn.frame = CGRectMake(KMYLetterEdgeMargin, CGRectGetMaxY(Abtn.frame)+KMYBigMargin, upperBtnW, nLetterItemH);
  }
}

@end
