//
//  VideoAnalyserViewController.m
//  VideoAnalyser
//
//  Created by Zhao Yisheng on 12-5-5.
//  Copyright (c) 2012年 Eason_Zhao. All rights reserved.
//

#import "VideoAnalyserViewController.h"

#pragma mark -
#pragma mark private property/method of VideoAnalyserController

@interface VideoAnalyserViewController ()

#pragma mark -
#pragma mark MainWindowControl
// Main Application View
@property (atomic, retain)  IBOutlet NSWindow          *mainAppWindow_;
@property (nonatomic, weak) IBOutlet VideoAnalyzerView *videoAnalyserview_;
    // Main Application Control Handle
- (IBAction)   recordVideo_: (NSButton *)      sender;
- (IBAction)    stopRecord_: (NSButton *)      sender;
- (IBAction)switchVAMethods: (NSPopUpButton *) sender;


@end


#pragma mark -
#pragma mark implementation of VideoAnalyserController
@implementation VideoAnalyserViewController

#pragma mark -
#pragma mark synthesize of property

// Synthesize Property to make sure they are not renamed
@synthesize mainAppWindow_     = _mainAppWindow_;
@synthesize videoAnalyserview_ = _videoAnalyserview_;


#pragma mark -
#pragma mark Init of the App
// Initilize the Nib
- (NSString *) nibName
{
    return @"VideoAnalyzer";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"VideoAnalyzer" bundle:nibBundleOrNil];
    if (self) 
        {
            NSLog(@"Initialize Successfully!");
        }
    
    return self;
}


#pragma mark -
#pragma mark Control Part
- (IBAction)recordVideo_:(NSButton *)sender 
{
    
}

- (IBAction)stopRecord_:(NSButton *)sender 
{
    
}

- (IBAction)switchVAMethods:(NSPopUpButton *)sender 
{
    
}
@end
