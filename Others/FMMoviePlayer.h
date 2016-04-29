//
//  FMMoviePlayer.h
//  Jscancode
//
//  Created by 范茂羽 on 16/4/28.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMMoviePlayer : UIView

@property (nonatomic, strong)NSURL *fileUrl;

-(instancetype)initWithFrame:(CGRect)frame fileUrl:(NSURL*)fileUrl;

-(void)play:(NSArray*)imagesArray;

@end
