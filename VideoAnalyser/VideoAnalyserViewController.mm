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

#pragma mark -
#pragma mark MainWindowControl
// Property that used to do VideoCapture&Preview&Store
    // For capture session
    @property (nonatomic, strong) AVCaptureSession              *captureSession_;
    // For capture device
    @property (nonatomic, strong) AVCaptureDevice               *videoDevice_;
    @property (nonatomic, strong) AVCaptureDeviceInput          *videoInput_;
    /*Add audio device if needed*/
    // For preview
    @property (nonatomic, strong) AVCaptureVideoPreviewLayer    *videoPreview_;
    /*Add audio device if needed*/
    // For storing
    @property (nonatomic, strong) AVCaptureMovieFileOutput      *videoStore_;

// Property used to do Video Analysis
@property (nonatomic, strong) AVCaptureVideoDataOutput  *toBProcessedFrame_;

// Supporting Property
@property (nonatomic, strong) CIContext                 *pixelContext_;

@property (nonatomic, strong) CIDetector                *faceDetector_;
@property (nonatomic, strong) VideoAnalyzerView         *glasses_;

@end


#pragma mark -
#pragma mark implementation of VideoAnalyserController
@implementation VideoAnalyserViewController

#pragma mark -
#pragma mark synthesize of property

// Synthesize Property to make sure they are not renamed
@synthesize mainAppWindow_        = _mainAppWindow_;
@synthesize videoAnalyserview_    = _videoAnalyserview_;
@synthesize captureSession_       = _captureSession_;
@synthesize videoDevice_          = _videoDevice_;
@synthesize videoInput_           = _videoInput_;
@synthesize videoPreview_         = _videoPreview_;
@synthesize videoStore_           = _videoStore_;
@synthesize toBProcessedFrame_    = _toBProcessedFrame_;
@synthesize pixelContext_         = _pixelContext_;

@synthesize faceDetector_         = _faceDetector_;
@synthesize glasses_              = _glasses_;

- (CIDetector *)faceDetector_
{
    if (!_faceDetector_) 
        {
            NSDictionary *detectorOptions = [
                                             NSDictionary dictionaryWithObjectsAndKeys:
                                             CIDetectorAccuracyLow, CIDetectorAccuracy, nil
                                             ];
            _faceDetector_ = [CIDetector detectorOfType:CIDetectorTypeFace
                                                context:nil
                                                options:detectorOptions];
        }
    return _faceDetector_;
}
- (VideoAnalyzerView *)glasses_
{
    _glasses_ = [VideoAnalyzerView new];
    [_glasses_ setWantsLayer:YES];
    return _glasses_;
}

#pragma mark -
#pragma mark Init of the App
// Initilize the Nib

- (id)init
{
    self = [super init];
    if (self) 
        {
            NSLog(@"init Successfully!");
            // Create a capture session
            self.captureSession_                    = [[AVCaptureSession alloc] init];
            self.captureSession_.sessionPreset      = AVCaptureSessionPreset320x240;
            
            // Get a device
            self.videoDevice_                       = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            self.videoInput_                        = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice_
                                                                                       error:nil];
            
            // Attach output to session
            self.videoStore_                        = [[AVCaptureMovieFileOutput alloc] init];
            [self.videoStore_ setDelegate:self];
            
            
            // Set to be processed frame == current frame
            self.toBProcessedFrame_                 = [[AVCaptureVideoDataOutput alloc] init];
            self.toBProcessedFrame_.videoSettings   = 
                [NSDictionary dictionaryWithObject:[
                                                    NSNumber numberWithInt:kCVPixelFormatType_32BGRA] 
                                            forKey:(id)kCVPixelBufferPixelFormatTypeKey
                                                    ];
            /*[self.toBProcessedFrame_ setSampleBufferDelegate:self 
                                                       queue:dispatch_get_main_queue()];*/
            
            // Add the stuff to the session
            [self.captureSession_  addInput:self.videoInput_];
            [self.captureSession_ addOutput:self.videoStore_];
            [self.captureSession_ addOutput:self.toBProcessedFrame_];
            
            //self.glasses_ = [[VideoAnalyzerView alloc] initWithImage:@"glasses.png"];
        }
    return self;
}

- (NSString *) nibName
{
    return @"VideoAnalyzer";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"VideoAnalyzer" bundle:nil];
    if (self) 
        {
            NSLog(@"Initialize Successfully!");
        }
    
    return self;
}


- (void)windowWillClose:(NSNotification *)notification
{
    NSLog(@"CloseWin~");
}

- (CIContext *) pixelContext_
{
    if(!_pixelContext_)
        {
            _pixelContext_ = [CIContext contextWithCGContext:nil options:nil];
        }
    return _pixelContext_;
}

#pragma mark -
#pragma mark Processing Frame starts here
- (void)awakeFromNib
{
    // init all the AVCapture stuff
    [self init];
    
    CALayer *previewViewLayer = [self.videoAnalyserview_ layer];
	[previewViewLayer setBackgroundColor:CGColorGetConstantColor(kCGColorBlack)];
    
	AVCaptureVideoPreviewLayer *basePreviewLayer = [
                                                   [AVCaptureVideoPreviewLayer alloc] 
                                                   initWithSession:self.captureSession_
                                                   ];
	[basePreviewLayer            setFrame:[previewViewLayer bounds]                   ];
	[basePreviewLayer setAutoresizingMask:kCALayerWidthSizable | kCALayerHeightSizable];
	[previewViewLayer         addSublayer:basePreviewLayer                            ];
	
    self.videoPreview_ = basePreviewLayer;
	
	
	// Start the session
	[self.captureSession_ startRunning];
}


- (void)captureOutput:(AVCaptureOutput *)    captureOutput 
didOutputSampleBuffer:(CMSampleBufferRef)    sampleBuffer 
       fromConnection:(AVCaptureConnection *)connection
{
    
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer   (sampleBuffer);
    OSType                format = CVPixelBufferGetPixelFormatType(pixelBuffer);
    CGRect             videoRect = CGRectMake(
                                              0.0f, 0.0f, 
                                              CVPixelBufferGetWidth(pixelBuffer), 
                                              CVPixelBufferGetHeight(pixelBuffer)
                                              );
    CIImage   *toBProcessedimgbf = [CIImage imageWithCVImageBuffer:pixelBuffer];
        
    NSArray *features = [self.faceDetector_ featuresInImage:toBProcessedimgbf];
    
    bool faceFound = false;
    
    for (CIFaceFeature *face in features) 
    {
        if (face.hasLeftEyePosition && face.hasRightEyePosition) 
        {
            CGPoint eyeCenter = CGPointMake(face.leftEyePosition.x*0.5+face.rightEyePosition.x*0.5, 
                                            face.leftEyePosition.y*0.5+face.rightEyePosition.y*0.5);
            
            // Set the glasses position based on mouth position
            double scalex = self.videoAnalyserview_.bounds.size.height/toBProcessedimgbf.extent.size.width;
            double scaley = self.videoAnalyserview_.bounds.size.width/toBProcessedimgbf.extent.size.height;
            self.glasses_.center = CGPointMake(scaley*eyeCenter.y-self.glasses_.bounds.size.height/4.0,
                                               scalex*(eyeCenter.x));
            
            // Set the angle of the glasses using eye deltas
            double deltax = face.leftEyePosition.x-face.rightEyePosition.x;
            double deltay = face.leftEyePosition.y-face.rightEyePosition.y;
            double angle  = atan2(deltax, deltay);
            //self.glasses_.transform = CGAffineTransformMakeRotation(angle+M_PI);
            
            //NSImage *img = [[NSImage alloc] initWithContentsOfFile:@"glasses.png"];
            
            // Set size based on distance between the two eyes:
            double scale = 3.0*sqrt(deltax*deltax+deltay*deltay);
            self.glasses_.bounds = CGRectMake(0, 0, scale, scale);
            faceFound = true;
        }
    }
   
    
    
    
    CGImageRef processingImgRef  = [
                                    self.pixelContext_ 
                                    createCGImage:toBProcessedimgbf 
                                         fromRect:toBProcessedimgbf.extent
                                    ];

    
    // For OpenCV to do the processing~
    if (format == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) 
        {
            // For grayscale mode, the luminance channel of the YUV data is used
            CVPixelBufferLockBaseAddress(pixelBuffer, 0);
            void *baseaddress = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
        
            cv::Mat mat(videoRect.size.height, videoRect.size.width, CV_8UC1, baseaddress, 0);
        
        
            CVPixelBufferUnlockBaseAddress(pixelBuffer, 0); 
        }
    else
        if (format == kCVPixelFormatType_32BGRA) 
        {
            // For color mode a 4-channel cv::Mat is created from the BGRA data
            CVPixelBufferLockBaseAddress(pixelBuffer, 0);
            void *baseaddress = CVPixelBufferGetBaseAddress(pixelBuffer);
        
            cv::Mat mat(videoRect.size.height, videoRect.size.width, CV_8UC4, baseaddress, 0);
        
        
            CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);    
        }
    else{
            NSLog(@"Unsupported video format");
        }

}

#pragma mark -
#pragma mark Control Part
- (IBAction)recordVideo_:(NSButton *)sender 
{
    NSLog(@"Recording");
    [
     self.videoStore_ startRecordingToOutputFileURL:[
                                                     NSURL fileURLWithPath:
                                                     @"/Users/apple/Documents/NFS_Share_Poly_Server/My Recorded Movie.mov"
                                                     ]
                                  recordingDelegate:self
     ];
}

- (IBAction)stopRecord_:(NSButton *)sender 
{
    NSLog(@"Stop");
    [self.videoStore_ stopRecording];
}

- (IBAction)switchVAMethods:(NSPopUpButton *)sender 
{
    NSLog(@"Switching");
}


#pragma mark -
#pragma mark AVCaptureFileOutputDelegate,AVCaptureFileOutputRecordingDelegate Part
// Open QuickTime to play recorded Frame
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)recordError
{
    [[NSWorkspace sharedWorkspace] openURL:outputFileURL];
}

@end



