//
//  FlipsideViewController.h
//  FingerTabla
//
//  Created by Alonzo Machiraju on 8/28/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#define kTanpuraKey @"Tanpura"

#import <AVFoundation/AVFoundation.h>
#import <iAd/iAd.h>

@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController {
	id <FlipsideViewControllerDelegate, ADBannerViewDelegate> delegate;
	
	AVAudioPlayer *tanpuraLoop;
	
	IBOutlet UISwitch *tanpuraSwitch;
	IBOutlet UIScrollView *scrollView1;	// holds five small images to scroll horizontally
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) UISwitch *tanpuraSwitch;

- (IBAction)done;
-(IBAction)tanpuraSwitchOnOff:(UISwitch *)sender;

@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

