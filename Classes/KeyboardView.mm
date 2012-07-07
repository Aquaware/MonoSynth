//
//  KeyboardView.m
//  MonoSynth
//
//  Created by KUDO IKUO on 10/07/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KeyboardView.h"


@implementation KeyboardView
@synthesize downKey_;
@synthesize xImageWhiteKey;
@synthesize xImagePushedWhiteKey;
@synthesize xImageBlackKey;

const int white[] = { 0, 2,  4, 5, 7, 9,  11, 12, 14, 16, 17, 19, 21, 23, 24 };
const int black[] = { 1, 3, -1, 6, 8, 10, -1, 13, 15, -1, 18, 20, 22 };


- ( void ) setAction: ( SEL ) selector
{
	xAction = selector;
}

- ( void ) setTarget: ( id ) object;
{
	xTarget = object;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- ( id ) initWithCoder:(NSCoder *)aDecoder
{
	if( self = [ super initWithCoder: aDecoder ] )
	{
		xTouchPointCount = 0;
		downKey_ = 0;
		xImageWhiteKey = [ UIImage imageNamed: @"whitekey.png" ]; // w: 24  h: 78pix
		xImageBlackKey = [ UIImage	imageNamed: @"blackkey.png" ]; // w: 24  h: 50pix
		xImagePushedWhiteKey = [ UIImage imageNamed: @"pushedWhitekey.png" ];
		
		for( int i =0; i < white_key_max; i++ )
		{
			whiteKey[ i ].isPushed = FALSE;
			whiteKey[ i ].note = white[ i ];
		}
		
	}
	
	return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	CGRect r;
    CGFloat width = self.bounds.size.width / 15;
	CGFloat heightW = self.bounds.size.height;
	CGFloat heightB = self.bounds.size.height * 40.0 / 78.0;
	
	// white key
	for( int i =0; i < white_key_max; i++ )
	{
		r = CGRectMake( i * width, 0, width, heightW );
		if( whiteKey[ i ].isPushed )
			[ xImagePushedWhiteKey drawInRect: r ];
		else
			[ xImageWhiteKey drawInRect: r ];
	}
	
}

- ( int ) getKeyPosition: ( CGPoint ) point
{
	int key;

	
	CGFloat width = self.bounds.size.width / 15;
	CGFloat heightW = self.bounds.size.height;
	CGFloat heightB = self.bounds.size.height * 40.0 / 78.0;
	
	if( point.y < 0 || point.y > heightW || point.x < 0 || point.x > width * 15.0 ) return -1;
	

	key =  ( int ) ( point.x / width );
	
	if( key >= white_key_max ) key = -1;
	
	return key;
}


- ( void ) updateKeyState
{
	
	for( int i = 0; i < white_key_max; i++ ) whiteKey[ i ].isPushed = FALSE;
	
	for( int i = 0; i < xTouchPointCount; i++ )
	{
		int keyno = [ self getKeyPosition: xTouchPoint[ i ] ];
		if( keyno >= 0 ) whiteKey[ keyno ].isPushed = TRUE;
	}
	
	downKey_ = 0;
	UInt32 mask = 1;
	for( int i = 0; i < white_key_max; i++ )
	{
		if( whiteKey[ i ].isPushed ) downKey_ += mask;
		mask <<= 1;
	}
}

- ( void ) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	for( UITouch* touch in touches )
	{
		if( xTouchPointCount >= 10 ) break;
		xTouchPoint[ xTouchPointCount ] = [ touch locationInView: self ];
		NSLog( @"touchesBegan ... #%d x=%f y=%f", xTouchPointCount, xTouchPoint[ xTouchPointCount ].x, xTouchPoint[ xTouchPointCount ].y );
		xTouchPointCount++;
	}
	
	[ self updateKeyState ];
	[ self setNeedsDisplay ];
	( void ) [ xTarget performSelector: xAction withObject: self ];
}

- ( void ) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint previous;
	CGPoint current;	
	CGFloat length;
	BOOL found[ 10 ];
	
	
	for( int i = 0; i < 10; i++ ) found[ i ] = FALSE;
	
	for( UITouch* touch in touches )
	{
		previous = [ touch previousLocationInView: self ];
		NSLog( @"touchesMoved(previous) ... x=%f y=%f", previous.x, previous.y );

		CGFloat min = 1000;
		int iMin = -1;
		for( int i = 0; i < xTouchPointCount; i++ )
		{
			if( found[ i ] ) continue;
			length  =   ( xTouchPoint[ i ].x - previous.x ) *  ( xTouchPoint[ i ].x - previous.x ); 
			          + ( xTouchPoint[ i ].y - previous.y ) *  ( xTouchPoint[ i ].y - previous.y ); 
			if( length < min ) 
			{
				min = length;
				iMin = i;
			}
		}
		
		if( iMin < 10 && iMin >= 0 )
		{
			found[ iMin ] = TRUE;
			current = [ touch locationInView: self ];			
			xTouchPoint[ iMin ] = current;
			NSLog( @"touchesMoved(current) ... x=%f y=%f", current.x, current.y );
		}
	}
	
	[ self updateKeyState ];	
	[ self setNeedsDisplay ];
	( void ) [ xTarget performSelector: xAction withObject: self ];
	
}

- ( void ) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint previous;	
	CGPoint current;
	CGFloat length;
	BOOL found[ 10 ];
	
	
	for( int i = 0; i < 10; i++ ) found[ i ] = FALSE;
	
	for( UITouch* touch in touches )
	{
		previous = [ touch previousLocationInView: self ];
		current = [ touch locationInView: self ];	
		NSLog( @"touchesEnded(previous) ... x=%f y=%f", previous.x, previous.y );
		NSLog( @"touchesEnded(current) ... x=%f y=%f", current.x, current.y );
		
		CGFloat min = 1000;
		int iMin = -1;
		for( int i = 0; i < xTouchPointCount; i++ )
		{
			if( found[ i ] ) continue;
			length  =   ( xTouchPoint[ i ].x - previous.x ) *  ( xTouchPoint[ i ].x - previous.x ); 
			+ ( xTouchPoint[ i ].y - previous.y ) *  ( xTouchPoint[ i ].y - previous.y ); 
			if( length < min ) 
			{
				min = length;
				iMin = i;
			}
		}
		
		if( iMin < 10 && iMin >= 0 ) found[ iMin ] = TRUE;

	}
	
	int count = 0;
	for( int i = 0; i <  xTouchPointCount; i++ )
	{
		if( found[ i ] ) continue;
		xTouchPoint[ count ] = xTouchPoint[ i ];
		count++;
	}
	xTouchPointCount = count;
	
	[ self updateKeyState ];	
	[ self setNeedsDisplay ];
	( void ) [ xTarget performSelector: xAction withObject: self ];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	xTouchPointCount = 0;
	NSLog( @"touchesCandeled" );
	
	[ self updateKeyState ];	
	[ self setNeedsDisplay ];
	( void ) [ xTarget performSelector: xAction withObject: self ];	
}

- (void)dealloc 
{
	[ xImageWhiteKey release ];
	[ xImagePushedWhiteKey release ];	
	[ xImageBlackKey release ];
    [super dealloc];
}


@end
