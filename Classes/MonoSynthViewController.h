//
//  MonoSynthViewController.h
//  MonoSynth
//
//  Created by KUDO IKUO on 10/07/12.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardView.h"
#import "KnobView.h"
#import "LPCMPlayer.h"



@interface MonoSynthViewController : UIViewController {
	KeyboardView* _keyboardView;
	KnobView* knobVcoWaveType_;
	LPCMPlayer* synth_;
	
}

@property ( nonatomic, retain ) IBOutlet KeyboardView* _keyboardView;
@property ( nonatomic, retain ) IBOutlet KnobView* knobVcoWaveType_;
@property ( nonatomic ) LPCMPlayer* synth_;

- ( void ) keyChanged: ( id ) sender;
- ( void ) vcoWaveTypeChanged: ( id ) sender;
@end

