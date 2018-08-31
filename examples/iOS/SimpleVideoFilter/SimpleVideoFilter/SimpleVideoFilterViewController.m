#import "SimpleVideoFilterViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>


@interface SimpleVideoFilterViewController()

@property (nonatomic,strong) GPUImageMovie *movie;
@end

@implementation SimpleVideoFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
//    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
//    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
//    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1920x1080 cameraPosition:AVCaptureDevicePositionBack];
    [videoCamera addAudioInputsAndOutputs];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    videoCamera.horizontallyMirrorFrontFacingCamera = YES;
//    videoCamera.horizontallyMirrorRearFacingCamera = NO;

    [videoCamera startCameraCapture];
    
    filter = [[GPUImageSepiaFilter alloc] init];
    filter1 = [[GPUImageMirrorFilter alloc] init];
    
    GPUImageSplitScreenFilter *splitScreenFilter = [[GPUImageSplitScreenFilter alloc] init];
    splitScreenFilter.ratio = 0.8;
    [videoCamera addTarget:splitScreenFilter];
    
    GPUImageView *filterView = (GPUImageView *)self.view;

    [splitScreenFilter addTarget:filterView];
    
    return;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"57436" withExtension:@"mp4"];
    GPUImageMovie *movie = [[GPUImageMovie alloc] initWithURL:url];
    movie.shouldRepeat = YES;
    movie.playAtActualSpeed = YES;
//    [movie addTarget:group];
    
    [movie startProcessing];
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"57436" withExtension:@"mp4"];
    GPUImageMovie *movie1 = [[GPUImageMovie alloc] initWithURL:url1];
    movie1.shouldRepeat = YES;
    movie1.playAtActualSpeed = YES;
//    [movie1 addTarget:group];
    
    [movie1 startProcessing];
    
    self.movie = movie;
    
//    [group addTarget:filterView];
    
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
    movieWriter.encodingLiveVideo = YES;
//    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640.0, 480.0)];
//    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(720.0, 1280.0)];
//    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(1080.0, 1920.0)];
    [filter1 addTarget:movieWriter];
    [filter1 addTarget:filterView];
    
    /**/
    double delayToStartRecording = 5;
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, delayToStartRecording * NSEC_PER_SEC);
    dispatch_after(startTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"Start recording");
        
        videoCamera.audioEncodingTarget = movieWriter;
        
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
            [movieWriter startRecording];
//        });

//        NSError *error = nil;
//        if (![videoCamera.inputCamera lockForConfiguration:&error])
//        {
//            NSLog(@"Error locking for configuration: %@", error);
//        }
//        [videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOn];
//        [videoCamera.inputCamera unlockForConfiguration];

        
        double delayInSeconds = 30;
        dispatch_time_t stopTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(stopTime, dispatch_get_main_queue(), ^(void){
            
            [filter1 removeTarget:movieWriter];
            videoCamera.audioEncodingTarget = nil;
            [movieWriter finishRecording];
            NSLog(@"Movie completed");
            /*
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:movieURL])
            {
                [library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:^(NSURL *assetURL, NSError *error)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         if (error) {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                             [alert show];
                         } else {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                                            delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                             [alert show];
                         }
                     });
                 }];
            }*/
            
//            [videoCamera.inputCamera lockForConfiguration:nil];
//            [videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOff];
//            [videoCamera.inputCamera unlockForConfiguration];
        });
    });
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // Map UIDeviceOrientation to UIInterfaceOrientation.
    UIInterfaceOrientation orient = UIInterfaceOrientationPortrait;
    switch ([[UIDevice currentDevice] orientation])
    {
        case UIDeviceOrientationLandscapeLeft:
            orient = UIInterfaceOrientationLandscapeLeft;
            break;

        case UIDeviceOrientationLandscapeRight:
            orient = UIInterfaceOrientationLandscapeRight;
            break;

        case UIDeviceOrientationPortrait:
            orient = UIInterfaceOrientationPortrait;
            break;

        case UIDeviceOrientationPortraitUpsideDown:
            orient = UIInterfaceOrientationPortraitUpsideDown;
            break;

        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationUnknown:
            // When in doubt, stay the same.
            orient = fromInterfaceOrientation;
            break;
    }
    videoCamera.outputImageOrientation = orient;

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.movie.paused = !self.movie.isPaused;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES; // Support all orientations.
}

- (IBAction)updateSliderValue:(id)sender
{
    [(GPUImageSepiaFilter *)filter setIntensity:[(UISlider *)sender value]];
}

@end
