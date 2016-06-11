//
//  LOLScanViewController.m
//  掌上英雄联盟
//
//  Created by 尚承教育 on 15/8/24.
//  Copyright (c) 2015年 尚承教育. All rights reserved.
//

#import "LOLScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MYHomeHospitalDeatilViewController.h"
#import "MYHeader.h"

static BOOL isLightOn = NO;
@interface LOLScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic)  AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) AVCaptureSession *session;
@property(strong,nonatomic) UIView * scanView;
@property(strong,nonatomic) CALayer * lineLayer;

@end

@implementation LOLScanViewController

-(void)viewWillAppear:(BOOL)animated
{
    
    [self settingScanView];
    [self settingCamera];
   [self scanLineAnimation];
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.lineLayer.hidden = YES;
    self.vc = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
//    [self settingScanView];
//    [self settingCamera];
//    [self scanLineAnimation];
    
    
    self.title = @"二维码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"开灯" style:UIBarButtonItemStyleDone target:self action:@selector(shangguangdeng)];
}
//打开LED闪光灯
-(void)turnOnLed:(bool)update
{
    AVCaptureDevice *device=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch])
    {
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
        [device unlockForConfiguration];
    }
    if (update)
    {
        isLightOn=YES;
    }
}

//关闭LED闪光灯
-(void)turnOffLed:(bool)update
{
    AVCaptureDevice *device=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch])
    {
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
    if (update)
    {
        isLightOn=NO;
    }
}
- (void)shangguangdeng
{
    if (isLightOn)
    {
        [self turnOffLed:YES];
    }
    else
    {
        [self turnOnLed:YES];
    }
}


//设置扫描框¸
- (void)settingScanView
{
    //设置扫描框
    UIView *scanView = [[UIView alloc] init];
    self.scanView = scanView;
    scanView.size = CGSizeMake(200, 200);
    scanView.centerX = self.view.centerX;
    scanView.centerY = self.view.centerY * 0.9;
    scanView.layer.borderWidth = 1;
    scanView.layer.borderColor = [UIColor orangeColor].CGColor;
    scanView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scanView];
    
    [self draw];
}

//初始化相机(扫描设备)
- (void)settingCamera
{
   // 1. 摄像头设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2. 设置输入
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error) {
        
        [MBProgressHUD showError:@"没有摄像头"];
        return;
    }
    
    // 3. 设置输出（Metadata元数据）
    AVCaptureMetadataOutput *outPut = [[AVCaptureMetadataOutput alloc] init];
    [outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 4. 拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    //添加session的输入和输出
    [session addInput:input];
    [session addOutput:outPut];
    
    //输出格式
    [outPut setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // 5. 设置预览图层(用来让用户能够看到扫描情况)
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    
    // 设置图层的属性
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    // 设置preview图层的大小
    [preview setFrame:self.view.bounds];
    
    //将图层添加的视图的图层
    [self.view.layer insertSublayer:preview atIndex:0];
    
    self.previewLayer = preview;
    
    // 6 启动会话
    [session startRunning];
    
    self.session = session;
    
}

//扫描框动画
- (void)scanLineAnimation
{
    
    CALayer *lineLayer = [[CALayer alloc] init];
    self.lineLayer = lineLayer;
    lineLayer.bounds = CGRectMake(0, 0, 198, 2);
    lineLayer.position = CGPointMake(self.view.width / 2, self.view.height / 2);
    lineLayer.backgroundColor = [UIColor whiteColor].CGColor;
    lineLayer.borderColor = [UIColor whiteColor].CGColor;
    lineLayer.shadowColor = [UIColor redColor].CGColor;
    lineLayer.shadowOffset = CGSizeMake(2, 1);
    lineLayer.shadowOpacity = 1;
    lineLayer.shadowRadius = 5;
    [self.view.layer addSublayer:lineLayer];
    
    
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(self.view.centerX, self.view.height / 2 * 0.9 - 100)];
    NSValue *pathValue = [NSValue valueWithCGPoint:CGPointMake(self.view.centerX, self.view.height / 2 * 0.9 + 100)];
    NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.centerX, self.view.height / 2 * 0.9 - 100)];
    keyAnimation.values = @[fromValue,pathValue,toValue];
    keyAnimation.duration = 5;
    keyAnimation.repeatCount = HUGE_VALF;
    [lineLayer addAnimation:keyAnimation forKey:@"lineLayerAnimation"];


}
-(void)draw
{
    //整个二维码扫描界面的颜色
    CGSize viewSize =self.view.bounds.size;
    CGRect screenDrawRect =CGRectMake(0, 0, viewSize.width,viewSize.height);
    
    //中间清空的矩形框
    CGRect clearDrawRect = CGRectMake(screenDrawRect.size.width / 2 - self.scanView.width / 2,screenDrawRect.size.height / 2 - self.scanView.height / 2 -40,self.scanView.width,self.scanView.height);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self addScreenFillRect:ctx rect:screenDrawRect];
    [self addCenterClearRect:ctx rect:clearDrawRect];
    [self addWhiteRect:ctx rect:clearDrawRect];
    [self addCornerLineWithContext:ctx rect:clearDrawRect];

}
- (void)addScreenFillRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextSetRGBFillColor(ctx, 60 / 255.0,40 / 255.0,40 / 255.0,0.5);
    CGContextFillRect(ctx, rect);   //draw the transparent layer
}

- (void)addCenterClearRect :(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextClearRect(ctx, rect);  //clear the center rect  of the layer
}

- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextStrokeRect(ctx, rect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 0.8);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
}
- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect{
    
    //画四个边角
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 52 /255.0, 152/255.0, 219/255.0, 1);//蓝色
    
    //左上角
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y),
        CGPointMake(rect.origin.x+0.7 , rect.origin.y + 15)
    };
    
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y +0.7),CGPointMake(rect.origin.x + 15, rect.origin.y+0.7)};
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    
    //左下角
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x+ 0.7, rect.origin.y + rect.size.height - 15),CGPointMake(rect.origin.x +0.7,rect.origin.y + rect.size.height)};
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x , rect.origin.y + rect.size.height - 0.7) ,CGPointMake(rect.origin.x+0.7 +15, rect.origin.y + rect.size.height - 0.7)};
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - 15, rect.origin.y+0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y +0.7 )};
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width-0.7, rect.origin.y),CGPointMake(rect.origin.x + rect.size.width-0.7,rect.origin.y + 15 +0.7 )};
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width -0.7 , rect.origin.y+rect.size.height+ -15),CGPointMake(rect.origin.x-0.7 + rect.size.width,rect.origin.y +rect.size.height )};
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - 15 , rect.origin.y + rect.size.height-0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y + rect.size.height - 0.7 )};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    CGContextStrokePath(ctx);
}
- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}

//处理扫描的结果
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
         // 会频繁的扫描，调用代理方法
    // 1.如果扫描完成，停止会话
    [self.session stopRunning];
    
    // 2. 删除图层
    [self.previewLayer removeFromSuperlayer];
    
    // 3.设置界面显示扫描结果
//     NSLog(@"%@,",metadataObjects);
    
    if (metadataObjects.count > 0) {
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        NSString *scanResult = obj.stringValue;
        
        if ([scanResult containsString:@"http"]) {
            
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scanResult]];
            
            MYHomeHospitalDeatilViewController *webviewVC = [[MYHomeHospitalDeatilViewController alloc]init];
            webviewVC.url = scanResult;
            webviewVC.tag = 3;
            [self.navigationController pushViewController:webviewVC animated:YES];
        }
        else
        {
            [MBProgressHUD showError:@"暂不支持条形码扫描"];
        }
       
        
        
    
        
    }
    

    
}

@end
