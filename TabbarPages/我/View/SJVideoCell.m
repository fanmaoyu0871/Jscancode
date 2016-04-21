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

@property (weak, nonatomic) IBOutlet UIButton *yueduliangBtn;
@end

@implementation SJVideoCell
{
    AVPlayer *_player;
    AVPlayerItem *_playItem;
    AVPlayerLayer *_playerLayer;
    
    UIButton *_playBtn;
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

+(CGFloat)heightForCell
{
    return 98 + (ScreenWidth-55-80)*480/640+ 10 + 30;
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

-(void)configUI:(NSURL*)videoUrl
{
    if(![[_firstUrl absoluteString] isEqualToString:[videoUrl absoluteString]])
    {
        if(_playItem == nil)
        {
            _playItem = [AVPlayerItem playerItemWithURL:videoUrl];
        }
        
        if(_player == nil)
        {
            _player = [AVPlayer playerWithPlayerItem:_playItem];
        }
        
        _playerLayer.player = _player;
    }
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
