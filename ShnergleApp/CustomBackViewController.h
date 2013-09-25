//
//  CustomBackViewController.h
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 06/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

@interface CustomBackViewController : UIViewController <UIGestureRecognizerDelegate>

- (void)setRightBarButton:(NSString *)title actionSelector:(SEL)actionSelector;

@end
