//
//  LPCMPlayer.h
//  MonoSynth
//
//  Created by KUDO IKUO on 10/10/04.
//  Copyright 2010 n/a. All rights reserved.
//


#import <AudioUnit/AudioUnit.h>
#include <AudioToolbox/AudioToolbox.h>

#define sample_rate 44100
//#define INT16_MAX 0x7fff 
class LPCMPlayer
{
	public:
		LPCMPlayer();
		~LPCMPlayer();
	
		void play( BOOL enable );
		void setKeyboard( UInt32 status );
	
	private:

		AudioUnit output_;
		AudioStreamBasicDescription format_;
		BOOL nowPlaying_;
		UInt32 keyboardStatus;
		
		float wave[ sample_rate ];// 基本波形
		float buffer[ sample_rate ];// バッファ
		float outPhase[ 25 ]; // 位相
		float outLevel[ 25 ]; // 出力レベル
	
		void setup( float sampleRate );
		void makeTable();
		static OSStatus callback(						void*	inRefCon,
									AudioUnitRenderActionFlags  *ioActionFlags,
										const AudioTimeStamp	*inTimeStamp,
														UInt32	inBusNumber,
														UInt32	inNumberFrames,
											AudioBufferList		*ioData );

		OSStatus waveRender( AudioBufferList *buffer, UInt32 inNumberFrames );
	
	
};