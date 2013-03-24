//
//  CurrencyRatesViewController.m
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 11/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import "CurrencyRatesViewController.h"
#import "CurrencyCollectionViewCell.h"
#import "CurrencyCollectionViewHeader.h"
#import "CurrencyMarketInfo.h"
#import "CurrencyValue.h"
#import "CurrencyHelper.h"

@interface CurrencyRatesViewController ()

@property (nonatomic, strong) NSArray *formattedCurrencies;
@property (nonatomic, strong) CurrencyMarketInfo *marketInfo;

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
    
    
    __weak typeof(self) weakSelf = self;
    [[CurrencyHelper sharedHelper] getCurrencyMarketInfo:^(CurrencyMarketInfo *info) {
        weakSelf.marketInfo = info;
        [weakSelf reloadCurrencies];
        [weakSelf.collectionView reloadData];
        
        if (weakSelf.finalCurrency) {
            NSUInteger idx = [weakSelf.availableCurrencies indexOfObject:weakSelf.finalCurrency];
            [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        }
    } failure:^(NSError *err) {
        NSLog(@"%@", err);
    }];
    
    
// is there another way to add an UIRefreshControl into an UICollectionView?
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshCurrencies:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
}

- (void)reloadCurrencies {
    NSMutableArray *arr = [NSMutableArray array];
    
    id languageCode = [NSLocale preferredLanguages][0];
    
    if (! self.baseValue) {
        NSString *baseCurrency = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode];
        self.baseValue = [CurrencyValue currencyWithValue:1 identifier:baseCurrency];
    }
    
    for (NSString *code in self.availableCurrencies) {
        
        NSDictionary *localeInfo = @{NSLocaleCurrencyCode : code, NSLocaleLanguageCode : languageCode};
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:
                            [NSLocale localeIdentifierFromComponents:localeInfo]];
        
        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
        fmt.numberStyle = NSNumberFormatterCurrencyStyle;
        fmt.locale = locale;
        
        CurrencyValue *value = [self.marketInfo convertValue:self.baseValue toCurrency:code];
        
        [arr addObject:[fmt stringFromNumber:@(value.value)]];
        
    }
    self.formattedCurrencies = arr;
}

- (void)refreshCurrencies:(UIRefreshControl *)refreshControl {
    
    __weak typeof(self) weakSelf = self;
    [[CurrencyHelper sharedHelper] getUpdatedCurrencyMarketInfo:^(CurrencyMarketInfo * info) {
        weakSelf.marketInfo = info;
        [weakSelf reloadCurrencies];
        [weakSelf.collectionView reloadData];
        [refreshControl endRefreshing];
    } failure:^(NSError *err) {
        [refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.availableCurrencies count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CurrencyCollectionViewHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                              withReuseIdentifier:@"Header" forIndexPath:indexPath];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    NSString *formattedTimeStamp = [formatter stringFromDate:self.marketInfo.timestamp];
    header.timestampLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Rates calculed on %@", @"Shows the rates last calculated date (the param)"), formattedTimeStamp];
    

    NSString *currency = self.baseValue.currency;
    header.flagImageView.image = [UIImage imageNamed:currency] ? : [UIImage imageNamed:@"unknown"];
    header.currencyLabel.text = [NSString stringWithFormat:@"%@ (%@)", currency, self.currenciesNames[currency]];
    
    id languageCode = [NSLocale preferredLanguages][0];
    NSDictionary *localeInfo = @{NSLocaleCurrencyCode : currency, NSLocaleLanguageCode : languageCode};
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:
                        [NSLocale localeIdentifierFromComponents:localeInfo]];
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    fmt.numberStyle = NSNumberFormatterCurrencyStyle;
    fmt.locale = locale;
    
    header.sourceCurrencyValue.text = [fmt stringFromNumber:@(self.baseValue.value)];
    
    return header;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CurrencyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *currencyCode = self.availableCurrencies[indexPath.row]; //@"BRL";
    
    cell.flagImageView.image = [UIImage imageNamed:currencyCode] ? : [UIImage imageNamed:@"unknown"];
    cell.rateLabel.text = self.formattedCurrencies[indexPath.row];
    
    if ([currencyCode isEqualToString:self.finalCurrency]) {
        cell.backgroundColor = [UIColor colorWithRed:0.677 green:0.929 blue:0.677 alpha:1.000];
    } else {
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

@end
