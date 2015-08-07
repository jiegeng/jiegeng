//
//  View.m
//  AlarmClock
//
//  Created by MS on 15-8-6.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "View.h"

@implementation View

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(instancetype)viewWithFrame:(CGRect)frame andColor:(UIColor *)color
{
    UIView *view = [[UIView alloc] init];
    view.frame = frame;
    view.backgroundColor = color;
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
