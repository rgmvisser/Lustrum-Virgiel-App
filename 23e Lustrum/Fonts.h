//
//  Fonts.h
//  23e Lustrum
//
//  Created by Ruud Visser on 3/6/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fonts : NSObject

+(void)setStaticBold:(UILabel *)label;
+(void)setValStencil:(UILabel *)label;
+(void)setStaticBold:(UILabel *)label withSize:(CGFloat)size;
+(UIFont *)getFont;
+(UIColor *)getColorWithId:(int)paapid;
@end
