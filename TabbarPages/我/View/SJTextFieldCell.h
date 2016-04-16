//
//  SJTextFieldCell.h
//  Jscancode
//
//  Created by 范茂羽 on 16/4/16.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^endEditBlock)(NSString *text);
typedef void(^keyboardBlock)(UITextField *textField);


@interface SJTextFieldCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, copy)endEditBlock endBlock;
@property (nonatomic, copy)keyboardBlock kbBlock;

-(void)configUI:(NSString*)leftText placeholder:(NSString*)phText;

@end
