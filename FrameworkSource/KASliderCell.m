//
//  KASliderCell.m
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

#import "KASliderCell.h"
#import "NSBezierPath+RoundedRect.h"

@implementation KASliderCell


static NSColor		*sliderTrackColor			=	nil;
static NSColor		*strokeColor				=	nil;
static NSColor		*disabledSliderTrackColor	=	nil;
static NSColor		*disabledStrokeColor		=	nil;
static NSColor		*ballbounds					=	nil;
static NSColor		*disabledballbounds			=	nil;
static NSShadow		*focusRing					=	nil;
static NSShadow		*dropShadow					=	nil;
static KAGradient	*highlightKnobColor			=	nil;
static KAGradient	*mknobColor					=	nil;
static KAGradient	*disabledKnobColor			=	nil;


#pragma mark -
#pragma mark Drawing Methods

- (void)drawBarInside:(NSRect)aRect flipped:(BOOL)flipped 
{
	if([self sliderType] == NSLinearSlider) 
	{
		if(![self isVertical]) 
		{			
			[self drawHorizontalBarInFrame: aRect];
		} 
		else 
		{			
			[self drawVerticalBarInFrame: aRect];
		}
	} 
	else 
	{		
		//Placeholder for when I figure out how to draw NSCircularSlider
	}
}

- (void)drawKnob:(NSRect)aRect {
	
	if([self sliderType] == NSLinearSlider) 
	{		
		if(![self isVertical])
		{			
			[self drawHorizontalKnobInFrame: aRect];
		} 
		else 
		{			
			[self drawVerticalKnobInFrame: aRect];
		}
	} 
	else 
	{		
		//Place holder for when I figure out how to draw NSCircularSlider
	}
}

- (void)drawHorizontalBarInFrame:(NSRect)frame 
{
	///
	sliderTrackColor = [NSColor colorWithCalibratedRed: 0.035f green:  0.035f blue:  0.035f alpha: 1.0f];
	strokeColor = [NSColor colorWithCalibratedRed: 0.231f green: 0.231f blue: 0.231f alpha: 1.0f];
	disabledStrokeColor = [NSColor colorWithDeviceRed: 0.768f green: 0.768f blue: 0.768f alpha: 0.5f];
	disabledSliderTrackColor = [NSColor colorWithDeviceRed: 0.710f green: 0.710f blue: 0.710f alpha: 0.5f];
	ballbounds = [NSColor colorWithCalibratedRed: 0.047f green:  0.047f blue:  0.047f alpha: 1.0f];
	ballbounds = [NSColor colorWithCalibratedRed: 0.047f green:  0.047f blue:  0.047f alpha: 1.0f];
	focusRing = [[NSShadow alloc] init];
	[focusRing setShadowColor: [NSColor whiteColor]];
	[focusRing setShadowBlurRadius: 3];
	[focusRing setShadowOffset: NSMakeSize( 0, 0)];
	[focusRing autorelease];
	dropShadow = [[NSShadow alloc] init];
	[dropShadow setShadowColor: [NSColor blackColor]];
	[dropShadow setShadowBlurRadius: 2];
	[dropShadow setShadowOffset: NSMakeSize( 0, -1)];
	[dropShadow autorelease];
	highlightKnobColor = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.451f green: 0.451f blue: 0.455f alpha: 1.0f]
														endingColor: [NSColor colorWithDeviceRed: 0.318f green: 0.318f blue: 0.318f alpha: 1.0f]] autorelease];
	mknobColor = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.251f green: 0.251f blue: 0.255f alpha: 1.0f]
												endingColor: [NSColor colorWithDeviceRed: 0.118f green: 0.118f blue: 0.118f alpha: 1.0f]] autorelease];			
	disabledKnobColor = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.251f green: 0.251f blue: 0.255f alpha: 1.0f]
													   endingColor: [NSColor colorWithDeviceRed: 0.118f green: 0.118f blue: 0.118f alpha: 1.0f]] autorelease];		
	///
	// Adjust frame based on ControlSize
	switch ([self controlSize]) 
	{			
		case NSRegularControlSize:			
			if([self numberOfTickMarks] != 0)
			{				
				if([self tickMarkPosition] == NSTickMarkBelow)
				{					
					frame.origin.y += 4;
				} 
				else 
				{					
					frame.origin.y += frame.size.height - 10;
				}
			} 
			else
			{				
				frame.origin.y = frame.origin.y + (((frame.origin.y + frame.size.height) /2) - 2.5f);
			}			
			frame.origin.x += 2.5f;
			frame.origin.y += 0.5f;
			frame.size.width -= 5;
			frame.size.height = 5;
			break;
			
		case NSSmallControlSize:
			
			if([self numberOfTickMarks] != 0) 
			{				
				if([self tickMarkPosition] == NSTickMarkBelow)
				{					
					frame.origin.y += 2;
				} 
				else
				{					
					frame.origin.y += frame.size.height - 8;
				}
			} 
			else 
			{
				frame.origin.y = frame.origin.y + (((frame.origin.y + frame.size.height) /2) - 2.5f);
			}
			
			frame.origin.x += 0.5f;
			frame.origin.y += 0.5f;
			frame.size.width -= 1;
			frame.size.height = 5;
			break;
			
		case NSMiniControlSize:
			
			if([self numberOfTickMarks] != 0)
			{
				if([self tickMarkPosition] == NSTickMarkBelow) 
				{
					frame.origin.y += 2;
				}
				else 
				{
					frame.origin.y += frame.size.height - 6;
				}
			} 
			else
			{
				frame.origin.y = frame.origin.y + (((frame.origin.y + frame.size.height) /2) - 2);
			}
			
			frame.origin.x += 0.5f;
			frame.origin.y += 0.5f;
			frame.size.width -= 1;
			frame.size.height = 3;
			break;
	}
	
	//Draw Bar
	//NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: frame xRadius: 2 yRadius: 2];
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: frame cornerRadius: 2];
	
	if([self isEnabled]) 
	{
		[sliderTrackColor set];
		[path fill];
		
		[strokeColor set];
		[path stroke];
	} 
	else 
	{
		[disabledSliderTrackColor set];
		[path fill];
		
		[disabledStrokeColor set];
		[path stroke];
	}
}

- (void)drawVerticalBarInFrame:(NSRect)frame 
{
	///
	
	sliderTrackColor = [NSColor colorWithCalibratedRed: 0.035f green:  0.035f blue:  0.035f alpha: 1.0f];
	strokeColor = [NSColor colorWithCalibratedRed: 0.231f green: 0.231f blue: 0.231f alpha: 1.0f];
	disabledStrokeColor = [NSColor colorWithDeviceRed: 0.318f green: 0.318f blue: 0.318f alpha: 0.2f];
	disabledSliderTrackColor = [NSColor colorWithDeviceRed: 0.749f green: 0.761f blue: 0.788f alpha: 0.2f];
	focusRing = [[NSShadow alloc] init];
	[focusRing setShadowColor: [NSColor whiteColor]];
	[focusRing setShadowBlurRadius: 3];
	[focusRing setShadowOffset: NSMakeSize( 0, 0)];
	[focusRing autorelease];
	dropShadow = [[NSShadow alloc] init];
	[dropShadow setShadowColor: [NSColor blackColor]];
	[dropShadow setShadowBlurRadius: 2];
	[dropShadow setShadowOffset: NSMakeSize( 0, -1)];
	[dropShadow autorelease];
	highlightKnobColor = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.451f green: 0.451f blue: 0.455f alpha: 1.0f]
														endingColor: [NSColor colorWithDeviceRed: 0.318f green: 0.318f blue: 0.318f alpha: 1.0f]] autorelease];
	mknobColor = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.251f green: 0.251f blue: 0.255f alpha: 1.0f]
												endingColor: [NSColor colorWithDeviceRed: 0.118f green: 0.118f blue: 0.118f alpha: 1.0f]] autorelease];			
	disabledKnobColor = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.251f green: 0.251f blue: 0.255f alpha: 1.0f]
													   endingColor: [NSColor colorWithDeviceRed: 0.118f green: 0.118f blue: 0.118f alpha: 1.0f]] autorelease];
	///
	//Vertical Scroller
	switch ([self controlSize]) 
	{
		case NSRegularControlSize:
			if([self numberOfTickMarks] != 0) 
			{
				if([self tickMarkPosition] == NSTickMarkRight) 
				{
					frame.origin.x += 4;
				}
				else
				{
					frame.origin.x += frame.size.width - 9;
				}
			} 
			else
			{
				frame.origin.x = frame.origin.x + (((frame.origin.x + frame.size.width) /2) - 2.5f);
			}
			frame.origin.x += 0.5f;
			frame.origin.y += 2.5f;
			frame.size.height -= 6;
			frame.size.width = 5;
			break;
			
		case NSSmallControlSize:
			
			if([self numberOfTickMarks] != 0) 
			{
				if([self tickMarkPosition] == NSTickMarkRight)
				{
					frame.origin.x += 3;
				} 
				else 
				{
					frame.origin.x += frame.size.width - 8;
				}
			}
			else
			{
				frame.origin.x = frame.origin.x + (((frame.origin.x + frame.size.width) /2) - 2.5f);
			}
			
			frame.origin.y += 0.5f;
			frame.size.height -= 1;
			frame.origin.x += 0.5f;
			frame.size.width = 5;
			break;
			
		case NSMiniControlSize:
			
			if([self numberOfTickMarks] != 0)
			{				
				if([self tickMarkPosition] == NSTickMarkRight)
				{
					frame.origin.x += 2.5f;
				} 
				else
				{
					frame.origin.x += frame.size.width - 6.5f;
				}
			} 
			else 
			{
				frame.origin.x = frame.origin.x + (((frame.origin.x + frame.size.width) /2) - 2);
			}
			
			frame.origin.x += 1;
			frame.origin.y += 0.5f;
			frame.size.height -= 1;
			frame.size.width = 3;
			break;
	}
	
	//Draw Bar
	//NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: frame xRadius: 2 yRadius: 2];
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: frame cornerRadius: 2];
	
	[sliderTrackColor set];
	[path fill];
	
	[strokeColor set];
	[path stroke];
}

- (void)drawHorizontalKnobInFrame:(NSRect)frame 
{
	sliderTrackColor = [NSColor colorWithCalibratedRed: 0.035f green:  0.035f blue:  0.035f alpha: 1.0f];
	strokeColor = [NSColor colorWithCalibratedRed: 0.231f green: 0.231f blue: 0.231f alpha: 1.0f];
	disabledStrokeColor = [NSColor colorWithDeviceRed: 0.768f green: 0.768f blue: 0.768f alpha: 0.5f];
	disabledSliderTrackColor = [NSColor colorWithDeviceRed: 0.710f green: 0.710f blue: 0.710f alpha: 0.5f];
	ballbounds = [NSColor colorWithCalibratedRed: 0.047f green:  0.047f blue:  0.047f alpha: 1.0f];
	disabledballbounds = [NSColor colorWithCalibratedRed: 0.725f green:  0.725f blue:  0.725f alpha: 1.0f];
	focusRing = [[NSShadow alloc] init];
	[focusRing setShadowColor: [NSColor whiteColor]];
	[focusRing setShadowBlurRadius: 3];
	[focusRing setShadowOffset: NSMakeSize( 0, 0)];
	[focusRing autorelease];
	dropShadow = [[NSShadow alloc] init];
	[dropShadow setShadowColor: [NSColor blackColor]];
	[dropShadow setShadowBlurRadius: 2];
	[dropShadow setShadowOffset: NSMakeSize( 0, -1)];
	[dropShadow autorelease];
	highlightKnobColor = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.804f green: 0.804f blue: 0.804f alpha: 1.0f]
														endingColor: [NSColor colorWithDeviceRed: 0.251f green: 0.251f blue: 0.251f alpha: 1.0f]] autorelease];
	mknobColor = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.251f green: 0.251f blue: 0.255f alpha: 1.0f]
												endingColor: [NSColor colorWithDeviceRed: 0.118f green: 0.118f blue: 0.118f alpha: 1.0f]] autorelease];			
	disabledKnobColor = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.808f green: 0.808f blue: 0.808f alpha: 1.0f]
													   endingColor: [NSColor colorWithDeviceRed: 0.808f green: 0.808f blue: 0.808f alpha: 1.0f]] autorelease];
	switch ([self controlSize])
	{
		case NSRegularControlSize:
			if([self numberOfTickMarks] != 0) 
			{
				if([self tickMarkPosition] == NSTickMarkAbove) 
				{
					frame.origin.y += 2;
				}

				frame.origin.x += 2;
				frame.size.height = 19.0f;
				frame.size.width = 15.0f;
			} 
			else 
			{
				frame.origin.x += 3;
				frame.origin.y += 3;
				frame.size.height = 15;
				frame.size.width = 15;
			}
			break;
			
		case NSSmallControlSize:
			
			if([self numberOfTickMarks] != 0)
			{
				if([self tickMarkPosition] == NSTickMarkAbove) 
				{
					frame.origin.y += 1;
				}
				
				frame.origin.x += 2.1f;
				frame.size.height = 11.0f;
				frame.size.width = 8.8f;
			} 
			else 
			{
				frame.origin.x += 2;
				frame.origin.y += 2;
				frame.size.height = 11;
				frame.size.width = 11;
			}
			break;
			
		case NSMiniControlSize:
			
			if([self numberOfTickMarks] != 0) 
			{
				frame.origin.x += 1;
				frame.size.height = 11.0f;
				frame.size.width = 9.0f;
			} 
			else 
			{
				frame.origin.x += 4;
				frame.origin.y += 1;
				frame.size.height = 9;
				frame.size.width = 7;
			}
			break;
	}
	/*NSBezierPath *ball = [[NSBezierPath alloc] init];
	NSBezierPath *triangle = [[NSBezierPath alloc] init];
	[ball moveToPoint: NSMakePoint(NSMinX(frame), NSMaxY(frame)/2)];
	[ball appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(frame)/2, NSMaxY(frame)/2)
									 radius: (frame.size.width/2)
								 startAngle: 0.1f 
								   endAngle: 0];
	[ball closePath];
	[strokeColor set];
	[ball stroke];
	[highlightKnobColor drawInBezierPath:ball angle:0];
	[ball release];*/
	//NSBezierPath *pathOuter = [[NSBezierPath alloc] init];
	//NSBezierPath *pathInner = [[NSBezierPath alloc] init];
	//NSPoint pointsOuter[7];
	//NSPoint pointsInner[7];
	NSBezierPath *ball = [[NSBezierPath alloc] init];
	NSBezierPath *triangle = [[NSBezierPath alloc] init];
	NSPoint tpoints[3];
	if([self numberOfTickMarks] != 0)
	{		
		if([self tickMarkPosition] == NSTickMarkBelow)
		{			
			/*pointsOuter[0] = NSMakePoint(NSMinX(frame) + 2, NSMinY(frame));
			pointsOuter[1] = NSMakePoint(NSMaxX(frame) - 2, NSMinY(frame));
			pointsOuter[2] = NSMakePoint(NSMaxX(frame), NSMinY(frame) + 2);
			pointsOuter[3] = NSMakePoint(NSMaxX(frame), NSMidY(frame) + 2);
			pointsOuter[4] = NSMakePoint(NSMidX(frame), NSMaxY(frame));
			pointsOuter[5] = NSMakePoint(NSMinX(frame), NSMidY(frame) + 2);
			pointsOuter[6] = NSMakePoint(NSMinX(frame), NSMinY(frame) + 2);
			
			[pathOuter appendBezierPathWithPoints: pointsOuter count: 7];*/
			
			[ball moveToPoint: NSMakePoint(NSMinX(frame), NSMidY(frame))];
			[ball appendBezierPathWithArcWithCenter: NSMakePoint(NSMidX(frame), NSMidY(frame))
											 radius: (frame.size.width/2)
										 startAngle: 180.1f 
										   endAngle: 180];
			[ball closePath];
			tpoints[0] =  NSMakePoint(NSMidX(frame), NSMaxY(frame) - 0.5);
			tpoints[1] =  NSMakePoint(NSMidX(frame)-1, NSMaxY(frame)-1.5);
			tpoints[2] =  NSMakePoint(NSMidX(frame)+1, NSMaxY(frame)-1.5);
			[triangle appendBezierPathWithPoints:tpoints count:3];
		}
		else 
		{
			/*pointsOuter[0] = NSMakePoint(NSMidX(frame), NSMinY(frame));
			pointsOuter[1] = NSMakePoint(NSMaxX(frame), NSMidY(frame) - 2);
			pointsOuter[2] = NSMakePoint(NSMaxX(frame), NSMaxY(frame) - 2);
			pointsOuter[3] = NSMakePoint(NSMaxX(frame) - 2, NSMaxY(frame));
			pointsOuter[4] = NSMakePoint(NSMinX(frame) + 2, NSMaxY(frame));
			pointsOuter[5] = NSMakePoint(NSMinX(frame), NSMaxY(frame) - 2);
			pointsOuter[6] = NSMakePoint(NSMinX(frame), NSMidY(frame) - 2);
			
			[pathOuter appendBezierPathWithPoints: pointsOuter count: 7];*/
			NSBezierPath *ball = [[NSBezierPath alloc] init];
			NSBezierPath *triangle = [[NSBezierPath alloc] init];
			[ball moveToPoint: NSMakePoint(NSMinX(frame), NSMidY(frame))];
			[ball appendBezierPathWithArcWithCenter: NSMakePoint(NSMidX(frame), NSMidY(frame))
											 radius: (frame.size.width/2)
										 startAngle: 180.1f 
										   endAngle: 180];
			[ball closePath];
			
			
			tpoints[0] =  NSMakePoint(NSMidX(frame), NSMinY(frame)+ 0.5);
			tpoints[1] =  NSMakePoint(NSMidX(frame)+1, NSMinY(frame)+1.5);
			tpoints[2] =  NSMakePoint(NSMidX(frame)-1, NSMinY(frame)+1.5);
			[triangle appendBezierPathWithPoints:tpoints count:3];
		}
		
		/*//Shrink frame for filling of center		
		frame = NSInsetRect(frame, 1, 1);
		
		if([self tickMarkPosition] == NSTickMarkBelow) 
		{
			pointsInner[0] = NSMakePoint(NSMinX(frame) + 2, NSMinY(frame));
			pointsInner[1] = NSMakePoint(NSMaxX(frame) - 2, NSMinY(frame));
			pointsInner[2] = NSMakePoint(NSMaxX(frame), NSMinY(frame) + 2);
			pointsInner[3] = NSMakePoint(NSMaxX(frame), NSMidY(frame) + 2);
			pointsInner[4] = NSMakePoint(NSMidX(frame), NSMaxY(frame));
			pointsInner[5] = NSMakePoint(NSMinX(frame), NSMidY(frame) + 2);
			pointsInner[6] = NSMakePoint(NSMinX(frame), NSMinY(frame) + 2);
			
			[pathInner appendBezierPathWithPoints: pointsInner count: 7];
			
		} else 
		{
			pointsInner[0] = NSMakePoint(NSMidX(frame), NSMinY(frame));
			pointsInner[1] = NSMakePoint(NSMaxX(frame), NSMidY(frame) - 2);
			pointsInner[2] = NSMakePoint(NSMaxX(frame), NSMaxY(frame) - 2);
			pointsInner[3] = NSMakePoint(NSMaxX(frame) - 2, NSMaxY(frame));
			pointsInner[4] = NSMakePoint(NSMinX(frame) + 2, NSMaxY(frame));
			pointsInner[5] = NSMakePoint(NSMinX(frame), NSMaxY(frame) - 2);
			pointsInner[6] = NSMakePoint(NSMinX(frame), NSMidY(frame) - 2);
			
			[pathInner appendBezierPathWithPoints: pointsInner count: 7];
		}*/
		
	}
	else
	{
		//[pathOuter appendBezierPathWithOvalInRect: frame];
		
		//frame = NSInsetRect(frame, 1, 1);
		
		[ball appendBezierPathWithOvalInRect: frame];
	}
	
	//I use two NSBezierPaths here to create the border because doing a simple
	//[path stroke] leaves ghost lines when the knob is moved.
	
	//Draw Base Layer
	/*if([self isEnabled])
	{
		[NSGraphicsContext saveGraphicsState];
		
		//Draw Focus ring or shadow depending on highlight state.
		if([self isHighlighted] && ([self focusRingType] == NSFocusRingTypeDefault ||
									[self focusRingType] == NSFocusRingTypeExterior)) 
		{
			[focusRing set];
		} 
		else 
		{
			[dropShadow set];
		}
		
		//[strokeColor set];
		[ball fill];
		
		[NSGraphicsContext restoreGraphicsState];
	} 
	else 
	{
		[disabledStrokeColor set];
		[ball fill];
	}*/
	
	//Draw Inner Layer
	if([self isEnabled]) 
	{
		if([self isHighlighted]) 
		{
			[highlightKnobColor drawInBezierPath: ball angle: 90];
		}
		else
		{
			[highlightKnobColor drawInBezierPath: ball angle: 90];
		}
		[ballbounds set];
		[triangle fill];
		[triangle stroke];
		[ball stroke];
	} 
	else 
	{
		[disabledKnobColor drawInBezierPath: ball angle: 90];
		[disabledballbounds set];
		[triangle fill];
		[triangle stroke];
		[ball stroke];
	}
	[ball release];
	[triangle release];
	//[pathOuter release];
	//[pathInner release];
}

- (void)drawVerticalKnobInFrame:(NSRect)frame 
{
	sliderTrackColor = [NSColor colorWithCalibratedRed: 0.035f green:  0.035f blue:  0.035f alpha: 1.0f];
	strokeColor = [NSColor colorWithCalibratedRed: 0.231f green: 0.231f blue: 0.231f alpha: 1.0f];
	disabledStrokeColor = [NSColor colorWithDeviceRed: 0.318f green: 0.318f blue: 0.318f alpha: 0.2f];
	disabledSliderTrackColor = [NSColor colorWithDeviceRed: 0.749f green: 0.761f blue: 0.788f alpha: 0.2f];
	focusRing = [[NSShadow alloc] init];
	[focusRing setShadowColor: [NSColor whiteColor]];
	[focusRing setShadowBlurRadius: 3];
	[focusRing setShadowOffset: NSMakeSize( 0, 0)];
	[focusRing autorelease];
	dropShadow = [[NSShadow alloc] init];
	[dropShadow setShadowColor: [NSColor blackColor]];
	[dropShadow setShadowBlurRadius: 2];
	[dropShadow setShadowOffset: NSMakeSize( 0, -1)];
	[dropShadow autorelease];
	highlightKnobColor = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.804f green: 0.451f blue: 0.455f alpha: 1.0f]
														endingColor: [NSColor colorWithDeviceRed: 0.318f green: 0.318f blue: 0.318f alpha: 1.0f]] autorelease];
	mknobColor = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.251f green: 0.251f blue: 0.255f alpha: 1.0f]
												endingColor: [NSColor colorWithDeviceRed: 0.118f green: 0.118f blue: 0.118f alpha: 1.0f]] autorelease];			
	disabledKnobColor = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.251f green: 0.251f blue: 0.255f alpha: 1.0f]
													   endingColor: [NSColor colorWithDeviceRed: 0.118f green: 0.118f blue: 0.118f alpha: 1.0f]] autorelease];
	switch ([self controlSize]) 
	{
		case NSRegularControlSize:
			
			if([self numberOfTickMarks] != 0) 
			{
				if([self tickMarkPosition] == NSTickMarkRight) 
				{
					
					frame.origin.x -= 3;
				}
				
				frame.origin.x += 3;
				frame.origin.y += 2;
				frame.size.height = 15;
				frame.size.width = 19;
			} else {
				
				frame.origin.x += 3;
				frame.origin.y += 3;
				frame.size.height = 15;
				frame.size.width = 15;
			}
			break;
			
		case NSSmallControlSize:
			
			if([self numberOfTickMarks] != 0) {
				
				frame.origin.x += 1;
				frame.origin.y += 2;
				frame.size.height = 9;
				frame.size.width = 13;
			} else {
				
				frame.origin.x += 2;
				frame.origin.y += 2;
				frame.size.height = 11;
				frame.size.width = 11;
			}
			break;
			
		case NSMiniControlSize:
			
			if([self numberOfTickMarks] != 0) {
				
				frame.origin.y += 2;
				frame.size.height = 7;
				frame.size.width = 11;
			} else {
				
				frame.origin.x += 1;
				frame.origin.y += 1;
				frame.size.height = 9;
				frame.size.width = 9;
			}
			break;
	}
	
	NSBezierPath *pathOuter = [[NSBezierPath alloc] init];
	NSBezierPath *pathInner = [[NSBezierPath alloc] init];
	NSPoint pointsOuter[7];
	NSPoint pointsInner[7];
	
	if([self numberOfTickMarks] != 0) {
		
		if([self tickMarkPosition] == NSTickMarkRight) {
			
			pointsOuter[0] = NSMakePoint(NSMinX(frame), NSMinY(frame) + 2);
			pointsOuter[1] = NSMakePoint(NSMinX(frame) + 2, NSMinY(frame));
			pointsOuter[2] = NSMakePoint(NSMidX(frame) + 2, NSMinY(frame));
			pointsOuter[3] = NSMakePoint(NSMaxX(frame), NSMidY(frame));
			pointsOuter[4] = NSMakePoint(NSMidX(frame) + 2, NSMaxY(frame));
			pointsOuter[5] = NSMakePoint(NSMinX(frame) + 2, NSMaxY(frame));
			pointsOuter[6] = NSMakePoint(NSMinX(frame), NSMaxY(frame) - 2);
			
			[pathOuter appendBezierPathWithPoints: pointsOuter count: 7];
			
		} else {
			
			pointsOuter[0] = NSMakePoint(NSMinX(frame), NSMidY(frame));
			pointsOuter[1] = NSMakePoint(NSMidX(frame) - 2, NSMinY(frame));
			pointsOuter[2] = NSMakePoint(NSMaxX(frame) - 2, NSMinY(frame));
			pointsOuter[3] = NSMakePoint(NSMaxX(frame), NSMinY(frame) + 2);
			pointsOuter[4] = NSMakePoint(NSMaxX(frame), NSMaxY(frame) - 2);
			pointsOuter[5] = NSMakePoint(NSMaxX(frame) - 2, NSMaxY(frame));
			pointsOuter[6] = NSMakePoint(NSMidX(frame) - 2, NSMaxY(frame));
			
			[pathOuter appendBezierPathWithPoints: pointsOuter count: 7];
		}
		
		frame = NSInsetRect(frame, 1, 1);
		
		if([self tickMarkPosition] == NSTickMarkRight) {
			
			pointsInner[0] = NSMakePoint(NSMinX(frame), NSMinY(frame) + 2);
			pointsInner[1] = NSMakePoint(NSMinX(frame) + 2, NSMinY(frame));
			pointsInner[2] = NSMakePoint(NSMidX(frame) + 2, NSMinY(frame));
			pointsInner[3] = NSMakePoint(NSMaxX(frame), NSMidY(frame));
			pointsInner[4] = NSMakePoint(NSMidX(frame) + 2, NSMaxY(frame));
			pointsInner[5] = NSMakePoint(NSMinX(frame) + 2, NSMaxY(frame));
			pointsInner[6] = NSMakePoint(NSMinX(frame), NSMaxY(frame) - 2);
			
			[pathInner appendBezierPathWithPoints: pointsInner count: 7];
			
		} else {
			
			pointsInner[0] = NSMakePoint(NSMinX(frame), NSMidY(frame));
			pointsInner[1] = NSMakePoint(NSMidX(frame) - 2, NSMinY(frame));
			pointsInner[2] = NSMakePoint(NSMaxX(frame) - 2, NSMinY(frame));
			pointsInner[3] = NSMakePoint(NSMaxX(frame), NSMinY(frame) + 2);
			pointsInner[4] = NSMakePoint(NSMaxX(frame), NSMaxY(frame) - 2);
			pointsInner[5] = NSMakePoint(NSMaxX(frame) - 2, NSMaxY(frame));
			pointsInner[6] = NSMakePoint(NSMidX(frame) - 2, NSMaxY(frame));
			
			[pathInner appendBezierPathWithPoints: pointsInner count: 7];
		}
		
	} else {
		
		[pathOuter appendBezierPathWithOvalInRect: frame];
		
		frame = NSInsetRect(frame, 1, 1);
		
		[pathInner appendBezierPathWithOvalInRect: frame];
	}
	
	//I use two NSBezierPaths here to create the border because doing a simple
	//[path stroke] leaves ghost lines when the knob is moved.
	
	//Draw Base Layer
	if([self isEnabled]) {
		
		[NSGraphicsContext saveGraphicsState];
		
		if([self isHighlighted] && ([self focusRingType] == NSFocusRingTypeDefault ||
									[self focusRingType] == NSFocusRingTypeExterior)) {
			
			[focusRing set];
		} else {
			
			[dropShadow set];
		}
		
		[strokeColor set];
		[pathOuter fill];
		
		[NSGraphicsContext restoreGraphicsState];
	} else {
		
		[disabledStrokeColor set];
		[pathOuter fill];
	}
	
	//Draw Inner Layer
	if([self isEnabled]) {
		
		if([self isHighlighted]) {
			
			[highlightKnobColor drawInBezierPath: pathInner angle: 90];
		} else {
			
			[mknobColor drawInBezierPath: pathInner angle: 90];
		}
	} else {
		
		[disabledKnobColor drawInBezierPath: pathInner angle: 90];
	}
	
	[pathOuter release];
	[pathInner release];
}

#pragma mark -
#pragma mark Overridden Methods

- (BOOL)_usesCustomTrackImage {
	
	return YES;
}

#pragma mark -

@end
