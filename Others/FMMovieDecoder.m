//
//  FMMovieDecoder.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/28.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "FMMovieDecoder.h"

@interface FMMovieDecoder ()
{
    AVAssetReader *_reader;
    AVAssetTrack *_videoTrack;
    AVAssetReaderTrackOutput *_videoReaderOutput;
}

@end

@implementation FMMovieDecoder

-(instancetype)initWithFileUrl:(NSURL*)fileUrl
{
    if(self = [super init])
    {
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileUrl options:nil];
        NSError *error = nil;
        _reader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
        
        NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        _videoTrack =[videoTracks objectAtIndex:0];
        
        
        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        [options setObject:@(kCVPixelFormatType_32BGRA) forKey:(id)kCVPixelBufferPixelFormatTypeKey];
        _videoReaderOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:_videoTrack outputSettings:options];
        
        [_reader addOutput:_videoReaderOutput];
        
    }
    return self;
}

-(void)startDecode
{
    [_reader startReading];
    
    NSMutableArray *imagesArray = [NSMutableArray array];
    
    while ([_reader status] == AVAssetReaderStatusReading && _videoTrack.nominalFrameRate > 0) {
        // 读取 video sample
        CMSampleBufferRef videoBuffer = [_videoReaderOutput copyNextSampleBuffer];
        
        if(videoBuffer == NULL)
        {
            NSLog(@"reader.status = %d", [_reader status]);
            continue;
        }
        
        CGImageRef cgimage = [UIImage imageFromSampleBufferRef:videoBuffer];
        if (!(__bridge id)(cgimage)) { continue; }
        
        [imagesArray addObject:(__bridge id)(cgimage)];
        
        CGImageRelease(cgimage);
        
        // 根据需要休眠一段时间；比如上层播放视频时每帧之间是有间隔的,这里的 sampleInternal 我设置为0.001秒
        [NSThread sleepForTimeInterval:0.001f];
    }
    
    if([self.delegate respondsToSelector:@selector(movieDecoderDidFinished:imagesArray:)])
    {
        [self.delegate movieDecoderDidFinished:self imagesArray:imagesArray];
    }

}
@end
