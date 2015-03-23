//
//  ViewController.h
//  Creat Music
//
//  Created by 徐纪光 on 15/3/16.
//  Copyright (c) 2015年 徐纪光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<AVAudioPlayerDelegate,UITableViewDataSource>{
    UITableView * table;
    NSTimer * timer;
    CGFloat progVal;
    UISlider * progressview;
    NSMutableArray *_musictime;
    NSMutableArray *_lyrics;
    NSMutableArray *_t;
}


@end

