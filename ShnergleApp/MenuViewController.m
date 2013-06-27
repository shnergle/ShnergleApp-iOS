//
//  MenuViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 11/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "SearchBarView.h"
#import "PostRequest.h"
#import "VenueViewController.h"

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    //load search bar
    UIView *searchBar = [[NSBundle mainBundle] loadNibNamed:@"SearchBar" owner:self options:nil][0];
    [self.view addSubview:searchBar];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    _tableSections = @[@"Profile", @"Explore"];
    _tableData = @{@0: @[appDelegate.fullName], @1: @[@"Around Me", @"Following", @"Promotions", @"Quiet", @"Trending", @"Add Venue"]};
    _searchResults = appDelegate.searchResults;
    //tmp - give it an element
    _searchResults = [[NSMutableArray alloc]init];
    self.searchResultsView.resultsTableView.delegate = self;
    self.searchResultsView.resultsTableView.dataSource = self;

    [self initSearchResultsView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [_menuItemsTableView deselectRowAtIndexPath:[_menuItemsTableView indexPathForSelectedRow] animated:YES];
}

- (void)initSearchResultsView {
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchResultsView" owner:self options:nil];
    self.searchResultsView = nibObjects[0];

    self.searchResultsView.frame = CGRectMake(320, 45, 320, self.searchResultsView.frame.size.height);
    [[self view] addSubview:self.searchResultsView];
    self.cancelButton.alpha = 0;
}

- (void)postResponse:(id)response {
    //NSLog(@"search response: %@", response);
    if ([response isKindOfClass:[NSArray class]]) {
        //_searchResults = [[NSMutableArray alloc]initWithArray:response];
        for (id obj in response) {
            if ([obj count] > 1) [_searchResults addObject:obj[1]];
        }
    }

    [_searchResultsView.resultsTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.menuItemsTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"MyCell%d%d", indexPath.section, indexPath.item]];
        cell.textLabel.text = _tableData[@(indexPath.section)][indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"Roboto" size:20];
        if (indexPath.section == 0) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profileicon.png"]];
            cell.accessoryView.bounds = CGRectMake(0, 0, 27, 19);
            _profileCell = cell;
        } else if (indexPath.row == 1) {
            UILabel *noLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 15)];
            noLabel.text = @"0";
            noLabel.font = [UIFont fontWithName:@"Roboto" size:20];
            noLabel.textColor = [UIColor whiteColor];
            noLabel.backgroundColor = [UIColor clearColor];
            cell.accessoryView = noLabel;
            cell.accessoryView.opaque = NO;
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"ResultCell"]];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"ResultCell"]];
        }
        cell.textLabel.text = _searchResults[indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"Roboto" size:20];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchResultsView.resultsTableView) {
        return [_searchResults count];
    } else {
        return [_tableData[@(section)] count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchResultsView.resultsTableView) {
        return 1;
    } else {
        return [_tableData count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchResultsView.resultsTableView) {
        return @"results";
    } else {
        return _tableSections[section];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *sectionLabel = [[UILabel alloc] init];
    sectionLabel.textColor = [UIColor colorWithRed:117 / 255. green:117 / 255. blue:117 / 255. alpha:1];
    sectionLabel.backgroundColor = [UIColor colorWithRed:29 / 255. green:29 / 255. blue:29 / 255. alpha:1];
    sectionLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
    sectionLabel.text = [NSString stringWithFormat:@"   %@", [self tableView:tableView titleForHeaderInSection:section]];
    return sectionLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.searchResultsView.resultsTableView) {
        return 0.1;
    } else {
        return [_tableData count] - 1 == section ? tableView.sectionFooterHeight : 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchResultsView.resultsTableView) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        VenueViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"Venue"];
        [viewController setTitle:_searchResults[indexPath.row]];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([segue.identifier isEqualToString:@"PromotionSegue"]) {
        appDelegate.topViewType = @"Promotions";
    } else if ([segue.identifier isEqualToString:@"QuietSegue"]) {
        appDelegate.topViewType = @"Quiet";
    } else if ([segue.identifier isEqualToString:@"TrendingSegue"]) {
        appDelegate.topViewType = @"Trending";
    } else if ([segue.identifier isEqualToString:@"FavouritesSegue"]) {
        appDelegate.topViewType = @"Following";
    }
    if ([segue.identifier isEqualToString:@"ProfileSegue"]) {
        _profileCell.selected = NO;
    } else {
        [self.presentingViewController.navigationController popViewControllerAnimated:NO];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *params = [NSString stringWithFormat:@"term=%@&facebook_id=%@", _bar.text, appDelegate.facebookId];
    [[[PostRequest alloc] init] exec:@"user_searches/set" params:params delegate:self callback:@selector(searchRegistered:)];
    [[[PostRequest alloc] init] exec:@"venues/get" params:params delegate:self callback:@selector(postResponse:)];
    [textField resignFirstResponder];
    [self.searchResultsView show];
    [self toggleCancelButton:true];

    return YES;
}

- (void)searchRegistered:(id)response {
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self toggleCancelButton:true];
    return YES;
}

- (IBAction)cancelButtonTapped:(id)sender {
    [_bar resignFirstResponder];
    [self.searchResultsView hide];
    [self toggleCancelButton:false];
}

- (void)toggleCancelButton:(bool)show {
    int newAlpha = 0;
    if (show) newAlpha = 1;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:[UIApplication sharedApplication]];
    [UIView setAnimationDidStopSelector:@selector(endIgnoringInteractionEvents)];
    self.cancelButton.alpha = newAlpha;
    [UIView commitAnimations];
}

@end
