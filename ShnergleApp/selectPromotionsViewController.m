//
//  selectPromotionsViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 24/07/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "selectPromotionsViewController.h"

@interface selectPromotionsViewController ()

@end

@implementation selectPromotionsViewController

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
    tableData = [NSMutableArray arrayWithArray:@[@"One",@"Two",@"Three"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    UIImage *img = [UIImage imageNamed:@"promotion.png"];
    UIImageView *promotionTicketView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 311.0, 67.5)];
    promotionTicketView.image = img;
    [cell addSubview:promotionTicketView];
    UILabel *promoTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 311.0, 10)];
    UILabel *promoContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 311.0, 20)];
    UILabel *promoCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 311.0, 10)];
    [cell addSubview:promoTitleLabel];
    [cell addSubview:promoContentLabel];
    [cell addSubview:promoCountLabel];
    [self setPromoContentTo:@"Content" promoHeadline:@"Headline" promoExpiry:@"5/5 Claimed" promoTitleLabel:promoTitleLabel promoContentLabel:promoContentLabel promoCountLabel:promoCountLabel];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67.5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (void)setPromoContentTo:(NSString *)promoContent promoHeadline:(NSString *)promoHeadline promoExpiry:(NSString *)promoExpiry promoTitleLabel:(UILabel *)promoTitleLabel promoContentLabel:(UILabel *)promoContentLabel promoCountLabel:(UILabel *)promoCountLabel
{
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


@end
