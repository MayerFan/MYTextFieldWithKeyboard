//
//  ViewController.m
//  MYTextFieldWithSpecialKeyboard
//
//  Created by zeroing on 17/2/10.
//  Copyright © 2017年 MayerF. All rights reserved.
//

#import "ViewController.h"

#import "MYCustomKeyboardTextField.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  self.view.backgroundColor = [UIColor blueColor];
  
  //添加测试textField
  MYCustomKeyboardTextField *customTextField = [[MYCustomKeyboardTextField alloc] initWithFrame:CGRectMake(50, 100, 200, 40)];
  customTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
  customTextField.borderStyle = UITextBorderStyleRoundedRect;
  customTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
  customTextField.returnKeyType = UIReturnKeyDone;
  customTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  customTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  customTextField.placeholder = @"点我";
  [self.view addSubview:customTextField];
  
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
