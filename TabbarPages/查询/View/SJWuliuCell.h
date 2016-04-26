//
//  SJWuliuCell.h
//  Jscancode
//
//  Created by 范茂羽 on 16/4/16.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJWuliuModel.h"

@interface SJWuliuCell : UITableViewCell

-(void)configUI:(SJWuliuModel*)model isFirst:(BOOL)isFirst;

+(CGFloat)heightForModel:(SJWuliuModel*)model;

@end
