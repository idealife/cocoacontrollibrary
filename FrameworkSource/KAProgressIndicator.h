//
//  KAProgressIndicator.h
//  AboutDemo
//
//  Created by Edward.Chen on 11/11/09.
//  Copyright 2009 yoyokko. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification,
//  are permitted provided that the following conditions are met:
//
//		Redistributions of source code must retain the above copyright notice, this
//	list of conditions and the following disclaimer.
//
//		Redistributions in binary form must reproduce the above copyright notice,
//	this list of conditions and the following disclaimer in the documentation and/or
//	other materials provided with the distribution.
//
//		Neither the name of the BinaryMethod.com nor the names of its contributors
//	may be used to endorse or promote products derived from this software without
//	specific prior written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS AS IS AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//	IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//	INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
//	BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
//	OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
//	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
//	POSSIBILITY OF SUCH DAMAGE.

#import <Cocoa/Cocoa.h>
#import "IPresentationSeparated.h"
#define PieceThick 16
#define PieceSpeed 2

@interface KAProgressIndicator : NSProgressIndicator <IPresentationSeparated>
{
@private
    int			_index;
	BOOL		_isRunning;
	int			_spinFrequency;
	BOOL		_switch;	
	int			_pieceOrigin;
	
	int __styleId;
	
	NSString *kastyle;
	NSArray  *kastyles;
	
	BOOL		hiddenWhenStop;
}

/* Animation*/
- (void)startAnimation:(id)sender;
- (void)stopAnimation:(id)sender;

- (void)animate:(id)sender;				// manual animation

- (BOOL) isRunning;
- (int) theIndex;
- (BOOL) isSwitch;
- (void) setSwitch:(BOOL) _isSw;

- (NSString *) kastyle;
- (void) setKastyle: (NSString *) newValue;
- (NSArray *) kastyles;
- (void) setKastyles: (NSArray *) newValue;

- (BOOL) hiddenWhenStop;
- (void) setHiddenWhenStop: (BOOL) newValue;

- (int)thePieceOrigin;
@end
