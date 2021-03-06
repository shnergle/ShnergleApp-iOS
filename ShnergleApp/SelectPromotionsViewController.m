//
//  SelectPromotionsViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 24/07/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "SelectPromotionsViewController.h"
#import "Request.h"
#import <Toast+UIView.h>

@implementation SelectPromotionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!(appDelegate.venueStatus == Staff && [appDelegate.activeVenue[@"promo_perm"] integerValue] == 0)) [self setRightBarButton:@"New" actionSelector:@selector(addPromotion)];

    promotions = [NSMutableArray array];
    [self.view makeToastActivity];
    self.navigationItem.title = @"Manage Promotions";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [Request post:@"promotions/get" params:@{@"venue_id": appDelegate.activeVenue[@"id"], @"getall": @"true"} callback:^(id response) {
        promotions = [NSMutableArray arrayWithArray:response];
        [self.tableView reloadData];
        [self.view hideToastActivity];
    }];
    appDelegate.activePromotion = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.backgroundColor = [UIColor colorWithRed:233/255. green:235/255. blue:240/255. alpha:1];

    UIImageView *promotionTicketView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 311.0, 67.5)];
    promotionTicketView.image = [UIImage imageNamed:@"promotion"];
    [cell addSubview:promotionTicketView];
    UILabel *promoTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 311.0, 10)];
    UILabel *promoContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 311.0, 20)];
    UILabel *promoCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 311.0, 10)];
    [cell addSubview:promoTitleLabel];
    [cell addSubview:promoContentLabel];
    [cell addSubview:promoCountLabel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setPromoContentTo:promotions[indexPath.row][@"description"] promoHeadline:promotions[indexPath.row][@"title"] promoExpiry:(([promotions[indexPath.row][@"maximum"] integerValue] == 0 || promotions[indexPath.row][@"maximum"] == nil) ? [NSString stringWithFormat:@"%@ claimed", promotions[indexPath.row][@"redemptions"]] : [NSString stringWithFormat:@"%@/%@ claimed", promotions[indexPath.row][@"redemptions"], promotions[indexPath.row][@"maximum"]]) promoTitleLabel:promoTitleLabel promoContentLabel:promoContentLabel promoCountLabel:promoCountLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    appDelegate.activePromotion = promotions[indexPath.row];
    [self addPromotion];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67.5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [promotions count];
}

- (void)setPromoContentTo:(NSString *)promoContent promoHeadline:(NSString *)promoHeadline promoExpiry:(NSString *)promoExpiry promoTitleLabel:(UILabel *)promoTitleLabel promoContentLabel:(UILabel *)promoContentLabel promoCountLabel:(UILabel *)promoCountLabel {
    promoCountLabel.text = promoExpiry;
    promoCountLabel.font = [UIFont systemFontOfSize:8];
    promoCountLabel.textAlignment = NSTextAlignmentCenter;
    promoCountLabel.textColor = [UIColor whiteColor];
    promoCountLabel.backgroundColor = [UIColor clearColor];
    promoTitleLabel.text = promoHeadline;
    promoTitleLabel.font = [UIFont systemFontOfSize:10];
    promoTitleLabel.textAlignment = NSTextAlignmentCenter;
    promoTitleLabel.textColor = [UIColor whiteColor];
    promoTitleLabel.backgroundColor = [UIColor clearColor];
    promoContentLabel.text = promoContent;
    promoContentLabel.font = [UIFont systemFontOfSize:21];
    promoContentLabel.textColor = [UIColor whiteColor];
    promoContentLabel.textAlignment = NSTextAlignmentCenter;
    promoContentLabel.backgroundColor = [UIColor clearColor];
}

- (void)setRightBarButton:(NSString *)title actionSelector:(SEL)actionSelector {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.rightBarButtonItem.title = title;
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = actionSelector;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [UIColor blackColor],
       NSFontAttributeName: [UIFont systemFontOfSize:14.0]}
                                                          forState:UIControlStateNormal];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.view makeToastActivity];
        [Request post:@"promotions/set" params:@{@"promotion_id": promotions[indexPath.row][@"id"], @"delete": @"true"} callback:^(id response) {
            [self.view hideToastActivity];
            if (response) {
                [promotions removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Error Deleting promotion" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
    }
}

- (void)addPromotion {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPromotionsViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
