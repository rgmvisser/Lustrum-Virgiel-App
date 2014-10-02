//
//  Message.h
//  23e Lustrum
//
//  Created by Ruud Visser on 3/17/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Paap.h"
@interface Message : NSObject

-(Message *)initWithPaap:(Paap* )paap andMessage:(NSString *)message time:(NSString *)time;

@property (nonatomic,retain) Paap *paap;
@property (nonatomic,retain) NSMutableArray *messages;
@property (nonatomic,retain) NSString *time;

@end
