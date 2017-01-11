//
//  MainViewController.h
//  FingerTabla
//
//  Created by Alonzo Machiraju on 8/28/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h> 
#import <iAd/iAd.h>

#import "PlayViewController.h"

enum ENCODED_FORMAT_SEGMENT_VALUES {
	ENCODED_FORMAT_AAC = 0,
	ENCODED_FORMAT_ALAC,
	ENCODED_FORMAT_IMA4,
	ENCODED_FORMAT_ILBC,
	ENCODED_FORMAT_ULAW
};

@class PlayViewController;
@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate, ADBannerViewDelegate>
{
	FlipsideViewController *controller;
	IBOutlet PlayViewController *playViewController;
	
	//Declare Bols
	AVAudioPlayer *dhe;
	AVAudioPlayer *ga;
	AVAudioPlayer *ka;
	AVAudioPlayer *ki;
	AVAudioPlayer *na;
	AVAudioPlayer *naa;
	AVAudioPlayer *ta;
	AVAudioPlayer *thee;
	AVAudioPlayer *thi;
	AVAudioPlayer *thin;
	
	UITextField *filenameField;
	UISegmentedControl *formatSegments;
	UIButton *formatButton;
	UILabel *currentTimeLabel;
	UIButton *recordPauseButton;
	UIButton *stopButton;
	UILabel *leftLevelLabel;
	//LevelMeterView *leftLevelMeter;
	UILabel *rightLevelLabel;
	//LevelMeterView *rightLevelMeter; 
	
	NSString *_documentsPath;
	NSTimer *currentTimeUpdateTimer;
	AVAudioRecorder *audioRecorder;
}

@property (nonatomic, retain) FlipsideViewController *controller;
@property (nonatomic, retain) PlayViewController *playViewController;

@property (nonatomic, retain) AVAudioPlayer *dhe;
@property (nonatomic, retain) AVAudioPlayer *ga;
@property (nonatomic, retain) AVAudioPlayer *ka;
@property (nonatomic, retain) AVAudioPlayer *ki;
@property (nonatomic, retain) AVAudioPlayer *na;
@property (nonatomic, retain) AVAudioPlayer *naa;
@property (nonatomic, retain) AVAudioPlayer *ta;
@property (nonatomic, retain) AVAudioPlayer *thee;
@property (nonatomic, retain) AVAudioPlayer *thi;
@property (nonatomic, retain) AVAudioPlayer *thin;

@property (nonatomic, retain) IBOutlet UITextField *filenameField;
@property (nonatomic, retain) IBOutlet UISegmentedControl *formatSegments;
@property (nonatomic, retain) IBOutlet UIButton *formatButton;
@property (nonatomic, retain) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic, retain) IBOutlet UIButton *recordPauseButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;
@property (nonatomic, retain) IBOutlet UILabel *leftLevelLabel;
//@property (nonatomic, retain) IBOutlet LevelMeterView *leftLevelMeter;
@property (nonatomic, retain) IBOutlet UILabel *rightLevelLabel;
//@property (nonatomic, retain) IBOutlet LevelMeterView *rightLevelMeter; 

- (IBAction)showInfo;
-(IBAction)showPlayView;

- (IBAction) playDhe;
- (IBAction) playGa;
- (IBAction) playKa;
- (IBAction) playKi;
- (IBAction) playNa;
- (IBAction) playNaa;
- (IBAction) playTa;
- (IBAction) playThee;
- (IBAction) playThi;
- (IBAction) playThin;

//-(IBAction) handleFormatButtonTapped;
-(IBAction) handleFormatSegmentChange;
-(IBAction) handleRecordPauseTapped;
-(IBAction) handleStopTapped;
-(NSError*) createAVAudioRecorder;

@end
