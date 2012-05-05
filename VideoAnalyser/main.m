//
//  main.m
//  VideoAnalyser
//
//  Created by Zhao Yisheng on 12-5-4.
//  Copyright (c) 2012年 __Eason_Zhao__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VideoAnalyserDelegate.h"

int main(int argc, char *argv[])
{
    //Test if the app is loaded successfully or not.
    if( NSApplicationLoad() )
        {
            NSLog(@"App Load Successfully!");
            return NSApplicationMain(argc, (const char **)argv);
        }
    else 
        {
            NSLog(@"Load Failed!");
            return -1;
        }
}
