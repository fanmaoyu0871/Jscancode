//
//  UIImage+Tools.h
//  Jscancode
//
//  Created by 范茂羽 on 16/4/28.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tools)
+ (CGImageRef)imageFromSampleBufferRef:(CMSampleBufferRef)sampleBufferRef;

//获取某帧图片
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
@end
