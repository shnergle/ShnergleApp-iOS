//
//  ScoreViewController.h
//  ShnergleApp
//
//  Created by Harshita Balaga on 15/07/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"

@interface ScoreViewController : CustomBackViewController

@property (weak, nonatomic) IBOutlet UILabel *youShare;
@property (weak, nonatomic) IBOutlet UILabel *valueShare;
@property (weak, nonatomic) IBOutlet UILabel *scoreShare;

@property (weak, nonatomic) IBOutlet UILabel *youCheckIn;
@property (weak, nonatomic) IBOutlet UILabel *valueCheckIn;
@property (weak, nonatomic) IBOutlet UILabel *scoreCheckIn;

@property (weak, nonatomic) IBOutlet UILabel *youRSVP;
@property (weak, nonatomic) IBOutlet UILabel *valueRSVP;
@property (weak, nonatomic) IBOutlet UILabel *scoreRSVP;

@property (weak, nonatomic) IBOutlet UILabel *youLike;
@property (weak, nonatomic) IBOutlet UILabel *valueLike;
@property (weak, nonatomic) IBOutlet UILabel *scoreLike;

@property (weak, nonatomic) IBOutlet UILabel *totalShnergleScore;

@end
