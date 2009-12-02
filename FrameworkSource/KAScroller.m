//
//  KAScroller.m
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

#import "KAScroller.h"
#import "KAGradient.h"

@class PresentationArgs, PresentationManager;



extern NSString *BlackFade;

@implementation KAScroller

#pragma mark Drawing Functions

-(id)init {
	
	self = [super init];
	
	if(self) {
		mTrackingTagForKnob = nil;
		[self setMMouseEntered: NO];
		__styleId = 0;
		[self setKastyles:[NSArray arrayWithObjects:@"BlackFade", nil]];
		[self setKastyle:@"BlackFade"];
	}
	
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder: aDecoder];
	if (self)
	{
		mTrackingTagForKnob = nil;
		[self setMMouseEntered: NO];
		__styleId = 0;
		
		if([aDecoder containsValueForKey:@"styles"])
		{
			[self setKastyles:[aDecoder decodeObjectForKey:@"kastyles"]];
		}else
		{
			[self setKastyles:[NSArray arrayWithObjects:@"BlackFade", nil]];
		}
		
		if([aDecoder containsValueForKey:@"kastyle"])
		{
			[self setKastyle:[aDecoder decodeObjectForKey:@"kastyle"]];
		}else
		{
			[self setKastyle:@"BlackFade"];
		}		
	}
	return self;
}

-(void)encodeWithCoder: (NSCoder *)coder {	
	[super encodeWithCoder: coder];
	
	[coder encodeObject:[self kastyles] forKey:@"kastyles"];
	[coder encodeObject:[self kastyle] forKey:@"kastyle"];
}

- (void)drawRect:(NSRect)rect 
{
	PresentationArgs *args = [[PresentationArgs alloc] init];
	[args setM_ClipRectangle:rect];
	[[PresentationManager Instance] DrawControl:self Args:args Style:__styleId];
	[args release];
}

- (void) resetTrackingRect
{
	mTrackingRect = [self bounds];
}

- (void)setFrame:(NSRect)frame 
{
    [super setFrame: frame];
    [self removeTrackingRect: mTrackingTagForKnob];
    [self resetTrackingRect];
	if (!NSIsEmptyRect(mTrackingRect))
		mTrackingTagForKnob = [self addTrackingRect: mTrackingRect owner:self userData:NULL assumeInside:NO];
}

- (void)setBounds:(NSRect)bounds 
{
    [super setBounds: bounds];
    [self removeTrackingRect: mTrackingTagForKnob];
    [self resetTrackingRect];
	if (!NSIsEmptyRect(mTrackingRect))
		mTrackingTagForKnob = [self addTrackingRect: mTrackingRect owner:self userData:NULL assumeInside:NO];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
	[self setMMouseEntered: YES];	
	[self setNeedsDisplay];
}

- (void)mouseExited:(NSEvent *)theEvent
{
	[self setMMouseEntered: NO];
	
	[self setNeedsDisplay];
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow 
{
    if ( [self window] && mTrackingTagForKnob ) {
        [self removeTrackingRect:mTrackingTagForKnob];
    }
}

- (void)viewDidMoveToWindow 
{
	[self resetTrackingRect];
	if (!NSIsEmptyRect(mTrackingRect))
		mTrackingTagForKnob = [self addTrackingRect: mTrackingRect owner:self userData:NULL assumeInside:NO];
}

-(void)dealloc {
	
	[self removeTrackingRect: mTrackingTagForKnob];
	[super dealloc];
}

#pragma mark - Accessors

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
	[kastyles autorelease];
	kastyles = [newValue retain];
}

- (struct _sFlags) scrollerFlags
{
	return sFlags;
}

- (void) setScrollerFlags:(struct _sFlags) scrollFlag
{
	sFlags = scrollFlag;
}


- (BOOL) mMouseEntered {
  return mMouseEntered;
}

- (void) setMMouseEntered: (BOOL) newValue {
  mMouseEntered = newValue;
}

@end
