//
//  KAProgressBarBlackFadeDrawer.m
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

#import "KAProgressBarBlackFadeDrawer.h"
#import "KAGradient.h"


#define MAX_Count 11
#define IdleRedraw_ProgressIndicator @"IdleRedraw_ProgressIndicator"

@implementation KAProgressBarBlackFadeDrawer

/*!
 @function
 @abstract   drawer
 @discussion This class method should return a auto release object of itself.
 @param      nil
 @result     The autorelease object of self.
 */

+ (id<IControlDrawer>) drawer
{
	return [[[self alloc] init] autorelease];
}

- (id) init
{
	if(self = [super init])
	{
		mStatusBar1 = [[NSImage alloc] initWithContentsOfFile: [[[NSBundle bundleForClass: [self class]] resourcePath] 
																stringByAppendingPathComponent: @"statusbar1.png"]];
		mStatusBar2 = [[NSImage alloc] initWithContentsOfFile: [[[NSBundle bundleForClass: [self class]] resourcePath] 
																stringByAppendingPathComponent: @"statusbar2.png"]];
		mStatusEmpty = [[NSImage alloc] initWithContentsOfFile: [[[NSBundle bundleForClass: [self class]] resourcePath]
																 stringByAppendingPathComponent: @"statusbarempty.png"]];
		
		[mStatusBar1 setFlipped: YES];
		[mStatusBar2 setFlipped: YES];
		[mStatusEmpty setFlipped: YES];
	}
	return self;
}

- (void) dealloc
{
	[mStatusBar1 release];
	[mStatusBar2 release];
	[mStatusEmpty release];
	
	[super dealloc];
}

/*!
 @function	
 @abstract   Draw the presentation of the control specified in the args.
 @discussion Draw the presentation of the control specified in the args.
 @param      control The control which implements protocol IPresentationSeparated
 @param		args The presentation args.
 @result     The function return void.
 */
- (void) DrawControl:(id<IPresentationSeparated>) control Args:(PresentationArgs *)args
{
	progressIndicator = (KAProgressIndicator *) control;
		
	NSRect rect = [args m_ClipRectangle];
	
	if ([progressIndicator isBezeled])
	{
		NSDrawLightBezel(rect, [progressIndicator bounds]);
	}
	
	if ([progressIndicator style] == NSProgressIndicatorBarStyle)
	{
		if ([progressIndicator isIndeterminate])
		{
			[self drawIndeterminateProgressBar];
		}
		else
		{
			[self drawNormalProgressBar];
		}
	}
	else
	{
		if ([progressIndicator isIndeterminate])
		{
			[self drawIndeterminateProgressSpin];
		}
		else
		{
			[self drawNormalProgressSpin];
		}
	}
}


- (NSColor*) progressIndicatorBorderColor
{
	return [NSColor grayColor];
}
- (NSColor*) progressIndicatorBackgroundColor
{
	return [NSColor grayColor];
}
- (NSColor*) progressIndicatorFaceColor
{
	return [NSColor colorWithCalibratedRed: 0.6 green:0 blue: 0 alpha:1];
}
- (KAGradient*) progressIndicatorIndeterminateGradient
{
	KAGradient* gradient = [KAGradient gradientWithStartingColor: [NSColor blackColor] endingColor: [NSColor blackColor]];
	
	[gradient addColorStop: [NSColor blackColor] atPosition: 0.15];
	[gradient addColorStop: [NSColor redColor] atPosition: 0.45];
	[gradient addColorStop: [NSColor redColor] atPosition: 0.5];
	[gradient addColorStop: [NSColor redColor] atPosition: 0.55];
	[gradient addColorStop: [NSColor blackColor] atPosition: 0.85];
	
	return gradient;
}

- (KAGradient*) progressIndicatorIndeterminateRadialGradient
{
	KAGradient* gradient = [KAGradient gradientWithStartingColor: [NSColor blackColor] endingColor: [NSColor blackColor]];
	[gradient addColorStop: [NSColor redColor] atPosition: 0.5];
	
	return gradient;
}

- (NSColor*) progressIndicatorDisabledColor
{
	return [NSColor colorWithCalibratedRed: 0.2 green: 0.2 blue: 0.2 alpha: 0.8];
}

- (KAGradient*) progressIndicatorDisabledGradient
{
	NSColor* colorlevelA = [NSColor colorWithCalibratedRed: 0.1 green: 0.1 blue: 0.1 alpha: 0.8];
	NSColor* colorlevelB = [NSColor colorWithCalibratedRed: 0.2 green: 0.2 blue: 0.2 alpha: 0.8];
	KAGradient* gradient = [KAGradient gradientWithStartingColor: colorlevelA endingColor: colorlevelA];
	[gradient addColorStop: colorlevelA atPosition: 0.15];
	[gradient addColorStop: colorlevelB atPosition: 0.45];
	[gradient addColorStop: colorlevelB atPosition: 0.5];
	[gradient addColorStop: colorlevelB atPosition: 0.55];
	[gradient addColorStop: colorlevelA atPosition: 0.85];
	
	return gradient;
}

- (NSColor*) progressIndicatorIndeterminateSpinColorA
{
	return [NSColor colorWithCalibratedRed: 1 green: .0 blue: 0.0 alpha: 1];
}
- (NSColor*) progressIndicatorIndeterminateSpinColorB
{
	return [NSColor colorWithCalibratedRed: 0.8 green:0.1 blue: 0.1 alpha: 1];
}
- (NSColor*) progressIndicatorIndeterminateSpinColorC
{
	return [NSColor colorWithCalibratedRed: 0.6 green:0.2 blue: 0.2 alpha: 1];
}
- (NSColor*) progressIndicatorIndeterminateSpinColorD
{
	return [NSColor colorWithCalibratedRed: 0.4 green:0.2 blue: 0.2 alpha: 1];
}
- (NSColor*) progressIndicatorIndeterminateSpinColor
{
	return [NSColor colorWithCalibratedRed: 0.2 green:0.2 blue: 0.2 alpha: 1];
}
- (NSColor*) progressIndicatorIndeterminateBarBorderColor
{
	return [NSColor grayColor];
}
- (NSColor*) progressIndicatorIndeterminateBarBackgroundColor
{
	return [NSColor whiteColor];
}

- (void) drawNormalProgressBar
{
	double val = [progressIndicator doubleValue];
	if (val < [progressIndicator minValue])
		val = [progressIndicator minValue];
	
	if (val > [progressIndicator maxValue])
		val = [progressIndicator maxValue];
	
	NSRect drawRect = NSInsetRect([progressIndicator bounds], 2, 2);
	float pieceWidth = drawRect.size.width / 20.0;
	float pieceFirstWidth = pieceWidth * 17.0 / 23.0;
	float pieceOffset = drawRect.size.width / 40.0;
	float pieceFirstOffset = pieceOffset * 17.0 / 23.0 - 2;
	int pieceCount = (int) ((val - [progressIndicator minValue]) * 40 / ([progressIndicator maxValue] - [progressIndicator minValue]) + 0.5);
	
	
	// draw empty graphics as default
	NSRect pieceEmptyRect = NSInsetRect(drawRect, 1, 1);
	[mStatusEmpty drawInRect: pieceEmptyRect 
					fromRect: NSZeroRect 
				   operation: NSCompositeSourceOver
					fraction: 1.0];
	
	NSRect pieceRegion = NSInsetRect(drawRect, 1, 1);
	
	if (pieceCount > 0)
	{
		// draw the first piece
		NSRect piece1Rect = pieceRegion;
		piece1Rect.size.width = pieceFirstWidth;
		piece1Rect = NSInsetRect(piece1Rect, 2, 2);
		[mStatusBar1 drawInRect: piece1Rect
					   fromRect: NSZeroRect
					  operation: NSCompositeSourceOver
					   fraction: 1.0];
	}
	if (pieceCount > 1)
	{
		int index = 0;
		for (; index < pieceCount; index++)
		{
			NSRect pieceRect = pieceRegion;
			pieceRect.origin.x += pieceFirstOffset + pieceOffset * index;
			pieceRect.size.width = pieceWidth;
			NSRect imageRect = NSMakeRect(0, 0, [mStatusBar2 size].width, [mStatusBar2 size].height);
			NSRect validRect = NSIntersectionRect(pieceRect, pieceRegion);
			pieceRect = NSInsetRect(pieceRect, 2, 2);
			validRect = NSInsetRect(validRect, 2, 2);
			
			imageRect.size.width = imageRect.size.width * validRect.size.width / pieceRect.size.width;
			
			
			[mStatusBar2 drawInRect: validRect 
						   fromRect: imageRect 
						  operation: NSCompositeSourceOver
						   fraction: 1.0];
		}
	}
	
}

- (void) drawIndeterminateProgressBar
{
	int _pieceOrigin = [progressIndicator thePieceOrigin];
	NSRect frame = [progressIndicator bounds];
	
	// draw border
	NSBezierPath *path = [NSBezierPath bezierPath];
	[path appendBezierPathWithRect: frame];
	//Draw border
	[NSGraphicsContext saveGraphicsState];
	//[[[[KAThemeManager defaultManager] theme] progressIndicatorBorderColor] set];
	[[self progressIndicatorBorderColor] set];
	[path setLineWidth: 3];
	[path stroke];
	[NSGraphicsContext restoreGraphicsState];
	
	NSRect drawRect = NSInsetRect(frame, 1, 3);
	
	//[[[[KAThemeManager defaultManager] theme] progressIndicatorBackgroundColor] set];
	[[self progressIndicatorIndeterminateBarBackgroundColor] set];
	[NSBezierPath fillRect: drawRect];
	int i;
	KAGradient *mygradient = [[KAGradient alloc] initWithStartingColor: [NSColor redColor]
														   endingColor: [NSColor redColor]];
	
	for(i = 0; i < ((drawRect.size.width + 28+PieceThick*2)/(PieceThick * 2));i++)
	{
		NSBezierPath *movingblock = [[NSBezierPath alloc] init];
		[movingblock moveToPoint:NSMakePoint(drawRect.origin.x + (PieceThick*2*i)+_pieceOrigin, drawRect.origin.y)];
		[movingblock lineToPoint:NSMakePoint(drawRect.origin.x + (PieceThick*2*i)+_pieceOrigin+drawRect.size.height, drawRect.origin.y+drawRect.size.height)];
		[movingblock lineToPoint:NSMakePoint(drawRect.origin.x + (PieceThick*2*i)+_pieceOrigin+drawRect.size.height+PieceThick, drawRect.origin.y+drawRect.size.height)];
		[movingblock lineToPoint:NSMakePoint(drawRect.origin.x + (PieceThick*2*i)+_pieceOrigin+PieceThick, drawRect.origin.y)];
		[movingblock closePath];
		[mygradient drawInBezierPath:movingblock angle:90];
		
		[movingblock release];
	}
	[mygradient release];
}

- (void) drawNormalProgressSpin
{
	NSRect bounds = [progressIndicator bounds];
	
	NSPoint center;
	float radius = bounds.size.width < bounds.size.height ? bounds.size.width/ 2 : bounds.size.height / 2;
	center.x = bounds.origin.x + radius;
	center.y = bounds.origin.y + radius;
	
	// border
	NSBezierPath* borderPath = [[NSBezierPath alloc] init];
	[borderPath appendBezierPathWithArcWithCenter: center 
										   radius: radius 
									   startAngle: 0 
										 endAngle: 360];
	[[NSColor whiteColor] set];
	[borderPath setLineWidth: 1];
	[borderPath stroke];
	
	radius -= 1;
	
	// draw contents
	NSPoint startPoint;
	startPoint.x = center.x;
	startPoint.y = center.y - radius;
	
	float length = [progressIndicator maxValue] - [progressIndicator minValue];
	float value = [progressIndicator doubleValue] - [progressIndicator minValue] + length / 360;
	float angle = -90 + value * 360 / length;
	
	NSBezierPath* currentPath = [[NSBezierPath alloc] init];
	[currentPath moveToPoint: center];
	[currentPath lineToPoint: startPoint];
	[currentPath appendBezierPathWithArcWithCenter: center 
											radius: radius 
										startAngle: -90 
										  endAngle: angle];
	[currentPath closePath];
	
	KAGradient* gradient = [KAGradient gradientWithStartingColor: [NSColor grayColor] endingColor: [NSColor whiteColor]];
	[gradient drawInBezierPath: currentPath angle: angle];
	
	// draw rest
	NSBezierPath* restPath = [[NSBezierPath alloc] init];
	[restPath moveToPoint: center];
	[restPath lineToPoint: startPoint];
	[restPath appendBezierPathWithArcWithCenter: center 
										 radius: radius 
									 startAngle: -90 
									   endAngle: -90 + value * 360 /length 
									  clockwise: YES];
	[restPath closePath];
	[[NSColor grayColor] set];
	[restPath fill];
	
}

- (void) drawIndeterminateProgressSpin
{
	NSRect bounds = [progressIndicator bounds];
	
	NSPoint center;
	float radius = bounds.size.width < bounds.size.height ? bounds.size.width/ 2 : bounds.size.height / 2;
	center.x = bounds.origin.x + radius;
	center.y = bounds.origin.y + radius;
	
	NSSize pieceSize = NSMakeSize(radius * 0.6 , radius/ 4);
	NSPoint pieceOrigin = NSMakePoint(bounds.origin.x + bounds.size.width - pieceSize.width,  bounds.origin.y + radius - pieceSize.height/2);
	NSRect pieceRect = NSMakeRect(pieceOrigin.x, pieceOrigin.y, pieceSize.width, pieceSize.height);
	
	float deltaX = center.x - bounds.origin.x;
	float deltaY = center.y - bounds.origin.y;
	
	for (int i = 0; i < 12; i++)
	{
		NSAffineTransform *transform = [[NSAffineTransform alloc] init];
		NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect: pieceRect];
		[transform translateXBy: deltaX yBy: deltaY];
		[transform rotateByDegrees: 15 * i];
		[transform translateXBy: -deltaX yBy: -deltaY];
		[path transformUsingAffineTransform:transform];
		
		if ([progressIndicator isRunning])
		{
			if (i == [progressIndicator theIndex]) 
				[[self progressIndicatorIndeterminateSpinColorA] set];
			else if ((i + 1) % (MAX_Count + 1) == [progressIndicator theIndex])
				[[self progressIndicatorIndeterminateSpinColorB] set];
			else if ((i + 2 ) % (MAX_Count + 1) == [progressIndicator theIndex])
				[[self progressIndicatorIndeterminateSpinColorC] set];
			else if ((i + 3 ) % (MAX_Count + 1) == [progressIndicator theIndex])
				[[self progressIndicatorIndeterminateSpinColorD] set];
			else
				[[self progressIndicatorIndeterminateSpinColor] set];
		}
		else
			[[self progressIndicatorDisabledColor] set];
		
		[path transformUsingAffineTransform: transform];
		[path fill];
		[transform release];
	}
}

@end
