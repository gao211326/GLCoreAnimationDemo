//
//  CATransitionViewController.m
//  GLCoreAnimationDemo
//
//  Created by 高磊 on 2017/2/20.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "CATransitionViewController.h"

static NSInteger const kMaxImageCout = 5;

@interface CATransitionViewController ()
{
    UIImageView *   _imageView;
    NSInteger       _currentIndex;//当前的图片
}
@end

@implementation CATransitionViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        _currentIndex = 0;
   
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    CGFloat image_h = 300;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (height - image_h)/2.0, width, image_h)];
    _imageView.image = [UIImage imageNamed:@"0.jpg"];
    [self.view addSubview:_imageView];
    
    UISwipeGestureRecognizer *leftSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwip:)];
    leftSwip.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwip];
    
    
    UISwipeGestureRecognizer *rightSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwip:)];
    rightSwip.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwip];
}


#pragma mark == event response
- (void)leftSwip:(UISwipeGestureRecognizer *)swip
{
    if (_currentIndex == 0)
    {
        return;
    }
    
    _currentIndex --;
    
    [self transition:NO];
}

- (void)rightSwip:(UISwipeGestureRecognizer *)swip
{
    if (_currentIndex == kMaxImageCout)
    {
        return;
    }
    
    _currentIndex ++;
    
    [self transition:YES];
}


/*
 关于下面type 的类型
 公开API  
 fade       淡出
 movein     新视图移动到旧视图上面
 push       推出
 reveal     移开旧视图显示新的
 共有API分别对应API中的4个常量
 CA_EXTERN NSString * const kCATransitionFade
 CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
 CA_EXTERN NSString * const kCATransitionMoveIn
 CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
 CA_EXTERN NSString * const kCATransitionPush
 CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
 CA_EXTERN NSString * const kCATransitionReveal
 CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
 
 
 私有API
 cube           立体翻转
 oglFlip        翻转
 suckEffect     收缩                          不支持subtype
 rippleEffect   水滴波纹效果                    不支持subtype
 pageCurl       向上翻页效果
 pageUnCurl     向下翻页效果
 cameraIrisHollowOpen   摄像头打开效果          不支持subtype
 cameraIrisHollowClose  摄像头关闭效果          不支持subtype
 */

#pragma mark == private method
- (void)transition:(BOOL)next
{
    CATransition *transition = [CATransition animation];
    transition.type = @"cube";
    if (next)
    {
        transition.subtype = kCATransitionFromLeft;
    }
    else
    {
        transition.subtype = kCATransitionFromRight;
    }
    transition.duration = 1.0;
    
    _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",(long)_currentIndex]];
    [_imageView.layer addAnimation:transition forKey:@"transitionAnimation"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
