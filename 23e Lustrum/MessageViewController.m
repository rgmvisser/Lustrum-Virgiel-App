//
//  MessageViewController.m
//  23e Lustrum
//
//  Created by Ruud Visser on 2/17/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import "MessageViewController.h"
#import "Paap.h"
#import "Message.h"
#import "ChatCell.h"
#import "Fonts.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "LoginController.h"

#define TIME_RELOAD 5

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *_messages;
    NSNumber *_lastupdate;
    NSTimer *_timer;
    BOOL _onScreen;
}
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *messageBox;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *sendView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 25;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.activity stopAnimating];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.tableview addGestureRecognizer:tap];
    
    _messages = [[NSMutableArray alloc] init];
    
    
	// Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // marshall parameters
    _onScreen = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessages) name:@"logged_in" object:nil];
    if([LoginController isLoggedIn])
    {
        [self getMessages];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timer invalidate];
    _onScreen = NO;
    
}

-(void)getMessages{
    NSLog(@"getmessages");
    NSString *urlStr = @"http://lustrumvirgiel.nl/";
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:url];
    [client setParameterEncoding:AFJSONParameterEncoding];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    client.parameterEncoding = AFJSONParameterEncoding;
    NSLog(@"Lastupdate :%@",_lastupdate);
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:_lastupdate, @"timestamp",nil];
    NSString *path = [[NSString alloc]initWithFormat:@"chat.php"];
    
    NSMutableURLRequest *af_request = [client requestWithMethod:@"GET" path:path parameters:params];
    
    [client setAuthorizationHeaderWithUsername:[Paap getUsername] password:[Paap getPassword]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    //[client requestWithMethod:@"GET" path:path parameters:params];
    
    // first way of trying..
    
    AFHTTPRequestOperation *af_operation = [client HTTPRequestOperationWithRequest:af_request success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Request: %@",af_request);
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"Fetched: %@", responseData);
        int success = [[responseData objectForKey:@"success"] integerValue];
        if(success == 1)
        {
            NSArray *messages = [responseData objectForKey:@"messages"];
            _lastupdate = [responseData objectForKey:@"last_date"];
            int index = [_messages count];
            for (NSDictionary *message in messages) {
                
                Paap *paap = [[Paap alloc] initPaapWithId:[[message objectForKey:@"id"] integerValue] Name:[message objectForKey:@"paap"]];
                NSString *messageaString = [message objectForKey:@"message"];
                NSString *time = [message objectForKey:@"time"];
                NSLog(@"Paap: %@, Message: %@",paap,messageaString);
                if([_messages count] > 0)
                {
                    Message *previous = (Message *)[_messages objectAtIndex:(index-1)];
                    if(previous.paap.paapId == paap.paapId && paap.paapId != [Paap current].paapId)
                    {
                        [previous.messages addObject:messageaString];
                        previous.time = time;
                    }else{
                        Message *newMessage = [[Message alloc] initWithPaap:paap andMessage:messageaString time:time];
                        [_messages addObject:newMessage];
                        index++;
                        
                    }
                    
                }else{
                    Message *newMessage = [[Message alloc] initWithPaap:paap andMessage:messageaString time:time];
                    [_messages addObject:newMessage];
                    index++;
                    
                }
                
            }
            if([messages count] > 0)
            {
                [self.tableview reloadData];            
                [self scrollToBottom];
            }
            if(_onScreen)
            {
                _timer = [NSTimer timerWithTimeInterval:TIME_RELOAD target:self selector:@selector(getMessages) userInfo:nil repeats:NO];
                NSRunLoop *runner = [NSRunLoop currentRunLoop];
                [runner addTimer:_timer forMode: NSDefaultRunLoopMode];
                
            }
            //NSLog(@"Messages: %@",_messages);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@",error);
        NSLog(@"Opertion: %@",operation);
        [[[UIAlertView alloc] initWithTitle:@"Foutmelding" message:@"Geen internet" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        
    }];
    [af_operation setCredential:[NSURLCredential credentialWithUser:[Paap getUsername] password:[Paap getPassword] persistence:NSURLCredentialPersistenceNone]];
    [af_operation start];
}

- (void)scrollToBottom
{
    CGFloat yOffset = 0;
    
    if (self.tableview.contentSize.height > self.tableview.bounds.size.height) {
        yOffset = self.tableview.contentSize.height - self.tableview.bounds.size.height;
    }
    
    [self.tableview setContentOffset:CGPointMake(0, yOffset) animated:YES];
}

-(void)dismissKeyboard {
    [self.messageBox resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text length] > 120) {
        return NO;
    }
    return YES;
}

- (IBAction)sendMessage:(id)sender {
    
    if([self.messageBox.text isEqualToString:@""]){ return; }
    [self.sendButton setEnabled:NO];
    
    NSLog(@"Send!");
    [self.messageBox resignFirstResponder];
    
    NSString *urlStr = @"http://lustrumvirgiel.nl/";
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:url];
    [client setParameterEncoding:AFJSONParameterEncoding];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    client.parameterEncoding = AFJSONParameterEncoding;
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:self.messageBox.text, @"message",nil];
    NSString *path = [[NSString alloc]initWithFormat:@"post.php"];
    
    NSMutableURLRequest *af_request = [client requestWithMethod:@"GET" path:path parameters:params];
    
    [client setAuthorizationHeaderWithUsername:[Paap getUsername] password:[Paap getPassword]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    //[client requestWithMethod:@"GET" path:path parameters:params];
    
    // first way of trying..
    [self.activity startAnimating];
    AFHTTPRequestOperation *af_operation = [client HTTPRequestOperationWithRequest:af_request success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Request: %@",af_request);
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"Fetched: %@", responseData);
        int success = [[responseData objectForKey:@"success"] integerValue];
        if(success == 1)
        {
            self.messageBox.text = @"";
            [self.tableview reloadData];
            [self scrollToBottom];
            [self.activity stopAnimating];
            [self.sendButton setEnabled:YES];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@",error);
        NSLog(@"Opertion: %@",operation);
        [self.activity stopAnimating];
        [self.sendButton setEnabled:YES];
        [[[UIAlertView alloc] initWithTitle:@"Foutmelding" message:@"Geen internet" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        
    }];
    [af_operation setCredential:[NSURLCredential credentialWithUser:[Paap getUsername] password:[Paap getPassword] persistence:NSURLCredentialPersistenceNone]];
    [af_operation start];
    
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect sendFrame = self.sendView.frame;
    sendFrame.origin.y -= 150;
    CGRect tableView = self.tableview.frame;
    tableView.size.height -= 150;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.sendView.frame = sendFrame;
        self.tableview.frame = tableView;
    } completion:^(BOOL finished) {
        [self scrollToBottom];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    CGRect sendFrame = self.sendView.frame;
    sendFrame.origin.y += 150;
    
    CGRect tableView = self.tableview.frame;
    tableView.size.height += 150;
    [UIView animateWithDuration:0.3 animations:^{
        self.sendView.frame = sendFrame;
        self.tableview.frame = tableView;
    }];
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_messages count];
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Message *message = [_messages objectAtIndex:section];
    return [message.messages count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCell *middleCell = [tableView dequeueReusableCellWithIdentifier:@"middleCell"];
    ChatCell *bottomCell = [tableView dequeueReusableCellWithIdentifier:@"bottomCell"];
    ChatCell *bottomCellRight = [tableView dequeueReusableCellWithIdentifier:@"bottomCellRight"];
    Message *message = [_messages objectAtIndex:indexPath.section];
    
    ChatCell *cell;

    if([message.messages count] == 1 || [message.messages count] == (indexPath.row+1))
    {
        if(message.paap.paapId == [Paap current].paapId)
        {
            cell = bottomCellRight;
            
            [cell setRight];
        }else{
            
            cell = bottomCell;
            [cell setLeft];
        }
        [cell.timeLabel setHidden:NO];
        [cell.timeLabel setText:message.time];
        
    }else{
        
        cell = middleCell;
        [cell.timeLabel setHidden:YES];
        [cell setMiddle];
    }
        
    NSString *messageString = [message.messages objectAtIndex:indexPath.row];
    
    [cell setMessageText:messageString];
    if(message.paap.paapId == [Paap current].paapId)
    {
        [cell setRightAlign];
    }else{
        [cell setLeftAlign];
    }
    
     return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = [_messages objectAtIndex:indexPath.section];
    NSString *messageString = [message.messages objectAtIndex:indexPath.row];
    CGSize size = [messageString sizeWithFont:[Fonts getFont] constrainedToSize:CGSizeMake(270, 300) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height + 5;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Message *message = [_messages objectAtIndex:section];
    CGRect frame = CGRectMake(0, 6, 320, 19);
    UIView *header = [[UIView alloc] initWithFrame:frame];
    [header setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_chat.png"]];
    headerImage.frame = frame;
    [headerImage setBackgroundColor:[UIColor clearColor]];
    
    CGRect nameFrame = CGRectMake(23, 9, 270, 19);
    UILabel *name = [[UILabel alloc] initWithFrame:nameFrame];
    [name setBackgroundColor:[UIColor clearColor]];
    [name setText:message.paap.name];
    [Fonts setStaticBold:name withSize:20];
    [name setTextColor:[Fonts getColorWithId:message.paap.paapId]];
    
    [header addSubview:headerImage];
    [header addSubview:name];
    return header;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setActivity:nil];
    [super viewDidUnload];
}
@end
