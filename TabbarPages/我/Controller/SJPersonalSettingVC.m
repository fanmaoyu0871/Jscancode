//
//  SJPersonalSettingVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJPersonalSettingVC.h"
#import "SJDefaultCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#define cellID @"cellID"

@interface SJPersonalSettingVC ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSArray *_titleArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SJPersonalSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _titleArr = @[@"修改昵称", @"更换头像"];
    
    self.navTitle = @"个人设置";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SJDefaultCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SJDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.leftLabel.text = _titleArr[indexPath.row];
    return cell;
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
    
    if(indexPath.row == 0)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"请输入昵称"
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
        
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        [av show];
    }
    else if (indexPath.row == 1)
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
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
    else //确定
    {
        UITextField *tf = [alertView textFieldAtIndex:0];
        NSLog(@"%@", tf.text);
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    
    
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
