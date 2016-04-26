//
//  SJMsgCell.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/25.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJMsgCell.h"

@interface SJMsgCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightCons;

@end

@implementation SJMsgCell

-(void)configUI:(SJSystemMsgModel*)model
{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:nil];
    self.contentLabel.text = model.content;
    self.timeLabel.text = [NSString stringFromSeconds:model.time];
    
    self.contentHeightCons.constant = [model.content sizeOfStringFont:[UIFont systemFontOfSize:12.0f] baseSize:CGSizeMake(ScreenWidth-57-20, MAXFLOAT)].height + 10;
}

+(CGFloat)heightForModel:(SJSystemMsgModel*)model
{
    CGFloat height = [model.content sizeOfStringFont:[UIFont systemFontOfSize:12.0f] baseSize:CGSizeMake(ScreenWidth-57-20, MAXFLOAT)].height + 10;
    
    return 41 + height + 10;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
