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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightCons;

@property (nonatomic, copy) void (^leftBlock)();
@property (nonatomic, copy) void (^midBlock)();
@property (nonatomic, copy) void (^rightBlock)();

@end

@implementation SJDongtaiCell

- (void)awakeFromNib {
    // Initialization code
    
    CGFloat space = 10.0f;
    _width = (ScreenWidth - self.nameLabel.left - 20) / 3 - 2*space;
    CGFloat height = _width;
    CGFloat x = 0;
    
    for(NSInteger i = 0; i < 9; i++)
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

+(CGFloat)heightForModel:(SJZixunModel*)model
{
    CGFloat height = [model.content sizeOfStringFont:[UIFont systemFontOfSize:12.0f] baseSize:CGSizeMake(ScreenWidth-75, MAXFLOAT)].height + 10;

    NSData *data = [model.path dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *imageArray = array;
    NSInteger count = 1;
    
    if(imageArray.count <= 3)
    {
        count = 1;
    }
    else if (imageArray.count >3 && imageArray.count <=6)
    {
        count = 2;
    }
    else
    {
        count = 3;
    }
    
    CGFloat width =  (ScreenWidth - 55 - 20) / 3 - 2*10;


    return 70 + height + 20 + width*count + 20 + 30;
}

-(void)configUI:(SJZixunModel*)model leftBtnBlock:(void (^)())leftBlock midBtnBlock:(void (^)())midBlock rightBtnBlock:(void (^)())rightBlock{
    
    self.leftBlock = leftBlock;
    self.midBlock = midBlock;
    self.rightBlock = rightBlock;
    
    [self.touxiangImageView sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:nil];
    self.nameLabel.text = model.name;
    self.timeLabel.text = [NSString stringFromSeconds:model.time];
    self.contentTextLabel.text = model.content;
    
    self.contentHeightCons.constant = [model.content sizeOfStringFont:[UIFont systemFontOfSize:12.0f] baseSize:CGSizeMake(ScreenWidth-75, MAXFLOAT)].height + 10;
    
    [self.yueduliangBtn setTitle:[NSString stringWithFormat:@"阅读量%@", model.num] forState:UIControlStateNormal];
    
    NSData *data = [model.path dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *imageArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSInteger count = 1;
    if(imageArray.count <= 3)
    {
        count = 1;
    }
    else if (imageArray.count >3 && imageArray.count <=6)
    {
        count = 2;
    }
    else
    {
        count = 3;
    }
        
    self.imagesViewHeightCons.constant = _width*count;
    
    for(NSInteger i = 0; i < imageArray.count; i++)
    {
        UIImageView *iv = (UIImageView*)[self.imagesView viewWithTag:BaseTag + i];
        [iv sd_setImageWithURL:[NSURL URLWithString:imageArray[i]]];
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
    if(self.midBlock)
    {
        self.midBlock();
    }
}

#pragma mark - 评价按钮事件
- (IBAction)pinglunBtnAction:(id)sender
{
    if(self.rightBlock)
    {
        self.rightBlock();
    }
}

@end
