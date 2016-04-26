//
//  SJHotZixunVC.h
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJBaseViewController.h"

@interface SJHotZixunVC : SJBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void)beginRefresh;

@end
