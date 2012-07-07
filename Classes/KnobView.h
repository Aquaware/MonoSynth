//
//  KnobView.h
//  MonoSynth
//
//  Created by KUDO IKUO on 10/09/28.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KnobView : UIView
{
	UIImage* imageActive_;
	UIImage* imageInactive_;
	
	BOOL active_;
	int value_;
	int max_;
	int min_;
	

	
	int initialValue_;
	CGFloat initialY_;
	
	SEL action;
	id target;
}

@property ( nonatomic, retain ) UIImage* imageActive_;
@property ( nonatomic, retain ) UIImage* imageInactive_;
@property ( nonatomic ) int value_;
@property ( nonatomic ) int max_;
@property ( nonatomic ) int min_;
@property ( nonatomic ) BOOL active_;

- ( void ) setAction: ( SEL ) selector;
- ( void ) setTarget: ( id ) object;
- ( void ) setInitialValue : ( int ) value max: ( int ) max min: ( int ) min;
- ( void ) setPosition :  ( CGPoint ) position;

@end
