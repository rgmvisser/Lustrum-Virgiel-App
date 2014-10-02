//
//  Fonts.m
//  23e Lustrum
//
//  Created by Ruud Visser on 3/6/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import "Fonts.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation Fonts


+(void)setStaticBold:(UILabel *)label
{
    [label setFont:[UIFont fontWithName:@"StaticBold" size:label.font.pointSize]];
    
}

+(void)setStaticBold:(UILabel *)label withSize:(CGFloat)size
{
    [label setFont:[UIFont fontWithName:@"StaticBold" size:size]];
    
}

+(void)setValStencil:(UILabel *)label
{
    [label setFont:[UIFont fontWithName:@"VAL Stencil" size:label.font.pointSize]];
    
}

+(UIFont *)getFont
{
    return [UIFont fontWithName:@"StaticBold" size:17];
}

+(UIColor *)getColorWithId:(int)paapid
{
    NSArray *colors = [NSArray arrayWithObjects:UIColorFromRGB(0xf29ac0),UIColorFromRGB(0xe70f8b),UIColorFromRGB(0x642890), UIColorFromRGB(0x2c388e), UIColorFromRGB(0x3D6FB7),UIColorFromRGB(0x22aae2), UIColorFromRGB(0x00cc75), UIColorFromRGB(0x43ff41), UIColorFromRGB(0xf5eb22), UIColorFromRGB(0xf06725), UIColorFromRGB(0xe9222b),nil];
    int num = (paapid % [colors count]);
    if(num > 10) { num = 10; }
    UIColor *theColor = [colors objectAtIndex:num];

    return theColor;
}

@end
