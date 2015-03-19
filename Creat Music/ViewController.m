//
//  ViewController.m
//  Creat Music
//
//  Created by 徐纪光 on 15/3/16.
//  Copyright (c) 2015年 徐纪光. All rights reserved.
//

#import "ViewController.h"

AVAudioPlayer * audioPlayer;

@interface ViewController ()

@end

@implementation ViewController

NSTimer * timer;
CGFloat progVal;
UISlider * progressview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewback"]]];
    self.view.alpha = 0.5;
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(140, 400, 40, 40);
    [button setShowsTouchWhenHighlighted:YES];
    [button setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(140, 360, 40, 40);
    [button1 setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    NSURL * fileURL = [[NSBundle mainBundle]URLForResource:@"就是爱你" withExtension:@"mp3"];
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
//    [audioPlayer play];
    progVal = audioPlayer.duration;
    audioPlayer.numberOfLoops = -1;
    audioPlayer.delegate = self;
    
    
    
    progressview = [[UISlider alloc]initWithFrame:CGRectMake(10, 450, 300, 10)];
    progressview.tintColor = [UIColor redColor];
    progressview.value = 0.0;
    progressview.minimumValue = 0.0;
    progressview.maximumValue = 1.0;
    [progressview addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:progressview];
    
    
    UITableView * tableview = [[UITableView alloc]initWithFrame:CGRectMake(20, 60, 300, 360) style:UITableViewStylePlain];
    tableview.backgroundColor = [UIColor whiteColor];
    
    
//    progressview.backgroundColor = [UIColor greenColor];
    
//    为什么吧解析URL放在progressview之后就不能用，进度条从最后就不动了。
    
    
    
//    NSString * msg = [NSString stringWithFormat:@"音频文件的声道数：%d\n音频文件的持续时间:%g",audioPlayer.numberOfChannels,audioPlayer.duration];
//    self.show.text = msg;
    
    
    
}

- (void)sliderValueChanged:(id)sender{
    
//    UIImageView *imageView = [progressview.subviews objectAtIndex:2];
//    CGRect theRect = [self.view convertRect:imageView.frame fromView:imageView.superview];
//    progressview.value = theRect.size.width/progressview.frame.size.width;    不懂了
    audioPlayer.currentTime = progressview.value*progVal;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)play:(id)sender{            //加上（id）sender可以引用按键
    
    if (audioPlayer.playing) {
        [audioPlayer pause];
        
    }
    else
    {
        [audioPlayer play];
    }
    if (timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProg) userInfo:nil repeats:YES];
    }
}

- (void)updateProg
{
    //    为什么self.button 可以，但是progress不可以？
    progressview.value = audioPlayer.currentTime/progVal;
}

-(void)stop:(id)sender
{
    
    [audioPlayer stop];
    [timer invalidate];
    timer = nil;
}

@end
