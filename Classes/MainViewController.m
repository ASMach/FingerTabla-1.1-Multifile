//
//  MainViewController.m
//  FingerTabla
//
//  Created by Alonzo Machiraju on 8/28/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"


@implementation MainViewController

@synthesize controller;
@synthesize playViewController;

@synthesize dhe;
@synthesize ga;
@synthesize ka;
@synthesize ki;
@synthesize na;
@synthesize naa;
@synthesize ta;
@synthesize thee;
@synthesize thi;
@synthesize thin;

@synthesize filenameField; 
@synthesize formatSegments;
@synthesize formatButton;
@synthesize currentTimeLabel;
@synthesize recordPauseButton; 
@synthesize stopButton;
@synthesize leftLevelLabel;
//@synthesize leftLevelMeter;
@synthesize rightLevelLabel;
//@synthesize rightLevelMeter;

#pragma mark helper methods

// returns _documentsPath, lazy-instantiating it if necessary
//START:code.RecordViewController.documentspath
- (NSString*) documentsPath {
	if (! _documentsPath) {
		NSArray *searchPaths =
		NSSearchPathForDirectoriesInDomains
		(NSDocumentDirectory, NSUserDomainMask, YES);
		_documentsPath = [searchPaths objectAtIndex: 0];
		[_documentsPath retain];
	}
	return _documentsPath;
}
//END:code.RecordViewController.documentspath


- (void) updateAudioDisplay {
	if (audioRecorder == nil) {
		currentTimeLabel.text = @"--:--";
	} else {
		double currentTime = audioRecorder.currentTime;
		currentTimeLabel.text = [NSString stringWithFormat: @"%02d:%02d",
								 (int) currentTime/60,
								 (int) currentTime%60];		
		//START:code.RecordViewController.setlevelmeters
		[audioRecorder updateMeters];
		
		/*
		[leftLevelMeter setPower: [audioRecorder averagePowerForChannel:0]
							peak: [audioRecorder peakPowerForChannel: 0]];
		if (! rightLevelMeter.hidden) {
			[rightLevelMeter setPower: [audioRecorder averagePowerForChannel:1]
								 peak: [audioRecorder peakPowerForChannel: 1]];
		}
		 */
		//END:code.RecordViewController.setlevelmeters
	}
}


// attempts to setup AVAudioRecorder from filename and settings
//START:code.RecordViewController.createavaudiorecorder.url
- (NSError*) createAVAudioRecorder {
	[audioRecorder release];
	audioRecorder = nil;
	
	NSString *destinationString = [[self documentsPath]
								   stringByAppendingPathComponent:filenameField.text];
	NSURL *destinationURL = [NSURL fileURLWithPath: destinationString];
	//END:code.RecordViewController.createavaudiorecorder.url
	
	//START:code.RecordViewController.createavaudiorecorder.pcmsettings
	NSMutableDictionary *recordSettings =
	[[NSMutableDictionary alloc] initWithCapacity:10];
	
	float sampleRate = 44100;
	int bitDepth = 16;
	
	if (formatSegments.selectedSegmentIndex == 0) {
		// Load settings from a set here.  Add components as needed
		
		[recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
		[recordSettings setObject:[NSNumber numberWithFloat:sampleRate] forKey: AVSampleRateKey];
		[recordSettings setValue: [NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
		[recordSettings setObject:[NSNumber numberWithInt:bitDepth] forKey:AVLinearPCMBitDepthKey];
		[recordSettings setObject:[NSNumber numberWithBool:YES] forKey:AVLinearPCMIsBigEndianKey];
		[recordSettings setObject:[NSNumber numberWithBool: YES] forKey:AVLinearPCMIsFloatKey];
	}
	//END:code.RecordViewController.createavaudiorecorder.pcmsettings
	//START:code.RecordViewController.createavaudiorecorder.encodingsettings
	else {
		// set these values from an NSDictionary
		NSNumber *formatObject = [NSNumber numberWithInt:ENCODED_FORMAT_ALAC];
		
		/*
		switch ([controller.formatSegments selectedSegmentIndex]) {
			case (ENCODED_FORMAT_AAC): 
				formatObject =
				[NSNumber numberWithInt: kAudioFormatMPEG4AAC];
				break;
			case (ENCODED_FORMAT_ALAC):
				formatObject =
				[NSNumber numberWithInt: kAudioFormatAppleLossless];
				break;
			case (ENCODED_FORMAT_IMA4):
				formatObject =
				[NSNumber numberWithInt: kAudioFormatAppleIMA4];
				break;
			case (ENCODED_FORMAT_ILBC):
				formatObject =
				[NSNumber numberWithInt: kAudioFormatiLBC];
				break;
			case (ENCODED_FORMAT_ULAW):
				formatObject =
				[NSNumber numberWithInt: kAudioFormatULaw];
				break;
			default:
				formatObject =
				[NSNumber numberWithInt: kAudioFormatLinearPCM];
		}
		 */
		
		
		[recordSettings setObject:formatObject forKey: AVFormatIDKey];
		[recordSettings setObject: [NSNumber numberWithFloat:sampleRate] forKey: AVSampleRateKey];
		[recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
		[recordSettings setObject:[NSNumber numberWithInt:bitDepth]forKey:AVEncoderBitRateKey];
		[recordSettings setObject:[NSNumber numberWithInt:bitDepth]forKey:AVEncoderBitDepthHintKey];
		int encoderQuality = AVAudioQualityMax;
		
		/*
		switch ([encodingSettingsViewController.qualitySegments
				 selectedSegmentIndex]) {
			case (0) : encoderQuality = AVAudioQualityMin; break;
			case (1) : encoderQuality = AVAudioQualityLow; break;
			case (2) : encoderQuality = AVAudioQualityMedium; break;
			case (3) : encoderQuality = AVAudioQualityHigh; break;
			case (4) : encoderQuality = AVAudioQualityMax; break;
		}
		 */
		
		
		[recordSettings setObject:[NSNumber numberWithInt: encoderQuality]forKey: AVEncoderAudioQualityKey];
	}
	//END:code.RecordViewController.createavaudiorecorder.encodingsettings
	
	//START:code.RecordViewController.createavaudiorecorder.init
	NSError *recorderSetupError = nil;
	audioRecorder = [[AVAudioRecorder alloc] initWithURL:destinationURL
												settings:recordSettings error:&recorderSetupError];	
	[recordSettings release];
	
	if (recorderSetupError) {
		UIAlertView *cantRecordAlert =
		[[UIAlertView alloc] initWithTitle: @"Can't record"
								   message: [recorderSetupError localizedDescription]
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
		[cantRecordAlert show];
		[cantRecordAlert release];
		return recorderSetupError;
	}
	[audioRecorder prepareToRecord];
	recordPauseButton.enabled = YES;
	audioRecorder.delegate = self;
	//END:code.RecordViewController.createavaudiorecorder.init
	
	// hide right level meter and change left to "M" if we're mono
	//START:code.RecordViewController.handlemono
	
	/*
	audioRecorder.meteringEnabled = YES;
	if ([[audioRecorder.settings
		  objectForKey:AVNumberOfChannelsKey] intValue] > 1) {
		leftLevelLabel.text = @"L";
		rightLevelLabel.hidden = NO;
		rightLevelMeter.hidden = NO;
	} else  {
		leftLevelLabel.text = @"M";
		rightLevelLabel.hidden = YES;
		rightLevelMeter.hidden = YES;
	}
	//END:code.RecordViewController.handlemono
	 */
	
	NSLog (@"error: %@", recorderSetupError);
	return recorderSetupError;
}

/* a handy tool for inspecting OSStatus return codes
 //START:code.RecordViewController.log4cc
 int errorCode = CFSwapInt32HostToBig ([recorderSetupError code]);
 NSLog(@"Error: %@ [%4.4s])",
 [recorderSetupError localizedDescription], (char*)&errorCode);
 //END:code.RecordViewController.log4cc
 */

//START:code.RecordViewController.alertifnoaudioinput
-(BOOL) alertIfNoAudioInput {
	AVAudioSession *session = [AVAudioSession sharedInstance];
	BOOL audioHWAvailable = session.inputIsAvailable;
	if (! audioHWAvailable) {
		UIAlertView *cantRecordAlert =
		[[UIAlertView alloc] initWithTitle: @"Can't record"
								   message: @"No audio input hardware is available"
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
		[cantRecordAlert show];
		[cantRecordAlert release]; 
	}
	return audioHWAvailable;
}
//END:code.RecordViewController.alertifnoaudioinput

/* this start method quoted earlier in the chapter does not have the
 check for audio input hardware that's added later
 //START:code.RecordViewController.startrecordingwithouthwcheck
 -(void) startRecording {
 [audioRecorder record];
 recordPauseButton.selected = YES;
 formatButton.enabled = NO;
 }
 
 -(void) pauseRecording {
 [audioRecorder pause];
 recordPauseButton.selected = NO;
 }
 
 -(void) stopRecording {
 [audioRecorder stop];
 }
 //END:code.RecordViewController.startrecordingwithouthwcheck
 */


-(void) startRecording {
	if (! [self alertIfNoAudioInput]) 
		return;
	[audioRecorder record];
	recordPauseButton.selected = YES;
	formatButton.enabled = NO;
}

-(void) pauseRecording {
	[audioRecorder pause];
	recordPauseButton.selected = NO;
}

-(void) stopRecording {
	[audioRecorder stop];
}
// stop's GUI cleanup in audioRecorderDidFinishRecording:successfully


#pragma mark UITextField delegates
//START:code.RecordViewController.textfielddidendediting
- (void)textFieldDidEndEditing:(UITextField *)textField {
	[textField resignFirstResponder];
	// verify that there's a legitimate filename extension
	if ([[textField.text pathExtension] length] == 0)
		textField.text =
		[NSString stringWithFormat: @"%@.caf", textField.text];
	[self createAVAudioRecorder];
}
//END:code.RecordViewController.textfielddidendediting

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

#pragma mark AVAudioRecorderDelegate methods
//START:code.RecordViewController.delegate.finish
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
						   successfully:(BOOL)flag {
	NSLog (@"audioRecorderDidFinishRecording:successfully:");
	recordPauseButton.selected = NO;
	recordPauseButton.enabled = NO;
	formatButton.enabled = YES;
	[audioRecorder release];
	audioRecorder = nil;
	filenameField.text = @"";	
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder
								   error:(NSError *)error {
	recordPauseButton.selected = NO;
	recordPauseButton.enabled = NO;
	[audioRecorder release];
	audioRecorder = nil;
	filenameField.text = @"";	
}
//END:code.RecordViewController.delegate.finish

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder {
	NSLog (@"begin interruption!");
	recordPauseButton.selected = NO;
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder {
	NSLog (@"end interruption!");
}


#pragma mark button handlers

/*
//START:code.RecordViewController.handleformatbuttontapped
-(IBAction) handleFormatButtonTapped {
	if (formatSegments.selectedSegmentIndex == 0) {
		[self presentModalViewController:pcmSettingsViewController
								animated:YES];
	} else {
		[self presentModalViewController:encodingSettingsViewController
								animated:YES];
	}
}
//END:code.RecordViewController.handleformatbuttontapped
 */

-(IBAction) handleFormatSegmentChange {
	[self createAVAudioRecorder];
}

//START:code.RecordViewController.handlebuttons
-(IBAction) handleRecordPauseTapped {
	NSLog (@"handleRecordPauseTapped");
	if (audioRecorder.recording) {
		[self pauseRecording];
	} else {
		[self startRecording];
	}
}

-(IBAction) handleStopTapped {
	NSLog (@"handleStopTapped");
	if (audioRecorder.recording) {
		[self stopRecording];
	}
}
//END:code.RecordViewController.handlebuttons

#pragma mark View Controller Lifecycle Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad 
{
	controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	[super viewDidLoad];
	
	NSError *error;
	
	NSString * dhePath = [[NSBundle mainBundle] pathForResource:@"Dhe" ofType:@"wav"];
	dhe = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:dhePath] error:&error];
	if (!dhe) {
		NSLog(@"no dhe: %@", [error localizedDescription]);	
	}
    dhe.volume = 1.0;
	[dhe prepareToPlay];
	dhe.delegate = self;
	
	NSString * gaPath = [[NSBundle mainBundle] pathForResource:@"Ga" ofType:@"wav"];
	ga = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:gaPath] error:&error];
	if (!ga) {
		NSLog(@"no ga: %@", [error localizedDescription]);	
	}
    ga.volume = 1.0;
	[ga prepareToPlay];
	ga.delegate = self;
	
	NSString * kaPath = [[NSBundle mainBundle] pathForResource:@"Ka" ofType:@"wav"];
	ka = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:kaPath] error:&error];
	if (!ka) {
		NSLog(@"no ka: %@", [error localizedDescription]);	
	}
    ka.volume = 1.0;
	[ka prepareToPlay];
	ka.delegate = self;
	
	NSString * kiPath = [[NSBundle mainBundle] pathForResource:@"Ki" ofType:@"wav"];
	ki = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:kiPath] error:&error];
	if (!ki) {
		NSLog(@"no ki: %@", [error localizedDescription]);	
	}
    ki.volume = 1.0;
	[ki prepareToPlay];
	ki.delegate = self;
	
	NSString * naPath = [[NSBundle mainBundle] pathForResource:@"Na" ofType:@"wav"];
	na = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:naPath] error:&error];
	if (!na) {
		NSLog(@"no na: %@", [error localizedDescription]);	
	}
    na.volume = 1.0;
	[na prepareToPlay];
	na.delegate = self;
	
	NSString * naaPath = [[NSBundle mainBundle] pathForResource:@"Naa" ofType:@"wav"];
	naa = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:naaPath] error:&error];
	if (!naa) {
		NSLog(@"no naa: %@", [error localizedDescription]);	
	}
    naa.volume = 1.0;
	[naa prepareToPlay];
	naa.delegate = self;
	
	NSString * taPath = [[NSBundle mainBundle] pathForResource:@"Ta" ofType:@"wav"];
	ta = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:taPath] error:&error];
	if (!ta) {
		NSLog(@"no ta: %@", [error localizedDescription]);	
	}
    ta.volume = 1.0;
	[ta prepareToPlay];
	ta.delegate = self;
	
	NSString * theePath = [[NSBundle mainBundle] pathForResource:@"Thee" ofType:@"wav"];
	thee = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:theePath] error:&error];
	if (!thee) {
		NSLog(@"no thee: %@", [error localizedDescription]);	
	}
    thee.volume = 1.0;
	[thee prepareToPlay];
	thee.delegate = self;
	
	NSString * thiPath = [[NSBundle mainBundle] pathForResource:@"Thi" ofType:@"wav"];
	thi = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:thiPath] error:&error];
	if (!thi) {
		NSLog(@"no thi: %@", [error localizedDescription]);	
	}
    thi.volume = 1.0;
	[thi prepareToPlay];
	thi.delegate = self;
	
	NSString * thinPath = [[NSBundle mainBundle] pathForResource:@"Thin" ofType:@"wav"];
	thin = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:thinPath] error:&error];
	if (!thin) {
		NSLog(@"no thin: %@", [error localizedDescription]);	
	}
    thin.volume = 1.0;
	[thin prepareToPlay];
	thin.delegate = self;
	
	[dhePath release];
	[gaPath release];
	[kaPath release];
	[kiPath release];
	[naPath release];
	[naaPath release];
	[taPath release];
	[theePath release];
	[thiPath release];
	[thinPath release];
	[error release];

}

//Begin Bol Methods

- (IBAction) playDhe
{
	dhe.currentTime = 0.0;
	[dhe play];
	NSLog(@"Dhe");
}

- (IBAction) playGa
{
	
	ga.currentTime = 0.0;
	[ga play];
	NSLog(@"Ga");
}

- (IBAction) playKa
{
	
	ka.currentTime = 0.0;
	[ka play];
	NSLog(@"Ka");
}

- (IBAction) playKi
{
	
	ki.currentTime = 0.0;
	[ki play];
	NSLog(@"Ki");
}

- (IBAction) playNa
{
	
	na.currentTime = 0.0;
	[na play];
	NSLog(@"Na");
}

- (IBAction) playNaa
{
	
	naa.currentTime = 0.0;
	[naa play];
	NSLog(@"Naa");
}

- (IBAction) playTa 
{
	
	ta.currentTime = 0.0;
	[ta play];
	NSLog(@"Ta");
}

- (IBAction) playThee
{
	
	thee.currentTime = 0.0;
	[thee play];
	NSLog(@"Thee");
}

- (IBAction) playThi 
{
	
	thi.currentTime = 0.0;
	[thi play];
	NSLog(@"Thi");
}

- (IBAction) playThin
{
	
	thin.currentTime = 0.0;
	[thin play];
	NSLog(@"Thin");
}

//End Bol methods

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo {    
	
	//FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	//controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	//[controller release];
}

-(IBAction)showPlayView
{
	//playViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:playViewController animated:YES];
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[dhe release];
	[ga release];
	[ka release];
	[ki release];
	[na release];
	[naa release];
	[ta release];
	[thee release];
	[thi release];
	[thin release];
    [super dealloc];
}


@end
