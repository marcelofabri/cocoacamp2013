//
//  CurrencySelectorViewController.m
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 10/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import "CurrencySelectorViewController.h"

@interface CurrencySelectorViewController ()

@property (nonatomic, strong) NSArray *sortedCurrenciesKeys;
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
    return [self.sortedCurrenciesKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.availableCurrencies[self.sortedCurrenciesKeys[indexPath.row]];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    NSString *selectedCurrency = self.sortedCurrenciesKeys[indexPath.row];
    [self.delegate currencySelector:self didSelectCurrency:selectedCurrency];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
