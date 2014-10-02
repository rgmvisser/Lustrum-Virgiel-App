//
//  LoginController.m
//  23e Lustrum
//
//  Created by Ruud Visser on 3/6/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import "LoginController.h"
#import "MenuViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "Paap.h"
@interface LoginController() <UIAlertViewDelegate,UITextFieldDelegate>
{
    UIViewController *_from;
    MenuViewController *_menu;
    UITextField *userField;
    UITextField *passwordField;
    UIAlertView *_alert;
}
@end

static LoginController *shared;

@implementation LoginController

+(LoginController *)shared
{
    if(!shared)
    {
        shared = [[LoginController alloc] init];
    }
    return shared;
}

+(BOOL)isLoggedIn
{
    NSLog(@"Username: '%@', password: '%@'",[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]);
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"username"] || ![[NSUserDefaults standardUserDefaults] objectForKey:@"password"])
    {
        return NO;
    }
    return YES;
}

-(void)loginFromVC:(UIViewController *)from sender:(id)menuvc
{
    _from = from;
    _menu = menuvc;
    UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"Login"
                                                            message:@"Vul hier je gegevens in van virgiel.nl\n\n\n\n"
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Annuleren",nil)
                                                  otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
    
    userField = [[UITextField alloc] initWithFrame:CGRectMake(16,78,252,25)];
    userField.borderStyle = UITextBorderStyleRoundedRect;
    [userField setPlaceholder:@"Gebruikersnaam"];
    userField.keyboardAppearance = UIKeyboardAppearanceAlert;
    userField.delegate = self;
    [userField becomeFirstResponder];
    
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(16,108,252,25)];
    passwordField.borderStyle = UITextBorderStyleRoundedRect;
    [passwordField setPlaceholder:@"Wachtwoord"];
    [passwordField setSecureTextEntry:YES];
    passwordField.keyboardAppearance = UIKeyboardAppearanceAlert;
    passwordField.delegate = self;   
    
    [passwordAlert addSubview:passwordField];
    [passwordAlert addSubview:userField];
    
    [passwordAlert show];
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [_menu showVC:_from];
    }else{
        NSString *urlStr = @"http://lustrumvirgiel.nl/";
        NSURL *url = [NSURL URLWithString:urlStr];
        
        __block NSString *username = userField.text;
        __block NSString *password = passwordField.text;
        
        AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:url];
        [client setParameterEncoding:AFJSONParameterEncoding];
        [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        client.parameterEncoding = AFJSONParameterEncoding;
        NSString *path = [[NSString alloc]initWithFormat:@"login.php"];
        
        NSMutableURLRequest *af_request = [client requestWithMethod:@"GET" path:path parameters:nil];
        
        [client setAuthorizationHeaderWithUsername:userField.text password:passwordField.text];
        [client setDefaultHeader:@"Accept" value:@"application/json"];
        
        _alert = [[UIAlertView alloc] initWithTitle:@"Inloggen" message:@"Bezig met inloggen.." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [_alert show];
        
        // first way of trying..
        AFHTTPRequestOperation *af_operation = [client HTTPRequestOperationWithRequest:af_request success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSLog(@"Response: %@",responseObject);
            NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONWritingPrettyPrinted error:nil];
           
            NSLog(@"Fetched: %@", payload);
            if ([[payload objectForKey:@"success"] integerValue] == 1) {
                NSDictionary *paapdict = [payload objectForKey:@"paap"];
                Paap *paap = [[Paap alloc] initPaapWithId:[[paapdict objectForKey:@"paapid"] integerValue] Name:[paapdict objectForKey:@"name"]];
                [Paap setCurrentPaap:paap];
                [[NSUserDefaults standardUserDefaults] setObject:paapdict forKey:@"paap"];
                NSLog(@"User: %@ Password: %@",username,password);
                [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"logged_in" object:self];
                
            }
            [_alert dismissWithClickedButtonIndex:0 animated:YES];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [_menu showVC:_from];
            [_alert dismissWithClickedButtonIndex:0 animated:YES];
            [[[UIAlertView alloc] initWithTitle:@"Fout" message:@"Inloggen niet gelukt" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil]show];
            
        }];
        [af_operation setCredential:[NSURLCredential credentialWithUser:userField.text password:passwordField.text persistence:NSURLCredentialPersistenceNone]];
        [af_operation start];
               
        
    }
}





@end
