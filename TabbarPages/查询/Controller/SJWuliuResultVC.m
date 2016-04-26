//
//  SJWuliuResultVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/16.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJWuliuResultVC.h"
#import "SJWuliuCell.h"
#import "SJWuliuModel.h"

#define wuliuCellID @"wuliuCellID"

@interface SJWuliuResultVC ()<UITableViewDelegate, UITableViewDataSource>
{
    UILabel *_topLabel;
    UILabel *_downLabel;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation SJWuliuResultVC

-(NSMutableArray *)dataArray{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navTitle = @"物流信息";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SJWuliuCell" bundle:nil] forCellReuseIdentifier:wuliuCellID];
    
    [self requestWuliuData];
}

#pragma mark - 请求物流单号数据
-(void)requestWuliuData
{
    if(!self.orderId)
    {
        [YDJProgressHUD showTextToast:@"没有运单号" onView:self.view];
        return;
    }
        
    NSDictionary *params = @{@"name":@"scancode.sys.sms.search", @"id":self.orderId};
    
    [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
        
        id obj = dic[@"data"];
        if([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *tmpDict = obj;
            id object = tmpDict[@"data"];
            if([object isKindOfClass:[NSArray class]])
            {
                NSArray *array = object;
                for(id tmpObj in array)
                {
                    if([tmpObj isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary *dict = tmpObj;
                        SJWuliuModel *model = [[SJWuliuModel alloc]init];
                        [model setValuesForKeysWithDictionary:dict];
                        [self.dataArray addObject:model];
                    }
                }
                
            }
            
            NSString *com = [NSString stringWithFormat:@"快递公司：%@", tmpDict[@"com"]];
            [self createHeaderView:com];
            
            [self.tableView reloadData];
        }
       
    } failure:^{
        
    }];
}

-(void)createHeaderView:(NSString*)com
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    bgView.backgroundColor = RGBHEX(0xEEEEF4);
    
    _topLabel = [UILabel labelWithFontName:Theme_MainFont fontSize:12.0f fontColor:[UIColor blackColor] text:com];
    [bgView addSubview:_topLabel];
    _topLabel.left = 20;
    _topLabel.top = 20;
    
    _downLabel = [UILabel labelWithFontName:Theme_MainFont fontSize:12.0f fontColor:[UIColor blackColor] text:[NSString stringWithFormat:@"运单号：%@", self.orderId]];
    [bgView addSubview:_downLabel];
    _downLabel.left = 20;
    _downLabel.top = _topLabel.bottom + 10;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.height-1, ScreenWidth, 1)];
    line.backgroundColor = RGBHEX(0x979797);
    [bgView addSubview:line];
    
    self.tableView.tableHeaderView = bgView;
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
    SJWuliuCell *cell = [tableView dequeueReusableCellWithIdentifier:wuliuCellID];
    if(indexPath.section < self.dataArray.count)
    {
        [cell configUI:self.dataArray[indexPath.section] isFirst:indexPath.section==0?YES:NO];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < self.dataArray.count)
    {
        SJWuliuModel *model = self.dataArray[indexPath.section];
        return [SJWuliuCell heightForModel:model];
    }
    return .0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .01f;
}


@end
