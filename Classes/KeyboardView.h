//
//  KeyboardView.h
//  MonoSynth
//
//  Created by KUDO IKUO on 10/07/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define white_key_max 15
#define black_key_max 10
typedef struct
{
	int note;
	BOOL isPushed;
} keyState ;

@interface KeyboardView : UIView {
	CGPoint xTouchPoint[ 10 ];
	UInt32 xTouchPointCount;
	UInt32 downKey_;
	UIImage* xImageWhiteKey;
	UIImage* xImagePushedWhiteKey;	
	UIImage* xImageBlackKey;
	keyState whiteKey[ white_key_max ];
	keyState blackKey[ black_key_max ];
	
	SEL xAction;
	id xTarget;
}

@property UInt32 downKey_;
@property ( nonatomic, retain ) UIImage* xImageWhiteKey;
@property ( nonatomic, retain ) UIImage* xImagePushedWhiteKey;
@property ( nonatomic, retain ) UIImage* xImageBlackKey;

- ( void ) setAction: ( SEL ) selector;
- ( void ) setTarget: ( id ) object;
@end
