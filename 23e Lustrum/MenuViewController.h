//
//  MenuViewController.h
//  23e Lustrum
//
//  Created by Ruud Visser on 2/17/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *eventButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *paapButton;
@property (weak, nonatomic) IBOutlet UIButton *musicButton;

- (void)showVC:(UIViewController *)vc;

@end
