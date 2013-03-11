//
//  CurrencyRatesViewController.m
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 11/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import "CurrencyRatesViewController.h"
#import "CurrencyCollectionViewCell.h"
#import "CurrencyMarketInfo.h"
#import "CurrencyValue.h"

@interface CurrencyRatesViewController ()

@property (nonatomic, strong) NSArray *formattedCurrencies;
@end

@implementation CurrencyRatesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSMutableArray *arr = [NSMutableArray array];
    
    id languageCode = [NSLocale preferredLanguages][0];
    
    NSString *baseCurrency = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode];
    CurrencyValue *baseValue = [CurrencyValue currencyWithValue:1 identifier:baseCurrency];
    
    for (NSString *code in self.availableCurrencies) {
        
        NSDictionary *localeInfo = @{NSLocaleCurrencyCode : code, NSLocaleLanguageCode : languageCode};
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:
                            [NSLocale localeIdentifierFromComponents:localeInfo]];
        
        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
        fmt.numberStyle = NSNumberFormatterCurrencyStyle;
        fmt.locale = locale;
        
        CurrencyValue *value = [self.marketInfo convertValue:baseValue toCurrency:code];

        [arr addObject:[fmt stringFromNumber:@(value.value)]];
        
    }
    self.formattedCurrencies = arr;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.availableCurrencies count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CurrencyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *currencyCode = self.availableCurrencies[indexPath.row]; //@"BRL";
    
    cell.flagImageView.image = [UIImage imageNamed:currencyCode] ? : [UIImage imageNamed:@"unknown"];
    cell.rateLabel.text = self.formattedCurrencies[indexPath.row];
    
    return cell;
}

@end
