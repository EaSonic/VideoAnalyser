//
//  VideoAnalyzerView.m
//  VideoAnalyser
//
//  Created by Zhao Yisheng on 12-5-5.
//  Copyright (c) 2012年 Eason_Zhao. All rights reserved.
//

#import "VideoAnalyzerView.h"

@implementation VideoAnalyzerView

@synthesize center = center_;

- (CGPoint) center
{
    center_ = CGPointMake((self.frame.origin.x + (self.frame.size.width / 2)),
                          (self.frame.origin.y + (self.frame.size.height / 2))
                          );
    return center_;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
        {
            // Initialization code here.
        }
    
    return self;
} 

@end
