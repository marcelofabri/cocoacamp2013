//
//  CurrencyRatesViewController.h
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 11/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CurrencyMarketInfo;

@interface CurrencyRatesViewController : UICollectionViewController

@property (nonatomic, strong) NSArray *availableCurrencies;
@property (nonatomic, strong) CurrencyMarketInfo *marketInfo;

@end
