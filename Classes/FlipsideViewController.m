//
//  FlipsideViewController.m
//  FingerTabla
//
//  Created by Alonzo Machiraju on 8/28/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FlipsideViewController.h"


@implementation FlipsideViewController

const CGFloat kScrollObjHeight	= 250.0;
const CGFloat kScrollObjWidth	= 280.0;
const NSUInteger kNumImages		= 8;

@synthesize delegate;
@synthesize tanpuraSwitch;

/*
- (void)viewWillDisappear:(BOOL)animated
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	tanpuraSwitch.on  = ([[defaults objectForKey:kTanpuraKey] isEqualToString:@"Engaged"]) ? YES : NO;
	NSString *prefValue = (tanpuraSwitch.on) ? @"Enabled" : @"Disabled";
	[defaults setObject:tanpuraSwitch forKey:kTanpuraKey];
	
	if (tanpuraSwitch.on)
	{
		tanpuraLoop.volume = 1.0;
		tanpuraLoop.numberOfLoops = -1;
		[tanpuraLoop play];
		NSLog(@"Loop on");
	}
	else
	{
		tanpuraLoop.numberOfLoops = 0;
		[tanpuraLoop stop];
		NSLog(@"Loop off");
	}
}
*/

-(IBAction)tanpuraSwitchOnOff:(UISwitch *)sender
{	
	if (tanpuraSwitch.on)
	{
		tanpuraLoop.volume = 1.0;
		tanpuraLoop.numberOfLoops = -1;
		[tanpuraLoop play];
		NSLog(@"Loop on");
	}
	else
	{
		tanpuraLoop.numberOfLoops = 0;
		[tanpuraLoop stop];
		NSLog(@"Loop off");
	}
}


- (void)layoutScrollImages
{
	UIImageView *view = nil;
	NSArray *subviews = [scrollView1 subviews];
	
	// reposition all image subviews in a horizontal serial fashion
	CGFloat curXLoc = 0;
	for (view in subviews)
	{
		if ([view isKindOfClass:[UIImageView class]] && view.tag > 0)
		{
			CGRect frame = view.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			view.frame = frame;
			
			curXLoc += (kScrollObjWidth);
		}
	}
	
	// set the content size so it can be scrollable
	[scrollView1 setContentSize:CGSizeMake((kNumImages * kScrollObjWidth), [scrollView1 bounds].size.height)];
}


- (void)viewDidLoad
{
	//Tanpura Loop Setup
	NSString *tanpuraPath = [[NSBundle mainBundle] pathForResource:@"TanpuraSample" ofType:@"wav"];
	tanpuraLoop = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:tanpuraPath] error:@"null"];
	
	// 1. setup the scrollview for multiple images and add it to the view controller
	//
	// note: the following can be done in Interface Builder, but we show this in code for clarity
	[scrollView1 setBackgroundColor:[UIColor blackColor]];
	[scrollView1 setCanCancelContentTouches:NO];
	scrollView1.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView1.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
	scrollView1.scrollEnabled = YES;
	
	// pagingEnabled property default is NO, if set the scroller will stop or snap at each photo
	// if you want free-flowing scroll, don't set this property.
	scrollView1.pagingEnabled = YES;
	
	// load all the images from our bundle and add them to the scroll view
	NSUInteger i;
	for (i = 1; i <= kNumImages; i++)
	{
		NSString *imageName = [NSString stringWithFormat:@"image%d.jpg", i];
		UIImage *image = [UIImage imageNamed:imageName];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		
		// setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
		CGRect rect = imageView.frame;
		rect.size.height = kScrollObjHeight;
		rect.size.width = kScrollObjWidth;
		imageView.frame = rect;
		imageView.tag = i;	// tag our images for later use when we place them in serial fashion
		[scrollView1 addSubview:imageView];
		[imageView release];
	}
	
	[self layoutScrollImages];	// now place the photos in serial layout within the scrollview
	
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];      
}


- (IBAction)done {
	[self.delegate flipsideViewControllerDidFinish:self];	
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
}


@end
