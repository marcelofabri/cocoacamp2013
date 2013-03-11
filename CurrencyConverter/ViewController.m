//
//  ViewController.m
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 03/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import "ViewController.h"
#import "CurrencyHelper.h"
#import "CurrencyMarketInfo.h"
#import "CurrencyValue.h"
#import "CurrencySelectorViewController.h"

@interface ViewController () <CurrencySelectorDelegate>

@property (weak, nonatomic) IBOutlet UILabel *sourceCurrencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *finalCurrencyLabel;

@property (nonatomic, strong) NSDictionary *currencies;

@property (nonatomic, copy) NSString *sourceCurrency;
@property (nonatomic, copy) NSString *finalCurrency;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[CurrencyHelper sharedHelper] getCurrencies:^(NSDictionary *currencies) {
        self.currencies = currencies;
        
        self.sourceCurrency = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode];
        self.sourceCurrencyLabel.text = currencies[self.sourceCurrency];
        
        if ([self.sourceCurrency isEqualToString:@"USD"]) {
            self.finalCurrency = @"EUR";
        } else {
            self.finalCurrency = @"USD";            
        }
        
        self.finalCurrencyLabel.text = currencies[self.finalCurrency];        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [[CurrencyHelper sharedHelper] getCurrencyMarketInfo:^(CurrencyMarketInfo *info) {
        CurrencyValue *value = [info convertValue:[CurrencyValue currencyWithValue:1 identifier:@"EUR"] toCurrency:@"BRL"];
        NSLog(@"%f", value.value);
    } failure:^(NSError *err) {
        NSLog(@"%@", err);
    }];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Gesture recognizers actions
- (IBAction)viewTapped:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)currencyLabelLongPressed:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CurrencySelectorViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"currencySelector"];

        NSMutableDictionary *currencies = [self.currencies mutableCopy];
        vc.delegate = self;
        
        if (sender.view == self.sourceCurrencyLabel) {
            vc.mode = CurrencySelectorModeSource;
            [currencies removeObjectForKey:self.finalCurrency];
        } else {
            vc.mode = CurrencySelectorModeFinal;
            [currencies removeObjectForKey:self.sourceCurrency];
        }
        
        vc.availableCurrencies = currencies;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark Currency selector delegate
- (void)currencySelector:(CurrencySelectorViewController *)selector didSelectCurrency:(NSString *)currencyCode {
    NSLog(@"%@", currencyCode);
    if (selector.mode == CurrencySelectorModeSource) {
        self.sourceCurrencyLabel.text = self.currencies[currencyCode];
    } else {
        self.finalCurrencyLabel.text = self.currencies[currencyCode];
    }
}

@end
