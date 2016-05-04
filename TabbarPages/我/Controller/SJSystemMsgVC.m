//
//  SJSystemMsgVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/25.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJSystemMsgVC.h"
#import "SJMsgCell.h"

#define msgCellID @"msgCellID"

@interface SJSystemMsgVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataArray;


@end

@implementation SJSystemMsgVC

-(NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navTitle = @"系统消息";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SJMsgCell" bundle:nil] forCellReuseIdentifier:msgCellID];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.sys.news", @"name", [YDJUserInfo sharedUserInfo].user_id, @"user_id", @"1", @"page", nil];
    
    [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
        id data = dic[@"data"];
        if([data isKindOfClass:[NSArray class]])
        {
            NSArray *array = data;
            for(id obj in array)
            {
                NSDictionary *dict = obj;
                SJSystemMsgModel *model = [[SJSystemMsgModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                model.tmpId = dict[@"id"];
                [self.dataArray addObject:model];
            }
        }
        
        [self.tableView reloadData];
    } failure:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SJMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:msgCellID];
    
    if(indexPath.section < self.dataArray.count)
    {
        SJSystemMsgModel *model = self.dataArray[indexPath.section];
        [cell configUI:model];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < self.dataArray.count)
    {
        SJSystemMsgModel *model = self.dataArray[indexPath.section];
        return [SJMsgCell heightForModel:model];
    }
    
    return .0f;
}


#pragma mark - 删除相关代理
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleDelete;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        if(indexPath.section < self.dataArray.count)
        {
            SJSystemMsgModel *model = self.dataArray[indexPath.section];
            
            [YDJProgressHUD showSystemIndicator:YES];
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.del.sysnews", @"name", model.tmpId, @"news_id", nil];
            [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
                [YDJProgressHUD showSystemIndicator:NO];
                if([dic[@"success"]integerValue] == 1)
                {
                    [self.dataArray removeObjectAtIndex:indexPath.section];
                    
                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
                }
            } failure:^{
                [YDJProgressHUD showSystemIndicator:NO];
                [YDJProgressHUD showTextToast:@"删除失败" onView:self.view];
            }];
        }
    }
}

@end
