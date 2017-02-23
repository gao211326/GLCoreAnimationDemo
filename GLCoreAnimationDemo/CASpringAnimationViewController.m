//
//  CASpringAnimationViewController.m
//  GLCoreAnimationDemo
//
//  Created by 高磊 on 2017/2/20.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "CASpringAnimationViewController.h"

//按钮数
static NSInteger const kShowButtonNumber = 3;

static NSInteger const kButtonTag = 1000;

@interface CASpringAnimationViewController ()<CAAnimationDelegate>
{
    //展示动画的按钮
    UIButton *      _showAnimationButton;
    
}
@end

@implementation CASpringAnimationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addShowAnimationButton];
    
    [self addShowButton];
}


#pragma mark == private method
- (void)addShowAnimationButton
{
    _showAnimationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _showAnimationButton.frame = CGRectMake((CGRectGetWidth(self.view.frame) - 40)/2, CGRectGetHeight(self.view.frame) - 200, 40, 40);
    [_showAnimationButton setBackgroundImage:[UIImage imageNamed:@"加"] forState:UIControlStateNormal];
    [_showAnimationButton addTarget:self action:@selector(showAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showAnimationButton];
}

- (void)addShowButton
{
    for (int i = 0 ; i < kShowButtonNumber; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = kButtonTag + i;
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon%d",(i + 1)]] forState:UIControlStateNormal];
        button.alpha = 0.0;
        button.backgroundColor = [UIColor clearColor];
        
        button.frame = _showAnimationButton.frame;
        [self.view insertSubview:button belowSubview:_showAnimationButton];
    }
}

- (void)showAnimation
{
    CGFloat buttonMargin = 60;
    CGFloat padding = (self.view.frame.size.width - buttonMargin*3)/4.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        _showAnimationButton.transform = CGAffineTransformMakeRotation(-M_PI_4);
    }];
    
    for (int i = 0; i < kShowButtonNumber; i ++)
    {
        //变化的是position  故下面加按钮宽的一半 默认的position为（0.5,0.5）
        CGRect rect = CGRectMake((i+ 1)*padding + i * buttonMargin + buttonMargin / 2, CGRectGetMinY(_showAnimationButton.frame) - 100, buttonMargin, buttonMargin);
        
        UIButton *button = [self.view viewWithTag:(kButtonTag + i)];
        
        //缩放
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @(1.0);
        scaleAnimation.toValue = @(1.5);
        
        //透明度
        CABasicAnimation *animationoPacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animationoPacity.fromValue = @(0);
        animationoPacity.toValue = @(1);
        
        //绕z轴旋转
        CABasicAnimation *transAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        transAnimation.fromValue = @(M_PI_4 / (i + 1));
        transAnimation.toValue = @(0);
        
        
        //ios9后面才出现 弹簧动画
        CASpringAnimation *positionAnimation = [CASpringAnimation animationWithKeyPath:@"position"];
        positionAnimation.toValue = [NSValue valueWithCGPoint:rect.origin];
        //质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大
        positionAnimation.mass = 0.1;
        //阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快
        positionAnimation.damping = 2;
        //刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快
        positionAnimation.stiffness = 50;
        //初始速率，动画视图的初始速度大小
        //速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反
        positionAnimation.initialVelocity = -10;
        
        //组合动画
        CAAnimationGroup *animationGroup=[CAAnimationGroup animation];
        animationGroup.animations = @[animationoPacity,scaleAnimation,positionAnimation,transAnimation];
        animationGroup.duration = 0.5;
        //让动画延迟执行
        animationGroup.beginTime = CACurrentMediaTime() + i*(0.4/kShowButtonNumber);
        animationGroup.removedOnCompletion = NO;
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.delegate = (id)self;
        
        [button.layer addAnimation:animationGroup forKey:[NSString stringWithFormat:@"animation%ld",(long)i]];
    }
}

- (void)closeAnimation
{
    CGFloat buttonMargin = 40;
    
    [UIView animateWithDuration:0.3 animations:^{
        _showAnimationButton.transform = CGAffineTransformIdentity;
    }];
    
    
    for (int i = 0; i < kShowButtonNumber; i ++)
    {
        CGRect rect = (CGRect){_showAnimationButton.center,CGSizeMake(buttonMargin, buttonMargin)};
        
        UIButton *button = [self.view viewWithTag:(kButtonTag + i)];
        
        //缩放
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.toValue = @(0.5);
        
        //透明度
        CABasicAnimation *animationoPacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animationoPacity.fromValue = @(1);
        animationoPacity.toValue = @(0);
        
        //绕z轴旋转
        CABasicAnimation *transAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        transAnimation.fromValue = @(-M_PI_4 / (i + 1));
        transAnimation.toValue = @(0);
        

        //不用弹簧动画
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.toValue = [NSValue valueWithCGPoint:rect.origin];
        
        
        CAAnimationGroup *animationGroup=[CAAnimationGroup animation];
        animationGroup.animations = @[animationoPacity,scaleAnimation,positionAnimation,transAnimation];
        animationGroup.duration = 0.5;
        //让动画延迟执行
        //CACurrentMediaTime() ---> 为图层的当前时间
        animationGroup.beginTime = CACurrentMediaTime() + i*(0.4/kShowButtonNumber);
        animationGroup.removedOnCompletion = NO;
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.delegate = (id)self;
        
        //-----1
//        [animationGroup setValue:[NSString stringWithFormat:@"animationClose%ld",(long)i] forKey:[NSString stringWithFormat:@"animationGroup%ld",(long)i]];
        
        //-----2
        [button.layer addAnimation:animationGroup forKey:[NSString stringWithFormat:@"animationClose%ld",(long)i]];
    }
}


#pragma mark == CAAnimationDelegate

//动画结束时调用  方法中的-----1  和 -----2和上面的一一对应 都可以用来判断是那个动画结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    UIButton *button = [self.view viewWithTag:kButtonTag];
    
    //-----2
    if ([anim isEqual:[button.layer animationForKey:@"animation0"]])
    {
        NSLog(@" 打印信息:-----  0");
    }
    
    //-----1
//    if ([[anim valueForKey:@"animationGroup0"] isEqualToString: @"animationClose0"])
//    {
//        NSLog(@" 打印信息:++++++   0");
//    }
}

#pragma mark == event response
- (void)showAnimation:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (!sender.selected)
    {
        [self closeAnimation];
    }
    else
    {
        [self showAnimation];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
