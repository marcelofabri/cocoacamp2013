//
//  CurrencyValue.m
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 09/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import "CurrencyValue.h"

@implementation CurrencyValue

- (instancetype) initWithValue:(CGFloat)value currency:(NSString *)currency {
    self = [super init];
    
    if (self) {
        _value = value;
        _currency = [currency copy];
    }
    return self;
}

+ (instancetype)currencyWithValue:(CGFloat)value identifier:(NSString *)currencyIdentifier {
    return [[self alloc] initWithValue:value currency:currencyIdentifier];
}
@end
