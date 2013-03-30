//
//  CurrencyHelper.h
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 03/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

@class CurrencyMarketInfo;

// Responsible for getting currency data. It'll get it from cache or via HTTP requests.
@interface CurrencyHelper : NSObject

// The singleton instance
+ (instancetype) sharedHelper;


// Get the list of the currencies. The list of currencies is passed to success block (the dictionary keys are the currencies identifiers, and the values are the names). The callbacks blocks are called in main queue.
- (void)getCurrencies:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;


// Get the market info (rates). The callbacks blocks are called in main queue.
- (void)getCurrencyMarketInfo:(void (^)(CurrencyMarketInfo *))success failure:(void (^)(NSError *))failure;

// Get the market info (rates). Calling this method ensures that you'll get the most updated information (it'll force a request). The callbacks blocks are called in main queue.
- (void)getUpdatedCurrencyMarketInfo:(void (^)(CurrencyMarketInfo *))success failure:(void (^)(NSError *))failure;

@end
