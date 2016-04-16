//
//  SJPickerCell.h
//  Jscancode
//
//  Created by 范茂羽 on 16/4/16.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^pickerBlock)();

@interface SJPickerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (nonatomic, copy)pickerBlock block;


-(void)configUI:(NSString*)leftText rightText:(NSString*)rightText isAddLength:(BOOL)isAddLength;

@end
