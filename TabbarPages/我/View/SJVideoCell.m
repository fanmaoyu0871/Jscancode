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
    BOOL _isExist;
    
    UIImageView *_bannerImageView;
}

@property (weak, nonatomic) IBOutlet UIImageView *touxiangImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons;
@property (weak, nonatomic) IBOutlet UIButton *yueduliangBtn;

@property (nonatomic, strong) SJZixunModel *zixunModel;


@property (nonatomic, copy) void (^leftBlock)();
@property (nonatomic, copy) void (^midBlock)();
@property (nonatomic, copy) void (^rightBlock)();

@property (nonatomic, weak)UIViewController *viewController;

@end

@implementation SJVideoCell
{
    AVPlayer *_player;
    AVPlayerItem *_playItem;
    AVPlayerLayer *_playerLayer;
    
    UIButton *_playBtn;
}

-(void)configUI:(SJZixunModel*)model leftBtnBlock:(void (^)())leftBlock midBtnBlock:(void (^)())midBlock rightBtnBlock:(void (^)())rightBlock viewController:(UIViewController*)vc
{
    
    self.zixunModel = model;
    self.leftBlock = leftBlock;
    self.midBlock = midBlock;
    self.rightBlock = rightBlock;
    self.viewController  = vc;
    
    [self.touxiangImageView sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:nil];
    self.nameLabel.text = model.name;
    self.timeLabel.text = [NSString stringFromSeconds:model.time];
    self.contentTextLabel.text = model.content;
    
    self.heightCons.constant = [model.content sizeOfStringFont:[UIFont systemFontOfSize:12.0f] baseSize:CGSizeMake(ScreenWidth-75, MAXFLOAT)].height + 10;
    
    [self.yueduliangBtn setTitle:[NSString stringWithFormat:@"阅读量%@", model.num] forState:UIControlStateNormal];
    
    //解析视频地址，看本地是否存在
    NSArray *pathArray = [model.path componentsSeparatedByString:@"/"];
    NSString *videoName = [pathArray lastObject];
    NSString *cacheDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [cacheDirPath stringByAppendingPathComponent:videoName];
    
    _isExist = [[NSFileManager defaultManager]fileExistsAtPath:filePath];
    if(_isExist)
    {
        [_playBtn removeFromSuperview];
        [_bannerImageView removeFromSuperview];
        
        //如果存在，就一直播放
        if(_playItem == nil)
        {
            _playItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:filePath]];
            _player = [AVPlayer playerWithPlayerItem:_playItem];
            _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
            _playerLayer.player = _player;
        }
        
        [_player play];
    }
    else
    {
        _playBtn.hidden = NO;
    }
}

- (void)awakeFromNib {
    // Initialization code
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:)name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    self.touxiangImageView.layer.cornerRadius = self.touxiangImageView.width/2;
    self.touxiangImageView.layer.masksToBounds = YES;
    
    CGFloat btnW = ScreenWidth-55-80;
    
    _playerLayer = [[AVPlayerLayer alloc]init];
    _playerLayer.frame = CGRectMake(55, 98, btnW, btnW*480/640);
    _playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//视频填充模式
    [self.contentView.layer addSublayer:_playerLayer];
    
    _bannerImageView = [[UIImageView alloc]initWithFrame:_playerLayer.frame];
    _bannerImageView.userInteractionEnabled = YES;
    _bannerImageView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:_bannerImageView];
    
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
//-(void)willDisplay
//{
//    if(_isLoaded)
//    {
//        [self playBtnAction];
//    }
//}

//-(void)endDisplay
//{
//    if(_isLoaded)
//    {
//        [self playbackFinished:nil];
//    }
//}

-(void)playBtnAction
{
    [_playBtn removeFromSuperview];
    
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.contentView addSubview:ai];
    ai.center = CGPointMake(ScreenWidth/2, self.contentView.height/2);
    [ai startAnimating];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSArray *pathArray = [self.zixunModel.path componentsSeparatedByString:@","];
    NSString *path = [pathArray firstObject];
    NSURLRequest *req = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:path]];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:req progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSLog(@"targetPath = %@, response.suggestedFilename = %@", targetPath, response.suggestedFilename);
        
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *desPath = [cachePath stringByAppendingPathComponent:response.suggestedFilename];
        
        NSURL *fileUrl = [NSURL fileURLWithPath:desPath];
        
        return fileUrl;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [ai stopAnimating];
        
        //清除ui
        [_bannerImageView removeFromSuperview];
        
        //播放视频
        _playItem = [AVPlayerItem playerItemWithURL:filePath];
        _player = [AVPlayer playerWithPlayerItem:_playItem];
        _playerLayer.player = _player;
        [_player play];
    }];
    
    [downloadTask resume];
    

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

#pragma mark - 阅读量按钮事件
- (IBAction)yueduliangBtnAction:(id)sender
{
    if(self.leftBlock)
    {
        self.leftBlock();
    }
}

@end
