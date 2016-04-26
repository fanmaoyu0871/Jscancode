//
//  SJDongtaiCell.h
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJZixunModel.h"

@interface SJVideoCell : UITableViewCell

-(void)configUI:(SJZixunModel*)model;

+(CGFloat)heightForModel:(SJZixunModel*)model;


-(void)willDisplay;

-(void)endDisplay;

@end
