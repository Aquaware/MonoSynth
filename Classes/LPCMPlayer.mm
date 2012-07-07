//
//  LPCMPlayer.mm
//  MonoSynth
//
//  Created by KUDO IKUO on 10/10/04.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LPCMPlayer.h"


LPCMPlayer::LPCMPlayer()
{
	setup( sample_rate );
	makeTable();
	nowPlaying_ = FALSE;
	keyboardStatus = 0;
}

LPCMPlayer::~LPCMPlayer() 
{
	if( nowPlaying_ ) AudioOutputUnitStop( output_ );
	AudioUnitUninitialize( output_ );
	AudioComponentInstanceDispose( output_ );
	output_ = NULL;
}

void LPCMPlayer::play( BOOL enable )
{
	if( nowPlaying_ == enable ) return;
	if( enable )
		AudioOutputUnitStart( output_ );
	else 
		AudioOutputUnitStop( output_ );
	
	nowPlaying_ = enable;
}

void LPCMPlayer:: setKeyboard( UInt32 status )
{
	keyboardStatus = status;
}



OSStatus LPCMPlayer:: callback( void*						inRefCon,
							   AudioUnitRenderActionFlags*	ioActionFlags,
							   const AudioTimeStamp*		inTimeStamp,
							   UInt32						inBusNumber,
							   UInt32						inNumberFrames,
							   AudioBufferList*				ioData )

{
	LPCMPlayer* THIS = ( LPCMPlayer* ) inRefCon;
	return THIS->waveRender( ioData, inNumberFrames );
}


void LPCMPlayer::setup( float sampleRate ) 
{
	AudioComponentDescription desc;
	AudioComponent component;	
	AURenderCallbackStruct render;	
	
	
	desc.componentType         = kAudioUnitType_Output;
	desc.componentSubType      = kAudioUnitSubType_RemoteIO;
	desc.componentManufacturer = kAudioUnitManufacturer_Apple;
	desc.componentFlags        = 0;
	desc.componentFlagsMask    = 0;
	
	component = AudioComponentFindNext(NULL, &desc);
	AudioComponentInstanceNew( component, &output_ ); //AudioUnit取得
	AudioUnitInitialize( output_ );//AudioUnitインスタンス
	
	//コールバック関数設定

	render.inputProc       = callback;
	render.inputProcRefCon = this;
	
	AudioUnitSetProperty( output_,
						 kAudioUnitProperty_SetRenderCallback,
						 kAudioUnitScope_Global,
						 0,
						 &render,
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
	AudioUnitSetProperty(	output_,
							kAudioUnitProperty_StreamFormat,
							kAudioUnitScope_Global,
							0,
							&format_,
							size);
	
	//オーディオデータフォーマット取得
	AudioUnitGetProperty(	output_,
							kAudioUnitProperty_StreamFormat,
							kAudioUnitScope_Global,
							0,
							&format_,
							&size );	
}


void LPCMPlayer:: makeTable()
{
	for( int i = 0; i < sample_rate; i++ )
	{
		float phase = i * M_PI * 2.0f / sample_rate;
		wave[ i ] = sinf( phase )
					+ sinf(phase * 2.0f) / 2.0f
					+ sinf(phase * 3.0f) / 3.0f
					+ sinf(phase * 4.0f) / 4.0f
					+ sinf(phase * 5.0f) / 5.0f
					+ sinf(phase * 6.0f) / 6.0f
					+ sinf(phase * 7.0f) / 7.0f
					+ sinf(phase * 8.0f) / 8.0f
					+ sinf(phase * 9.0f) / 9.0f
					+ sinf(phase * 10.0f) / 10.0f;
		wave[ i ] /= 2.0f;
	}
	
	for( int i = 0; i < 25; i++ )
	{
		outPhase[ i ] = 0.0f;
		outLevel[ i ] = 0.0f;
	}
}

OSStatus LPCMPlayer::waveRender( AudioBufferList *data, UInt32 inNumberFrames )
{
	OSStatus status = noErr;
	float* p;
	
	p = buffer;
	for( UInt32 i = 0; i < inNumberFrames; i++ ) *p++ = 0.0;

	int scale = 69 - 24;
	for (int i = 0; i < 25; i++ )
	{
		BOOL flag = ( keyboardStatus & ( 1 << i ) ) != 0;
		
		int note = scale + i;
		float freq = 440.0f * powf( 2.0f, ( note - 69.0f ) / 12.0f );
		
		float phase = outPhase[ i ];
		float level = outLevel[ i ];
		p = buffer;
		for( int j = 0; j < inNumberFrames; j++ )
		{
			if( flag ) level += 0.001f; else level -= 0.001f;
			
			if( level > 1.0f ) level = 1.0f;
			if( level <= 0.0f )
			{
				level = 0.0f;
				break;
			}
			
			*p += wave[ ( int ) phase ] * level;
			phase += freq;
			if (phase >= sample_rate ) phase -= sample_rate;
			p++;
		}
		outPhase[ i ] = phase;
		outLevel[ i ] = level;
	}
	
	// オーディオ バッファに書き込み
	for ( int i = 0; i < data->mNumberBuffers; i++ )
	{
		AudioSampleType* ptr = ( AudioSampleType* ) data->mBuffers[ i ].mData;
		for ( int j = 0; j < inNumberFrames; j++ )
		{
			float sinewave = buffer[ j ];
			if (sinewave < -1.0) sinewave = -1.0; else if (sinewave > 1.0) sinewave = 1.0;
			
			sinewave = sinewave * INT16_MAX;
			
			UInt32 n = data->mBuffers[ i ].mNumberChannels;
			
			for ( int k = 0; k < n; k++ ) 
				ptr[ j * n + k ] = sinewave;
		}
	}	
	
	return status;
}