//
//  PlayViewController.h
//  FingerTabla
//
//  Created by Alonzo Machiraju on 3/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, AVAudioPlayerDelegate> {
	UIPickerView *filePicker;
	UIButton *playPauseButton;
	UIButton *stopButton;
	UILabel *currentTimeLabel;
	UISlider *currentTimeSlider;
	UILabel *durationLabel;
	//LevelMeterView *leftLevelMeter;
	UILabel *rightLevelLabel;
	//LevelMeterView *rightLevelMeter; 
	UISlider *volumeSlider;
	
	NSString *_documentsPath;
	NSArray *filenames;
	NSTimer *currentTimeUpdateTimer;
	AVAudioPlayer *audioPlayer;
	BOOL isCurrentTimeScrubbing;
}

-(IBAction) handlePlayPauseTapped;
-(IBAction) handleStopTapped;
-(IBAction) handleCurrentTimeScrubberTouchDown;
-(IBAction) handleCurrentTimeScrubberTouchUp;
-(IBAction) handleCurrentTimeScrub;
-(IBAction) handleVolumeScrub;

-(IBAction)dismissView;

@property (nonatomic, retain) IBOutlet UIPickerView *filePicker;
@property (nonatomic, retain) IBOutlet UIButton *playPauseButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;
@property (nonatomic, retain) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic, retain) IBOutlet UISlider *currentTimeSlider;
@property (nonatomic, retain) IBOutlet UILabel *durationLabel;
//@property (nonatomic, retain) IBOutlet LevelMeterView *leftLevelMeter;
@property (nonatomic, retain) IBOutlet UILabel *rightLevelLabel;
//@property (nonatomic, retain) IBOutlet LevelMeterView *rightLevelMeter; 
@property (nonatomic, retain) IBOutlet UISlider *volumeSlider;

@end
