//
//  CAAnimationGroupViewController.m
//  GLCoreAnimationDemo
//
//  Created by 高磊 on 2017/2/20.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "CAAnimationGroupViewController.h"

@interface CAAnimationGroupViewController ()<CAAnimationDelegate>
{
    //定义一个圆球layer
    CALayer *   _ballLayer;
}
@end

@implementation CAAnimationGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *animationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    animationButton.frame = CGRectMake(220, 70, 70, 30);
    animationButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [animationButton setTitle:@"执行动画" forState:UIControlStateNormal];
    animationButton.backgroundColor = [UIColor orangeColor];
    [animationButton addTarget:self action:@selector(showAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:animationButton];
    
    _ballLayer = [CALayer layer];
    _ballLayer.frame = CGRectMake((self.view.frame.size.width - 30)/2.0, self.view.frame.size.height - 30, 30, 30);
    _ballLayer.contents = (id)[UIImage imageNamed:@"玩具熊"].CGImage;
    [self.view.layer addSublayer:_ballLayer];
}


#pragma mark == private method

//发射
- (void)launchAnimation
{
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    animation1.fromValue = @(1.0);
    animation1.toValue = @(1.5);
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    animation2.fromValue = @(1.0);
    animation2.toValue = @(1.5);
    
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"position"];
    animation3.fromValue = [NSValue valueWithCGPoint:_ballLayer.position];
    animation3.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width - (30 * 1.3)/2.0 , _ballLayer.position.y - 200)];
    
    
    CAAnimationGroup *anima = [CAAnimationGroup animation];
    anima.animations = @[animation1, animation2,animation3];
    anima.duration = 1.0;
    anima.delegate = (id)self;
    anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anima.fillMode = kCAFillModeForwards;
    anima.removedOnCompletion = NO;
    
    [_ballLayer addAnimation:anima forKey:@"group_launch"];
}

//形变
- (void)reverseAnimation
{
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    animation1.toValue = @(1.0);
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    animation2.toValue = @(1.0);
    
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"position"];
    animation3.toValue = [NSValue valueWithCGPoint:CGPointMake(_ballLayer.position.x , _ballLayer.position.y - 400)];
    
    CAAnimationGroup *anima = [CAAnimationGroup animation];
    anima.animations = @[animation1, animation2,animation3];
    anima.duration = 1.0;
    anima.delegate = (id)self;
    anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anima.fillMode = kCAFillModeForwards;
    anima.removedOnCompletion = NO;
    
    [_ballLayer addAnimation:anima forKey:@"group_reverse"];
}


//抖动效果
- (void)jitterAnimation
{

    CAKeyframeAnimation *keyAnimation=[CAKeyframeAnimation animation];
    keyAnimation.keyPath = @"transform.rotation.z";

    keyAnimation.values = @[@(-10 * M_PI / 180),@(10 * M_PI / 180),@(-10 * M_PI / 180)];
    //是否按路径返回
    keyAnimation.autoreverses = true;
    //动画将在设置的 beginTime 后开始执行（如没有设置beginTime属性，则动画立即执行），动画执行完成后将layer恢复原状
    keyAnimation.fillMode = kCAFillModeRemoved;
    keyAnimation.duration = 1;
    
    keyAnimation.delegate = self;
    [_ballLayer addAnimation:keyAnimation forKey:nil];
}
#pragma mark == event response
- (void)showAnimation:(UIButton *)sender
{
    [self launchAnimation];
}

#pragma mark == CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([anim isEqual:[_ballLayer animationForKey:@"group_launch"]])
    {
        [self reverseAnimation];
    }
    else if ([anim isEqual:[_ballLayer animationForKey:@"group_reverse"]])
    {
        [self jitterAnimation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
