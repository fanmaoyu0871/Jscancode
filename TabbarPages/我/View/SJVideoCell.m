//
//  SJDongtaiCell.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJVideoCell.h"
#import <AVFoundation/AVFoundation.h>

@interface SJVideoCell ()
{
    BOOL _isLoaded;
    NSURL *_firstUrl;
}

@property (weak, nonatomic) IBOutlet UIImageView *touxiangImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons;
@property (weak, nonatomic) IBOutlet UIButton *yueduliangBtn;
@end

@implementation SJVideoCell
{
    AVPlayer *_player;
    AVPlayerItem *_playItem;
    AVPlayerLayer *_playerLayer;
    
    UIButton *_playBtn;
}

-(void)configUI:(SJZixunModel*)model
{
    [self.touxiangImageView sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:nil];
    self.nameLabel.text = model.name;
    self.timeLabel.text = [NSString stringFromSeconds:model.time];
    self.contentTextLabel.text = model.content;
    
    self.heightCons.constant = [model.content sizeOfStringFont:[UIFont systemFontOfSize:12.0f] baseSize:CGSizeMake(ScreenWidth-75, MAXFLOAT)].height + 10;
    
    [self.yueduliangBtn setTitle:[NSString stringWithFormat:@"阅读量%@", model.num] forState:UIControlStateNormal];
    
    NSData *data = [model.path dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSString *path = [array firstObject];
    _playItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:path]];
    _player = [AVPlayer playerWithPlayerItem:_playItem];
    _playerLayer.player = _player;
    
}

- (void)awakeFromNib {
    // Initialization code
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:)name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    CGFloat btnW = ScreenWidth-55-80;
    
    _playerLayer = [[AVPlayerLayer alloc]init];
    _playerLayer.frame = CGRectMake(55, 98, btnW, btnW*480/640);
    _playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//视频填充模式
    [self.contentView.layer addSublayer:_playerLayer];
    
    [self createPlayBtn];
    
}

+(CGFloat)heightForModel:(SJZixunModel*)model
{
    CGFloat height = [model.content sizeOfStringFont:[UIFont systemFontOfSize:12.0f] baseSize:CGSizeMake(ScreenWidth-75, MAXFLOAT)].height + 10;
    
    return 70 + height + 20 + (ScreenWidth-55-80)*480/640+ 20 + 30;
}

-(void)createPlayBtn
{
    CGFloat btnW = ScreenWidth-55-80;
    _playBtn = [[UIButton alloc]initWithFrame:CGRectMake(55, 98, btnW, btnW*480/640)];
    [_playBtn setImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(playBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_playBtn];
    [self.contentView bringSubviewToFront:_playBtn];
}

#pragma mark - exposed
-(void)willDisplay
{
    if(_isLoaded)
    {
        [self playBtnAction];
    }
}

-(void)endDisplay
{
    if(_isLoaded)
    {
        [self playbackFinished:nil];
    }
}

-(void)playBtnAction
{
    _isLoaded = YES;
    _playBtn.hidden = YES;
    [_player play];
}

-(void)playbackFinished:(NSNotification *)notification
{
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
