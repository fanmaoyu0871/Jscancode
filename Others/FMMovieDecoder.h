//
//  FMMovieDecoder.h
//  Jscancode
//
//  Created by 范茂羽 on 16/4/28.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMMovieDecoder;

@protocol FMMovieDecoderDelegate <NSObject>

-(void)movieDecoderDidFinished:(FMMovieDecoder *)decoder imagesArray:(NSArray*)imageArray;
@end

@interface FMMovieDecoder : NSObject

@property (nonatomic, assign) NSInteger tag;


-(instancetype)initWithFileUrl:(NSURL*)fileUrl;

@property (nonatomic, weak)id<FMMovieDecoderDelegate> delegate;

-(void)startDecode;


@end
