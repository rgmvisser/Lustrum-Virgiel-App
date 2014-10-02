//
//  Message.m
//  23e Lustrum
//
//  Created by Ruud Visser on 3/17/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import "Message.h"

@implementation Message

-(Message *)initWithPaap:(Paap *)paap andMessage:(NSString *)message time:(NSString *)time
{
    self = [[Message alloc] init];
    if(self)
    {
        self.paap = paap;
        self.messages = [NSMutableArray arrayWithObject:message];
        self.time = time;
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Paap: %@, time: %@, Messages: %@",self.paap,self.time,self.messages ];
}
@end
