//
//  overlayText.m
//  Consumer App
//
//  Created by Stian Johansen on 3/28/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "overlayText.h"

@implementation overlayText
{
    NSInteger minimisedHeight;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.frame = CGRectMake(self.frame.origin.x, 200, self.frame.size.width, self.frame.size.height);
}


- (IBAction)swipeDown:(id)sender {
    //if the box is already swiped down, ignore
    if(self.frame.origin.y > 200){
        
    }else if(self.frame.origin.y < 200){
        self.frame = CGRectMake(self.frame.origin.x, 200, self.frame.size.width, self.frame.size.height);
    }else{
        self.frame = CGRectMake(self.frame.origin.x, 390, self.frame.size.width, self.frame.size.height);
    }
}

- (IBAction)swipeUp:(id)sender {
    if(self.frame.origin.y > 200){
        self.frame = CGRectMake(self.frame.origin.x, 200, self.frame.size.width, self.frame.size.height);
    }else if(self.frame.origin.y <= 200){
        self.frame = CGRectMake(self.frame.origin.x, 50, self.frame.size.width, self.frame.size.height);
    }
}
@end
