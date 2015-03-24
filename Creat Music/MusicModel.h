//
//  MusicModel.h
//  Creat Music
//
//  Created by 徐纪光 on 15/3/23.
//  Copyright (c) 2015年 徐纪光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

@property(copy,nonatomic)NSString *name;
@property(copy,nonatomic)NSString *type;
    
-(id)initWithName:(NSString *)name andType:(NSString *)type;

@end
