//
//  SJMsgCell.h
//  Jscancode
//
//  Created by 范茂羽 on 16/4/25.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJSystemMsgModel.h"

@interface SJMsgCell : UITableViewCell

-(void)configUI:(SJSystemMsgModel*)model;

+(CGFloat)heightForModel:(SJSystemMsgModel*)model;

@end
