//
//  CurrencySelectorViewController.h
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 10/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CurrencySelectorMode) {
    CurrencySelectorModeSource,
    CurrencySelectorModeFinal
};

@class CurrencySelectorViewController;

@protocol CurrencySelectorDelegate <NSObject>

// Called when the currency is selected
- (void)currencySelector:(CurrencySelectorViewController *)selector didSelectCurrency:(NSString *)currencyCode;

@end

@interface CurrencySelectorViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *availableCurrencies; // the currencies that will be available for picking. The dictionary's keys are the currencies' identifiers, and the values are the full names
@property (nonatomic, weak) id<CurrencySelectorDelegate> delegate; // doesn't retain the delegate
@property (nonatomic) CurrencySelectorMode mode; // is the user selecting the source or final currency?

@end
