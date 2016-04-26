//
//  SJPersonalCenterVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJPersonalCenterVC.h"

#import "SJDongtaiCell.h"
#import "SJVideoCell.h"
#import "SJZixunModel.h"

#define dongtaiCellID @"dongtaiCellID"
#define videoCellID @"videoCellID"

@interface SJPersonalCenterVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation SJPersonalCenterVC

-(NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navBar.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SJDongtaiCell" bundle:nil] forCellReuseIdentifier:dongtaiCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SJVideoCell" bundle:nil] forCellReuseIdentifier:videoCellID];
    
    [self createHeaderView];
    
    [self requestPersonalZixun];
}

-(void)requestPersonalZixun
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.mine.info", @"name", [QQDataManager manager].userId, @"visit_id", @(1), @"page", nil];
    [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
        id obj = dic[@"data"];
        if([obj isKindOfClass:[NSArray class]])
        {
            NSArray *array = obj;
            for(id tmpObj in array)
            {
                if([tmpObj isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dict = tmpObj;
                    
                    SJZixunModel *model = [[SJZixunModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.dataArray addObject:model];
                }
            }
            
            [self.tableView reloadData];
        }
    }];
}

-(void)createHeaderView
{
    UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 160)];
    headerView.image = [UIImage imageNamed:@"gerenzhongxinHeaderView"];
    headerView.userInteractionEnabled = YES;
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 60, 44)];
    [backBtn setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backBtn];
    
    UIImageView *touxiangImageView = [[UIImageView alloc]initWithFrame:CGRectMake(35, backBtn.bottom+5, 65, 65)];
    touxiangImageView.layer.cornerRadius = touxiangImageView.width/2;
    touxiangImageView.layer.masksToBounds = YES;
    touxiangImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    touxiangImageView.layer.borderWidth = 1;
    [headerView addSubview:touxiangImageView];
    
    UILabel *nameLabel = [UILabel labelWithFontName:Theme_MainFont fontSize:17.0f fontColor:[UIColor whiteColor] text:@"扫码啦"];
    nameLabel.left = touxiangImageView.right + 20;
    nameLabel.top = touxiangImageView.top + 10;
    [headerView addSubview:nameLabel];
    
    UILabel *stateLabel = [UILabel labelWithFontName:Theme_MainFont fontSize:12.0f fontColor:[UIColor whiteColor] text:@"认证状态"];
    stateLabel.left = touxiangImageView.right + 20;
    stateLabel.top = nameLabel.bottom + 5;
    [headerView addSubview:stateLabel];
    
    self.tableView.tableHeaderView = headerView;
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 发布动态按钮事件
- (IBAction)distributeBtnAction:(id)sender
{
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
    if(indexPath.section < self.dataArray.count)
    {
        SJZixunModel *zixunModel = self.dataArray[indexPath.section];
        SJWEAKSELF
        if([zixunModel.type integerValue] == 0) //图片
        {
            SJDongtaiCell *dongtaiCell = [tableView dequeueReusableCellWithIdentifier:dongtaiCellID];
            dongtaiCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [dongtaiCell configUI:zixunModel leftBtnBlock:^{
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.add.infonum", @"name", zixunModel.tmpId, @"user_info_id", nil];
                [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
                    
                }];
            } midBtnBlock:^{
                
            } rightBtnBlock:^{
                LCActionSheet *as = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"删除"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
                    if(buttonIndex == 0)
                    {
                        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.del.info", @"name", zixunModel.tmpId, @"info_id", nil];
                        [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
                            [YDJProgressHUD showTextToast:@"删除成功" onView:weakSelf.view];
                            
                            [weakSelf.dataArray removeObject:zixunModel];
                            [weakSelf.tableView reloadData];
                        }];
                    }
                }
                ];
                [as show];
            }];
            return dongtaiCell;
        }
        else if ([zixunModel.type integerValue] == 1) //视频
        {
            SJVideoCell *videoCell = [tableView dequeueReusableCellWithIdentifier:videoCellID];
            videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [videoCell configUI:zixunModel];
            
            return videoCell;
        }
    }
    
    return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell isKindOfClass:[SJVideoCell class]])
    {
        SJVideoCell *videoCell = (SJVideoCell*)cell;
        [videoCell willDisplay];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if([cell isKindOfClass:[SJVideoCell class]])
    {
        SJVideoCell *videoCell = (SJVideoCell*)cell;
        [videoCell endDisplay];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < self.dataArray.count)
    {
        SJZixunModel *model = self.dataArray[indexPath.section];
        
        if([model.type integerValue] == 0)
        {
            return [SJDongtaiCell heightForModel:model];
        }
        else if ([model.type integerValue] == 1)
        {
            return [SJVideoCell heightForModel:model];
        }
    }
    
    return .0f;
}

@end
