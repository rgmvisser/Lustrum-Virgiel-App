//
//  PaapViewController.m
//  23e Lustrum
//
//  Created by Ruud Visser on 2/17/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import "PaapViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "Paap.h"
#import <QuartzCore/QuartzCore.h>
#import "Fonts.h"
#import "LoginController.h"
@interface PaapViewController ()
{
    Paap *_paap1;
    Paap *_paap2;
    Paap *_paap3;
    Paap *_paap4;
    NSString *_questionId;
    NSString *_imagePath;
    NSArray *_papen;
    UIImage *_paapImage;
    NSTimer *_timer;
    int _timeLeft;
}

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIImageView *paapImageView;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *paap1Button;
@property (weak, nonatomic) IBOutlet UIButton *paap2Button;
@property (weak, nonatomic) IBOutlet UIButton *paap3Button;
@property (weak, nonatomic) IBOutlet UIButton *paap4Button;
@property (weak, nonatomic) IBOutlet UIButton *initialStart;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;



@end

@implementation PaapViewController

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
    [self disableButtons];
    _papen = [NSArray arrayWithObjects:_paap1,_paap2,_paap3,_paap4, nil];
    
    [self.paap1Button setTitle:@"" forState:UIControlStateNormal];
    [self.paap2Button setTitle:@"" forState:UIControlStateNormal];
    [self.paap3Button setTitle:@"" forState:UIControlStateNormal];
    [self.paap4Button setTitle:@"" forState:UIControlStateNormal];
    [self.paapImageView.layer setCornerRadius:17];
    [self.paapImageView.layer setMasksToBounds:YES];
    [self setScore];
    [self.indicator setHidden:YES];
    
    
    [Fonts setStaticBold:self.paap1Button.titleLabel];
    [Fonts setStaticBold:self.paap2Button.titleLabel];
    [Fonts setStaticBold:self.paap3Button.titleLabel];
    [Fonts setStaticBold:self.paap4Button.titleLabel];
    [Fonts setStaticBold:self.scoreLabel];
    [Fonts setStaticBold:self.timerLabel];
	// Do any additional setup after loading the view.
    
}


- (IBAction)start:(id)sender {
    [self.indicator setHidden:NO];
    [self.initialStart setHidden:YES];
    [self.startButton setHidden:YES];
    [self.paap1Button setTitle:@"" forState:UIControlStateNormal];
    [self.paap2Button setTitle:@"" forState:UIControlStateNormal];
    [self.paap3Button setTitle:@"" forState:UIControlStateNormal];
    [self.paap4Button setTitle:@"" forState:UIControlStateNormal];
    [self.timerLabel setText:@"10"];
    [self.paap1Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.paap2Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.paap3Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.paap4Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.paap1Button setBackgroundColor:[UIColor whiteColor]];
    [self.paap2Button setBackgroundColor:[UIColor whiteColor]];
    [self.paap3Button setBackgroundColor:[UIColor whiteColor]];
    [self.paap4Button setBackgroundColor:[UIColor whiteColor]];
    [self.paapImageView setImage:nil];
    
    
    // marshall parameters
    NSString *urlStr = @"http://lustrumvirgiel.nl/";
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:url];
    [client setParameterEncoding:AFJSONParameterEncoding];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    client.parameterEncoding = AFJSONParameterEncoding;
    //NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:@"json", @"format", @"66854529@N00", @"user_id", @"1", @"jsoncallback", nil];
    NSString *path = [[NSString alloc]initWithFormat:@"paap.php"];
    
    NSMutableURLRequest *af_request = [client requestWithMethod:@"GET" path:path parameters:nil];
    
    [client setAuthorizationHeaderWithUsername:[Paap getUsername] password:[Paap getPassword]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    //[client requestWithMethod:@"GET" path:path parameters:params];
    
    // first way of trying..
    AFHTTPRequestOperation *af_operation = [client HTTPRequestOperationWithRequest:af_request success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"Fetched: %@", payload);
        _paap1 = [[Paap alloc] initPaapWithId:[[payload objectForKey:@"wie_is_id"] integerValue] Name:[payload objectForKey:@"wie_is"]];
        _paap2 = [[Paap alloc] initPaapWithId:[[payload objectForKey:@"paap2_id"] integerValue] Name:[payload objectForKey:@"paap2"]];
        _paap3 = [[Paap alloc] initPaapWithId:[[payload objectForKey:@"paap3_id"] integerValue] Name:[payload objectForKey:@"paap3"]];
        _paap4 = [[Paap alloc] initPaapWithId:[[payload objectForKey:@"paap4_id"] integerValue] Name:[payload objectForKey:@"paap4"]];
        _questionId = [payload objectForKey:@"question_id"];
        NSNumber *score = [payload objectForKey:@"correct"];
        NSNumber *total = [payload objectForKey:@"total"];
        NSLog(@"score loaded: %@/%@",score,total);
        [[NSUserDefaults standardUserDefaults] setObject:score forKey:@"score"];
        [[NSUserDefaults standardUserDefaults] setObject:total forKey:@"total"];
        [self setScore];
        
        
        _imagePath = [payload objectForKey:@"photo"];
        
        _papen = [NSArray arrayWithObjects:_paap1,_paap2,_paap3,_paap4, nil];
        [self setQuestion];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@",error);
        NSLog(@"Opertion: %@",operation);
        [[[UIAlertView alloc] initWithTitle:@"Foutmelding" message:@"Geen internet" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        [self.startButton setHidden:NO];
        
    }];
    //@TODO 
    [af_operation setCredential:[NSURLCredential credentialWithUser:[Paap getUsername] password:[Paap getPassword] persistence:NSURLCredentialPersistenceNone]];
    [af_operation start];
    
    
}


-(void)setQuestion
{
    [self shufflePapen];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_imagePath]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    /*
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"filename"];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    */
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Operation: %@",responseObject);
        _paapImage = [UIImage imageWithData:responseObject];
        [self.paapImageView setImage:_paapImage];
        [self.paap1Button setTitle:[[_papen objectAtIndex:0] name] forState:UIControlStateNormal];
        [self.paap2Button setTitle:[[_papen objectAtIndex:1] name] forState:UIControlStateNormal];
        [self.paap3Button setTitle:[[_papen objectAtIndex:2] name] forState:UIControlStateNormal];
        [self.paap4Button setTitle:[[_papen objectAtIndex:3] name] forState:UIControlStateNormal];
        [self enableButtons];
        [self startTimer];
        [self.indicator setHidden:YES];
        

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [[[UIAlertView alloc] initWithTitle:@"Foutmelding" message:@"Geen internet" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        [self.startButton setHidden:NO];
    }];
    
    
    
    [operation start];
}


-(void)shufflePapen
{
    NSMutableArray *papencp = [_papen mutableCopy];
    for (int x = 0; x < [papencp count]; x++) {
        int randInt = (arc4random() % ([papencp count] - x)) + x;
        [papencp exchangeObjectAtIndex:x withObjectAtIndex:randInt];
    }
    NSLog(@"Papen: %@",papencp);
    _papen = papencp;
}

- (IBAction)answer:(id)sender {
    [self.initialStart setHidden:YES];
    [self.startButton setHidden:NO];
    [self stopTimer];
    [self disableButtons];
    BOOL correct = NO;
    Paap *chosen;
    if(sender == self.paap1Button)
    {
        chosen = [_papen objectAtIndex:0];
    }else if (sender == self.paap2Button)
    {
        chosen = [_papen objectAtIndex:1];
    }else if (sender == self.paap3Button)
    {
        chosen = [_papen objectAtIndex:2];
    }else if (sender == self.paap4Button)
    {
        chosen = [_papen objectAtIndex:3];
    }
    if([[chosen name] isEqual:[_paap1 name]])
    {
        correct = YES;
    }
    
    NSString *urlStr = @"http://lustrumvirgiel.nl/";
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:url];
    [client setParameterEncoding:AFJSONParameterEncoding];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    client.parameterEncoding = AFJSONParameterEncoding;
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",correct], @"correct", [NSString stringWithFormat:@"%d",[chosen paapId]], @"answer_id",_questionId , @"question_id", nil];
    NSString *path = [[NSString alloc]initWithFormat:@"answer.php"];
    
    NSMutableURLRequest *af_request = [client requestWithMethod:@"GET" path:path parameters:params];
    
    [client setAuthorizationHeaderWithUsername:[Paap getUsername] password:[Paap getPassword]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    //[client requestWithMethod:@"GET" path:path parameters:params];
    
    // first way of trying..
    AFHTTPRequestOperation *af_operation = [client HTTPRequestOperationWithRequest:af_request success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONWritingPrettyPrinted error:nil];

        NSLog(@"Fetched: %@", payload);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@",error);
        NSLog(@"Opertion: %@",operation);
        
    }];
    
    [af_operation setCredential:[NSURLCredential credentialWithUser:[Paap getUsername] password:[Paap getPassword]persistence:NSURLCredentialPersistenceNone]];
    [af_operation start];
    
    
    UIColor *green = [UIColor colorWithRed:0.62 green:0.89 blue:0.57 alpha:1]; //green
    
    if([sender isKindOfClass:[UIButton class]])
    {
        UIButton *button = (UIButton *)sender;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if(correct)
        {
            [button setBackgroundColor:green]; //green
        }else{
            [button setBackgroundColor:[UIColor colorWithRed:0.94 green:0.39 blue:0.475 alpha:1]]; //red
        }
    }
    
    
    
    
    
    if(correct)
    {
        [self addScore:YES];
    }else{
        [self addScore:NO];
        
        if([self.paap1Button.titleLabel.text isEqual:[_paap1 name]])
        {
            [self.paap1Button setBackgroundColor:green];
        }
        if([self.paap2Button.titleLabel.text isEqual:[_paap1 name]])
        {
            [self.paap2Button setBackgroundColor:green];
        }
        if([self.paap3Button.titleLabel.text isEqual:[_paap1 name]])
        {
            [self.paap3Button setBackgroundColor:green];
        }
        if([self.paap4Button.titleLabel.text isEqual:[_paap1 name]])
        {
            [self.paap4Button setBackgroundColor:green];
        }
        
        
    }   
    
    [self.startButton setHidden:NO];
    
    
}

-(void)startTimer
{
    _timeLeft = 10;
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

-(void)stopTimer
{
    [_timer invalidate];
}

-(void)countDown:(id)sender
{
    
    
    _timeLeft--;
    NSLog(@"Time left:%d",_timeLeft);
    [self.timerLabel setText:[NSString stringWithFormat:@"%d",_timeLeft]];
    if(_timeLeft <= 0)
    {
        [self answer:self];
        
    }
}


-(void)disableButtons
{
    [self.paap1Button setUserInteractionEnabled:NO];
    [self.paap2Button setUserInteractionEnabled:NO];
    [self.paap3Button setUserInteractionEnabled:NO];
    [self.paap4Button setUserInteractionEnabled:NO];
}

-(void)enableButtons
{
    [self.paap1Button setUserInteractionEnabled:YES];
    [self.paap2Button setUserInteractionEnabled:YES];
    [self.paap3Button setUserInteractionEnabled:YES];
    [self.paap4Button setUserInteractionEnabled:YES];
}

-(void)setScore
{
    NSNumber *score = [[NSUserDefaults standardUserDefaults] objectForKey:@"score"];
    NSNumber *total = [[NSUserDefaults standardUserDefaults] objectForKey:@"total"];
    NSLog(@"Total: %@",total);
    if(!total)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"score"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"total"];
        total = [NSNumber numberWithInt:0];
        score = [NSNumber numberWithInt:0];
    }
    
    [self.scoreLabel setText:[NSString stringWithFormat:@"%@/%@",score,total]];
}

-(void)addScore:(BOOL)correct
{
    NSNumber *score = [[NSUserDefaults standardUserDefaults] objectForKey:@"score"];
    NSNumber *total = [[NSUserDefaults standardUserDefaults] objectForKey:@"total"];
    if(correct)
    {
        int newScore = [score intValue] + 1;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:newScore] forKey:@"score"];
    }
    int newTotal = [total intValue] + 1;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:newTotal] forKey:@"total"];
    [self setScore];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
