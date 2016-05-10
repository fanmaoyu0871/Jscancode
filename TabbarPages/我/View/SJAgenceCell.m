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
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end

@implementation SJAgenceCell

-(void)configUI:(SJAgentModel*)model
{
    self.nameLabel.text = model.name;
    
//    0总代，1省代，2市代，3美丽顾问
    NSString *str = @"";
    if([model.level integerValue] == 0)
    {
        str = @"总代";
    }
    else if([model.level integerValue] == 1)
    {
        str = @"省代";
    }
    else if([model.level integerValue] == 2)
    {
        str = @"市代";
    }
    else if([model.level integerValue] == 3)
    {
        str = @"美丽顾问";
    }
    self.levelLabel.text = str;
    
    self.weixinLabel.text = model.weixin;
    
    self.phoneLabel.text = model.phone;
    
    self.jinhuolinagLabel.text = model.goods_num;
    
    self.jifenLabel.text = model.points;
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.head]];
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
