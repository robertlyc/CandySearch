//
//  CandyTableViewController.m
//  CandySearch
//
//  Created by RoBeRt on 13-1-18.
//  Copyright (c) 2013年 RoBeRt. All rights reserved.
//

#import "CandyTableViewController.h"
#import "Candy.h"

@interface CandyTableViewController ()

@end

@implementation CandyTableViewController
@synthesize candyArray = _candyArray;
@synthesize candySearchBar = _candySearchBar;
@synthesize filteredCandyArray = _filteredCandyArray;

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
    
    self.candySearchBar.showsScopeBar = NO;
    [self.candySearchBar sizeToFit];
    
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y + self.candySearchBar.bounds.size.height;
    self.tableView.bounds = newBounds;
    
    self.candyArray = [NSArray arrayWithObjects:
                  [Candy candyOfCategory:@"chocolate" name:@"chocolate bar"],
                  [Candy candyOfCategory:@"chocolate" name:@"chocolate chip"],
                  [Candy candyOfCategory:@"chocolate" name:@"dark chocolate"],
                  [Candy candyOfCategory:@"hard" name:@"lollipop"],
                  [Candy candyOfCategory:@"hard" name:@"candy cane"],
                  [Candy candyOfCategory:@"hard" name:@"jaw breaker"],
                  [Candy candyOfCategory:@"other" name:@"caramel"],
                  [Candy candyOfCategory:@"other" name:@"sour chew"],
                  [Candy candyOfCategory:@"other" name:@"peanut butter cup"],
                  [Candy candyOfCategory:@"other" name:@"gummi bear"], nil];
    
    self.filteredCandyArray = [NSMutableArray arrayWithCapacity:[self.candyArray count]];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToSearch:(id)sender {
    [self.candySearchBar becomeFirstResponder];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.filteredCandyArray.count;
    } else {
        return self.candyArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Candy *candy;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        candy = [self.filteredCandyArray objectAtIndex:indexPath.row];
    } else {
        candy = [self.candyArray objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = candy.name;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (void)filterContentForSearchBarText:(NSString *)searchText scope:(NSString *)scope {
    [self.filteredCandyArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    NSArray *tempArray = [self.candyArray filteredArrayUsingPredicate:predicate];
    
    if (![scope isEqualToString:@"All"]) {
        NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"SELF.category contains[c] %@", scope];
        tempArray = [tempArray filteredArrayUsingPredicate:scopePredicate];
    }
    
    self.filteredCandyArray = [NSMutableArray arrayWithArray:tempArray];
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSString *scope = [[self.searchDisplayController.searchBar scopeButtonTitles]
                       objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    [self filterContentForSearchBarText:searchString scope:scope];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    NSString *scope = [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption];
    [self filterContentForSearchBarText:self.searchDisplayController.searchBar.text scope:scope];
    return YES;
}

#pragma mark - TableView Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"candyDetail" sender:tableView];
}

#pragma mark - Seuge
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"candyDetail"]) {
        UIViewController *candyDetailViewController = [segue destinationViewController];
        if (sender == self.searchDisplayController.searchResultsTableView) {
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            NSString *destinationTitle = [[self.filteredCandyArray objectAtIndex:indexPath.row] name];
            candyDetailViewController.title = destinationTitle;
        } else {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            NSString *destinationTitle = [[self.candyArray objectAtIndex:indexPath.row] name];
            candyDetailViewController.title = destinationTitle ;
        }
    }
}


- (void)viewDidUnload {
    _candyArray = nil;
    _filteredCandyArray = nil;
    [super viewDidUnload];
}

@end
