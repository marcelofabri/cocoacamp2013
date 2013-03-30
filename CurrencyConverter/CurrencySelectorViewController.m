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

@property (nonatomic, strong) NSArray *sections;

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
    
    [self.searchDisplayController.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAvailableCurrencies:(NSDictionary *)availableCurrencies {
    _availableCurrencies = [availableCurrencies copy];
    
    // sorts the keys according the the full name
    self.sortedCurrenciesKeys = [[_availableCurrencies allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [self.availableCurrencies[obj1] localizedCompare:self.availableCurrencies[obj2]];
    }];
    
    [self createSortedSections:self.sortedCurrenciesKeys];
    
    [self.tableView reloadData];
}

- (void)createSortedSections:(NSArray *)sortedKeys {
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    NSMutableArray *tempSections = [NSMutableArray array];
    
    for(NSUInteger i = 0; i < [collation.sectionTitles count]; i++) {
        [tempSections addObject:[NSMutableArray array]];
    }
    
    for (NSString *key in sortedKeys) {
        NSInteger index = [collation sectionForObject:self.availableCurrencies[key] collationStringSelector:@selector(self)];
        [tempSections[index] addObject:key];
    }
    
    NSMutableArray *sections = [NSMutableArray array];
    
    for (NSMutableArray *section in tempSections) {
        [sections addObject:[collation sortedArrayFromArray:section collationStringSelector:@selector(self)]];
    }
    
    self.sections = sections;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //we use sectionTitles and not sections
    if (tableView == self.tableView) {
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
    }
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredCurrencies count];
    }
    
    return [self.sections[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sections[section] count] > 0 && self.tableView == tableView ? [[UILocalizedIndexedCollation currentCollation] sectionTitles][section] : nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSArray *arr = tableView == self.searchDisplayController.searchResultsTableView ? self.filteredCurrencies : self.sections[indexPath.section];
    cell.textLabel.text = self.availableCurrencies[arr[indexPath.row]]; // the text
    cell.imageView.image = [UIImage imageNamed:arr[indexPath.row]] ? : [UIImage imageNamed:@"unknown"]; // the flag
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (tableView == self.tableView) {
        if (index == 0) { // search bar
            [tableView setContentOffset:CGPointZero animated:NO];
            return NSNotFound;
        }
        
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
    }
    return 0;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return [@[UITableViewIndexSearch] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }
    return nil;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = tableView == self.searchDisplayController.searchResultsTableView ? self.filteredCurrencies : self.sections[indexPath.section];
    NSString *selectedCurrency = arr[indexPath.row];
    [self.delegate currencySelector:self didSelectCurrency:selectedCurrency];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Search display delegate

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    NSIndexSet *indexes = [self.sortedCurrenciesKeys indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [self.availableCurrencies[obj] rangeOfString:searchString options:NSCaseInsensitiveSearch].length > 0;
    }];
    
    self.filteredCurrencies = [self.sortedCurrenciesKeys objectsAtIndexes:indexes];

    return YES;
}

@end
