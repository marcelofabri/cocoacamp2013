//
//  CurrencyMarketInfo.h
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 09/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

@class CurrencyValue;

// Represents the currency market on a given date.
@interface CurrencyMarketInfo : NSObject

@property (nonatomic, strong) NSDate *timestamp; // when were these rates prices valid?

// Creates an instance that represents the market on a given date. baseCurrency is the identifier of the currency that is used to calculates all other rates. rates is a dictionary which keys are currencies identifiers and values are the currencies values related to the baseCurrency.
+ (CurrencyMarketInfo *)marketInfoWithTimeStamp:(NSDate *)timestamp baseCurrency:(NSString *)baseCurrency rates:(NSDictionary *)rates;

// Converts an amount of money in a given currency (sourceValue) to another currency (finalCurrency, which is the currency's identifier). The conversion is made with the rates values at the time of this instance's timestamp.
- (CurrencyValue *)convertValue:(CurrencyValue *)sourceValue toCurrency:(NSString *)finalCurrency;
@end
