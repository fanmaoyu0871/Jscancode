//
//  SJWuliuCell.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/16.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJWuliuCell.h"

@interface SJWuliuCell ()
{
    CGFloat _height;
}

@property (weak, nonatomic) IBOutlet UIView *point;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons;

@end

@implementation SJWuliuCell

-(void)configUI:(SJWuliuModel *)model isFirst:(BOOL)isFirst
{
    self.point.backgroundColor = isFirst?Theme_MainColor:[UIColor whiteColor];
    
    self.contentLabel.textColor = isFirst?Theme_MainColor:Theme_TextMainColor;
    
    self.contentLabel.text = [NSString stringWithFormat:@"您的订单在%@", model.context];
    _height = [self.contentLabel.text sizeOfStringFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12.0f] baseSize:CGSizeMake(ScreenWidth - 75, 1000)].height;
    
    self.dateLabel.text = model.time;
    
    [self layoutIfNeeded];
}

-(void)layoutSubviews
{
    self.heightCons.constant = _height+10;
}

+(CGFloat)heightForModel:(SJWuliuModel *)model
{
    NSString *str = [NSString stringWithFormat:@"您的订单在%@", model.context];
    
    CGFloat height = [str sizeOfStringFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12.0f] baseSize:CGSizeMake(ScreenWidth - 75, 1000)].height;
    
    return 65 + height+10;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
