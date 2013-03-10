//
//  CurrencyValue.h
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 09/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencyValue : NSObject

@property (nonatomic, readonly) CGFloat value;
@property (nonatomic, readonly) NSString *currency;

- (instancetype)initWithValue:(CGFloat)value currencyIdentifier:(NSString *)currency;

+ (instancetype)currencyWithValue:(CGFloat)value identifier:(NSString *)currencyIdentifier;

@end
