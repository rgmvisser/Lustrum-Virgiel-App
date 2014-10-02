//
//  StartViewController.m
//  23e Lustrum
//
//  Created by Ruud Visser on 3/3/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *lampOn;
@property (weak, nonatomic) IBOutlet UIImageView *lampOff;

@end

@implementation StartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.lampOff setHidden:YES];
    [self.lampOn setHidden:YES];
    NSLog(@"alal");
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
