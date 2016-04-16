//
//  SJPickerCell.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/16.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJPickerCell.h"

@interface SJPickerCell ()
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCons;

@end

@implementation SJPickerCell

-(void)configUI:(NSString*)leftText rightText:(NSString*)rightText isAddLength:(BOOL)isAddLength
{
    self.leftLabel.text = leftText;
    self.rightLabel.text = rightText;
    
    self.widthCons.constant = isAddLength?200.0f:140.0f;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
