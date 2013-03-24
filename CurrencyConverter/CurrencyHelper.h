//
//  CurrencyHelper.h
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 03/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

@class CurrencyMarketInfo;

@interface CurrencyHelper : NSObject

+ (instancetype) sharedHelper;
- (void)getCurrencies:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
- (void)getCurrencyMarketInfo:(void (^)(CurrencyMarketInfo *))success failure:(void (^)(NSError *))failure;

- (void)getUpdatedCurrencyMarketInfo:(void (^)(CurrencyMarketInfo *))success failure:(void (^)(NSError *))failure;
@end
