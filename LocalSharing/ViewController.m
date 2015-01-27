//
//  ViewController.m
//  LocalSharing
//
//  Created by adam on 2015-01-26.
//  Copyright (c) 2015 dgp.adam. All rights reserved.
//

#import "ViewController.h"
#import "NetworkCalls.h"

@implementation ViewController

@synthesize emailField;

@synthesize passwordField;
@synthesize mainMessage;
@synthesize emailLabel;
@synthesize passwordLabel;
@synthesize loginButton;

NetworkCalls *networkCaller;


// the function specified in the same class where we defined the addObserver
- (void)showMainMenu:(NSNotification *)note {
    NSLog(@"Received Notification - Someone seems to have logged in");
    
    NSString *auth = [[note userInfo] valueForKey:@"authToken"];
    NSLog(@"============");
    NSLog(auth);
    NSLog(@"------------");
    [mainMessage setStringValue:@"Broadcasting your current app..."];
    emailLabel.hidden = YES;
    emailField.hidden = YES;
    passwordLabel.hidden = YES;
    passwordField.hidden = YES;
    loginButton.hidden = YES;
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                   selector:@selector(handleTimer:) userInfo:[note userInfo] repeats:YES];
    
}

- (void)showFailureMessage:(NSNotification *)note {
    NSLog(@"Username or password is incorrect.");
   [mainMessage setStringValue:@"Please try again, incorrect username or password."];
}

- (void)handleTimer:(NSTimer*)timer {
    NSDictionary *activeApp = [[NSWorkspace sharedWorkspace] activeApplication];
    NSString *title = (NSString *)[activeApp objectForKey:@"NSApplicationName"];
    NSNotification* postNotification;
    [NetworkCalls sendPostRequest:(postNotification) withAppTitle:(title) withAuthToken:([[timer userInfo] valueForKey:@"authToken"])];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    
    networkCaller = [NetworkCalls alloc];
    
    // Add an observer that will respond to loginComplete
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showMainMenu:)
                                                 name:@"loginComplete" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showFailureMessage:)
                                                 name:@"loginFailed" object:nil];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)loginPressed:(id)sender {
    NSLog(@"login was pressed");
    NSString *email = [emailField stringValue];
    NSString *password = [passwordField stringValue];
    NSLog(@"Email is %@", email);
    NSLog(@"Password is %@", password);
    NSNotification* loginNotification;
    [NetworkCalls login:loginNotification withEmail:email withPassword:password];
}



@end
