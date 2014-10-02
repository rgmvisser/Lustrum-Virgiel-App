//
//  Event.h
//  23e Lustrum
//
//  Created by Ruud Visser on 3/4/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Program : NSObject

@property (nonatomic,retain) NSString *date;
@property (nonatomic,retain) NSString *time;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *info;
@property (nonatomic,retain) UIImage *image;

-(Program *)initEvent:(NSString *)date time:(NSString *)time title:(NSString *)title info:(NSString *)info  image:(UIImage *)image;

@end
