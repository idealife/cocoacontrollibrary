//
//  KAButtonCell.m
//  AiOControlIBPlugin
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

#import "KAPopUpButtonCell.h"
#import "KAGradient.h"
#import "NSBezierPath+RoundedRect.h"

@class PresentationArgs, PresentationManager, KAButtonPresentationInfo;

static float BGCenterX(NSRect aRect) {
	return (aRect.size.width / 2);
}

static float BGCenterY(NSRect aRect) {
	return (aRect.size.height / 2);
}

extern NSString *BlackFade;

@implementation KAPopUpButtonCell

#pragma mark Drawing Functions

-(id)init {
	self = [super init];
	if(self)
	{
		[self initTextCell: @"stringValue" pullsDown: YES];
		__styleId = 0;
		[self setKastyle:BlackFade];
		[self setKastyles:[NSArray arrayWithObjects:@"BlackFade", nil]];
	}
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder: aDecoder];
	if(self)
	{
		__styleId = 0;
		if([aDecoder containsValueForKey:@"kastyle"])
		{
			[self setKastyle:[aDecoder decodeObjectForKey:@"kastyle"]];
		}else
		{
			[self setKastyle:BlackFade];
		}
		
		[self setKastyles:[NSArray arrayWithObjects:@"BlackFade", nil]];
	}
	
	return self;
}

-(void)encodeWithCoder: (NSCoder *)coder
{
	[super encodeWithCoder: coder];
	
	[coder encodeObject:[self kastyle] forKey:@"kastyle"];	
	[coder encodeObject:[self kastyles] forKey:@"styles"];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	PresentationArgs *args = [[PresentationArgs alloc] init];
	KAButtonPresentationInfo *preInfo = [[KAButtonPresentationInfo alloc] init];
	[preInfo setControlView:controlView];
	[args setM_ClipRectangle:cellFrame];
	[args setM_PresentationInfo:preInfo];
	
	[[PresentationManager Instance] DrawControl:self Args:args Style:0];
	
	[preInfo release];
	[args release];	
}

-(void)dealloc {
	//[self setKastyle:nil];
	//[self setKastyles:nil];
	[super dealloc];
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

@end
