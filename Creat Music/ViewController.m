//
//  ViewController.m
//  Creat Music
//
//  Created by 徐纪光 on 15/3/16.
//  Copyright (c) 2015年 徐纪光. All rights reserved.
//

#import "ViewController.h"
#import "MusicModel.h"

AVAudioPlayer * audioPlayer;

@interface ViewController ()


@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewback"]]];
//    [self.view setBackgroundColor:[UIImage imageNamed:@"viewback"]];
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
    [button1 setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * buttonLrc = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonLrc.frame = CGRectMake(240, 400, 40, 40);
    [buttonLrc setImage:[UIImage imageNamed:@"lrc"] forState:UIControlStateNormal];
    [buttonLrc setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:buttonLrc];
    [buttonLrc addTarget:self action:@selector(showlyric) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * buttonNext = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonNext.frame = CGRectMake(190, 400, 40, 40);
    [buttonNext setShowsTouchWhenHighlighted:YES];
    [buttonNext setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [buttonNext addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonNext];
    
    
    UIButton * buttonPrevious = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonPrevious.frame = CGRectMake(90, 400, 40, 40);
    [buttonPrevious setShowsTouchWhenHighlighted:YES];
    [buttonPrevious setImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
    [buttonPrevious addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonPrevious];

    
    [self initdata];

    
    
    progressview = [[UISlider alloc]initWithFrame:CGRectMake(10, 450, 300, 10)];
    progressview.tintColor = [UIColor redColor];
    progressview.value = 0.0;
    progressview.minimumValue = 0.0;
    progressview.maximumValue = 1.0;
    [progressview addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:progressview];
    
    
    
    
//    progressview.backgroundColor = [UIColor greenColor];
//    为什么吧解析URL放在progressview之后就不能用，进度条从最后就不动了。
//    NSString * msg = [NSString stringWithFormat:@"音频文件的声道数：%d\n音频文件的持续时间:%g",audioPlayer.numberOfChannels,audioPlayer.duration];
//    self.show.text = msg;
    
}

-(void)initdata{
    
    
    MusicModel *music1=[[MusicModel alloc]initWithName:@"就是爱你" andType:@"mp3"];
    MusicModel *music2=[[MusicModel alloc]initWithName:@"当我唱起这首歌" andType:@"mp3"];
    _musicmodel=[[NSMutableArray alloc]initWithCapacity:10];
    [_musicmodel addObject:music1];
    [_musicmodel addObject:music2];
    
    NSURL * fileURL = [[NSBundle mainBundle]URLForResource:music1.name withExtension:music1.type];
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
    //    [audioPlayer play];
    progVal = audioPlayer.duration;
    audioPlayer.numberOfLoops = -1;
    audioPlayer.delegate = self;
    
    currentMusic = music1;
}

-(void)next{
//    NSInteger index;
    if ([_musicmodel indexOfObject:currentMusic] < _musicmodel.count-1) {
        currentMusic = [_musicmodel objectAtIndex:([_musicmodel indexOfObject:currentMusic]+1)];
    }
    else
        currentMusic = [_musicmodel objectAtIndex:0];
    NSURL * fileURL = [[NSBundle mainBundle]URLForResource:currentMusic.name withExtension:currentMusic.type];
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
    //    [audioPlayer play];
    progVal = audioPlayer.duration;
//    无限循环
//        audioPlayer.numberOfLoops = -1;
    audioPlayer.delegate = self;
//    bug解决了但是总是感觉不好啊，上次的bug的更本原因就是开始歌曲的cell太小，下一首歌词很大导致数组越界
    [self showlyric];
    [self showlyric];
    [audioPlayer play];
    [self parselyric];
    [self updateLrc];
}

-(void)previous{
    if ([_musicmodel indexOfObject:currentMusic] > 0) {
        currentMusic = [_musicmodel objectAtIndex:[_musicmodel indexOfObject:currentMusic]-1];
    } else {
        currentMusic = [_musicmodel lastObject];
    }
    NSURL * fileURL = [[NSBundle mainBundle]URLForResource:currentMusic.name withExtension:currentMusic.type];
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
    //    [audioPlayer play];
    progVal = audioPlayer.duration;
    //    无限循环
    //        audioPlayer.numberOfLoops = -1;
    audioPlayer.delegate = self;
    [audioPlayer play];
    [self parselyric];
    [self updateLrc];
}

-(void)parselyric
{
    NSString *path = [[NSBundle mainBundle]pathForResource:currentMusic.name ofType:@"lrc"];
    //if lyric file exits
    if ([path length]) {
        //get the lyric string
        NSString *lyc = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        //init
        _musictime = [[NSMutableArray alloc]init];
        _lyrics = [[NSMutableArray alloc]init];
        _t = [[NSMutableArray alloc]init];
        NSArray *arr = [lyc componentsSeparatedByString:@"\n"];
        for (NSString *item in arr) {
            //if item is not empty
            if ([item length]) {
                NSRange startrange = [item rangeOfString:@"["];
                NSLog(@"%d%d",startrange.length,startrange.location);
                NSRange stoprange = [item rangeOfString:@"]"];
                NSString *content = [item substringWithRange:NSMakeRange(startrange.location+1, stoprange.location-startrange.location-1)];
                NSLog(@"%d",[item length]);
                //the music time format is mm.ss.xx such as 00:03.84
                if ([content length] == 8) {
                    NSString *minute = [content substringWithRange:NSMakeRange(0, 2)];
                    NSString *second = [content substringWithRange:NSMakeRange(3, 2)];
                    NSString *mm = [content substringWithRange:NSMakeRange(6, 2)];
                    NSString *time = [NSString stringWithFormat:@"%@:%@.%@",minute,second,mm];
                    NSNumber *total =[NSNumber numberWithInteger:[minute integerValue] * 60 + [second integerValue]];
                    [_t addObject:total];
//                    NSLog(@"%@",total);
                    NSString *lyric = [item substringFromIndex:10];
                    [_musictime addObject:time];
                    [_lyrics addObject:lyric];
                }
            }
        }
    }
    else
        _lyrics = nil;
}

//    NSLog(@"234234");
//    NSInteger n=0;
//    for (id object in _t) {
//        while ([object intValue] == (int)audioPlayer.currentTime) {
//            NSIndexPath *indexpath=[NSIndexPath indexPathForRow:[_t indexOfObject:object] inSection:0];
//            [table selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//        }
//    }
    
    
    
//    while (audioPlayer.currentTime == [_t[n] intValue]){
////        NSIndexPath *indexpath=[NSIndexPath indexPathForRow:n inSection:0];
////        [table selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//        n++;
//        NSLog(@"234234");
//    }

-(void)showlyric{
    if (!table) {
        table = [[UITableView alloc]initWithFrame:CGRectMake(20, 120, 280, 160) style:UITableViewStylePlain];
        table.alpha = 0.5;
        table.backgroundColor = [UIColor grayColor];
        table.dataSource = self;
        table.layer.cornerRadius = 8;
#warning budong
        table.layer.masksToBounds = YES;
        [self.view addSubview:table];
        [self parselyric];
    }
    else
    {
        [table removeFromSuperview];
//        等于nil后是不是就不占用内存了，cell所占用的内存呢？
        table = nil;
    }
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    可重用表格行队列
    if (cell == nil) {
          cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    for (id object in _lyrics) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//        cell.textLabel.text = object;
//        cell.textLabel.textAlignment = NSTextAlignmentCenter;
//        NSLog(@"%@",object);
//    }
//    cell.textLabel.text = _lyrics[0];
    }
    NSUInteger rowNo = indexPath.row;
//    数组越界
    cell.textLabel.text = [_lyrics objectAtIndex:rowNo];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return  cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _lyrics.count;
}






- (void)sliderValueChanged:(id)sender{
//    UIImageView *imageView = [progressview.subviews objectAtIndex:2];
//    CGRect theRect = [self.view convertRect:imageView.frame fromView:imageView.superview];
//    progressview.value = theRect.size.width/progressview.frame.size.width;    不懂了
    audioPlayer.currentTime = progressview.value*progVal;
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
#warning 重复调用
//    这个东西我应该放在哪使他的内存最小一定不能是这
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLrc)  userInfo:nil repeats:YES];
}

-(void)updateLrc{
    for (id object in _t) {
    if ([object intValue] == (int)audioPlayer.currentTime) {
        NSIndexPath *indexpath=[NSIndexPath indexPathForRow:[_t indexOfObject:object] inSection:0];
        [table selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
