//
//  FingerTablaAppDelegate.h
//  FingerTabla
//
//  Created by Alonzo Machiraju on 8/28/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@class MainViewController;

@interface FingerTablaAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

@end

