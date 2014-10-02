//
//  ProgramDetailViewController.m
//  23e Lustrum
//
//  Created by Ruud Visser on 3/25/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import "ProgramDetailViewController.h"
#import "Fonts.h"
@interface ProgramDetailViewController ()

@end

@implementation ProgramDetailViewController

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
	// Do any additional setup after loading the view.
    [Fonts setStaticBold:self.dateTime];
    [Fonts setValStencil:self.programTitle];
    [self setProgramInfo];
}

-(void)setProgramInfo{

    if(self.program)
    {
        
        [self.programTitle setText:self.program.title];
        NSString *date = [NSString stringWithFormat:@"Datum: %@ ",self.program.date];
        NSString *time;
        if(![self.program.time isEqualToString:@""])
        {
            time = [NSString stringWithFormat:@"| Tijd: %@ ",self.program.time];
        }else{
            time = @"";
        }
        [self.dateTime setText:[NSString stringWithFormat:@"%@%@",date,time]];
        [self.image setImage:self.program.image];
        NSURL *base = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:self.program.info ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [self.info setOpaque:NO];
        [self.info setBackgroundColor:[UIColor clearColor]];
        [self.info loadHTMLString:htmlString baseURL:base];
    }
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setProgramTitle:nil];
    [self setDateTime:nil];
    [self setImage:nil];
    [self setInfo:nil];
    [super viewDidUnload];
}
@end
