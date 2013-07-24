//
//  selectPromotionsViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 24/07/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "selectPromotionsViewController.h"
#import "PostRequest.h"
#import <Toast+UIView.h>

@implementation selectPromotionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightBarButton:@"New" actionSelector:@selector(addPromotion)];

    promotions = [NSMutableArray arrayWithArray:@[]];
    [self.view makeToastActivity];
    self.navigationItem.title = @"Manage Promotions";
    //reusing activepromotion from venue page.
    appDelegate.activePromotion = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [[[PostRequest alloc]init]exec:@"promotions/get" params:[NSString stringWithFormat:@"venue_id=%@&getall=true", appDelegate.activeVenue[@"id"]] delegate:self callback:@selector(didFinishGettingPromotions:)];
}

- (void)didFinishGettingPromotions:(NSArray *)response {
    promotions = [NSMutableArray arrayWithArray:response];
    [self.tableView reloadData];
    [self.view hideToastActivity];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];

    UIImage *img = [UIImage imageNamed:@"promotion.png"];
    UIImageView *promotionTicketView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 311.0, 67.5)];
    promotionTicketView.image = img;
    [cell addSubview:promotionTicketView];
    UILabel *promoTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 311.0, 10)];
    UILabel *promoContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 311.0, 20)];
    UILabel *promoCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 311.0, 10)];
    [cell addSubview:promoTitleLabel];
    [cell addSubview:promoContentLabel];
    [cell addSubview:promoCountLabel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setPromoContentTo:promotions[indexPath.row][@"description"] promoHeadline:promotions[indexPath.row][@"title"] promoExpiry:[NSString stringWithFormat:@"/%@ claimed", promotions[indexPath.row][@"maximum"] ] promoTitleLabel:promoTitleLabel promoContentLabel:promoContentLabel promoCountLabel:promoCountLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    appDelegate.activePromotion = promotions[indexPath.row];
    [self addPromotion];
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
     @{UITextAttributeTextColor: [UIColor blackColor],
       UITextAttributeTextShadowColor: [UIColor clearColor],
       UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
       UITextAttributeFont: [UIFont systemFontOfSize:14.0]}
                                                          forState:UIControlStateNormal];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        selectedIndexPath = indexPath;
        [self.view makeToastActivity];
        [[[PostRequest alloc]init]exec:@"promotions/set" params:[NSString stringWithFormat:@"delete=true&promotion_id=%@", promotions[indexPath.row][@"id"] ] delegate:self callback:@selector(didFinishDeletingPromotion:) type:@"string"];
    }
}

- (void)didFinishDeletingPromotion:(NSString *)response {
    [self.view hideToastActivity];

    if ([@"true" isEqualToString : response]) {
        [promotions removeObjectAtIndex:selectedIndexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error Deleting promotion" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)addPromotion {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPromotionsViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
