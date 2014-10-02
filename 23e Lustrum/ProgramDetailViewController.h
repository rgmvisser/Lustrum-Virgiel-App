//
//  ProgramDetailViewController.h
//  23e Lustrum
//
//  Created by Ruud Visser on 3/25/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Program.h"
@interface ProgramDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *programTitle;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIWebView *info;

@property (nonatomic, retain) Program *program;

@end
