//
//  SJWarningView.h
//  Jscancode
//
//  Created by 范茂羽 on 16/5/4.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJWarningView : UIView

@property (nonatomic, copy)void (^tapBlock)();


-(void)show;

-(void)dismiss;

@end
