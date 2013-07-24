//
//  MenuViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 11/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "MenuViewController.h"
#import "PostRequest.h"
#import "VenueViewController.h"

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *searchBar = [[NSBundle mainBundle] loadNibNamed:@"SearchBar" owner:self options:nil][0];
    [self.view addSubview:searchBar];

    tableSections = @[@"Profile", @"Explore"];
    tableData = @[@[appDelegate.fullName], @[@"Around Me", @"Following", @"Promotions", @"Quiet", @"Trending", @"+ Add Place"]];
    searchResults = appDelegate.searchResults;
    searchResults = [[NSMutableArray alloc] init];
    self.searchResultsView.resultsTableView.delegate = self;
    self.searchResultsView.resultsTableView.dataSource = self;

    [self initsearchResultsView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.menuItemsTableView deselectRowAtIndexPath:[self.menuItemsTableView indexPathForSelectedRow] animated:YES];
}

- (void)initsearchResultsView {
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchResultsView" owner:self options:nil];
    self.searchResultsView = nibObjects[0];

    self.searchResultsView.frame = CGRectMake(320, 45, 320, self.searchResultsView.frame.size.height - 65);
    [[self view] addSubview:self.searchResultsView];
    self.cancelButton.alpha = 0;
}

- (void)postResponse:(id)response {
    if ([response isKindOfClass:[NSArray class]]) {
        for (id obj in response) {
            if ([obj count] > 1) [searchResults addObject:obj];
        }
    }

    [self.self.searchResultsView.resultsTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.menuItemsTableView) {
        UITableViewCell *cell;
        if (indexPath.section == 0 && indexPath.row != 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"MyCellVenue"];
            cell.textLabel.text = appDelegate.ownVenues[indexPath.row - 1][@"name"];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"MyCell%d%d", indexPath.section, indexPath.item]];
            cell.textLabel.text = tableData[indexPath.section][indexPath.row];
        }
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profileicon.png"]];
            cell.accessoryView.bounds = CGRectMake(0, 0, 27, 19);
            profileCell = cell;
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ResultCell"];
        }
        cell.textLabel.text = searchResults[indexPath.row][@"name"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchResultsView.resultsTableView) {
        return [searchResults count];
    } else {
        if (section != 0)
            return [tableData[section] count];
        else
            return [tableData[section] count] + [appDelegate.ownVenues count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchResultsView.resultsTableView) {
        return 1;
    } else {
        return [tableData count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchResultsView.resultsTableView) {
        return @"Results";
    } else {
        return tableSections[section];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *sectionLabel = [[UILabel alloc] init];
    sectionLabel.textColor = [UIColor colorWithRed:117 / 255. green:117 / 255. blue:117 / 255. alpha:1];
    sectionLabel.backgroundColor = [UIColor colorWithRed:29 / 255. green:29 / 255. blue:29 / 255. alpha:1];
    sectionLabel.font = [UIFont systemFontOfSize:12];
    sectionLabel.text = [NSString stringWithFormat:@"   %@", [self tableView:tableView titleForHeaderInSection:section]];
    return sectionLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.searchResultsView.resultsTableView) {
        return 0.1;
    } else {
        return [tableData count] - 1 == section ? tableView.sectionFooterHeight : 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchResultsView.resultsTableView) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        VenueViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"Venue"];
        [viewController setVenueInfo];
        appDelegate.activeVenue = searchResults[indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.section == 0 && indexPath.row != 0) {
        appDelegate.activeVenue = appDelegate.ownVenues[indexPath.row - 1];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[VenueViewController class]])
        [((VenueViewController *)[segue destinationViewController]) setVenueInfo];
    if ([segue.identifier isEqualToString:@"PromotionSegue"]) {
        appDelegate.topViewType = @"Promotions";
    } else if ([segue.identifier isEqualToString:@"QuietSegue"]) {
        appDelegate.topViewType = @"Quiet";
    } else if ([segue.identifier isEqualToString:@"TrendingSegue"]) {
        appDelegate.topViewType = @"Trending";
    } else if ([segue.identifier isEqualToString:@"FavouritesSegue"]) {
        appDelegate.topViewType = @"Following";
    } else if ([segue.identifier isEqualToString:@"AddVenueSegue"]) {
        appDelegate.addVenueCheckIn = NO;
    }
    if ([segue.identifier isEqualToString:@"ProfileSegue"]) {
        profileCell.selected = NO;
    } else {
        [self.presentingViewController.navigationController popViewControllerAnimated:NO];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    searchResults = [NSMutableArray array];
    if (textField.text.length > 0) {
        NSString *params = [NSString stringWithFormat:@"term=%@", self.bar.text];
        [[[PostRequest alloc] init] exec:@"user_searches/set" params:params delegate:self callback:@selector(searchRegistered:)];
        [[[PostRequest alloc] init] exec:@"venues/get" params:params delegate:self callback:@selector(postResponse:)];
        [textField resignFirstResponder];
        [self.searchResultsView show];
        [self toggleCancelButton:true];
    }
    return YES;
}

- (void)searchRegistered:(id)response {
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self toggleCancelButton:true];
    return YES;
}

- (IBAction)cancelButtonTapped:(id)sender {
    self.bar.text = @"";
    [self.bar resignFirstResponder];
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
