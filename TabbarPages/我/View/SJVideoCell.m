//
//  SJDongtaiCell.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJVideoCell.h"
#import <AVFoundation/AVFoundation.h>
#import "DACircularProgressView.h"
#import "SJPreviewVideoVC.h"

@interface SJVideoCell ()
{
    BOOL _isExist;
    
    UIImageView *_bannerImageView;
    
    DACircularProgressView *_progressView;
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

-(void)layoutSubviews
{
    self.heightCons.constant = [self.zixunModel.content sizeOfStringFont:[UIFont systemFontOfSize:13.0f] baseSize:CGSizeMake(ScreenWidth-75, MAXFLOAT)].height + 10;
    
    CGFloat btnW = ScreenWidth-55-80;

    _bannerImageView.frame  = CGRectMake(55, 49 + self.heightCons.constant + 10, btnW, btnW*480/640);
    _playBtn.center = CGPointMake(_bannerImageView.width/2, _bannerImageView.height/2);
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
    [_bannerImageView sd_setImageWithURL:[NSURL URLWithString:model.banner]];
    

    NSString *str = @"";
    if([model.num integerValue] >= 10000)
    {
        str = [NSString stringWithFormat:@"%.1fW", [model.num integerValue]/10000.0];
    }
    else
    {
        str = [NSString stringWithFormat:@"%@", model.num];
    }
    [self.yueduliangBtn setTitle:[NSString stringWithFormat:@"阅读量%@", str] forState:UIControlStateNormal];
    
    [_playerLayer removeFromSuperlayer];
    _bannerImageView.hidden = NO;
    _playBtn.hidden = NO;
    
    [self setNeedsLayout];
    
    if(self.zixunModel.isDownLoading)
    {
        _progressView.hidden = NO;
        _playBtn.hidden = YES;
        [_progressView setProgress:self.zixunModel.progress animated:YES];
        if(self.zixunModel.progress >= 1)
        {
            _progressView.hidden = YES;
            _playBtn.hidden = NO;
            self.zixunModel.isDownLoading = NO;
        }
    }
    else
    {
        _playBtn.hidden = NO;
        _progressView.hidden = YES;
    }

}


- (void)awakeFromNib {
    // Initialization code
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:)name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    self.touxiangImageView.layer.cornerRadius = self.touxiangImageView.width/2;
    self.touxiangImageView.layer.masksToBounds = YES;
    
    _bannerImageView = [[UIImageView alloc]init];
    _bannerImageView.userInteractionEnabled = YES;
    _bannerImageView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:_bannerImageView];
    
    [self createPlayBtn];
    
}

+(CGFloat)heightForModel:(SJZixunModel*)model
{
    CGFloat height = [model.content sizeOfStringFont:[UIFont systemFontOfSize:13.0f] baseSize:CGSizeMake(ScreenWidth-75, MAXFLOAT)].height + 10;
    
    return 70 + height + 10 + (ScreenWidth-55-80)*480/640+ 10 + 30;
}

-(void)createPlayBtn
{
    CGFloat btnW = ScreenWidth-55-80;
    _playBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnW, btnW*480/640)];
    [_playBtn setImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(playBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_bannerImageView addSubview:_playBtn];
    [self.contentView bringSubviewToFront:_playBtn];
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    BOOL flag = CGRectContainsPoint(_bannerImageView.frame, point);
    
    if(flag && _playBtn.hidden)
    {
        CGRect rect = [self convertRect:_bannerImageView.frame toView:[UIApplication sharedApplication].keyWindow];
        SJPreviewVideoVC *previewVC = [[SJPreviewVideoVC alloc]initWithNibName:@"SJPreviewVideoVC" bundle:nil];
        NSArray *pathArray = [self.zixunModel.path componentsSeparatedByString:@"/"];
        NSString *videoName = [pathArray lastObject];
        NSString *cacheDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filePath = [cacheDirPath stringByAppendingPathComponent:videoName];
        previewVC.videoPath = filePath;
        previewVC.fromRect = rect;
        [self.viewController presentViewController:previewVC animated:YES completion:^{
            
        }];
    }
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
    //增加阅读量
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.add.infonum", @"name", self.zixunModel.tmpId, @"user_info_id", nil];
    [YDJProgressHUD showSystemIndicator:YES];
    [QQNetworking requestDataWithQQFormatParam:params view:self.viewController.view success:^(NSDictionary *dic) {
        [YDJProgressHUD showSystemIndicator:NO];
        [self addYueDuliang];
    }failure:^{
        [YDJProgressHUD showSystemIndicator:NO];
    }];
    
    _playBtn.hidden = YES;
    
    NSArray *pathArray = [self.zixunModel.path componentsSeparatedByString:@"/"];
    NSString *videoName = [pathArray lastObject];
    NSString *cacheDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [cacheDirPath stringByAppendingPathComponent:videoName];
    BOOL isExist = [[NSFileManager defaultManager]fileExistsAtPath:filePath];
    if(!isExist)
    {
        self.zixunModel.isDownLoading = YES;
        if(_progressView == nil)
        {
            _progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 40.0f, 40.0f)];
            _progressView.trackTintColor = [UIColor clearColor];
            _progressView.progressTintColor = [UIColor whiteColor];
            _progressView.thicknessRatio = 1.0f;
            _progressView.clockwiseProgress = YES;
            [_bannerImageView addSubview:_progressView];
            _progressView.center = CGPointMake(_bannerImageView.width/2, _bannerImageView.height/2);
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSArray *pathArray = [self.zixunModel.path componentsSeparatedByString:@","];
        NSString *path = [pathArray firstObject];
        NSURLRequest *req = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:path]];
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:req progress:^(NSProgress * _Nonnull downloadProgress) {
            
            NSLog(@"已下载＝%f",1.0* downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
            
            self.zixunModel.progress = 1.0* downloadProgress.completedUnitCount/downloadProgress.totalUnitCount;
            [_progressView setProgress:1.0* downloadProgress.completedUnitCount/downloadProgress.totalUnitCount animated:YES];
            
        }  destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            NSLog(@"targetPath = %@, response.suggestedFilename = %@", targetPath, response.suggestedFilename);
            
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *desPath = [cachePath stringByAppendingPathComponent:response.suggestedFilename];
            
            NSURL *fileUrl = [NSURL fileURLWithPath:desPath];
            
            return fileUrl;
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            
            //清除ui
            [_progressView removeFromSuperview];
            _progressView = nil;
            _bannerImageView.hidden = YES;
            
            //播放视频
            _playItem = [AVPlayerItem playerItemWithURL:filePath];
            _player = [AVPlayer playerWithPlayerItem:_playItem];
            _player.volume = .0f;
            
            CGFloat btnW = ScreenWidth-55-80;
            _playerLayer = [[AVPlayerLayer alloc]init];
            _playerLayer.frame = CGRectMake(55, self.contentTextLabel.bottom+10, btnW, btnW*480/640);
            _playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//视频填充模式
            [self.contentView.layer addSublayer:_playerLayer];
            _playerLayer.player = _player;
            [_player play];
            
        }];
        
        [downloadTask resume];

    }
    else
    {
        _bannerImageView.hidden = YES;
        
        NSArray *pathArray = [self.zixunModel.path componentsSeparatedByString:@"/"];
        NSString *videoName = [pathArray lastObject];
        NSString *cacheDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filePath = [cacheDirPath stringByAppendingPathComponent:videoName];
        
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:filePath]];
        _player = [AVPlayer playerWithPlayerItem:item];
        _player.volume = .0f;
        CGFloat btnW = ScreenWidth-55-80;
        _playerLayer = [[AVPlayerLayer alloc]init];
        _playerLayer.frame = CGRectMake(55, self.contentTextLabel.bottom+10, btnW, btnW*480/640);
        _playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//视频填充模式
        [self.contentView.layer addSublayer:_playerLayer];
        _playerLayer.player = _player;
        [_player play];

    }
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
