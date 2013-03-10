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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[CurrencyHelper sharedHelper] getCurrencies:^(NSDictionary *currencies) {
        NSLog(@"%@", currencies);
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

@end
