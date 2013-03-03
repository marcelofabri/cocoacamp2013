//
//  CurrencyAPIClient.h
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 03/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencyAPIClient : NSObject

+ (instancetype) sharedClient;
- (void)getCurrencies:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

@end
