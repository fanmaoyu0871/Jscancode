//
//  FMMoviePlayer.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/28.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "FMMoviePlayer.h"
#import "FMMovieDecoder.h"

@interface FMMoviePlayer ()
{
    UIImageView *_imageView;
    CAKeyframeAnimation *_animation;
}

@end

@implementation FMMoviePlayer

-(instancetype)initWithFrame:(CGRect)frame fileUrl:(NSURL*)fileUrl;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.fileUrl = fileUrl;
        
    }
    return self;
}

//如果本地存在，就拿缓存的来播放，不存在就解码
-(void)play:(NSArray*)imagesArray
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.fileUrl options:nil];
    
    // 得到媒体的资源
    [self.layer removeAllAnimations];
    
    _animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    // asset.duration.value/asset.duration.timescale 得到视频的真实时间
    _animation.duration = asset.duration.value/asset.duration.timescale;
    _animation.values = imagesArray;
    _animation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:_animation forKey:nil];
    
}


@end
