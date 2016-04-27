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

#import "TZImagePickerController.h"
#import "SJDistributeDongtaiVC.h"
#import "SJCaptureVideoVC.h"
#import "SJNavigationController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#define dongtaiCellID @"dongtaiCellID"
#define videoCellID @"videoCellID"

@interface SJPersonalCenterVC ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
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
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.mine.info", @"name", [YDJUserInfo sharedUserInfo].user_id, @"visit_id", @(1), @"page", nil];
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
                    model.tmpId = dict[@"id"];
                    [self.dataArray addObject:model];
                }
            }
            
            [self.tableView reloadData];
        }
    } failure:^{
        
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
    [touxiangImageView sd_setImageWithURL:[NSURL URLWithString:[YDJUserInfo sharedUserInfo].head]];
    [headerView addSubview:touxiangImageView];
    
    NSString *name = nil;
    if([YDJUserInfo sharedUserInfo].name)
    {
        name = [YDJUserInfo sharedUserInfo].name;
    }
    else
    {
        name = @"未设置昵称";
    }
    UILabel *nameLabel = [UILabel labelWithFontName:Theme_MainFont fontSize:17.0f fontColor:[UIColor whiteColor] text:name];
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
    
    LCActionSheet *as = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"小视频", @"拍照", @"从相册选择"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
        if(buttonIndex == 0)
        {
            SJCaptureVideoVC *vc = [[SJCaptureVideoVC alloc]initWithNibName:@"SJCaptureVideoVC" bundle:nil];
            SJNavigationController *navVC = [[SJNavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:navVC animated:YES completion:nil];
        }
        else if (buttonIndex == 1)
        {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (!(authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied))
            {
                UIImagePickerController *pc = [[UIImagePickerController alloc]init];
                pc.sourceType = UIImagePickerControllerSourceTypeCamera;
                pc.delegate = self;
                [self presentViewController:pc animated:YES completion:^{
                    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                }];
            }
            else
            {
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:@"请在iPhone的\"设置-隐私－相机\"选项中，允许壹哒健访问你的相机" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [av show];
            }
            
        }
        else if (buttonIndex == 2)
        {
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
            SJWEAKSELF
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
                SJDistributeDongtaiVC *vc = [[SJDistributeDongtaiVC alloc]initWithNibName:@"SJDistributeDongtaiVC" bundle:nil];
                vc.dongtaiType = photoType;
                vc.photoArray = photos;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            
            // Set the appearance
            // 在这里设置imagePickerVc的外观
            // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
            // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
            // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
            
            // Set allow picking video & originalPhoto or not
            // 设置是否可以选择视频/原图
            imagePickerVc.allowPickingVideo = NO;
            imagePickerVc.allowPickingOriginalPhoto = NO;
            
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }];
    [as show];

}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *oriImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if(oriImage)
        {
            NSArray *array = @[oriImage];
            SJDistributeDongtaiVC *vc = [[SJDistributeDongtaiVC alloc]initWithNibName:@"SJDistributeDongtaiVC" bundle:nil];
            vc.dongtaiType = photoType;
            vc.photoArray = array;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
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
                [YDJProgressHUD showSystemIndicator:YES];
                [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
                    [YDJProgressHUD showSystemIndicator:NO];
                }failure:^{
                    [YDJProgressHUD showSystemIndicator:NO];
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
                        } failure:^{
                            
                        }];
                    }
                }
                ];
                [as show];
            } viewController:self];
            return dongtaiCell;
        }
        else if ([zixunModel.type integerValue] == 1) //视频
        {
            SJVideoCell *videoCell = [tableView dequeueReusableCellWithIdentifier:videoCellID];
            videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [videoCell configUI:zixunModel leftBtnBlock:^{
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.add.infonum", @"name", zixunModel.tmpId, @"user_info_id", nil];
                [YDJProgressHUD showSystemIndicator:YES];
                [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
                    [YDJProgressHUD showSystemIndicator:NO];
                }failure:^{
                    [YDJProgressHUD showSystemIndicator:NO];
                }];
                
                
            } midBtnBlock:^{
                
            } rightBtnBlock:^{
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.del.info", @"name", zixunModel.tmpId, @"info_id", nil];
                [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
                    [YDJProgressHUD showTextToast:@"删除成功" onView:weakSelf.view];
                    
                    [weakSelf.dataArray removeObject:zixunModel];
                    [weakSelf.tableView reloadData];
                } failure:^{
                    
                }];
            } viewController:self];
            
            return videoCell;
        }
    }
    
    return [[UITableViewCell alloc]init];
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if([cell isKindOfClass:[SJVideoCell class]])
//    {
//        SJVideoCell *videoCell = (SJVideoCell*)cell;
//        [videoCell willDisplay];
//    }
//}
//
//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
//{
//    if([cell isKindOfClass:[SJVideoCell class]])
//    {
//        SJVideoCell *videoCell = (SJVideoCell*)cell;
//        [videoCell endDisplay];
//    }
//}

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
