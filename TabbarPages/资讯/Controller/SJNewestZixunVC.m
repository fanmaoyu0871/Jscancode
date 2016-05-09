//
//  SJNewestZixunVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJNewestZixunVC.h"
#import "SJZixunModel.h"

@interface SJNewestZixunVC ()
{
    NSInteger _reqPage;
}
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation SJNewestZixunVC

-(NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

-(void)beginRefresh
{
    [self.tableView.mj_header beginRefreshing];
}

-(void)requestZixunIsHeader:(BOOL)isHeader
{
    if(isHeader)
    {
        _reqPage = 1;
        [self.dataArray removeAllObjects];
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.user.new.info", @"name", @(_reqPage), @"page", nil];
    [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic){
        
        id obj = dic[@"data"];
        
        if([obj isKindOfClass:[NSArray class]])
        {
            NSArray *array = obj;
            
            for(id obj in array)
            {
                if([obj isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *tmpDict = obj;
                    SJZixunModel *model = [[SJZixunModel alloc]init];
                    [model setValuesForKeysWithDictionary:tmpDict];
                    model.tmpId = tmpDict[@"id"];
                    [self.dataArray addObject:model];
                }
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
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];

    } failure:^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)createHeaderView
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
