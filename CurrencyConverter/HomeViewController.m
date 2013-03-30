//
//  HomeViewController.m
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 03/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import "HomeViewController.h"
#import "CurrencyHelper.h"
#import "CurrencyMarketInfo.h"
#import "CurrencyValue.h"
#import "CurrencySelectorViewController.h"
#import "CurrencyRatesViewController.h"

@interface HomeViewController () <CurrencySelectorDelegate>

@property (weak, nonatomic) IBOutlet UILabel *sourceCurrencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *finalCurrencyLabel;
@property (weak, nonatomic) IBOutlet UIButton *convertButton;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;

@property (nonatomic, strong) NSDictionary *currencies;

@property (nonatomic, copy) NSString *sourceCurrency;
@property (nonatomic, copy) NSString *finalCurrency;

@property (nonatomic, strong) CurrencyMarketInfo *marketInfo;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImage *img = [[UIImage imageNamed:@"confirm_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [self.convertButton setBackgroundImage:img forState:UIControlStateNormal];
    
    [[CurrencyHelper sharedHelper] getCurrencies:^(NSDictionary *currencies) {
        self.currencies = currencies;
        
        // the initial source currency is the device's default currency
        self.sourceCurrency = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode];
        self.sourceCurrencyLabel.text = currencies[self.sourceCurrency];
        
        // the initial final currency is dollar or euro (if the source already is dollar)
        if ([self.sourceCurrency isEqualToString:@"USD"]) {
            self.finalCurrency = @"EUR";
        } else {
            self.finalCurrency = @"USD";            
        }
        
        self.finalCurrencyLabel.text = currencies[self.finalCurrency];        
    } failure:^(NSError *error) {
        // TODO: error handling
        NSLog(@"%@", error);
    }];
    
    // just to cache the market info, so it'll be loaded faster on anothers screens
    [[CurrencyHelper sharedHelper] getCurrencyMarketInfo:^(CurrencyMarketInfo *info) {
    } failure:^(NSError *err) {
        // TODO: error handling
        NSLog(@"%@", err);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// exit segue
- (IBAction)done:(UIStoryboardSegue *)segue {
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.view endEditing:YES];
    
    if ([segue.identifier isEqualToString:@"currencySelection"]) {
        CurrencySelectorViewController *vc = segue.destinationViewController;
        
        NSMutableDictionary *currencies = [self.currencies mutableCopy];
        vc.delegate = self;
        
        
        UILongPressGestureRecognizer *recognizer = sender;
        if (recognizer.view == self.sourceCurrencyLabel) { // was the segue created by which label?
            vc.mode = CurrencySelectorModeSource;
            [currencies removeObjectForKey:self.finalCurrency];
        } else {
            vc.mode = CurrencySelectorModeFinal;
            [currencies removeObjectForKey:self.sourceCurrency];
        }
        
        vc.availableCurrencies = currencies;
    } else if (! [segue.identifier isEqualToString:@"about"]) {
        CurrencyRatesViewController *vc = segue.destinationViewController;
        
        vc.availableCurrencies = [[self.currencies allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [self.currencies[obj1] compare:self.currencies[obj2] options:NSCaseInsensitiveSearch];
        }];
        vc.currenciesNames = self.currencies;
        
        if (sender == self.convertButton) {
            double amount = [self.amountTextField.text doubleValue];
            CurrencyValue *value = [[CurrencyValue alloc] initWithValue:amount currencyIdentifier:self.sourceCurrency];
            vc.baseValue = value;
            vc.finalCurrency = self.finalCurrency;
        }
    }
}
- (IBAction)textFieldChanged:(UITextField *)sender {
    self.convertButton.enabled = [sender.text length] > 0;
}

#pragma mark Gesture recognizers actions
- (IBAction)viewTapped:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)currencyLabelLongPressed:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self performSegueWithIdentifier:@"currencySelection" sender:sender];
    }
}

#pragma mark Currency selector delegate
- (void)currencySelector:(CurrencySelectorViewController *)selector didSelectCurrency:(NSString *)currencyCode {

    if (selector.mode == CurrencySelectorModeSource) {
        self.sourceCurrencyLabel.text = self.currencies[currencyCode];
        self.sourceCurrency = currencyCode;
    } else {
        self.finalCurrencyLabel.text = self.currencies[currencyCode];
        self.finalCurrency = currencyCode;
    }
}

@end
