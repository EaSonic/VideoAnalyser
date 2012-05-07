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


- (void)awakeFromNib
{
    [self init];
    CALayer *previewViewLayer = [self.videoAnalyserview_ layer];
	[previewViewLayer setBackgroundColor:CGColorGetConstantColor(kCGColorBlack)];
	AVCaptureVideoPreviewLayer *newPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession_];
	[newPreviewLayer setFrame:[previewViewLayer bounds]];
	[newPreviewLayer setAutoresizingMask:kCALayerWidthSizable | kCALayerHeightSizable];
	[previewViewLayer addSublayer:newPreviewLayer];
	self.videoPreview_ = newPreviewLayer;
	
	
	// Start the session
	[self.captureSession_ startRunning];
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
    [self.videoStore_ startRecordingToOutputFileURL:nil 
                                  recordingDelegate:self];
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



