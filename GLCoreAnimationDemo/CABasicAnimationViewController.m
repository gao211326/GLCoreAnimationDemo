//
//  CABasicAnimationViewController.m
//  GLCoreAnimationDemo
//
//  Created by 高磊 on 2017/2/20.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "CABasicAnimationViewController.h"

@interface CABasicAnimationViewController ()

@property (nonatomic,assign) CGSize normalSize;

@end

@implementation CABasicAnimationViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.normalSize = CGSizeMake(60, 60);
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self showAnimation];
}

- (void)showAnimation
{
    CAShapeLayer * circle = [CAShapeLayer layer];
    circle.frame = self.view.bounds;
    
    //
    UIBezierPath  * circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)) radius:self.normalSize.width/2 -1 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    circle.path = circlePath.CGPath;
    circle.strokeColor = [UIColor blueColor].CGColor;
    circle.fillColor = nil;
    [self.view.layer addSublayer:circle];
    
    //通过圆的strokeStart 改变来进行改变
    CABasicAnimation * strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(0.2);
    strokeStartAnimation.toValue = @(0);
    
    //通过圆的strokeEnd 改变来进行改变
    CABasicAnimation * strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @0.5;
    strokeEndAnimation.toValue = @(1.0);
    
    //通过圆的transform.rotation.z 改变来进行改变
    CABasicAnimation * rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = @(-M_PI * 2);
    
    //组合动画
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.duration = 5;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.animations = @[strokeStartAnimation,strokeEndAnimation,rotationAnimation];
    [circle addAnimation:group forKey:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
