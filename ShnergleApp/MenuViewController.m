//
//  MenuViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 11/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "MenuViewController.h"
#import "Request.h"
#import "VenueViewController.h"
#import <MapKit/MapKit.h>

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *searchBar = [[NSBundle mainBundle] loadNibNamed:@"SearchBar" owner:self options:nil][0];
    searchBar.frame = CGRectOffset(searchBar.frame, 0, 20);
    [self.view addSubview:searchBar];

    tableSections = @[@"Profile", @"Explore", @" "];
    tableData = @[@[appDelegate.fullName], @[@"Around Me", @"Following", @"Promotions", @"Quiet", @"Trending", @"+ Add Place"], @[@"Account Settings", @"FAQ", @"Help", @"Privacy Policy", @"Terms of Use"]];
    searchResults = [NSMutableArray array];
    searchResultsLocation = [NSMutableArray array];
    self.searchResultsView.resultsTableView.delegate = self;
    self.searchResultsView.resultsTableView.dataSource = self;

    [self initsearchResultsView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)initsearchResultsView {
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchResultsView" owner:self options:nil];
    self.searchResultsView = nibObjects[0];

    self.searchResultsView.frame = CGRectMake(320, 45, 320, self.view.frame.size.height - 45);
    [[self view] addSubview:self.searchResultsView];
    self.cancelButton.alpha = 0;
}

- (void)postResponse:(id)response {
    @synchronized(self) {
        if ([response isKindOfClass:[NSArray class]]) {
            for (id obj in response) {
                if ([obj count] > 1) [searchResults addObject:obj];
            }
        }

        [self.searchResultsView.resultsTableView reloadData];
    }
}

- (void)postResponseLocation:(id)response {
    @synchronized(self) {
        if ([response isKindOfClass:[NSArray class]]) {
            for (id obj in response) {
                if ([obj count] > 1) [searchResultsLocation addObject:obj];
            }
        }

        [self.searchResultsView.resultsTableView reloadData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.menuItemsTableView) {
        UITableViewCell *cell;
        if (indexPath.section == 0 && indexPath.row != 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"MyCellVenue"];
            cell.textLabel.text = appDelegate.ownVenues[indexPath.row - 1][@"name"];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"MyCell%ld%ld", (long)indexPath.section, (long)indexPath.item]];
            cell.textLabel.text = tableData[indexPath.section][indexPath.row];
        }
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profileicon"]];
            cell.accessoryView.bounds = CGRectMake(0, 0, 27, 19);
            profileCell = cell;
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ResultCell"];
        }
        cell.textLabel.text = (indexPath.section == 0 ? searchResults : searchResultsLocation)[indexPath.row][@"name"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchResultsView.resultsTableView) {
        return section == 0 ? [searchResults count] : [searchResultsLocation count];
    } else {
        if (section != 0) return [tableData[section] count];
        else return [tableData[section] count] + [appDelegate.ownVenues count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchResultsView.resultsTableView) {
        return 2;
    } else {
        return [tableData count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchResultsView.resultsTableView) {
        return section == 0 ? @"Name Matches" : @"Location Matches";
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
        if (indexPath.section == 0) appDelegate.activeVenue = searchResults[indexPath.row];
        else appDelegate.activeVenue = searchResultsLocation[indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.section == 0 && indexPath.row != 0) {
        appDelegate.activeVenue = appDelegate.ownVenues[indexPath.row - 1];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[VenueViewController class]]) [((VenueViewController *)[segue destinationViewController])setVenueInfo];
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
    searchResultsLocation = [NSMutableArray array];
    if (textField.text.length > 0) {
        NSDictionary *params = @{@"term": self.bar.text,
                                 @"level": appDelegate.level};
        [Request post:@"user_searches/set" params:params delegate:self callback:@selector(searchRegistered:)];
        [Request post:@"venues/get" params:params delegate:self callback:@selector(postResponse:)];
        [[[CLGeocoder alloc] init] geocodeAddressString:self.bar.text completionHandler:^(NSArray *placemarks, NSError *error) {
            if (!error) {
                MKCoordinateRegion rgn = MKCoordinateRegionMakeWithDistance(((CLPlacemark *)placemarks[0]).location.coordinate, 2000, 2000);
                double distanceInDegrees = sqrt(pow(rgn.span.latitudeDelta, 2) + pow(rgn.span.longitudeDelta, 2));
                NSDictionary *params = @{@"my_lat": @(((CLPlacemark *)placemarks[0]).location.coordinate.latitude),
                                         @"my_lon": @(((CLPlacemark *)placemarks[0]).location.coordinate.longitude),
                                         @"distance": @(distanceInDegrees),
                                         @"level": appDelegate.level};
                [Request post:@"venues/get" params:params delegate:self callback:@selector(postResponseLocation:)];
            }
        }];
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
