//
//  MonoSynthAppDelegate.h
//  MonoSynth
//
//  Created by KUDO IKUO on 10/07/12.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MonoSynthViewController;

@interface MonoSynthAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MonoSynthViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MonoSynthViewController *viewController;

@end

