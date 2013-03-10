//
//  CurrencyValue.h
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 09/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

@interface CurrencyValue : NSObject

@property (nonatomic, readonly) double value;
@property (nonatomic, readonly) NSString *currency;

- (instancetype)initWithValue:(double)value currencyIdentifier:(NSString *)currency;

+ (instancetype)currencyWithValue:(double)value identifier:(NSString *)currencyIdentifier;

@end
