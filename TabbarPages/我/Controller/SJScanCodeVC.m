//
//  SJScanCodeVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/20.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJScanCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@interface SJScanCodeVC ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureVideoPreviewLayer *_previewLayer;
    
    UIImageView *_moveLine;
}
@end

@implementation SJScanCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navBar.hidden = YES;
    
    [self initUI];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (!(authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied))
    {
        [self initDevice];
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:@"请在iPhone的\"设置-隐私－相机\"选项中，允许xx访问你的相机" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [av show];
    }
}

-(void)initUI
{
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(50, (ScreenHeight - (ScreenWidth - 50*2))/2, ScreenWidth - 50*2, ScreenWidth - 50*2)];
    bgView.image = [UIImage imageNamed:@"saomiaobeijing"];
    bgView.layer.masksToBounds = YES;
    [self.view addSubview:bgView];
    
    _moveLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qrcode_scanner_line"]];
    _moveLine.frame = bgView.bounds;
    _moveLine.bottom = 0;
    [bgView addSubview:_moveLine];
    [self moveLineAnimation];
    
    //蒙板
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    UIBezierPath *boundsPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    UIBezierPath *insidePath = [UIBezierPath bezierPathWithRect:CGRectMake(50, (ScreenHeight - (ScreenWidth - 50*2))/2, ScreenWidth - 50*2, ScreenWidth - 50*2)];
    [boundsPath appendPath:insidePath];
    [boundsPath setUsesEvenOddFillRule:YES];
    
    mask.path = boundsPath.CGPath;
    mask.fillRule =kCAFillRuleEvenOdd;
    mask.fillColor = [UIColor colorWithWhite:0 alpha:0.3f].CGColor;
    [self.view.layer addSublayer:mask];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 60, 44)];
    [backBtn setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)moveLineAnimation
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position.y"];
    anim.fromValue = @(-(ScreenWidth - 50*2));
    anim.toValue = @(ScreenWidth - 50*2);
    anim.duration = 1.5f;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.repeatCount = MAXFLOAT;
    [_moveLine.layer addAnimation:anim forKey:@"animation"];
}


-(void)initDevice
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error != nil) {
        NSLog(@"error===%@",[error description]);
        return;
    }
    if ([_session canAddInput:input]) {
        [_session addInput:input];
    }
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    output.rectOfInterest = CGRectMake(((ScreenHeight - (ScreenWidth - 50*2))/2)/ScreenHeight, 50/ScreenWidth, (ScreenWidth-50*2)/ScreenHeight, (ScreenWidth-50*2)/ScreenWidth);
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if ([_session canAddOutput:output]) {
        [_session addOutput:output];
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    }
    [_session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    if (metadataObjects.count > 0) {
        [_session stopRunning];
        
        AVMetadataMachineReadableCodeObject *meta = (AVMetadataMachineReadableCodeObject *)metadataObjects[0];
        
        NSLog(@"%@", meta.stringValue);
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
