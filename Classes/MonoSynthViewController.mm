//
//  MonoSynthViewController.m
//  MonoSynth
//
//  Created by KUDO IKUO on 10/07/12.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MonoSynthViewController.h"

@implementation MonoSynthViewController
@synthesize _keyboardView;
@synthesize knobVcoWaveType_;
@synthesize synth_;

- ( void ) keyChanged: ( id ) sender
{
	synth_->setKeyboard( _keyboardView.downKey_ ); 
}

- ( void ) vcoWaveTypeChanged: ( id ) sender
{
	
}


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
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

static void interruptionListenerCallback(void *inUserData, UInt32 interruptionState)
{
	
}

- ( void ) startup
{
	//オーディオセッションを初期化
	AudioSessionInitialize(NULL, NULL, interruptionListenerCallback, self);
	//オーディオセッションのカテゴリを設定
	UInt32 sessionCategory = kAudioSessionCategory_SoloAmbientSound;
	AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
							sizeof(sessionCategory),
							&sessionCategory);
	//オーディオセッションのアクティブ化
	AudioSessionSetActive(true);

	synth_ = new LPCMPlayer();

	synth_->play( TRUE );
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	CGSize size = CGSizeMake( 48, 48);

	
    [super viewDidLoad];
	[ _keyboardView setTarget: self ];
	[ _keyboardView setAction: @selector( keyChanged: ) ];
	
	[ knobVcoWaveType_ setTarget: self ];
	[ knobVcoWaveType_ setAction: @selector( vcoWaveTypeChanged: ) ];
	[ knobVcoWaveType_ setInitialValue: 64 max: 127 min: 0 ];
	[ knobVcoWaveType_ setPosition: CGPointMake( 100, 100 ) ];
	
	[ self startup ];
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
	_keyboardView = nil;
	knobVcoWaveType_ = nil;
}


- (void)dealloc {
	[ _keyboardView release ];
	[ knobVcoWaveType_  release ];
	
	delete synth_;
	
    [super dealloc];
}

@end
