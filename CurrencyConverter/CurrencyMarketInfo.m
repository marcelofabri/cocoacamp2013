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
    
    // https://openexchangerates.org/documentation#how-to-use
    CGFloat value = [self.rates[finalCurrency] doubleValue] * (1 / [self.rates[sourceValue.currency] doubleValue]);
    return [CurrencyValue currencyWithValue:value identifier:finalCurrency];
}

+ (CurrencyMarketInfo *)marketInfoWithTimeStamp:(NSDate *)timestamp baseCurrency:(NSString *)baseCurrency rates:(NSDictionary *)rates {
    CurrencyMarketInfo *marketInfo = [[CurrencyMarketInfo alloc] init];
    
    marketInfo.baseCurrency = baseCurrency;
    marketInfo.timestamp = timestamp;
    marketInfo.rates = rates;
    
    return marketInfo;
}

@end
