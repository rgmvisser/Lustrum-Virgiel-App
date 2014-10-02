//
//  MenuViewController.m
//  23e Lustrum
//
//  Created by Ruud Visser on 2/17/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import "MenuViewController.h"
#import "MessageViewController.h"
#import "EventsViewController.h"
#import "LocationViewController.h"
#import "MusicViewController.h"
#import "PaapViewController.h"
#import "LoginController.h"

@interface MenuViewController ()
{
    UIViewController *_currentVC;
}

@property (nonatomic,strong) MessageViewController *mvc;
@property (nonatomic,strong) EventsViewController *evc;
@property (nonatomic,strong) LocationViewController *lvc;
@property (nonatomic,strong) MusicViewController *muvc;
@property (nonatomic,strong) PaapViewController *pvc;

@end


@implementation MenuViewController

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
    self.mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"mvc"];
    self.evc = [self.storyboard instantiateViewControllerWithIdentifier:@"evc"];
    self.lvc = [self.storyboard instantiateViewControllerWithIdentifier:@"lvc"];
    self.pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"pvc"];
    self.muvc = [self.storyboard instantiateViewControllerWithIdentifier:@"muvc"];
    CGRect containerframe = self.containerView.frame;
    self.mvc.view.frame = containerframe;self.evc.view.frame = containerframe;
    self.lvc.view.frame = containerframe;self.pvc.view.frame = containerframe;
    self.muvc.view.frame = containerframe;
    _currentVC = [[self childViewControllers] objectAtIndex:0];
    [self addChildViewController:self.mvc];
    [self addChildViewController:self.evc];
    [self addChildViewController:self.lvc];
    [self addChildViewController:self.muvc];
    [self addChildViewController:self.pvc];
    //[self.containerView addSubview:self.muvc.view];
    //_currentVC = self.muvc;
    
    
    
	// Do any additional setup after loading the view.
}


- (IBAction)showMessage:(id)sender {
    if(![LoginController isLoggedIn])
    {
        [[LoginController shared] loginFromVC:_currentVC sender:self];
    }
    [self showVC:self.mvc];
    
     
}
- (IBAction)showEvents:(id)sender {
    [self showVC:self.evc];
}
- (IBAction)showLocation:(id)sender {
    [self showVC:self.lvc];
}
- (IBAction)showPaap:(id)sender {
    if(![LoginController isLoggedIn])
    {
        [[LoginController shared] loginFromVC:_currentVC sender:self];
    }
    [self showVC:self.pvc];
    
    
}
- (IBAction)showMusic:(id)sender {
    [self showVC:self.muvc];
}


- (void)showVC:(UIViewController *)vc
{
    NSLog(@"View: %@",vc.view);
    if(_currentVC != vc)
    {
        [self transitionFromViewController:_currentVC toViewController:vc duration:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
            
        } completion:^(BOOL finished) {
            _currentVC = vc;
        }];
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
