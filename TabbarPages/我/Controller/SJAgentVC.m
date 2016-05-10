//
//  SJAgentVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/5/7.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJAgentVC.h"
#import "SJAgenceCell.h"
#import "SJAgentModel.h"

#define agentCellID @"agentCellID"

@interface SJAgentVC ()
{
    NSInteger _reqPage;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataArray;


@end

@implementation SJAgentVC

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
    
    self.navTitle = self.isSameLevel?@"我的同级":@"我的下级";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SJAgenceCell" bundle:nil] forCellReuseIdentifier:agentCellID];
    
    //refresh
    YDJHeaderRefresh *header = [YDJHeaderRefresh headerWithRefreshingBlock:^{
        [self requestAgent:@(1) isHeader:YES];
    }];
    self.tableView.mj_header = header;
    
    YDJFooterRefresh *footer = [YDJFooterRefresh footerWithRefreshingBlock:^{
        [self requestAgent:@(_reqPage) isHeader:NO];
    }];
    self.tableView.mj_footer = footer;
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)showNoneView
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];

    UILabel *label = [UILabel labelWithFontName:Theme_MainFont fontSize:16.0 fontColor:Theme_TextMainColor text:self.isSameLevel?@"你还没有同级代理哦~":@"你还没有下级代理哦~"];
    label.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:label];
    label.center = CGPointMake(bgView.width/2, bgView.height/2);
    self.tableView.tableHeaderView = bgView;
}

-(void)hideNoneView
{
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.01f)];
}

-(void)requestAgent:(NSNumber*)page isHeader:(BOOL)isHeader
{
    if(isHeader)
    {
        _reqPage = 1;
        [self.dataArray removeAllObjects];
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.isSameLevel?@"scancode.sys.peer.agency":@"scancode.sys.lower.agency", @"name", [YDJUserInfo sharedUserInfo].user_id, @"user_id", @(_reqPage), @"page", nil];
    [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
        id obj = dic[@"data"];
        if([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = obj;
            
            id tmpObj = dict[@"peer"];
            if([tmpObj isKindOfClass:[NSArray class]])
            {
                NSArray *array = tmpObj;
                
                for(id dictObj in array)
                {
                    if([dictObj isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary *tmpDict = dictObj;
                        
                        SJAgentModel *model = [[SJAgentModel alloc]init];
                        [model setValuesForKeysWithDictionary:tmpDict];
                        [self.dataArray addObject:model];
                    }
                }
                
                if(array.count == 0)
                {
                    [self showNoneView];
                }
                else
                {
                    [self hideNoneView];
                }
                
                if(array.count < 10)
                {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView reloadData];
                    return;
                }
                else
                {
                    _reqPage += 1;
                }
                
                [self.tableView reloadData];
            }
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } failure:^{
    
        [self showNoneView];

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    SJAgenceCell *cell = [tableView dequeueReusableCellWithIdentifier:agentCellID];
    if(indexPath.section < self.dataArray.count)
    {
        SJAgentModel *model = self.dataArray[indexPath.section];
        [cell configUI:model];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .01f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
