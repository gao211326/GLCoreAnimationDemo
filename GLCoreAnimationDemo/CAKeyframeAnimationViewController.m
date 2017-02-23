//
//  CAKeyframeAnimationViewController.m
//  GLCoreAnimationDemo
//
//  Created by 高磊 on 2017/2/20.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "CAKeyframeAnimationViewController.h"

@interface CAKeyframeAnimationViewController ()<CAAnimationDelegate>
{
    UIImageView *   _imageView;
    
    UIImageView *   _fishImageView;
    
    CGPoint         _beginPoint;//默认的position
}
@end

@implementation CAKeyframeAnimationViewController

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
    
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    CGFloat image_h = 300;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (height - image_h)/2.0, width, image_h)];
    _imageView.image = [UIImage imageNamed:@"water.jpg"];
    [self.view addSubview:_imageView];
    
    _fishImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 41, 32)];
    _fishImageView.image = [UIImage imageNamed:@"鱼"];
    [_imageView addSubview:_fishImageView];
    
    _beginPoint = _fishImageView.layer.position;
}


//用CGPathRef的方式进行展示动画
- (void)showKeyFrameAnimationWithPath
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:_fishImageView.layer.position];
    //三次贝塞尔曲线
    [path addCurveToPoint:CGPointMake(300, 200) controlPoint1:CGPointMake(150, 400) controlPoint2:CGPointMake(230, -100)];
    
    animation.path = path.CGPath;
    animation.duration = 5.0;
    animation.delegate = (id)self;
    [_fishImageView.layer addAnimation:animation forKey:@"keyframeAnimation_path_fish"];
}

//用value的方式进行展示动画
- (void)showKeyFrameAnimationWithValues
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *key1 = [NSValue valueWithCGPoint:_beginPoint];
    NSValue *key2 = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    NSValue *key3 = [NSValue valueWithCGPoint:CGPointMake(150, 50)];
    NSValue *key4 = [NSValue valueWithCGPoint:CGPointMake(300, 250)];
    animation.values = @[key1,key2,key3,key4];
    animation.duration = 5.0;
    animation.delegate = (id)self;
//    animation.autoreverses = true;//是否按路径返回
//    animation.repeatCount = HUGE;//是否重复执行
    animation.removedOnCompletion = NO;//执行后移除动画
    animation.fillMode = kCAFillModeForwards;
    
    //存储位置
    [animation setValue:key4 forKey:@"keyframeAnimationLocation"];
    
    [_fishImageView.layer addAnimation:animation forKey:@"keyframeAnimation_fish"];
}


#pragma mark == event response
- (void)showAnimation:(UIButton *)sender
{
    [self showKeyFrameAnimationWithValues];
//    [self showKeyFrameAnimationWithPath];
}


#pragma mark == CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([anim isEqual:[_fishImageView.layer animationForKey:@"keyframeAnimation_fish"]])
    {
//        [CATransaction begin];
//        //禁用隐式动画
//        [CATransaction setDisableActions:YES];
        
        _fishImageView.layer.position = [[anim valueForKey:@"keyframeAnimationLocation"] CGPointValue];
   
//        //提交事务
//        [CATransaction commit];
    }
    else if ([anim isEqual:[_fishImageView.layer animationForKey:@"keyframeAnimation_path_fish"]])
    {
    
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
