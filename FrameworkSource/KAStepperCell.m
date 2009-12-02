//
//  KAStepperCell.m
//  KAStepperDemo
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

#import "KAStepperCell.h"


@implementation KAStepperCell

-(void)drawWithFrame:(NSRect) frame inView:(NSView *) controlView 
{
	frame.size.height -= 5;
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:5 yRadius:5];

	KAGradient * buttoncolor = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.251f green: 0.251f blue: 0.255f alpha: 1.0f]
															  endingColor: [NSColor colorWithDeviceRed: 0.118f green: 0.118f blue: 0.118f alpha: 1.0f]] autorelease];	
	[path stroke];
	[buttoncolor drawInBezierPath:path angle:90];
	
	KAGradient * arrowcolor = [[KAGradient alloc] initWithStartingColor: [NSColor colorWithCalibratedRed:0.8f green:0.8f blue:0.8f alpha:1.0f]
															endingColor: [NSColor colorWithCalibratedRed:0.592f green:0.592f blue:0.592f alpha:1.0f]];
	NSRect tophalfRect = NSMakeRect(frame.origin.x, frame.origin.y + (frame.size.height/2), frame.size.width, (frame.size.height/2));
	topRect = tophalfRect;
	tophalfRect = NSInsetRect(tophalfRect, 3, 3);
	NSBezierPath *topArrow = [[NSBezierPath alloc] init];
	NSPoint topPoints[3];
	topPoints[0] = NSMakePoint(tophalfRect.origin.x, tophalfRect.origin.y);
	topPoints[1] = NSMakePoint(tophalfRect.origin.x + tophalfRect.size.width,tophalfRect.origin.y);
	topPoints[2] = NSMakePoint(tophalfRect.origin.x + (tophalfRect.size.width /2), tophalfRect.origin.y+tophalfRect.size.height);
	[topArrow appendBezierPathWithPoints: topPoints count: 3];
	[topArrow closePath];	
	
	[arrowcolor drawInBezierPath:topArrow angle:0];
	[topArrow release];
	
	NSRect bottomhalfRect = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width, (frame.size.height/2));
	bottomRect = bottomhalfRect;
	bottomhalfRect = NSInsetRect(bottomhalfRect, 3, 3);
	NSBezierPath *bottomArrow = [[NSBezierPath alloc] init];
	NSPoint bottomPoints[3];
	bottomPoints[0] = NSMakePoint(bottomhalfRect.origin.x, bottomhalfRect.origin.y + bottomhalfRect.size.height);
	bottomPoints[1] = NSMakePoint(bottomhalfRect.origin.x + bottomhalfRect.size.width,bottomhalfRect.origin.y + bottomhalfRect.size.height);
	bottomPoints[2] = NSMakePoint(bottomhalfRect.origin.x + (bottomhalfRect.size.width /2), bottomhalfRect.origin.y);
	[bottomArrow appendBezierPathWithPoints: bottomPoints count: 3];
	[bottomArrow closePath];
	[bottomArrow stroke];
	[arrowcolor drawInBezierPath:bottomArrow angle:0];
	[bottomArrow release];
	
	[arrowcolor release];
	
	
}

@end
