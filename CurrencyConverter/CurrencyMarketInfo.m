//
//  CurrencyMarketInfo.m
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 09/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import "CurrencyMarketInfo.h"
#import "CurrencyValue.h"

@interface CurrencyMarketInfo ()

@property (nonatomic, copy) NSString *baseCurrency;
@property (nonatomic, strong) NSDictionary *rates; // keys are the currencies identifiers and values, the rates

@end

@implementation CurrencyMarketInfo

- (CurrencyValue *)convertValue:(CurrencyValue *)sourceValue toCurrency:(NSString *)finalCurrency {
    
    NSAssert(self.rates[sourceValue.currency], @"Invalid source currency");
    NSAssert(self.rates[finalCurrency], @"Invalid final currency");
    
    CGFloat value = [self.rates[finalCurrency] floatValue] * (1 / [self.rates[sourceValue.currency] floatValue]);
    return [[CurrencyValue alloc] initWithValue:value currency:finalCurrency];
}

+ (CurrencyMarketInfo *)marketInfoWithTimeStamp:(NSDate *)timestamp baseCurrency:(NSString *)baseCurrency rates:(NSDictionary *)rates {
    CurrencyMarketInfo *marketInfo = [[CurrencyMarketInfo alloc] init];
    
    marketInfo.baseCurrency = baseCurrency;
    marketInfo.timestamp = timestamp;
    marketInfo.rates = rates;
    
    return marketInfo;
}
@end
