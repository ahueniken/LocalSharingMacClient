//
//  ViewController.h
//  LocalSharing
//
//  Created by adam on 2015-01-26.
//  Copyright (c) 2015 dgp.adam. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
{
    IBOutlet NSTextField *emailField;
    IBOutlet NSTextField *emailLabel;
    
    IBOutlet NSSecureTextField *passwordField;
    IBOutlet NSTextField *passwordLabel;
    
    IBOutlet NSButton *loginButton;
    IBOutlet NSTextField *mainMessage;
}

    @property (nonatomic, retain) IBOutlet NSTextField *emailField;

    @property (nonatomic, retain) IBOutlet NSTextField *mainMessage;

    @property (nonatomic, retain) IBOutlet NSTextField *emailLabel;

    @property (nonatomic, retain) IBOutlet NSTextField *passwordLabel;

    @property (nonatomic, retain) IBOutlet NSSecureTextField *passwordField;

    @property (nonatomic, retain) IBOutlet NSButton *loginButton;

@end

