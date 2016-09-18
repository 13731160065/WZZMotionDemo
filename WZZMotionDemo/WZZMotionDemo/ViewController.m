//
//  ViewController.m
//  WZZMotionDemo
//
//  Created by 王泽众 on 16/9/8.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "ViewController.h"
#import "WZZMotionManager.h"
#import "WZZDrawView.h"

@interface ViewController ()
{
    WZZMotionManager * manager;
    WZZDrawView * dView;
    CGFloat currentX;
    CGFloat currentY;
    CGFloat currentZ;
}
@property (weak, nonatomic) IBOutlet UIView *xyzView;
@property (weak, nonatomic) IBOutlet UIButton *startB;
@property (weak, nonatomic) IBOutlet UISwitch *s1;
@property (weak, nonatomic) IBOutlet UISwitch *s2;
@property (weak, nonatomic) IBOutlet UISwitch *s3;
@property (weak, nonatomic) IBOutlet UILabel *bx1;
@property (weak, nonatomic) IBOutlet UILabel *by1;
@property (weak, nonatomic) IBOutlet UILabel *bz1;
@property (weak, nonatomic) IBOutlet UILabel *bx2;
@property (weak, nonatomic) IBOutlet UILabel *by2;
@property (weak, nonatomic) IBOutlet UILabel *bz2;
@property (weak, nonatomic) IBOutlet UILabel *bx3;
@property (weak, nonatomic) IBOutlet UILabel *by3;
@property (weak, nonatomic) IBOutlet UILabel *bz3;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    manager = [WZZMotionManager sharedWZZMotionManager];
    dView = [[WZZDrawView alloc] initWithFrame:_xyzView.bounds];
    [_xyzView addSubview:dView];
    [dView setAutoReload:YES];
    [dView setBackgroundColor:[UIColor whiteColor]];
    //x轴
    [dView drawLineWithPoint1:CGPointMake(0, dView.frame.size.height/2) point2:CGPointMake(dView.frame.size.width, dView.frame.size.height/2) color:[UIColor blackColor] border:1];
    //y轴
    [dView drawLineWithPoint1:CGPointMake(dView.frame.size.width/2, 0) point2:CGPointMake(dView.frame.size.width/2, dView.frame.size.height) color:[UIColor blackColor] border:1];
    //z轴
    [dView drawLineWithPoint1:CGPointMake(0, dView.frame.size.height) point2:CGPointMake(dView.frame.size.width, 0) color:[UIColor blackColor] border:1];
    [_seg setSelectedSegmentIndex:0];
}

- (IBAction)selectChange:(id)sender {
    [dView clear];
    if (_seg.selectedSegmentIndex == 0) {
        
    } else {
        currentX = 0;
        currentY = 0;
        currentZ = 0;
    }
}


- (IBAction)startEnd:(id)sender {
    const CGFloat danwei = dView.frame.size.width/2;
    if ([_startB.titleLabel.text isEqualToString:@"开始测试"]) {
        [_startB setTitle:@"停止测试" forState:UIControlStateNormal];
        NSLog(@"1");
        //开始
        [manager startUpdateWithReturnModel:^(WZZMotionModel *dataModel) {
            _bx1.text = [@"x:" stringByAppendingString:@(dataModel.a.x).stringValue];
            _by1.text = [@"y:" stringByAppendingString:@(dataModel.a.y).stringValue];
            _bz1.text = [@"z:" stringByAppendingString:@(dataModel.a.z).stringValue];
            
            _bx2.text = [@"x:" stringByAppendingString:@(dataModel.xyz.x).stringValue];
            _by2.text = [@"y:" stringByAppendingString:@(dataModel.xyz.y).stringValue];
            _bz2.text = [@"z:" stringByAppendingString:@(dataModel.xyz.z).stringValue];
            
            _bx3.text = [@"x:" stringByAppendingString:@(dataModel.ns.x).stringValue];
            _by3.text = [@"y:" stringByAppendingString:@(dataModel.ns.y).stringValue];
            _bz3.text = [@"z:" stringByAppendingString:@(dataModel.ns.z).stringValue];
            
            CGFloat datax = 0;
            CGFloat datay = 0;
            CGFloat dataz = 0;
            if (_s3.on) {
                datax = dataModel.ns.x/100;
                datay = dataModel.ns.y/100;
                dataz = dataModel.ns.z/100;
            }
            if (_s2.on) {
                datax = dataModel.xyz.x;
                datay = dataModel.xyz.y;
                dataz = dataModel.xyz.z;
            }
            if (_s1.on) {
                datax = dataModel.a.x;
                datay = dataModel.a.y;
                dataz = dataModel.a.z;
            }
            [dView clear];
            if (_seg.selectedSegmentIndex == 0) {
                //x轴
                [dView drawLineWithPoint1:CGPointMake(0, dView.frame.size.height/2) point2:CGPointMake(dView.frame.size.width, dView.frame.size.height/2) color:[UIColor blackColor] border:1];
                //y轴
                [dView drawLineWithPoint1:CGPointMake(dView.frame.size.width/2, 0) point2:CGPointMake(dView.frame.size.width/2, dView.frame.size.height) color:[UIColor blackColor] border:1];
                //z轴
                [dView drawLineWithPoint1:CGPointMake(0, dView.frame.size.height) point2:CGPointMake(dView.frame.size.width, 0) color:[UIColor blackColor] border:1];
                CGFloat fff = (sqrt(pow(dataz, 2)/2));
                [dView drawPoint:CGPointMake(datax*danwei+danwei+fff, datay*danwei+danwei+fff) color:[UIColor redColor] border:3];
            } else {
                if (datax>0.1 || datax<-0.1) {
                    currentX += datax;
                }
                if (datay>0.1 || datay<-0.1) {
                    currentY += datay;
                }
                if (dataz>0.1 || dataz<-0.1) {
                    currentZ += dataz;
                }
                //x轴
                [dView drawLineWithPoint1:CGPointMake(0, dView.frame.size.height/2) point2:CGPointMake(dView.frame.size.width, dView.frame.size.height/2) color:[UIColor blackColor] border:1];
                //y轴
                [dView drawLineWithPoint1:CGPointMake(dView.frame.size.width/2, 0) point2:CGPointMake(dView.frame.size.width/2, dView.frame.size.height) color:[UIColor blackColor] border:1];
                //z轴
                [dView drawLineWithPoint1:CGPointMake(0, dView.frame.size.height) point2:CGPointMake(dView.frame.size.width, 0) color:[UIColor blackColor] border:1];
//                CGFloat fff = (sqrt(pow(currentZ*danwei/4, 2)/2));
//                [dView drawPoint:CGPointMake(currentX*danwei/4+danwei+fff, currentY*danwei/4+danwei+fff) color:[UIColor redColor] border:3];
                [dView drawPoint:CGPointMake(currentX*danwei/4+danwei, currentY*danwei/4+danwei) color:[UIColor redColor] border:3];
//                //x轴
//                [dView drawLineWithPoint1:CGPointMake(0+currentY*danwei/4, dView.frame.size.height/2) point2:CGPointMake(dView.frame.size.width-currentY*danwei/4, dView.frame.size.height/2) color:[UIColor blackColor] border:1];
//                //y轴
//                [dView drawLineWithPoint1:CGPointMake(dView.frame.size.width/2, 0+currentX*danwei/4) point2:CGPointMake(dView.frame.size.width/2, dView.frame.size.height-currentX*danwei/4) color:[UIColor blackColor] border:1];
//                //z轴
//                [dView drawLineWithPoint1:CGPointMake(0, dView.frame.size.height) point2:CGPointMake(dView.frame.size.width, 0) color:[UIColor blackColor] border:1];
            }
        }];
    } else {
        NSLog(@"2");
        [_startB setTitle:@"开始测试" forState:UIControlStateNormal];
        //停止
        [manager stopUpdate];
    }
}

- (IBAction)s1c:(id)sender {
    manager.openA = _s1.on;
}
- (IBAction)s2c:(id)sender {
    manager.openXYZ = _s2.on;
}
- (IBAction)s3c:(id)sender {
    manager.openNS = _s3.on;
}

@end
