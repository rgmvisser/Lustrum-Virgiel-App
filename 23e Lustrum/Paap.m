//
//  Paap.m
//  23e Lustrum
//
//  Created by Ruud Visser on 3/1/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import "Paap.h"

static Paap *currentPaap;
static NSString *username;
static NSString *password;


@implementation Paap

+(void)setCurrentPaap:(Paap *)paap
{
    currentPaap = paap;
}

+(Paap *)current
{
    if(!currentPaap)
    {
        NSDictionary *paap = [[NSUserDefaults standardUserDefaults] objectForKey:@"paap"];
        currentPaap = [[Paap alloc] initPaapWithId:[[paap objectForKey:@"paapid"] integerValue] Name:[paap objectForKey:@"name"]];
    }
    
    return currentPaap;
}

+(NSString *)getUsername{
    if(!username)
    {
        username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    }
    return username;
}

+(NSString *)getPassword{
    if(!password)
    {
        password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    }
    return password;
}

-(Paap *)initPaapWithId:(int)paapId Name:(NSString *)name
{
    self = [[Paap alloc] init];
    if(self)
    {
        self.paapId = paapId;
        self.name = name;
    }
    return self;
    
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Paap(%d): %@",self.paapId,self.name];
}


@end
