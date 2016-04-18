//
//  SJTextFieldCell.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/16.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJTextFieldCell.h"

@interface SJTextFieldCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@end

@implementation SJTextFieldCell

-(void)configUI:(NSString*)leftText placeholder:(NSString*)phText
{
    self.leftLabel.text = leftText;
    self.textField.placeholder = phText;
    self.textField.delegate = self;
}

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(self.kbBlock)
    {
        self.kbBlock(textField);
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.endBlock)
    {
        self.endBlock(textField.text);
    }
}

@end
