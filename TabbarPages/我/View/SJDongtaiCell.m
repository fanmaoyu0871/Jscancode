//
//  SJDongtaiCell.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJDongtaiCell.h"
#import "SJPersonalCenterVC.h"

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

@property (nonatomic, strong) SJZixunModel *zixunModel;


@property (nonatomic, copy) void (^leftBlock)();
@property (nonatomic, copy) void (^midBlock)();
@property (nonatomic, copy) void (^rightBlock)();

@property (nonatomic, weak)UIViewController *viewController;


@end

@implementation SJDongtaiCell

- (void)awakeFromNib {
    // Initialization code
    self.touxiangImageView.layer.cornerRadius = self.touxiangImageView.width/2;
    self.touxiangImageView.layer.masksToBounds = YES;
}

+(CGFloat)heightForModel:(SJZixunModel*)model
{
    CGFloat height = [model.content sizeOfStringFont:[UIFont systemFontOfSize:13.0f] baseSize:CGSizeMake(ScreenWidth-75, MAXFLOAT)].height + 10;

    NSArray *imageArray = [model.path componentsSeparatedByString:@","];

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


    return 70 + height + 10 + width*count  + 30;
}

-(void)configUI:(SJZixunModel*)model leftBtnBlock:(void (^)())leftBlock midBtnBlock:(void (^)())midBlock rightBtnBlock:(void (^)())rightBlock viewController:(UIViewController*)vc{
    
    self.zixunModel = model;
    self.leftBlock = leftBlock;
    self.midBlock = midBlock;
    self.rightBlock = rightBlock;
    self.viewController  = vc;
    
    [self.touxiangImageView sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:nil];
    self.nameLabel.text = model.name;
    self.timeLabel.text = [NSString stringFromSeconds:model.time];
    self.contentTextLabel.text = model.content;
    
    self.contentHeightCons.constant = [model.content sizeOfStringFont:[UIFont systemFontOfSize:13.0f] baseSize:CGSizeMake(ScreenWidth-75, MAXFLOAT)].height + 10;
    
    NSString *str = @"";
    if([model.num integerValue] >= 10000)
    {
        str = [NSString stringWithFormat:@"%.1fw", [model.num integerValue]/10000.0];
    }
    else
    {
        str = [NSString stringWithFormat:@"%@", model.num];
    }
    [self.yueduliangBtn setTitle:[NSString stringWithFormat:@"阅读量%@", str] forState:UIControlStateNormal];
    
    NSArray *imageArray = [model.path componentsSeparatedByString:@","];
    
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
    
    
    [self.imagesView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat space = 10.0f;
    _width = (ScreenWidth - self.nameLabel.left - 20) / 3 - 2*space;
    CGFloat height = _width;
    CGFloat x = 0;
    
    for(NSInteger i = 0; i < 9; i++)
    {
        x = _width*(i%3)+space*(i%3);
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(x, space*(i/3)+ height*(i/3), _width, height)];
        iv.tag = BaseTag + i;
        iv.userInteractionEnabled = YES;
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.layer.masksToBounds = YES;
        [self.imagesView addSubview:iv];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [iv addGestureRecognizer:tap];
    }
    
    self.imagesViewHeightCons.constant = _width*count;
    
    for(NSInteger i = 0; i < imageArray.count; i++)
    {
        UIImageView *iv = (UIImageView*)[self.imagesView viewWithTag:BaseTag + i];
        [iv sd_setImageWithURL:[NSURL URLWithString:imageArray[i]]];
    }
}

-(void)addYueDuliang
{
    NSString *str = @"";
    self.zixunModel.num = [NSString stringWithFormat:@"%ld", [self.zixunModel.num integerValue]+1];
    if(([self.zixunModel.num integerValue]) >= 10000)
    {
        str = [NSString stringWithFormat:@"%.1fW", [self.zixunModel.num integerValue]/10000.0];
    }
    else
    {
        str = [NSString stringWithFormat:@"%ld", [self.zixunModel.num integerValue]];
    }
    [self.yueduliangBtn setTitle:[NSString stringWithFormat:@"阅读量%@", str] forState:UIControlStateNormal];
}



-(void)tapAction:(UITapGestureRecognizer*)ges
{
    //增加阅读量
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.add.infonum", @"name", self.zixunModel.tmpId, @"user_info_id", nil];
    [YDJProgressHUD showSystemIndicator:YES];
    [QQNetworking requestDataWithQQFormatParam:params view:self.viewController.view success:^(NSDictionary *dic) {
        [YDJProgressHUD showSystemIndicator:NO];
        
        [self addYueDuliang];
        
    }failure:^{
        [YDJProgressHUD showSystemIndicator:NO];
    }];

    
    NSArray *imagesArray = [self.zixunModel.path componentsSeparatedByString:@","];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    UIImageView *imageView = (UIImageView*)ges.view;
    NSInteger index = imageView.tag - BaseTag;
    
    for(NSInteger i = 0; i < imagesArray.count; i++)
    {
        ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imagesArray[i]];
        UIImageView *iv = [self.imagesView viewWithTag:BaseTag + i];
        photo.toView = iv;
        [tmpArray addObject:photo];
    }
    
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    if(![self.viewController isKindOfClass:[SJPersonalCenterVC class]])
    {
        pickerBrowser.navigationHeight = 64;
    }
    pickerBrowser.status = UIViewAnimationAnimationStatusZoom;
    // 数据源/delegate
//    pickerBrowser.delegate = self;
    //    pickerBrowser.editing = YES;
    pickerBrowser.photos = tmpArray;
    // 当前选中的值
    pickerBrowser.currentIndex = index;
    // 展示控制器
    [pickerBrowser showPickerVc:self.viewController];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 阅读量按钮事件
- (IBAction)yueduliangBtnAction:(id)sender
{
    if(self.leftBlock)
    {
        self.leftBlock();
    }
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
