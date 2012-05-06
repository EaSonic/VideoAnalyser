//
//  VideoAnalyserViewController.m
//  VideoAnalyser
//
//  Created by Zhao Yisheng on 12-5-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VideoAnalyserViewController.h"

@interface VideoAnalyserViewController ()

// Main Application View
@property (atomic, retain)  IBOutlet NSWindow          *mainAppWindow_;
@property (nonatomic, weak) IBOutlet VideoAnalyzerView *videoAnalyserview_;


@end

@implementation VideoAnalyserViewController

// Synthesize Property to make sure they are not renamed
@synthesize mainAppWindow_     = _mainAppWindow_;
@synthesize videoAnalyserview_ = _videoAnalyserview_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
        {
            // Initialization code here.
        }
    
    return self;
}

@end
