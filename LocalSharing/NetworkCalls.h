//
//  NetworkCalls.h
//  LocalSharing
//
//  Created by adam on 2015-01-27.
//  Copyright (c) 2015 dgp.adam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkCalls : NSObject

+ (void)sendPostRequest:(NSNotification *)aNotification withAppTitle:(NSString *)title withAuthToken:(NSString *)token;

+ (void)login:(NSNotification *)loginNotification withEmail:(NSString *)email withPassword:(NSString *)password;

@end
