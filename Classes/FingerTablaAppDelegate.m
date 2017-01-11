//
//  FingerTablaAppDelegate.m
//  FingerTabla
//
//  Created by Alonzo Machiraju on 8/28/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FingerTablaAppDelegate.h"
#import "MainViewController.h"

@implementation FingerTablaAppDelegate


@synthesize window;
@synthesize mainViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	//Anti-Piracy
	
	NSBundle *bundle = [NSBundle mainBundle];
	NSDictionary *info = [bundle infoDictionary];
	if ([info objectForKey:@"SignerIdentity"] != nil)
	{
		//antipiracyimage.hidden = NO;
		window.userInteractionEnabled = NO;
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"PIRACY WARNING" message:@"It appears you have a pirated copy of this program.  Please delete it and download a legitimate copy from the App Store to use this program.  Software piracy is a form of copyright infringement and is punishable by up to $150,000 in civil damages per infringement and/or a fine up to $250,000 and up to 5 years imprisonment.  Please refrain from using pirated software in the future." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
    
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
