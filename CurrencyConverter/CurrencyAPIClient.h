//
//  CurrencyAPIClient.h
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 03/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Responsible for connecting with the remote server and performing requests. More details on https://openexchangerates.org/documentation */

@interface CurrencyAPIClient : NSObject

// returns the singleton instance
+ (instancetype) sharedClient;

// Get the list of the currencies. The list of currencies is passed to success block (the dictionary keys are the currencies identifiers, and the values are the names). The callbacks blocks are called in main queue.
- (void)getCurrencies:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

// Get the current market info (the rates values). Blocks are called in main queue.
- (void)getCurrencyMarketInfo:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

@end
