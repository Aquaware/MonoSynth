//
//  LpcmOut.mm
//  MonoSynth
//
//  Created by KUDO IKUO on 10/09/30.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LpcmOut.h"


@implementation LpcmOut
@synthesize nowPlaying_;
@synthesize format_;
@synthesize output_;



static OSStatus waveRender( void*						inRefCon,
						AudioUnitRenderActionFlags  *ioActionFlags,
						const AudioTimeStamp        *inTimeStamp,
						UInt32                      inBusNumber,
						UInt32                      inNumberFrames,
						AudioBufferList             *ioData)
{
	OSStatus err = noErr;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
/*	err = [(id)inRefCon outputCallback:ioActionFlags
						   inTimeStamp:inTimeStamp
						   inBusNumber:inBusNumber
						inNumberFrames:inNumberFrames
								ioData:ioData];
*/	
	[ pool release];
	return err;
}

- ( void ) setup: ( float ) sampleRate
{
	AudioComponentDescription desc;
	desc.componentType         = kAudioUnitType_Output;
	desc.componentSubType      = kAudioUnitSubType_RemoteIO;
	desc.componentManufacturer = kAudioUnitManufacturer_Apple;
	desc.componentFlags        = 0;
	desc.componentFlagsMask    = 0;
	
	AudioComponent component;
	component = AudioComponentFindNext(NULL, &desc);
	
	AudioComponentInstanceNew( component, &output_ ); //AudioUnit取得
	AudioUnitInitialize( output_ );//AudioUnitインスタンス
	
	//コールバック関数設定
	AURenderCallbackStruct callback;
	callback.inputProc       = waveRender;
	callback.inputProcRefCon = self;

	AudioUnitSetProperty( output_,
						 kAudioUnitProperty_SetRenderCallback,
						 kAudioUnitScope_Global,
						 0,
						 &callback,
						 sizeof(AURenderCallbackStruct));
	
	//オーディオデータフォーマット設定
	format_.mSampleRate        = sampleRate;
	format_.mFormatID          = kAudioFormatLinearPCM;
	format_.mFormatFlags       = kAudioFormatFlagsAudioUnitCanonical;
	format_.mBytesPerPacket    = sizeof(AudioUnitSampleType);
	format_.mFramesPerPacket   = 1;
	format_.mBytesPerFrame     = sizeof(AudioUnitSampleType);
	format_.mChannelsPerFrame  = 2;
	format_.mBitsPerChannel    = 8 * sizeof(AudioUnitSampleType);
	format_.mReserved          = 0;
	UInt32 size = sizeof( format_ );
	AudioUnitSetProperty( output_,
						 kAudioUnitProperty_StreamFormat,
						 kAudioUnitScope_Global,
						 0,
						 &format_,
						 size);
	
	//オーディオデータフォーマット取得
	//	UInt32 size = sizeof(outputFormat);
	AudioUnitGetProperty( output_,
						 kAudioUnitProperty_StreamFormat,
						 kAudioUnitScope_Global,
						 0,
						 &format_,
						 &size );
	
#if defined(DEBUG)
	NSLog(@"samplerate = %f", format_.mSampleRate);
	NSLog(@"bits       = %u", format_.mBitsPerChannel);
	NSLog(@"channels   = %u", format_.mChannelsPerFrame);
	NSLog(@"%@",
		  (format_.mFormatFlags & kLinearPCMFormatFlagIsNonInterleaved) ?
		  @"buffer     = non interleaved" : @"buffer     = interleaved");
	if (format_.mFormatFlags & kLinearPCMFormatFlagIsFloat) NSLog(@"data type  = float");
	if (format_.mFormatFlags & kLinearPCMFormatFlagIsSignedInteger) NSLog(@"data type  = single integer");
#endif
	

	nowPlaying_ = FALSE;
}

- ( id ) init
{
	self = [ super init ];
	if ( self != nil )
	{
		[ self setup : 44100.00 ];
	}
	
	return self;
}


-( void ) dealloc
{
	if( nowPlaying_ ) AudioOutputUnitStop( output_ );
	AudioUnitUninitialize( output_ );
	AudioComponentInstanceDispose( output_ );
	output_ = NULL;
	[ super dealloc ];
}


- ( void ) play : ( BOOL ) flag
{
	if( nowPlaying_ == flag ) return;
	
	nowPlaying_ = flag;
	if( flag )
		AudioOutputUnitStart( output_ );
	else 
		AudioOutputUnitStop( output_ );
}

@end
