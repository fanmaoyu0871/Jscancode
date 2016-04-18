//
//  SJCaptureVideoVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJCaptureVideoVC.h"
#import <AVFoundation/AVFoundation.h>
#import "SJDistributeDongtaiVC.h"


@interface SJCaptureVideoVC ()<AVCaptureFileOutputRecordingDelegate>
{
    AVCaptureSession *_session;
    
    AVCaptureMovieFileOutput *_outputVideo;
    
    AVCaptureVideoPreviewLayer *_previewLayer;
    
    UIImageView *_lpImageView;
    
    UILabel *_tipLabel;
    
    CALayer *_progressLayer;
    
    BOOL _canSave;
}

@property (nonatomic, strong)CADisplayLink *link;


@end

@implementation SJCaptureVideoVC

-(CADisplayLink *)link
{
    if(_link == nil)
    {
        _link  =[CADisplayLink displayLinkWithTarget:self selector:@selector(linkAction)];
        [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    
    return _link;
}

-(void)linkAction
{
    CGRect tmpRect = _progressLayer.frame;
    tmpRect.size.width += ScreenWidth / (60*6);
    _progressLayer.frame = tmpRect;
    
    if(tmpRect.size.width >= ScreenWidth)
    {
        [self stopRecord];
        SJDistributeDongtaiVC *vc = [[SJDistributeDongtaiVC alloc]initWithNibName:@"SJDistributeDongtaiVC" bundle:nil];
        vc.videoUrl = [self outPutFileURL];
        vc.dongtaiType = videoType;
        [self.navigationController setViewControllers:@[vc] animated:YES];
        
        [_link invalidate];
        _link = nil;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navBar.hidden = YES;
    
    [self createNavBar];

    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (!(authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied))
    {
        [self initCapture];

    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:@"请在iPhone的\"设置-隐私－相机\"选项中，允许壹哒健访问你的摄像头" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [av show];
    }
    
}

-(void)createNavBar
{
    UIImageView *navBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    navBar.image = [UIImage imageNamed:@"captureNavBar"];
    navBar.userInteractionEnabled = YES;
    [self.view addSubview:navBar];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 60, 44)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont fontWithName:Theme_MainFont size:14.0f];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:cancelBtn];
}

-(void)cancelBtnAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)initCapture
{
    
    //session
    _session = [[AVCaptureSession alloc] init];
    if ([_session canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        [_session setSessionPreset:AVCaptureSessionPreset640x480];
    }
    
    [_session beginConfiguration];
    
    /***************init input***************/
    //camera
    NSArray *deviceArray = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];//first后置
    AVCaptureDeviceInput *inputVideo = [AVCaptureDeviceInput deviceInputWithDevice:[deviceArray firstObject] error:NULL];
    
    //micro
    AVCaptureDevice *deviceAudio = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *inputAudio = [AVCaptureDeviceInput deviceInputWithDevice:deviceAudio error:NULL];
    
    if ([_session canAddInput:inputVideo])
    {
        [_session addInput:inputVideo];
    }
    
    if ([_session canAddInput:inputAudio])
    {
        [_session addInput:inputAudio];
    }
    
    /***************init video output***************/
    _outputVideo = [[AVCaptureMovieFileOutput alloc] init];
    if([_session canAddOutput:_outputVideo])
    {
        [_session addOutput:_outputVideo];
        AVCaptureConnection *captureConnection = [_outputVideo connectionWithMediaType:AVMediaTypeVideo];
        // 视频稳定设置
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
        
        captureConnection.videoScaleAndCropFactor = captureConnection.videoMaxScaleAndCropFactor;
    }
    
    
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = CGRectMake(0, 64, ScreenWidth, 480*ScreenWidth/640);
    [self.view.layer addSublayer:_previewLayer];
    
    [_session commitConfiguration];
    
    [_session startRunning];

    _lpImageView = [[UIImageView alloc]init];
    _lpImageView.image = [UIImage imageNamed:@"anzhupai"];
    _lpImageView.userInteractionEnabled = YES;
    [self.view addSubview:_lpImageView];
    [_lpImageView sizeToFit];
    _lpImageView.centerX = ScreenWidth/2;
    _lpImageView.top = 64 + 480*ScreenWidth/640 + 50;
    
    _tipLabel = [UILabel labelWithFontName:Theme_MainFont fontSize:14.0f fontColor:[UIColor whiteColor] text:@"上滑取消"];
    [self.view addSubview:_tipLabel];
    [self.view bringSubviewToFront:_tipLabel];
    NSLog(@"%@", NSStringFromCGRect(_previewLayer.frame));
    _tipLabel.center = CGPointMake(ScreenWidth/2, _previewLayer.frame.origin.y+_previewLayer.frame.size.height-20);
    
    _progressLayer = [CALayer layer];
    _progressLayer.backgroundColor = Theme_MainColor.CGColor;
    _progressLayer.frame = CGRectMake(0, _previewLayer.frame.origin.y + _previewLayer.frame.size.height-3, 0, 4);
    [self.view.layer addSublayer:_progressLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark touchs

- (void)isFitCondition:(BOOL)condition
{
    if (condition) {
        _tipLabel.text = @"上滑取消";
        _tipLabel.backgroundColor = [UIColor orangeColor];
        _tipLabel.textColor = [UIColor blackColor];
        [_tipLabel sizeToFit];
        _tipLabel.center = CGPointMake(ScreenWidth/2, _previewLayer.frame.origin.y+_previewLayer.frame.size.height-20);
        
    }else{
        _tipLabel.text = @"松手取消录制";
        _tipLabel.backgroundColor = [UIColor redColor];
        _tipLabel.textColor = [UIColor whiteColor];
        [_tipLabel sizeToFit];
        _tipLabel.center = CGPointMake(ScreenWidth/2, _previewLayer.frame.origin.y+_previewLayer.frame.size.height-20);
    }
}

- (void)startAnimation
{
    self.link.paused = NO;

    [UIView animateWithDuration:0.5 animations:^{
        _tipLabel.alpha = 1.0;
        _lpImageView.alpha = 0.0;
        _lpImageView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    } completion:^(BOOL finished) {
    }];
}

-(void)stopAnimation
{
    self.link.paused = YES;

    [UIView animateWithDuration:0.5 animations:^{
        _tipLabel.alpha = 0.0;
        _lpImageView.alpha = 1.0;
        _lpImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        CGRect tmpRect = _progressLayer.frame;
        tmpRect.size.width = 0;
        _progressLayer.frame = tmpRect;
    }];
}

-(void)finishRecoed
{
    _canSave = YES;
    [self stopAnimation];
    [self stopRecord];
}

-(void)cancelRecord
{
    _canSave = NO;
    [self stopAnimation];
    [self stopRecord];
    NSURL *outFileUrl = [self outPutFileURL];
    [[NSFileManager defaultManager]removeItemAtURL:outFileUrl error:nil];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    BOOL condition = CGRectContainsPoint(_lpImageView.frame, point);
    
    if (condition) {
        [self isFitCondition:condition];
    }
    
    [self startRecord];
    [self startAnimation];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    BOOL condition = CGRectContainsPoint(_lpImageView.frame, point);
    
    [self isFitCondition:condition];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    BOOL condition = CGRectContainsPoint(_lpImageView.frame, point);
    /*
     结束时候咱们设定有两种情况依然算录制成功
     1.抬手时,录制时长 > 1/3总时长
     2.录制进度条完成时,就算手指超出按钮范围也算录制成功 -- 此时 end 方法不会调用,因为用户手指还在屏幕上,所以直接代码调用录制成功的方法,将控制器切换
     */
    if(!condition)
    {
        [self cancelRecord];
        return;
    }
    else
    {
        if (_progressLayer.frame.size.width >= ScreenWidth * 0.67) {
            //录制完成
            [self finishRecoed];
        }
        else
        {
            [self cancelRecord];
        }

    }
    
}

#pragma mark 录制相关

- (NSURL *)outPutFileURL
{
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"outPut.mov"]];
}

- (void)startRecord
{
    [_outputVideo startRecordingToOutputFileURL:[self outPutFileURL] recordingDelegate:self];
}

- (void)stopRecord
{
    // 取消视频拍摄
    [_outputVideo stopRecording];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"---- 开始录制 ----");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"---- 录制结束 ---%@-%@ ",outputFileURL,captureOutput.outputFileURL);
    
    if (outputFileURL.absoluteString.length == 0 && captureOutput.outputFileURL.absoluteString.length == 0 ) {
        NSLog(@"录制视频保存地址出错");
        return;
    }
    
    if(_canSave)
    {
        SJDistributeDongtaiVC *vc = [[SJDistributeDongtaiVC alloc]initWithNibName:@"SJDistributeDongtaiVC" bundle:nil];
        vc.videoUrl = [self outPutFileURL];
        vc.dongtaiType = videoType;
        [self.navigationController setViewControllers:@[vc] animated:YES];
    }
}

-(void)dealloc
{
    [_link invalidate];
    _link = nil;
    
    [_session stopRunning];
    _session = nil;
}

@end
