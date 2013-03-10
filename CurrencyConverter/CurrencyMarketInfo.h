//
//  CurrencyMarketInfo.h
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 09/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

@class CurrencyValue;

@interface CurrencyMarketInfo : NSObject

@property (nonatomic, strong) NSDate *timestamp; // when was these rates prices?

- (CurrencyValue *)convertValue:(CurrencyValue *)sourceValue toCurrency:(NSString *)finalCurrency;

+ (CurrencyMarketInfo *)marketInfoWithTimeStamp:(NSDate *)timestamp baseCurrency:(NSString *)baseCurrency rates:(NSDictionary *)rates;

@end
