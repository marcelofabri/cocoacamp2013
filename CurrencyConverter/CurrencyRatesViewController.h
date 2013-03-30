//
//  CurrencyRatesViewController.h
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 11/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CurrencyMarketInfo;
@class CurrencyValue;

@interface CurrencyRatesViewController : UICollectionViewController

@property (nonatomic, strong) NSArray *availableCurrencies; // The identifiers of the currencies that'll be listed.
@property (nonatomic, strong) CurrencyValue *baseValue; // if is not set, will use the default currency with 1 of amount. All the rates values will be calculated using this currency
@property (nonatomic, copy) NSString *finalCurrency; // will show this currency value highlighted
@property (nonatomic, strong) NSDictionary *currenciesNames; // the names of all currencies (keys are identifiers, values are the names)

@end
