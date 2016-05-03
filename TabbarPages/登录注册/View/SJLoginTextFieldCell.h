//
//  SJTextFieldCell.h
//  Jscancode
//
//  Created by 范茂羽 on 16/4/20.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJLoginTextFieldCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, copy)void (^tfBlock)(NSString* text);

@property (nonatomic, copy)void (^getVerifyCodeBlock)();

@property (nonatomic, strong) UIViewController *vc;



-(void)configUI:(NSString*)leftText placeholder:(NSString*)ph showRightBtn:(BOOL)isShow;

@end
