//
//  KACustomView.m
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

#import "KACustomView.h"
#import "KAGradient.h"
#import "PresentationArgs.h"
#import "PresentationManager.h"

NSString *BlackFade = @"BlackFade";
NSString *Custom = @"Custom";
NSString *Gray = @"Gray";


@implementation KACustomView

- (id) initWithFrame: (NSRect) rect
{
	if(self = [super initWithFrame:rect])
	{		
		__style = 0;
		[self setKastyle:BlackFade];
		[self setPosition:0.7f];
		[self setBackgroundImage: nil];
		[self setKastyles:[NSArray arrayWithObjects:@"BlackFade", @"Custom", nil]];
		[self setStartColor:[NSColor colorWithCalibratedRed: 0.1333
													  green: 0.1333
													   blue: 0.1333
													  alpha: 1.0]];
		[self setEndColor:[NSColor colorWithCalibratedRed: 0.1333
													green: 0.1333
													 blue: 0.1333
													alpha: 1.0]];
	}
	
	return self;
}

- (id) init
{
	if (self = [super init])
	{
		__style = 0;
		[self setBackgroundImage: nil];
	}
	return self;
}

- (BOOL) _wantsHeartBeat
{	
	return YES;
}

- (void) dealloc
{
	[self setBackgroundImage: nil];
	[self setBackImage:nil];
	[self setStartColor:nil];
	[self setEndColor:nil];
	[self setKastyle:nil];
	[self setKastyles:nil];
	
	[super dealloc];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder: aDecoder];
	if (self)
	{
		__style = 0;
		if([aDecoder containsValueForKey:@"kastyle"])
		{
			[self setKastyle:[aDecoder decodeObjectForKey:@"kastyle"]];
		}else
		{
			[self setKastyle:BlackFade];
		}
		
		if([aDecoder containsValueForKey:@"startColor"])
		{
			[self setStartColor:[aDecoder decodeObjectForKey:@"startColor"]];
		}else
		{
			[self setStartColor:[NSColor colorWithCalibratedRed: 0.1333
														  green: 0.1333
														   blue: 0.1333
														  alpha: 1.0]];
		}
		
		if([aDecoder containsValueForKey:@"endColor"])
		{
			[self setEndColor:[aDecoder decodeObjectForKey:@"endColor"]];
		}else
		{
			[self setEndColor:[NSColor colorWithCalibratedRed: 0.1333
														green: 0.1333
														 blue: 0.1333
														alpha: 1.0]];
		}
		
		if([aDecoder containsValueForKey:@"backgroundImage"])
		{
			[self setBackgroundImage:[aDecoder decodeObjectForKey:@"backgroundImage"]];
		}else
		{
			[self setBackgroundImage:nil];
		}
		if([aDecoder containsValueForKey:@"position"])
		{
			[self setPosition:[aDecoder decodeFloatForKey:@"position"]];
		}else
		{
			[self setPosition:0.7f];
		}
		
		[self setKastyles:[NSArray arrayWithObjects:@"BlackFade", @"Custom", nil]];
		
	}
	return self;
}

-(void)encodeWithCoder: (NSCoder *)coder {	
	[super encodeWithCoder: coder];
	
	[coder encodeFloat:[self position] forKey:@"position"];
	[coder encodeObject:[self kastyle] forKey:@"kastyle"];
	[coder encodeObject:[self startColor] forKey:@"startColor"];
	[coder encodeObject:[self endColor] forKey:@"endColor"];
	[coder encodeObject:[self backgroundImage] forKey:@"backgroundImage"];
	[coder encodeObject:[self kastyles] forKey:@"kastyles"];
}

#pragma mark Override Draw method
- (void) drawRect: (NSRect) rect
{
	NSRect bounds = [self bounds];
	PresentationArgs *args = [[PresentationArgs alloc] init];
	[args setM_ClipRectangle:bounds];
	[[PresentationManager Instance] DrawControl:self Args:args Style:__style];
	[args release];	
}

#pragma mark Accessors

- (NSString*) backgroundImage {
	return m_BackgroundImage;
}

- (void) setBackgroundImage: (NSString*) image {
	if(m_BackgroundImage != image)
	{
		[m_BackgroundImage release];
		m_BackgroundImage = [image retain];
		
		NSBundle *mainBundle = [NSBundle mainBundle];
		NSString *imageBundlePath = [mainBundle pathForImageResource:[[m_BackgroundImage lastPathComponent] stringByDeletingPathExtension]];
		if(imageBundlePath != nil)
		{
			[self setBackImage:[NSImage imageNamed:[[m_BackgroundImage lastPathComponent] stringByDeletingPathExtension]]];
		}else {
			[self setBackImage:[[[NSImage alloc] initWithContentsOfFile:m_BackgroundImage] autorelease]];
		}

	}
}

- (NSColor *) startColor {
	return m_StartColor;
}

- (void) setStartColor: (NSColor *) newValue {
	if(m_StartColor != newValue)
	{
		[m_StartColor release];
		m_StartColor = [newValue retain];
	}
}

- (NSColor *) endColor {
	return m_EndColor;
}

- (void) setEndColor: (NSColor *) newValue {
	if(m_EndColor != newValue)
	{
		[m_EndColor release];
		m_EndColor = [newValue retain];
	}
}

- (NSString *) kastyle
{
	return kastyle;
}
- (void) setKastyle:(NSString *) newValue
{
	if(kastyle != newValue)
	{
		[kastyle release];
		kastyle = [newValue retain];
		
		if([kastyle compare:BlackFade] == NSOrderedSame)
		{
			__style = 0;
		}else if([kastyle compare:Custom] == NSOrderedSame)
		{
			__style = 1;
		}
	}
}

- (CGFloat) position {
	return m_GrandientPosition;
}

- (void) setPosition: (CGFloat) newValue {
	m_GrandientPosition = newValue;
}


- (NSImage *) BackImage {
	return m_BackImage;
}

- (void) setBackImage: (NSImage *) newValue {
	if(m_BackImage != newValue)
	{
		[m_BackImage release];
		m_BackImage = [newValue retain];
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
