//
//  MusicModel.m
//  Creat Music
//
//  Created by 徐纪光 on 15/3/23.
//  Copyright (c) 2015年 徐纪光. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

-(id)initWithName:(NSString *)name andType:(NSString *)type{
    if(self=[super init])
    {
        self.name=name;
        self.type=type;
    }
    return self;
}

@end
