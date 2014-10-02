//
//  Event.m
//  23e Lustrum
//
//  Created by Ruud Visser on 3/4/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import "Program.h"

@implementation Program


-(Program *)initEvent:(NSString *)date time:(NSString *)time title:(NSString *)title info:(NSString *)info image:(UIImage *)image
{
    self = [[Program alloc] init];
    if(self)
    {
        self.date = date;
        self.time = time;
        self.title = title;
        self.image = image;
        self.info = info;
    }
    return self;
    
}

@end
