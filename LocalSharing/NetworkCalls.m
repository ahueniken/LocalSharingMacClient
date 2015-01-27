//
//  NetworkCalls.m
//  LocalSharing
//
//  Created by adam on 2015-01-27.
//  Copyright (c) 2015 dgp.adam. All rights reserved.
//

#import "NetworkCalls.h"

@implementation NetworkCalls

NSMutableData* webData;
NSString* authToken = NULL;

+ (void)sendPostRequest:(NSNotification *)aNotification withAppTitle:(NSString *)title withAuthToken:(NSString *)token{
    authToken = token;
    if (authToken == NULL) {
        NSNotification* loginNotification;
        NSLog(@"test");
        // [NetworkCalls login:(loginNotification)];
    } else {
        NSNotification* shareNotification;
        [NetworkCalls share:(shareNotification) appTitle:(title)];
    }
    }

+ (void)share:(NSNotification *)shareNotification appTitle:(NSString *)title {
    NSLog(@"share request started");
    NSString *post = [NSString stringWithFormat:@"title=%@&description=This is from the mac&user_token=%@&user_email=adamh@gmail.com", title, authToken];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%ld", (unsigned long)[postData length]];
    
    NSLog(@"Share data: %@", post);
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:[NSURL URLWithString:@"http://local-experiences.herokuapp.com/actions/share"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(theConnection) {
        webData = [NSMutableData data];
        NSLog(@"share connection initiated");
    }
    
}

+ (void)login:(NSNotification *)loginNotification withEmail:(NSString *)email withPassword:(NSString *)password{
    NSLog(@"web request started");
    NSString *post = [NSString stringWithFormat:@"user[email]=%@&user[password]=%@&commit=Log in", email, password];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%ld", (unsigned long)[postData length]];
    
    NSLog(@"Post data: %@", post);
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:[NSURL URLWithString:@"http://local-experiences.herokuapp.com/users/sign_in"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(theConnection) {
        webData = [NSMutableData data];
        NSLog(@"connection initiated");
    }

}

+ (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [webData appendData:data];
    NSLog(@"connection received data");
}

+ (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"connection received response");
    NSHTTPURLResponse *ne = (NSHTTPURLResponse *)response;
    if([ne statusCode] == 200) {
        NSLog(@"connection state is 200 - all okay");
        NSDictionary *headers = [ne allHeaderFields];
        authToken = [headers objectForKey:@"Auth_token"];
        NSLog(authToken);
        if (authToken != NULL) {
            NSDictionary* dict = [NSDictionary dictionaryWithObject:authToken forKey:@"authToken"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginComplete" object:nil userInfo:dict];
        } else {
            NSString *url = [[[connection currentRequest] URL] absoluteString];
            if ([url isEqualToString:@"http://local-experiences.herokuapp.com/users/sign_in"])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginFailed" object:nil];
            }
        }
    } else {
        NSLog(@"connection state is NOT 200");
    }
}

+ (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Conn Err: %@", [error localizedDescription]);
}

+ (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Conn finished loading");
    NSString *html = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
//NSLog(@"OUTPUT:: %@", html);
}


@end
