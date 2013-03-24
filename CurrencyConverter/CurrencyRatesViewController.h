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

@property (nonatomic, strong) NSArray *availableCurrencies;
@property (nonatomic, strong) CurrencyValue *baseValue;
@property (nonatomic, copy) NSString *finalCurrency;
@property (nonatomic, strong) NSDictionary *currenciesNames;

@end
