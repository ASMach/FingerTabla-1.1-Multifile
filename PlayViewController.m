//
//  PlayViewController.m
//  FingerTabla
//
//  Created by Alonzo Machiraju on 3/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlayViewController.h"


@implementation PlayViewController

@synthesize  filePicker,  playPauseButton, stopButton,
currentTimeLabel, currentTimeSlider, durationLabel, 
/*leftLevelMeter,*/ rightLevelLabel, /*rightLevelMeter,*/ volumeSlider;

-(IBAction)dismissView
{
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark helper methods
- (void) updateAudioDisplay {
	if (audioPlayer == nil) {
		currentTimeLabel.text = @"--:--";
	} else {
		double currentTime = audioPlayer.currentTime;
		currentTimeLabel.text = [NSString stringWithFormat: @"%02d:%02d",
								 (int) currentTime/ (int)60,
								 (int) currentTime%60];	
		/*
		[audioPlayer updateMeters];
		[leftLevelMeter setPower: [audioPlayer averagePowerForChannel:0]
							peak: [audioPlayer peakPowerForChannel: 0]];
		if (! rightLevelMeter.hidden) {
			[rightLevelMeter setPower: [audioPlayer averagePowerForChannel:1]
								 peak: [audioPlayer peakPowerForChannel: 1]];
		}
		if (! isCurrentTimeScrubbing) {
			currentTimeSlider.value = audioPlayer.currentTime;
		}
		 */
	}
}


// attempts to setup AVAudioPlayer from picker-selected file
//START:code.PlayViewController.createavaudioplayer
- (NSError*) createAVAudioPlayer {
	[audioPlayer release];
	audioPlayer = nil;
	currentTimeSlider.value = 0;
	
	NSString *filename = [filenames objectAtIndex:
						  [filePicker selectedRowInComponent:0]];
	NSString *playbackPath =
	[_documentsPath stringByAppendingPathComponent: filename];
	NSURL *playbackURL = [NSURL fileURLWithPath: playbackPath];
	NSError *playerSetupError = nil;
	audioPlayer = [[AVAudioPlayer alloc] // <label id="code.PlayViewController.createavaudioplayer.init.start"/>
				   initWithContentsOfURL:playbackURL error:&playerSetupError]; // <label id="code.PlayViewController.createavaudioplayer.init.end"/>
	
	if (playerSetupError) {
		NSString *errorTitle =
		[NSString stringWithFormat:@"Cannot Play %@:", filename];
		UIAlertView *cantPlayAlert =
		[[UIAlertView alloc] initWithTitle: errorTitle
								   message: [playerSetupError localizedDescription]
								  delegate:nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
		[cantPlayAlert show];
		[cantPlayAlert release]; 
		audioPlayer = nil;
		durationLabel.text = @"--:--";
		return playerSetupError;
	}
	
	audioPlayer.delegate = self;
	audioPlayer.meteringEnabled = YES;
	audioPlayer.volume = volumeSlider.value;
	currentTimeSlider.maximumValue = audioPlayer.duration;
	durationLabel.text = [NSString stringWithFormat: @"%02d:%02d",
						  (int) audioPlayer.duration/60,
						  (int) audioPlayer.duration%60];		
	return playerSetupError;
}
//END:code.PlayViewController.createavaudioplayer


//START:code.PlayViewController.pickerdatasource
#pragma mark UIPickerViewDataSource methods
-(NSInteger) pickerView: (UIPickerView*) pickerView
numberOfRowsInComponent: (NSInteger) component {
	return [filenames count];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

#pragma mark UIPickerViewDelegate methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row
			forComponent:(NSInteger)component {
	return [filenames objectAtIndex:row];
}
//END:code.PlayViewController.pickerdatasource

//START:code.PlayViewController.pickerdidselectrow
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
	   inComponent:(NSInteger)component {
	// stop if playing
	[audioPlayer stop];
	playPauseButton.selected = NO;
	[self createAVAudioPlayer];
}
//END:code.PlayViewController.pickerdidselectrow

#pragma mark AVAudioPlayerDelegate methods
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	NSLog (@"did finish playing");
	playPauseButton.selected = NO;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
	playPauseButton.selected = NO;
	UIAlertView *cantPlayAlert =
	[[UIAlertView alloc] initWithTitle: @"Playback error"
							   message: [error localizedDescription]
							  delegate:nil
					 cancelButtonTitle:@"OK"
					 otherButtonTitles:nil];
	[cantPlayAlert show];
	[cantPlayAlert release]; 
}



#pragma mark event handlers
-(IBAction) handlePlayPauseTapped {
	if (playPauseButton.selected) {
		[audioPlayer pause];
		playPauseButton.selected = NO;
	} else {
		[audioPlayer play];
		playPauseButton.selected = YES;
	}
}

-(IBAction) handleStopTapped {
	[audioPlayer stop];
	playPauseButton.selected = NO;
}

-(IBAction) handleCurrentTimeScrubberTouchDown {
	isCurrentTimeScrubbing = YES;
}

-(IBAction) handleCurrentTimeScrubberTouchUp {
	isCurrentTimeScrubbing = NO;
}

-(IBAction) handleCurrentTimeScrub {
	audioPlayer.currentTime = currentTimeSlider.value;
}

-(IBAction) handleVolumeScrub {
	audioPlayer.volume = volumeSlider.value;
}



#pragma mark VC lifecycle methods

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// load directory contents for picker
	//START:code.PlayViewController.loadfiles
	[_documentsPath release];
	NSArray *searchPaths =
	NSSearchPathForDirectoriesInDomains
	(NSDocumentDirectory, NSUserDomainMask, YES);
	_documentsPath = [searchPaths objectAtIndex: 0];
	[_documentsPath retain];
	[filenames release];
	filenames = [[NSFileManager defaultManager] directoryContentsAtPath:_documentsPath];
	[filenames retain];
	//END:code.PlayViewController.loadfiles
	
	// setup clock, sliders
	currentTimeUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
															  target:self selector:@selector(updateAudioDisplay)
															userInfo:NULL repeats:YES];
	isCurrentTimeScrubbing = NO;
	
	// try to set up for first file
	// (note: in simulator, this is usually .DS_Store, and therefore fails)
	[self createAVAudioPlayer];
	
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
    [super dealloc];
	[filePicker release];
	[playPauseButton release];
	[stopButton release];
	[currentTimeLabel release];
	[currentTimeSlider release];
	[durationLabel release];
	//[leftLevelMeter release];
	[rightLevelLabel release];
	//[rightLevelMeter release]; 
	[volumeSlider release];
}


@end

