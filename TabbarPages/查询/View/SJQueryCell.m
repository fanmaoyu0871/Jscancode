//
//  SJQueryCell.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/16.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJQueryCell.h"

@interface SJQueryCell()
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation SJQueryCell

-(void)configUI:(NSString*)bgImageName title:(NSString*)title rightImage:(NSString*)rightImageName
{
    self.leftLabel.text = title;
    self.bgImageView.image = [UIImage imageNamed:bgImageName];
    self.rightImageView.image = [UIImage imageNamed:rightImageName];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
