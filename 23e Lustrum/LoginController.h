//
//  LoginController.h
//  23e Lustrum
//
//  Created by Ruud Visser on 3/6/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MenuViewController;
@interface LoginController : NSObject

+(LoginController *)shared;

+(BOOL)isLoggedIn;

-(void)loginFromVC:(UIViewController *)from sender:(MenuViewController *)menuvc;

@end
