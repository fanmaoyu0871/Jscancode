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
#import "SJUploadPhotoVC.h"

#define cellID @"cellID"

extern NSString *uploadPhotoSuccessNotification;

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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadPhotoSuccess:) name:uploadPhotoSuccessNotification object:nil];
    
    _titleArr = @[@"修改昵称", @"更换头像"];
    
    self.navTitle = @"个人设置";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SJDefaultCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
}

-(void)uploadPhotoSuccess:(NSNotification*)noti
{
    NSString *path = noti.object;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.userhead.change", @"name", [YDJUserInfo sharedUserInfo].user_id, @"user_id", path, @"head", nil];
    
    [YDJProgressHUD showSystemIndicator:YES];
    [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
        [YDJProgressHUD showSystemIndicator:NO];
        [YDJProgressHUD showTextToast:@"头像更换成功" onView:self.view];
        
        //修改完后更新下单例
        [YDJUserInfo sharedUserInfo].head = path;
        
    } failure:^{
        [YDJProgressHUD showSystemIndicator:NO];
    }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
        SJUploadPhotoVC *vc = [[SJUploadPhotoVC alloc]initWithNibName:@"SJUploadPhotoVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
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
        
        if(tf.text.length > 8 || tf.text.length == 0)
        {
            [YDJProgressHUD showTextToast:@"姓名8个字符以内哦～" onView:self.view];
            return;
        }

        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.username.change", @"name", [YDJUserInfo sharedUserInfo].user_id, @"user_id", tf.text, @"user_name", nil];
        [YDJProgressHUD showDefaultProgress:self.view];
        [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
            [YDJProgressHUD hideDefaultProgress:self.view];
            [YDJProgressHUD showTextToast:@"昵称修改成功" onView:self.view];
            
            //修改完后更新下单例
            [YDJUserInfo sharedUserInfo].name = tf.text;
            
        } failure:^{
            [YDJProgressHUD hideDefaultProgress:self.view];
        }];
    }
}

@end
