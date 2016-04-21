//
//  SJDongtaiCell.h
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJVideoCell : UITableViewCell

+(CGFloat)heightForCell;

-(void)configUI:(NSURL*)videoUrl;

-(void)willDisplay;

-(void)endDisplay;

@end
