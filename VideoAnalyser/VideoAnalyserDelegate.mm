//
//  VideoAnalyserAppDelegate.m
//  VideoAnalyser
//
//  Created by Zhao Yisheng on 12-5-4.
//  Copyright (c) 2012年 Eason_Zhao. All rights reserved.
//

#import "VideoAnalyserDelegate.h"

#import "VideoAnalyserViewController.h"

// Interface: The private property of the Controller
@interface VideoAnalyserDelegate()

@property (nonatomic, strong) VideoAnalyserViewController *mainViewController_;

@end


/*-----------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------*/

// Implementation: To control the IB
@implementation VideoAnalyserDelegate

// Set the getter to avoid rename
@synthesize mainViewController_ = _mainViewController_;

/*-----------------------------------------------------------------------------------------------------*/

// Show that if the app is finished launching
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //Show that the delegate is successuflly launched
    self.mainViewController_ = [[VideoAnalyserViewController alloc]
                                initWithNibName:@"VideoAnalyser"
                                         bundle:nil];
    NSLog(@"Program Launch Successfully!");
}
/*-----------------------------------------------------------------------------------------------------*/

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "Eason.Iris.VideoAnalyser" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager   = [NSFileManager defaultManager];
    NSURL         *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory
                                                        inDomains:NSUserDomainMask] lastObject];
    
    return [appSupportURL URLByAppendingPathComponent:@"Eason.Iris.VideoAnalyser"];
}
/*-----------------------------------------------------------------------------------------------------*/



@end
