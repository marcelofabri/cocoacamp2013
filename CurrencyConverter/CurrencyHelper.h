//
//  CurrencyHelper.h
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 03/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencyHelper : NSObject

+ (instancetype) sharedHelper;
- (void)getCurrencies:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

@end
