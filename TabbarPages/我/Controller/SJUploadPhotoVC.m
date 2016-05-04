//
//  SJUploadPhotoVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJUploadPhotoVC.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

NSString *uploadPhotoSuccessNotification = @"uploadPhotoSuccessNotification";

@interface SJUploadPhotoVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL _isForeBtn;
    NSData *_imageData;
}
@property (weak, nonatomic) IBOutlet UIButton *foreImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;

@property (weak, nonatomic) IBOutlet UIView *progressNeedView;
@end

@implementation SJUploadPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navTitle = @"上传照片";
    
    self.foreImageBtn.layer.cornerRadius = 5;
    self.foreImageBtn.layer.masksToBounds = YES;
    self.foreImageBtn.layer.borderColor = RGBHEX(0xf0f0f0).CGColor;
    self.foreImageBtn.layer.borderWidth = 2;
    
//    self.uploadBtn.enabled = _editImage?YES:NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)uploadBtnAction:(id)sender
{
    if(_imageData == nil)
    {
        [YDJProgressHUD showTextToast:@"请上传照片" onView:self.progressNeedView];
        return;
    }
    
    [self.view bringSubviewToFront:self.progressNeedView];
    [YDJProgressHUD showAnimationTextToast:@"上传中..." onView:self.progressNeedView];
    
    [QQNetworking requestUploadFormdataParam:@{@"name":@"scancode.sys.upload_pic"} mediaData:_imageData mediaType:Image view:self.progressNeedView success:^(NSDictionary *dic) {
        [YDJProgressHUD hideDefaultProgress:self.progressNeedView];
        
        id obj = dic[@"data"];
        if([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = obj;
            NSString *path = dict[@"path"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:uploadPhotoSuccessNotification object:path];
            [Utils delayWithDuration:2.0f DoSomeThingBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [YDJProgressHUD showTextToast:@"图片上传成功" onView:self.progressNeedView];
        }
   } failure:^{

       [self.view sendSubviewToBack:self.progressNeedView];
       [YDJProgressHUD hideDefaultProgress:self.progressNeedView];
   }];
    
}

- (IBAction)pickImageBtnAction:(UIButton*)btn
{
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"拍照", @"从相册中选取"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
        if(buttonIndex == 0)
        {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (!(authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied))
            {
                UIImagePickerController *pc = [[UIImagePickerController alloc]init];
                pc.sourceType = UIImagePickerControllerSourceTypeCamera;
                pc.delegate = self;
                pc.allowsEditing = YES;
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
        else if (buttonIndex == 1)
        {
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if (!(author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied)){
                UIImagePickerController *pc = [[UIImagePickerController alloc]init];
                pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                pc.delegate = self;
                pc.allowsEditing = YES;
                [self presentViewController:pc animated:YES completion:^{
                    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                }];
            }
            else
            {
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:@"请在iPhone的\"设置-隐私－相机\"选项中，允许壹哒健访问你的手机相册" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [av show];
            }
        }
    }];
    [sheet show];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    _imageData = UIImageJPEGRepresentation(editImage, 0.1);

    self.uploadBtn.enabled = YES;
    
    [self.foreImageBtn setTitle:@"" forState:UIControlStateNormal];
    [self.foreImageBtn setBackgroundImage:editImage forState:UIControlStateNormal];
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
}


@end
