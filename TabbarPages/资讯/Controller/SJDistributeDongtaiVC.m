//
//  SJDistributeDongtaiVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJDistributeDongtaiVC.h"
#import "TZImagePickerController.h"
#import "SJPhotoCell.h"
#import "SJHideTextView.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVFoundation.h>

#define BaseTag 3000

#define photoCellID @"photoCellID"

NSString *RefreshTableViewNotification = @"RefreshTableViewNotification";

@interface SJDistributeDongtaiVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate, UIAlertViewDelegate, ZLPhotoPickerBrowserViewControllerDelegate>
{
    UIImage *_addImage;
    UICollectionView *_collectionView;
    
    AVPlayer *_player;
    AVPlayerItem *_playItem;
    AVPlayerLayer *_playerLayer;
    
    UIButton *_playBtn;
    
    NSString *_videoPath;

    UIImage *_firstImage;
}
@property (weak, nonatomic) IBOutlet SJHideTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *charNumLabel;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (nonatomic, strong)NSMutableArray *pagePhotoArray;

@property (nonatomic, strong)NSMutableArray *browerArray;
@property (weak, nonatomic) IBOutlet UIView *progressNeedView;


@end

@implementation SJDistributeDongtaiVC

-(NSMutableArray *)pagePhotoArray
{
    if(_pagePhotoArray == nil)
    {
        _pagePhotoArray = [NSMutableArray arrayWithArray:self.photoArray];
    }
    
    return _pagePhotoArray;
}

-(NSMutableArray *)browerArray
{
    if(_browerArray == nil)
    {
        _browerArray = [NSMutableArray array];
    }
    
    return _browerArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navTitle = @"发布动态";
    
    self.textView.delegate = self;
    
    [self initNavBar];
    
    if(self.dongtaiType == photoType)
    {
        
        [self createCollectionView];
        
        _addImage = [UIImage imageNamed:@"addbeijing"];
        [self.pagePhotoArray addObject:_addImage];
        [_collectionView reloadData];
    }
    else if (self.dongtaiType == videoType)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:)name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        _firstImage = [UIImage thumbnailImageForVideo:self.videoUrl atTime:1];
        
        [self createPlayerView];
        [self createPlayBtn];
    }
    
}

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(range.location > 256)
        return NO;
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLabel.hidden = textView.text.length>0?YES:NO;
    
    self.charNumLabel.text = [NSString stringWithFormat:@"%ld/256", textView.text.length];
}

-(void)initNavBar
{
    self.backBtn.hidden = YES;
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 60, 44)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:cancelBtn];

    
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-60, 20, 60, 44)];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [sendBtn addTarget:self action:@selector(sendBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:sendBtn];
}

#pragma mark - 发送按钮事件
-(void)sendBtnAction
{
    [self.view endEditing:YES];
    
    NSMutableDictionary *tmpParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.info.publish", @"name", [YDJUserInfo sharedUserInfo].user_id, @"user_id", self.textView.text, @"content", [NSString stringWithFormat:@"%ld", self.dongtaiType], @"type",  nil];
    
    if(self.dongtaiType == videoType)
    {
        NSData *videoData = [NSData dataWithContentsOfURL:self.videoUrl];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.upload.video", @"name", nil];

        [self.view bringSubviewToFront:self.progressNeedView];
        [YDJProgressHUD showAnimationTextToast:@"上传中..." onView:self.progressNeedView];
        [QQNetworking requestUploadFormdataParam:params mediaData:videoData mediaType:Video view:self.progressNeedView success:^(NSDictionary *dic) {
            id obj = dic[@"data"];
            if([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict = obj;
                NSString *path = dict[@"path"];
                
                if(path)
                {
                    [tmpParams setObject:path forKey:@"path"];
                }
                
                if(_firstImage)
                {
                    NSData *imageData = UIImageJPEGRepresentation(_firstImage, 0.1f);
                    //上传封面图
                    [QQNetworking requestUploadFormdataParam:@{@"name":@"scancode.sys.upload_pic"} mediaData:imageData mediaType:Image view:self.progressNeedView success:^(NSDictionary *dic) {
                        
                        id obj = dic[@"data"];
                        if([obj isKindOfClass:[NSDictionary class]])
                        {
                            NSDictionary *dict = obj;
                            NSString *picPath = dict[@"path"];
                            if(picPath)
                            {
                                [tmpParams setObject:picPath forKey:@"banner"];
                            }
                            else
                            {
                                [tmpParams setObject:@"" forKey:@"banner"];
                            }
                            
                            //此处正式上传视频
                            [QQNetworking requestDataWithQQFormatParam:tmpParams view:self.progressNeedView success:^(NSDictionary *dic) {
                                
                                [[NSNotificationCenter defaultCenter]postNotificationName:RefreshTableViewNotification object:nil];
                                
                                [YDJProgressHUD hideDefaultProgress:self.progressNeedView];
                                [Utils delayWithDuration:2.0f DoSomeThingBlock:^{
                                    if(self.dongtaiType == photoType)
                                    {
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }
                                    else if(self.dongtaiType == videoType)
                                    {
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                    }
                                }];
                                [YDJProgressHUD showTextToast:@"上传成功" onView:self.progressNeedView];
                            } failure:^{
                                [self.view sendSubviewToBack:self.progressNeedView];
                                [YDJProgressHUD hideDefaultProgress:self.progressNeedView];
                            }];

                        }
                        
                    } failure:^{
                        [self.view sendSubviewToBack:self.progressNeedView];

                        [YDJProgressHUD hideDefaultProgress:self.progressNeedView];
                    }];
                }
                
            }
            
            [YDJProgressHUD hideDefaultProgress:self.progressNeedView];
        } failure:^{
            [self.view sendSubviewToBack:self.progressNeedView];
            [YDJProgressHUD hideDefaultProgress:self.progressNeedView];
        }];
    }
    else if(self.dongtaiType == photoType)
    {
        [self.pagePhotoArray removeObjectAtIndex:self.pagePhotoArray.count-1];
        NSMutableArray *tmpArray = [NSMutableArray array];
        for(NSInteger i = 1; i <= self.pagePhotoArray.count; i++)
        {
            UIImage *img = self.pagePhotoArray[i-1];
            NSData *data = UIImageJPEGRepresentation(img, 0.1f);
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:data forKey:@"data"];
            [dict setObject:[NSString stringWithFormat:@"image%ld", i] forKey:@"name"];
            
            [tmpArray addObject:dict];
        }
        
        [self.view bringSubviewToFront:self.progressNeedView];
        [YDJProgressHUD showAnimationTextToast:@"上传中..." onView:self.progressNeedView];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"scancode.sys.upload.mutipic", @"name", @(tmpArray.count), @"num", nil];
        [QQNetworking requestUploadFormdataParam:params mediaData:tmpArray mediaType:Image view:self.progressNeedView success:^(NSDictionary *dic) {
            id obj = dic[@"data"];
            if([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict = obj;
                NSMutableArray *pathArray = [NSMutableArray array];
                [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if([obj isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary *tmpDict = obj;
                        if(tmpDict[@"path"])
                        {
                            [pathArray addObject:tmpDict[@"path"]];
                        }
                    }
                }];
                
                
                NSString *str = [pathArray componentsJoinedByString:@","];
                [tmpParams setObject:str forKey:@"path"];
                
                [tmpParams setObject:@"banner" forKey:@"banner"];
                
                [QQNetworking requestDataWithQQFormatParam:tmpParams view:self.progressNeedView success:^(NSDictionary *dic) {
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:RefreshTableViewNotification object:nil];
                    
                    [YDJProgressHUD hideDefaultProgress:self.progressNeedView];
                    [Utils delayWithDuration:1.0f DoSomeThingBlock:^{
                        if(self.dongtaiType == photoType)
                        {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else if(self.dongtaiType == videoType)
                        {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                    }];
                    [YDJProgressHUD showTextToast:@"上传成功" onView:self.progressNeedView];
                } failure:^{
                    [self.view sendSubviewToBack:self.progressNeedView];
                    [YDJProgressHUD hideDefaultProgress:self.view];
                }];
            }
            
        } failure:^{
            [self.view sendSubviewToBack:self.progressNeedView];
            [YDJProgressHUD hideDefaultProgress:self.view];
        }];

    }
    
}

#pragma mark - 取消按钮事件
-(void)cancelBtnAction
{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:@"是否取消发布动态" delegate:self cancelButtonTitle:@"继续编辑" otherButtonTitles:@"放弃", nil];
    [av show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
#warning 这里用来解决pop的一个bug
        if(self.dongtaiType == photoType)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if(self.dongtaiType == videoType)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(void)createPlayBtn
{
    _playBtn = [[UIButton alloc]initWithFrame:_playerLayer.frame];
    [_playBtn setImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playBtn];
    [self.view bringSubviewToFront:_playBtn];
}

-(void)playBtnAction:(UIButton*)btn
{
    btn.hidden = YES;
    [_player play];
}

-(void)playbackFinished:(NSNotification *)notification
{
    _playBtn.hidden = NO;
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player pause];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_player pause];
    _player = nil;
}

#pragma mark - 创建播放视频视图
-(void)createPlayerView
{
    _playItem = [AVPlayerItem playerItemWithURL:self.videoUrl];
    _player = [AVPlayer playerWithPlayerItem:_playItem];
    _playerLayer =[AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(20, self.line.bottom+20, ScreenWidth - 20*2, 480*(ScreenWidth-20*2)/640);
    _playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//视频填充模式
    [self.view.layer addSublayer:_playerLayer];
}

-(void)createCollectionView
{
    CGSize itemSize = CGSizeMake((ScreenWidth - 20*2 - 3*10)/4, (ScreenWidth - 20*2 - 3*10)/4);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 10.0f;
    layout.minimumLineSpacing = 10.0f;
    layout.itemSize = itemSize;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(20, self.line.bottom+20, ScreenWidth - 20*2, ScreenHeight - self.line.y - 40) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"SJPhotoCell" bundle:nil] forCellWithReuseIdentifier:photoCellID];
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(self.pagePhotoArray.count >= 10)
    {
        return 9;
    }
    return self.pagePhotoArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SJPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellID forIndexPath:indexPath];
    if(indexPath.row < self.pagePhotoArray.count)
    {
        cell.photoImageView.image = self.pagePhotoArray[indexPath.row];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == self.pagePhotoArray.count-1)
    {
        [self addAction];
    }
    else
    {
        [self showPhotoBrower:indexPath count:self.pagePhotoArray.count - 1];
    }
}

-(void)showPhotoBrower:(NSIndexPath*)indexPath count:(NSInteger)count
{
    [self.browerArray removeAllObjects];
    
    for(NSInteger i = 0; i < count; i++)
    {
        ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:self.pagePhotoArray[i]];
        SJPhotoCell *cell = (SJPhotoCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        photo.toView = cell.photoImageView;
        [self.browerArray addObject:photo];
    }
    
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    pickerBrowser.status = UIViewAnimationAnimationStatusZoom;
    // 数据源/delegate
    pickerBrowser.delegate = self;
    //    pickerBrowser.editing = YES;
    pickerBrowser.photos = self.browerArray;
    // 当前选中的值
    pickerBrowser.currentIndex = indexPath.row;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser didCurrentPage:(NSUInteger)page
{
    
}

-(void)addAction
{
    LCActionSheet *as = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"拍照", @"从相册选择"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
        if (buttonIndex == 0)
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
        else if (buttonIndex == 1)
        {
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(9-self.pagePhotoArray.count+1) delegate:nil];
            SJWEAKSELF
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
                if(weakSelf.pagePhotoArray.count-1 < 9)
                {
                    [weakSelf.pagePhotoArray removeObjectAtIndex:weakSelf.pagePhotoArray.count-1];
                    [weakSelf.pagePhotoArray addObjectsFromArray:photos];
                    [weakSelf.pagePhotoArray addObject:_addImage];
                    [_collectionView reloadData];
                }
            }];
            
            // Set the appearance
            // 在这里设置imagePickerVc的外观
            // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
            // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
            // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
            
            // Set allow picking video & originalPhoto or not
            // 设置是否可以选择视频/原图
            imagePickerVc.allowPickingVideo = NO;
            imagePickerVc.allowPickingOriginalPhoto = YES;
            
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }];
    [as show];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *oriImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.pagePhotoArray removeObjectAtIndex:self.pagePhotoArray.count-1];
    [self.pagePhotoArray addObject:oriImage];
    [self.pagePhotoArray addObject:_addImage];
    [_collectionView reloadData];
    
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

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
