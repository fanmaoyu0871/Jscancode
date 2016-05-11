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
#import "JSAdScrollView.h"
#import "FMMovieDecoder.h"
#import "JSAdScrollView.h"

#define dongtaiCellID @"dongtaiCellID"
#define videoCellID @"videoCellID"

extern NSString *RefreshTableViewNotification;


@interface SJHotZixunVC ()<UITableViewDataSource, UITableViewDelegate>
{
    UIScrollView *_sv;
    UIPageControl *_pc;
    
    NSInteger _reqPage;
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

-(void)beginRefresh
{
    [self.tableView.mj_header beginRefreshing];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)needRefreshNotiAction
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(needRefreshNotiAction) name:RefreshTableViewNotification object:nil];
    
    self.navBar.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SJDongtaiCell" bundle:nil] forCellReuseIdentifier:dongtaiCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SJVideoCell" bundle:nil] forCellReuseIdentifier:videoCellID];
    
    [self createHeaderView];
    
    //refresh
    YDJHeaderRefresh *header = [YDJHeaderRefresh headerWithRefreshingBlock:^{
        [self requestZixunIsHeader:YES];
        if([self isKindOfClass:[SJHotZixunVC class]])
        {
            JSAdScrollView *adSv = (JSAdScrollView*)self.tableView.tableHeaderView;
            [adSv reloadData];
        }
    }];
    self.tableView.mj_header = header;
    
    YDJFooterRefresh *footer = [YDJFooterRefresh footerWithRefreshingBlock:^{
        [self requestZixunIsHeader:NO];
    }];
    self.tableView.mj_footer = footer;
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)createHeaderView
{
    JSAdScrollView *adScrollView = [[JSAdScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth / (750.0f / 260.0f))];
    self.tableView.tableHeaderView = adScrollView;
}

-(void)requestZixunIsHeader:(BOOL)isHeader
{
    if(isHeader)
    {
        _reqPage = 1;
        [self.dataArray removeAllObjects];
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.user.hot.info", @"name", @(_reqPage), @"page", nil];
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
        SJWEAKSELF
        if([zixunModel.type integerValue] == 0) //图片
        {
            SJDongtaiCell *dongtaiCell = [tableView dequeueReusableCellWithIdentifier:dongtaiCellID];
            dongtaiCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [dongtaiCell configUI:zixunModel leftBtnBlock:^{
                                
            } midBtnBlock:^{
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.info.share", @"name", zixunModel.tmpId, @"info_id",  nil];
                [YDJProgressHUD showSystemIndicator:YES];
                [QQNetworking requestDataWithQQFormatParam:params view:weakSelf.view success:^(NSDictionary *dic) {
                    [YDJProgressHUD showSystemIndicator:NO];

                    id obj = dic[@"data"];
                    if([obj isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary *tmpDict = obj;
                        NSString *shareUrl = tmpDict[@"url"];
                        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
                        [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
                        [UMSocialData defaultData].extConfig.wechatSessionData.title = @"资讯详情";
                        [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"资讯详情";
                        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
                        
                        [UMSocialData defaultData].extConfig.qqData.title = @"资讯详情";
                        [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
                        [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
                        
                        [UMSocialSnsService presentSnsIconSheetView:self
                                                             appKey:nil
                                                          shareText:[NSString stringWithFormat:@"资讯详情%@", shareUrl]
                                                         shareImage:[UIImage imageNamed:@"icon.png"]
                                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline, UMShareToSina, UMShareToQQ]
                                                           delegate:nil];
                    }
                    
                } failure:^{
                    [YDJProgressHUD showSystemIndicator:NO];
                }];
            } rightBtnBlock:^{
                LCActionSheet *as = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"举报"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
                    if(buttonIndex == 0)
                    {
                        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.report.info", @"name", [YDJUserInfo sharedUserInfo].user_id, @"user_id", zixunModel.tmpId, @"info_id", nil];
                        [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
                            [YDJProgressHUD showTextToast:@"举报成功" onView:weakSelf.view];
                            
                        } failure:^{
                            
                        }];
                     }
                }];
                [as show];
                
            } viewController:self];
            return dongtaiCell;
        }
        else if ([zixunModel.type integerValue] == 1) //视频
        {
            SJVideoCell *videoCell = [tableView dequeueReusableCellWithIdentifier:videoCellID];
            videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [videoCell configUI:zixunModel leftBtnBlock:^{
                
            } midBtnBlock:^{
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.info.share", @"name", zixunModel.tmpId, @"info_id",  nil];
                [YDJProgressHUD showSystemIndicator:YES];
                [QQNetworking requestDataWithQQFormatParam:params view:weakSelf.view success:^(NSDictionary *dic) {
                    [YDJProgressHUD showSystemIndicator:NO];
                    
                    id obj = dic[@"data"];
                    if([obj isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary *tmpDict = obj;
                        NSString *shareUrl = tmpDict[@"url"];
                        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
                        [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
                        [UMSocialData defaultData].extConfig.wechatSessionData.title = @"资讯详情";
                        [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"资讯详情";
                        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
                        
                        
                        [UMSocialData defaultData].extConfig.qqData.title = @"资讯详情";
                        [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
                        [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
                        
                        [UMSocialSnsService presentSnsIconSheetView:self
                                                             appKey:nil
                                                          shareText:[NSString stringWithFormat:@"资讯详情%@", shareUrl]
                                                         shareImage:[UIImage imageNamed:@"icon.png"]
                                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline, UMShareToSina, UMShareToQQ]
                                                           delegate:nil];
                    }
                    
                } failure:^{
                    [YDJProgressHUD showSystemIndicator:NO];
                }];

            } rightBtnBlock:^{
                LCActionSheet *as = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"举报"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
                    if(buttonIndex == 0)
                    {
                        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.report.info", @"name", [YDJUserInfo sharedUserInfo].user_id, @"user_id", zixunModel.tmpId, @"info_id", nil];
                        [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
                            [YDJProgressHUD showTextToast:@"举报成功" onView:weakSelf.view];
                            
                            [weakSelf.dataArray removeObject:zixunModel];
                            [weakSelf.tableView reloadData];
                        } failure:^{
                            
                        }];
                    }
                }];
                [as show];
                
            } viewController:self];
            
            
            return videoCell;
        }
    }
    return [[UITableViewCell alloc]init];
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
