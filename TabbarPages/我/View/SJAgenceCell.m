//
//  SJAgenceCell.m
//  Jscancode
//
//  Created by 范茂羽 on 16/5/7.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJAgenceCell.h"

@interface SJAgenceCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *jinhuolinagLabel;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;

@end

@implementation SJAgenceCell

-(void)configUI
{
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
