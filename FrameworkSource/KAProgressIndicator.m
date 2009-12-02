//
//  KAProgressIndicator.m
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

#import "KAProgressIndicator.h"
#import "KAGradient.h"
#import "PresentationArgs.h"
#import "PresentationManager.h"
#import "NSUIHeartBeat.h"

#define MAX_Count 11
extern NSString *BlackFade;
const float kBlackColor[] = { 0.0, 0.0, 0.0, 1.0};
@implementation KAProgressIndicator

- (void) initialize
{
	_spinFrequency = 0;
	_switch = NO;
	_pieceOrigin = -28;
	[self setAnimationDelay: 0.5 /60];	
	__styleId = 0;
}

- (id)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame: frameRect];
	if (self)
	{
		[self initialize];
		[self setKastyle:BlackFade];
		[self setKastyles:[NSArray arrayWithObjects:@"BlackFade", nil]];	
		[self setHiddenWhenStop:YES];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *) aDecoder {
	
	self = [super initWithCoder: aDecoder];
	
	if(self) 
	{
		[self initialize];
		
		if([aDecoder containsValueForKey:@"kastyle"])
		{
			[self setKastyle:[aDecoder decodeObjectForKey:@"kastyle"]];
		}else
		{
			[self setKastyle:BlackFade];
		}
		
		if([aDecoder containsValueForKey:@"hiddenWhenStop"])
		{
			[self setHiddenWhenStop:[aDecoder decodeBoolForKey:@"hiddenWhenStop"]];
		}else
		{
			[self setHiddenWhenStop:YES];
		}
		
		[self setKastyles:[NSArray arrayWithObjects:@"BlackFade", nil]];
	}
	
	return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {	
	[super encodeWithCoder: coder];
	
	[coder encodeObject:[self kastyle] forKey:@"kastyle"];	
	[coder encodeObject:[self kastyles] forKey:@"styles"];
	[coder encodeBool:[self hiddenWhenStop] forKey:@"hiddenWhenStop"];
}

- (void) dealloc
{	
	[self setKastyle:nil];
	[self setKastyles:nil];
	
	[super dealloc];
}

- (void)setIndeterminate:(BOOL)flag
{
	[super setIndeterminate: flag];
	
	// Maybe we need more functionality here when we implement indeterminate
	if (flag == NO && _isRunning)
		[self stopAnimation: self];
}

/* Animation*/
- (void)startAnimation:(id)sender
{
	_isRunning = YES;
	[[NSUIHeartBeat sharedHeartBeat] addHeartBeatView:self];
}

- (void)stopAnimation:(id)sender
{
	_isRunning = NO;
	[[NSUIHeartBeat sharedHeartBeat] removeHeartBeatView:self];
	[self setNeedsDisplay:YES];
}

- (void)animate				// manual animation
{
	if (![self isIndeterminate]) return;
	
	if ([self style] == NSProgressIndicatorSpinningStyle)
	{
		_spinFrequency = (_spinFrequency + 1) % 1;
		if (_spinFrequency != 0) return;
	}
	
	_index++;
	if (_index > MAX_Count)
		_index = 0;
	_pieceOrigin += PieceSpeed;
	if (_pieceOrigin >= (-28+ (PieceThick *2)))
	{
		_pieceOrigin = -28;
	}
}

- (BOOL) isRunning{
	return _isRunning;
}

- (int) theIndex{
	return _index;
}
- (BOOL) isSwitch{
	return _switch;
}

- (void) setSwitch:(BOOL) _isSw{
	_switch = _isSw;
}

- (NSString *) kastyle {
	return kastyle;
}

- (void) setKastyle: (NSString *) newValue {
	if(kastyle != newValue)
	{
		[kastyle release];
		kastyle = [newValue retain];
		
		if([kastyle compare:BlackFade] == NSOrderedSame)
		{
			__styleId = 0;
		}
	}
}


- (NSArray *) kastyles {
	return kastyles;
}

- (void) setKastyles: (NSArray *) newValue {
	if(kastyles != newValue)
	{
		[kastyles release];
		kastyles = [newValue retain];
	}
}

- (BOOL) _wantsHeartBeat
{	
	//
	return NO;
}

- (void)heartBeat:(CDAnonymousStruct7 *)fp8
{
	if ([self isIndeterminate] && _isRunning)
	{
		NSRect bounds = [self bounds];
		CGRect myRect = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
		//[[NSUIHeartBeat sharedHeartBeat] lockFocusForView:self inRect:myRect needsTranslation:YES];
		[self lockFocus];
		[self animate];
		[self drawRect:[self bounds]];
		[self unlockFocus];
		//[[NSUIHeartBeat sharedHeartBeat] unlockFocusInRect:myRect];
	}	
}



/*Draw functions*/
- (void) drawRect: (NSRect) rect 
{
	if (hiddenWhenStop && [self isIndeterminate] && !_isRunning && [self style] == NSProgressIndicatorSpinningStyle)
	{
		return;
	}
	
	PresentationArgs *args = [[PresentationArgs alloc] init];
	[args setM_ClipRectangle:rect];
		
	[[PresentationManager Instance] DrawControl:self Args:args Style:__styleId];
	
	[args release];
}


- (BOOL) hiddenWhenStop {
	return hiddenWhenStop;
}

- (void) setHiddenWhenStop: (BOOL) newValue {
	hiddenWhenStop = newValue;
}

- (int)thePieceOrigin
{
	return _pieceOrigin;
}

@end
