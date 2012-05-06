//
//  NSImage+OpenCV.m
//  VideoAnalyser
//
//  Created by Zhao Yisheng on 12-5-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSImage+OpenCV.h"


static void ProviderReleaseDataNOP(void *info, const void *data, size_t size)
{
    // Do not release memory
    return;
}



@implementation NSImage (OpenCV)

-(CGImageRef) CGImage
{
    NSData           *cocoaData     = [NSBitmapImageRep TIFFRepresentationOfImageRepsInArray: [self representations]];
    CFDataRef        carbonData     = (__bridge_retained CFDataRef)cocoaData;
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData(carbonData, NULL);
    CGImageRef       out            = CGImageSourceCreateImageAtIndex(imageSourceRef, 0, NULL);
    CFRelease(imageSourceRef);
    return out;
}

-(cv::Mat)CVMat
{
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(self.CGImage);
    CGFloat         cols       = self.size.width;
    CGFloat         rows       = self.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef    contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
                                                    cols,                      // Width of bitmap
                                                    rows,                     // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

-(cv::Mat)CVGrayscaleMat
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGFloat         cols       = self.size.width;
    CGFloat         rows       = self.size.height;
    
    cv::Mat         cvMat      = cv::Mat(rows, cols, CV_8UC1); // 8 bits per component, 1 channel
    
    CGContextRef    contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
                                                    cols,                      // Width of bitmap
                                                    rows,                     // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNone |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}

+ (NSImage *)imageWithCVMat:(const cv::Mat&)cvMat
{
    return [[NSImage alloc] initWithCVMat:cvMat];
}

- (id)initWithCVMat:(const cv::Mat&)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
    NSSize imageRefSize;
    
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1)
        {
            colorSpace = CGColorSpaceCreateDeviceGray();
        }
    else
        {
            colorSpace = CGColorSpaceCreateDeviceRGB();
        }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    CGImageRef        imageRef = CGImageCreate(cvMat.cols,                                     // Width
                                        cvMat.rows,                                     // Height
                                        8,                                              // Bits per component
                                        8 * cvMat.elemSize(),                           // Bits per pixel
                                        cvMat.step[0],                                  // Bytes per row
                                        colorSpace,                                     // Colorspace
                                        kCGImageAlphaNone | kCGBitmapByteOrderDefault,  // Bitmap info flags
                                        provider,                                       // CGDataProviderRef
                                        NULL,                                           // Decode
                                        false,                                          // Should interpolate
                                        kCGRenderingIntentDefault);                     // Intent   
    
    imageRefSize.width         = cvMat.cols;
    imageRefSize.height        = cvMat.rows;

    self                       = [self initWithCGImage:imageRef size:imageRefSize];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return self;
}



@end

