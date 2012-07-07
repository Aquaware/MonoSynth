//
//  KnobView.m
//  MonoSynth
//
//  Created by KUDO IKUO on 10/09/28.
//  Copyright 2010 n/a. All rights reserved.
//

#import "KnobView.h"


@implementation KnobView
@synthesize imageActive_;
@synthesize imageInactive_;
@synthesize active_;
@synthesize value_;
@synthesize max_;
@synthesize min_;

const double angle_min = - M_PI * 3 / 4;
const double angle_max =   M_PI * 3 / 4;
const int stroke_pixel = 200;

- ( void ) setAction: ( SEL ) selector
{
	action = selector;
}

- ( void ) setTarget: ( id ) object
{
	target = object;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	CGRect rect;
	
	if (  ( self = [ super initWithCoder:aDecoder ] ) )
	{
		imageActive_ = [UIImage imageNamed:@"KnobOn.png"];
		imageInactive_ = [UIImage imageNamed:@"KnobOff.png"];
		rect = CGRectMake( 0, 0, CGImageGetWidth( [ imageActive_ CGImage ] ), CGImageGetHeight( [ imageActive_ CGImage ] ) );
		super.bounds = rect;
		active_ = FALSE;
		max_ = min_ = value_ = 0;
	}
	return self;
}

- ( void ) setPosition :  ( CGPoint ) position
{
	super.center = position;
}

- ( void ) setInitialValue : ( int ) value max: ( int ) max min: ( int ) min
{
	value_ = value;
	max_ = max;
	min_ = min;
	
	[ self rotate: value ];
	[ self setNeedsDisplay ];
	
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
	
    }
    return self;
}


- (void)dealloc {
	[ imageActive_ release ];
	[ imageInactive_ release ];
    [super dealloc];
}

- (void)drawRect: ( CGRect )rect
{
	rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
	if( self.active_ )
		[ imageActive_ drawInRect: rect ];
	else 
		[ imageInactive_ drawInRect: rect ];	
}

- ( void ) rotate: ( int ) value
{
	CGAffineTransform trans;
	CGFloat r;
	
	trans = CGAffineTransformIdentity;
	r = ( angle_max - angle_min ) *  ( float ) value  / ( float ) ( max_ - min_ ) + angle_min;
	self.transform = CGAffineTransformRotate( trans, r );
}

- ( void ) setKnob : ( int ) y
{
	float delta = ( float ) ( max_ - min_ ) * ( float ) ( initialY_ - y ) / ( float ) stroke_pixel / 2.0;
	value_ += ( int ) delta;
	if( value_ > max_ ) value_ = max_;
	if( value_ < min_ ) value_ = min_;
	
	[ self rotate: value_ ];
}



- (void)touchesBegan: ( NSSet * )touches withEvent: ( UIEvent * ) event
{
	UITouch* touch = [ touches anyObject ];
	initialValue_ = self.value_;
	CGPoint p = [ touch locationInView:self.superview ];
	initialY_ = p.y;
	active_ = TRUE;
	
	[ self setNeedsDisplay ];

}

- (void)touchesMoved: ( NSSet * ) touches withEvent: ( UIEvent * ) event
{
	UITouch* touch = [ touches anyObject ];
	CGPoint p = [ touch locationInView:self.superview ];
	[ self setKnob: p.y ];
	
	(void)[ target performSelector:action withObject: self ];
}

- (void)touchesEnded: ( NSSet *)touches withEvent: ( UIEvent * ) event
{
	UITouch* touch = [ touches anyObject ];
	CGPoint p = [ touch locationInView:self.superview ];
	[ self setKnob: p.y ];
	
	active_ = FALSE;
	[ self setNeedsDisplay ];
	( void ) [ target performSelector: action withObject: self ];
	
}


@end
