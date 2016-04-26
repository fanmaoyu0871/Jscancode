//
//  SJDongtaiCell.h
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJZixunModel.h"

@interface SJDongtaiCell : UITableViewCell

-(void)configUI:(SJZixunModel*)model leftBtnBlock:(void (^)())leftBlock midBtnBlock:(void (^)())midBlock rightBtnBlock:(void (^)())rightBlock;

+(CGFloat)heightForModel:(SJZixunModel*)model;

@end
