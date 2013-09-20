//
//  CrowdItem.h
//  ShnergleApp
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

@interface CrowdItem : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *crowdImage;
@property (weak, nonatomic) IBOutlet UILabel *venueName;
@property (weak, nonatomic) IBOutlet UIImageView *promotionIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *followingIndicator;
@property (nonatomic) int index;
@end
