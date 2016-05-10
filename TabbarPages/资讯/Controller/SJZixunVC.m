//
//  SJZixunVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/16.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJZixunVC.h"
#import "SJNewestZixunVC.h"
#import "SJHotZixunVC.h"
#import "TZImagePickerController.h"
#import "SJDistributeDongtaiVC.h"
#import "SJCaptureVideoVC.h"
#import "SJNavigationController.h"
#import "SJWarningView.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVAudioSession.h>

#define BaseTag 1500

@interface SJZixunVC ()<UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LCActionSheetDelegate>
{
    UIView *_line;
    
    UIView *_bgView;
    
    SJWarningView *_warnView;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) SJNewestZixunVC *newestVC;
@property (nonatomic, strong) SJHotZixunVC *hotVC;

@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation SJZixunVC

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
    
    self.scrollView.contentSize = CGSizeMake(ScreenWidth*2, ScreenWidth-64-49);
    self.scrollView.delegate = self;
    
    [self initNavBar];
    [self initChildVC];
    
    [self topBtnAction:[_bgView viewWithTag:BaseTag]];
}

-(void)initChildVC
{
    self.newestVC = [[SJNewestZixunVC alloc]initWithNibName:@"SJNewestZixunVC" bundle:nil];
    [self addChildViewController:self.newestVC];
    [self.scrollView addSubview:self.newestVC.view];
    self.hotVC = [[SJHotZixunVC alloc]initWithNibName:@"SJHotZixunVC" bundle:nil];
    [self addChildViewController:self.hotVC];
    [self.scrollView addSubview:self.hotVC.view];
}

-(void)viewDidLayoutSubviews
{
    self.hotVC.view.frame = CGRectMake(0, 0, ScreenWidth, self.scrollView.height);
    self.newestVC.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, self.scrollView.height);
}

-(void)initNavBar
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-80*2, 30)];
    [self.navBar addSubview:_bgView];
    _bgView.center = CGPointMake(self.navBar.width/2, 45);
    
    NSArray *_titleArr = @[@"精选", @"最新"];
    
    CGFloat btnW = _bgView.width / 2;
    for(NSInteger i = 0; i < 2; i++)
    {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnW*i, 0, btnW, _bgView.height)];
        btn.tag = BaseTag + i;
        [btn setTitle:_titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [btn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:btn];
    }
    
    CGFloat width = [UILabel sizeWithText:@"最新" fontSize:17.0f].width + 10;
    _line = [[UIView alloc]initWithFrame:CGRectMake(0, _bgView.height, width, 4)];
    _line.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:_line];
    
    UIButton *cameraBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-60, 24, 60, 44)];
    [cameraBtn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(cameraBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:cameraBtn];
}

-(void)cameraBtnAction
{
    if([[YDJUserInfo sharedUserInfo].user_type integerValue] == 0)
    {
        [YDJProgressHUD showTextToast:@"请先登录哦～" onView:self.view];
        return;
    }
    
    LCActionSheet *as = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"小视频", @"拍照", @"从相册选择"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
        
        [_warnView dismiss];
        
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
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:@"请在iPhone的\"设置-隐私－相机\"选项中，允许吉莫特访问你的相机" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
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
    
    if(_warnView == nil)
    {
        _warnView = [[SJWarningView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 200)];
        _warnView.tapBlock = ^{
        };
    }
    [_warnView show];
    
}

-(void)topBtnAction:(UIButton*)btn
{
    NSInteger index = btn.tag - BaseTag;
    
    [UIView animateWithDuration:0.3f animations:^{
        _line.center = CGPointMake(btn.centerX, _bgView.height);
    }];
   
    [self.scrollView setContentOffset:index == 0?CGPointZero:CGPointMake(ScreenWidth, 0) animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / ScreenWidth;
    [self topBtnAction:[_bgView viewWithTag:BaseTag+index]];
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

@end
