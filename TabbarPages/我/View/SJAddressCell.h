//
//  SJAddressCell.h
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;


-(void)configUI:(NSString*)text vc:(UIViewController*)vc;

@property (nonatomic, copy)void (^endEditBlock)(NSString* comp0, NSString* comp1, NSString* comp2);

-(void)showPickView;

@end
