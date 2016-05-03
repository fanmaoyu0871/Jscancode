//
//  SJMineCell.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/16.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJMineCell.h"

@interface SJMineCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeighCons;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingCons;
@end

@implementation SJMineCell

-(void)configUI:(NSString*)image leftText:(NSString*)leftText rightText:(NSString*)rightText showLine:(BOOL)isShowLine
{
    self.leftImageView.image = [UIImage imageNamed:image];
    self.leftLabel.text = leftText;
    self.rightLabel.text = rightText;
    
    self.leadingCons.constant = isShowLine?0:20;
    self.lineHeighCons.constant = 0.5f;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
