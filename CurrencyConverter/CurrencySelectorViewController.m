//
//  CurrencySelectorViewController.m
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 10/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import "CurrencySelectorViewController.h"

@interface CurrencySelectorViewController () <UISearchDisplayDelegate>

@property (nonatomic, strong) NSArray *sortedCurrenciesKeys;
@property (nonatomic, strong) NSArray *filteredCurrencies;

@end

@implementation CurrencySelectorViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAvailableCurrencies:(NSDictionary *)availableCurrencies {
    _availableCurrencies = [availableCurrencies copy];
    
    self.sortedCurrenciesKeys = [[_availableCurrencies allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [self.availableCurrencies[obj1] compare:self.availableCurrencies[obj2]];
    }];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredCurrencies count];
    }
    
    return [self.sortedCurrenciesKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSArray *arr = tableView == self.searchDisplayController.searchResultsTableView ? self.filteredCurrencies : self.sortedCurrenciesKeys;
    cell.textLabel.text = self.availableCurrencies[arr[indexPath.row]];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = tableView == self.searchDisplayController.searchResultsTableView ? self.filteredCurrencies : self.sortedCurrenciesKeys;
    NSString *selectedCurrency = arr[indexPath.row];
    [self.delegate currencySelector:self didSelectCurrency:selectedCurrency];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    
    NSIndexSet *indexes = [self.sortedCurrenciesKeys indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [self.availableCurrencies[obj] rangeOfString:searchString options:NSCaseInsensitiveSearch].length > 0;
    }];
    
    self.filteredCurrencies = [self.sortedCurrenciesKeys objectsAtIndexes:indexes];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end
