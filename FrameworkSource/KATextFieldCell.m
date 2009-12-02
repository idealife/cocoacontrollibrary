//
//  KATextFieldCell.m
//  AiOControlIBPlugin
//
//  Created by Caravan Zhang on 9/15/09.
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

#import "KATextFieldCell.h"
#import "NSBezierPath+RoundedRect.h"
#import "KATextFieldPresentationInfo.h"

@class PresentationArgs, PresentationManager;

extern NSString *BlackFade;

@implementation KATextFieldCell
- (id)initTextCell:(NSString *)aString
{
	self = [super initTextCell: aString];
	if (self)
	{
	}	
	return self;
}

- (id)initWithCoder:(NSCoder *) aDecoder {
	
	self = [super initWithCoder: aDecoder];
	
	if(self) {
		if([aDecoder containsValueForKey:@"kastyle"])
		{
			[self setKastyle:[aDecoder decodeObjectForKey:@"kastyle"]];
		}else
		{
			[self setKastyle:BlackFade];
		}
		[self setKastyles:[NSArray arrayWithObjects:BlackFade, nil]];
	}
	
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {	
	[super encodeWithCoder: aCoder];
	
	[aCoder encodeObject:[self kastyle] forKey:@"kastyle"];
	[aCoder encodeObject:[self kastyles] forKey:@"kastyles"];
}

-(void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	PresentationArgs *args = [[PresentationArgs alloc] init];
	KATextFieldPresentationInfo *info = [[KATextFieldPresentationInfo alloc] init];
	[info setControlView:controlView];
	[args setM_ClipRectangle:cellFrame];
	[args setM_PresentationInfo:info];
	
	[[PresentationManager Instance] DrawControl:self Args:args Style:__styleId];
	
	[info release];
	[args release];
}

-(void)drawInteriorWithFrame:(NSRect) cellFrame inView:(NSView *) controlView 
{
	[super drawInteriorWithFrame: cellFrame inView: controlView];
}

- (struct __tfFlags) TFFlags
{
	return _tfFlags;
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

-(void)dealloc 
{
	[super dealloc];
}
@end
