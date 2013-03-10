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

- (void)currencySelector:(CurrencySelectorViewController *)selector didSelectCurrency:(NSString *)currencyCode;

@end

@interface CurrencySelectorViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *availableCurrencies;
@property (nonatomic, weak) id<CurrencySelectorDelegate> delegate;
@property (nonatomic) CurrencySelectorMode mode;

@end
