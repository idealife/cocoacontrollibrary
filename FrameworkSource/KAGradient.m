//
//  KAGradient.m
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

#import "KAGradient.h"
#import "_KAGradient.h"
#import "_NSGradient.h"

@implementation KAGradient

#pragma mark Protocol Methods
+ (id) gradientWithStartingColor: (NSColor*) startingColor
					 endingColor: (NSColor*) endingColor
{
	return [[[self alloc] initWithStartingColor:startingColor endingColor:endingColor] autorelease];
}

- (id) initWithStartingColor: (NSColor*) startingColor
				 endingColor: (NSColor*) endingColor
{
	if(self = [super init])
	{
		SInt32 minorVer, majorVer;
		Gestalt(gestaltSystemVersionMajor, &majorVer);
		Gestalt(gestaltSystemVersionMinor, &minorVer);
		
		// Leopard && Snow Leopard
		if((majorVer >= 10)&&(minorVer >= 5))
		{
			[self SetGradient:[_NSGradient gradientWithStartingColor:startingColor endingColor:endingColor]];
		}
		// 10.4
		else if((majorVer == 10)&&(minorVer == 4) )
		{
			[self SetGradient:[_KAGradient gradientWithStartingColor:startingColor endingColor:endingColor]];
		}
		// Error OS Version
		else
		{
			[NSException raise:NSInvalidArgumentException format:@"You can't use gradient on this OS version. We only support 10.4 and later. You Max OS version is %i.%i", 
			 majorVer, minorVer];
		}
	}
	return self;
}
- (void) addColorStop: (NSColor*) stopColor
		   atPosition: (CGFloat) position
{
	[m_TheGradient addColorStop:stopColor atPosition:position];
}

- (void) drawFromPoint: (NSPoint) startingPoint
			   toPoint: (NSPoint) endingPoint
{
	[m_TheGradient drawFromPoint:startingPoint toPoint:endingPoint];
}

- (void) drawFromCenter: (NSPoint) startingCenter
				 radius: (CGFloat) startRadius
			   toCenter: (NSPoint) endCenter
				 radius: (CGFloat) endRadius
{
	[m_TheGradient drawFromCenter:startingCenter radius:startRadius toCenter:endCenter radius:endRadius];
}

- (void) drawInRect: (NSRect) rect 
			  angle: (CGFloat) angle
{
	[m_TheGradient drawInRect:rect angle:angle];
}

- (void) drawInBezierPath: (NSBezierPath*) path 
					angle: (CGFloat) angle
{
	[m_TheGradient drawInBezierPath:path angle:angle];
}

- (void) drawRadialInRect: (NSRect) rect
{
	[m_TheGradient drawRadialInRect:rect];
}

- (void) drawRadialInBezierPath: (NSBezierPath*) path
{
	[m_TheGradient drawRadialInBezierPath:path];
}

- (void) dealloc
{
	[self SetGradient:nil];
	
	[super dealloc];
}

- (id<KAGradientProtocol>) theGradient
{
	return m_TheGradient;
}
- (void) SetGradient:(id<KAGradientProtocol>)newGradient
{
	if(m_TheGradient != newGradient)
	{
		if(newGradient != nil && ![newGradient conformsToProtocol:@protocol(KAGradientProtocol)])
		{
			[NSException raise:NSInvalidArgumentException format:@"The %@ doesn't implement all methods in KAGradientProtocol.", newGradient];
		}
		[m_TheGradient release];
		m_TheGradient = [newGradient retain];
	}
}

@end
