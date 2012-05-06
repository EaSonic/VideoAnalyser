//
//  VideoAnalyserViewController.h
//  VideoAnalyser
//
//  Created by Zhao Yisheng on 12-5-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import "VideoAnalyzerView.h"

@interface VideoAnalyserViewController : NSViewController 
                                         <
                                          AVCaptureVideoDataOutputSampleBufferDelegate,
                                          AVCaptureFileOutputDelegate,
                                          AVCaptureFileOutputRecordingDelegate
                                         >

// I did not put any properity due to the fact that they are private, and they are decalared in the .mm file

@end
