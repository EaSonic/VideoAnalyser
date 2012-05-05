//
//  NSImage+OpenCV.h
//  VideoAnalyser
//
//  Created by Zhao Yisheng on 12-5-5.
//  Copyright (c) 2012年 Eason_Zhao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (OpenCV)

+(NSImage *)imageWithCVMat:(const cv::Mat&)cvMat;
-(id)initWithCVMat:(const cv::Mat&)cvMat;

@property(nonatomic, readonly) CGImageRef CGImage;
@property(nonatomic, readonly) cv::Mat    CVMat;
@property(nonatomic, readonly) cv::Mat    CVGrayscaleMat;

@end
