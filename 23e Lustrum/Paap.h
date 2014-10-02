//
//  Paap.h
//  23e Lustrum
//
//  Created by Ruud Visser on 3/1/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Paap : NSObject

@property (nonatomic) int paapId;
@property (nonatomic,retain) NSString *name;

+(void)setCurrentPaap:(Paap *)paap;
+(Paap *)current;
-(Paap *)initPaapWithId:(int)paapId Name:(NSString *)name;
+(NSString *)getPassword;
+(NSString *)getUsername;

@end
