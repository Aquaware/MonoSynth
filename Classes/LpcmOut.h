//
//  LpcmOut.h
//  MonoSynth
//
//  Created by KUDO IKUO on 10/09/30.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>

@interface LpcmOut : NSObject
{
	AudioUnit output_;
	AudioStreamBasicDescription format_;
	
	BOOL nowPlaying_;
}

@property ( nonatomic ) BOOL nowPlaying_;
@property ( nonatomic ) AudioStreamBasicDescription format_;
@property ( nonatomic ) AudioUnit output_;

@end
