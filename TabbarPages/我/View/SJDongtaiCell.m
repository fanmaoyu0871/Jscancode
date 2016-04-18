//
//  SJDongtaiCell.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJDongtaiCell.h"

#define BaseTag 2000

@interface SJDongtaiCell ()
{
    CGFloat _width;
}
@property (weak, nonatomic) IBOutlet UIView *imagesView;

@property (weak, nonatomic) IBOutlet UIImageView *touxiangImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;

@property (weak, nonatomic) IBOutlet UIButton *yueduliangBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesViewHeightCons;
@end

@implementation SJDongtaiCell

- (void)awakeFromNib {
    // Initialization code
    
    CGFloat space = 10.0f;
    _width = (ScreenWidth - self.nameLabel.left - 20) / 3 - 2*space;
    CGFloat height = _width;
    CGFloat x = 0;
    
    for(NSInteger i = 0; i < 6; i++)
    {
        x = x+_width*(i%3)+space*(i%3);
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(x, height*(i/3), _width, height)];
        iv.tag = BaseTag + i;
        iv.userInteractionEnabled = YES;
        [self.imagesView addSubview:iv];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [iv addGestureRecognizer:tap];
    }
}

-(void)configUI:(NSArray*)imageArray
{
    self.imagesViewHeightCons.constant = imageArray.count > 3?_width*2:_width;
    
    for(NSInteger i = 0; i < imageArray.count; i++)
    {
        UIImageView *iv = (UIImageView*)[self.imagesView viewWithTag:BaseTag + i];
        [iv sd_setImageWithURL:[NSURL URLWithString:@""]];
    }
}


-(void)tapAction
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 分享按钮事件
- (IBAction)shareBtnAction:(id)sender
{
    
}

#pragma mark - 评价按钮事件
- (IBAction)pinglunBtnAction:(id)sender
{
    
}

@end
