//
//  SJHotZixunVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJHotZixunVC.h"

#import "SJDongtaiCell.h"
#import "SJVideoCell.h"
#import "SJZixunModel.h"

#define dongtaiCellID @"dongtaiCellID"
#define videoCellID @"videoCellID"

@interface SJHotZixunVC ()<UITableViewDataSource, UITableViewDelegate>
{
    UIScrollView *_sv;
    UIPageControl *_pc;
}

@property (nonatomic, strong)NSMutableArray *imageArray;

@property (nonatomic, strong)NSMutableArray *dataArray;


@end

@implementation SJHotZixunVC

-(NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

-(NSMutableArray *)imageArray
{
    if(_imageArray == nil)
    {
        _imageArray = [NSMutableArray array];
    }
    
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navBar.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SJDongtaiCell" bundle:nil] forCellReuseIdentifier:dongtaiCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SJVideoCell" bundle:nil] forCellReuseIdentifier:videoCellID];
    
    [self createHeaderView];
    
    [self requestZixunWithPage:@(1)];
}

-(void)createHeaderView
{
    [self requestBanner];
}

-(void)requestZixunWithPage:(NSNumber*)number
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.user.hot.info", @"name", @"1", @"page", nil];
    [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
        
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
                    [self.dataArray addObject:model];
                }
            }
        }
        
        [self.tableView reloadData];
    }];
}

-(void)requestBanner
{
    [QQNetworking requestDataWithQQFormatParam:@{@"name":@"scancode.sys.official.info"} view:self.view success:^(NSDictionary *dic) {
        id data = dic[@"data"];
        if([data isKindOfClass:[NSArray class]])
        {
            NSArray *array = data;
            for(NSDictionary *dict in array)
            {
                if(dict[@"img"])
                {
                    [self.imageArray addObject:dict[@"img"]];
                }
            }
        }
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
        _sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, bgView.height)];
        _sv.delegate = self;
        _sv.showsHorizontalScrollIndicator = NO;
        _sv.pagingEnabled = YES;
        [bgView addSubview:_sv];
        self.tableView.tableHeaderView = bgView;
        
        _pc = [[UIPageControl alloc]init];
        _pc.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pc.pageIndicatorTintColor = RGBHEX(0xf0f0f0);
        _pc.numberOfPages = self.imageArray.count;
        [bgView addSubview:_pc];
        [_pc sizeToFit];
        _pc.center = CGPointMake(ScreenWidth/2, bgView.bottom - 20);
        
        
        for(NSInteger i = 0; i < self.imageArray.count; i++)
        {
            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(i*ScreenWidth, 0, ScreenWidth, _sv.height)];
            [iv sd_setImageWithURL:[NSURL URLWithString:self.imageArray[i]] placeholderImage:nil];
            [_sv addSubview:iv];
            iv.tag = 1000+i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [iv addGestureRecognizer:tap];
        }
        
        _sv.contentSize = CGSizeMake(ScreenWidth *self.imageArray.count, 200);
    }];
}

-(void)tapAction:(UITapGestureRecognizer*)ges
{
    
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
    
    if(indexPath.section < self.dataArray.count)
    {
        SJZixunModel *zixunModel = self.dataArray[indexPath.section];
        if([zixunModel.type integerValue] == 0) //图片
        {
            SJDongtaiCell *dongtaiCell = [tableView dequeueReusableCellWithIdentifier:dongtaiCellID];
            dongtaiCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [dongtaiCell configUI:zixunModel leftBtnBlock:^{
                
            } midBtnBlock:^{
                
            } rightBtnBlock:^{
                
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
