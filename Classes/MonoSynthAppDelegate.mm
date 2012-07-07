//
//  MonoSynthAppDelegate.m
//  MonoSynth
//
//  Created by KUDO IKUO on 10/07/12.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MonoSynthAppDelegate.h"
#import "MonoSynthViewController.h"

@implementation MonoSynthAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
