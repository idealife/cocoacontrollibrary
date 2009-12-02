//
//  NSBezierPath+RoundedRect.m
//  ColoredControlsDemo
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

#import "NSBezierPath+RoundedRect.h"


@implementation NSBezierPath (RoundedRect)

+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius
{
    NSBezierPath *result = [NSBezierPath bezierPath];
    [result appendBezierPathWithRoundedRect:rect cornerRadius:radius];
    return result;
}

+ (NSBezierPath *) bezierPathWithRoundedRect: (NSRect)aRect cornerRadius: (float)radius inCorners:(OSCornerType)corners
{
	NSBezierPath* path = [self bezierPath];
	radius = MIN(radius, 0.5f * MIN(NSWidth(aRect), NSHeight(aRect)));
	NSRect rect = NSInsetRect(aRect, radius, radius);
	
	if (corners & OSBottomLeftCorner)
	{
		[path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMinY(rect)) radius:radius startAngle:180.0 endAngle:270.0];
	}
	else
	{
		NSPoint cornerPoint = NSMakePoint(NSMinX(aRect), NSMinY(aRect));
		[path appendBezierPathWithPoints:&cornerPoint count:1];
	}
	
	if (corners & OSBottomRightCorner)
	{
		[path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMinY(rect)) radius:radius startAngle:270.0 endAngle:360.0];
	}
	else
	{
		NSPoint cornerPoint = NSMakePoint(NSMaxX(aRect), NSMinY(aRect));
		[path appendBezierPathWithPoints:&cornerPoint count:1];
	}
	
	if (corners & OSTopRightCorner)
	{
		[path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMaxY(rect)) radius:radius startAngle:  0.0 endAngle: 90.0];
	}
	else
	{
		NSPoint cornerPoint = NSMakePoint(NSMaxX(aRect), NSMaxY(aRect));
		[path appendBezierPathWithPoints:&cornerPoint count:1];
	}
	
	if (corners & OSTopLeftCorner)
	{
		[path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMaxY(rect)) radius:radius startAngle: 90.0 endAngle:180.0];
	}
	else
	{
		NSPoint cornerPoint = NSMakePoint(NSMinX(aRect), NSMaxY(aRect));
		[path appendBezierPathWithPoints:&cornerPoint count:1];
	}
	
	[path closePath];
	return path;	
}

+ (NSBezierPath *)bezierPathWithTopHalfRoundedRect:(NSRect)rect cornerRadius:(float)radius
{
    NSBezierPath *result = [NSBezierPath bezierPath];
    [result appendBezierPathWithTopHalfRoundedRect:rect cornerRadius:radius];
    return result;
}

+ (NSBezierPath *)bezierPathWithBottomHalfRoundedRect:(NSRect)rect cornerRadius:(float)radius
{
    NSBezierPath *result = [NSBezierPath bezierPath];
    [result appendBezierPathWithBottomHalfRoundedRect:rect cornerRadius:radius];
    return result;
}

/*
- (void)appendBezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius 
{
    if (!NSIsEmptyRect(rect)) 
	{
		if (radius > 0.0)
		{
			// Clamp radius to be no larger than half the rect's width or height.
			float clampedRadius = MIN(radius, 0.5 * MIN(rect.size.width, rect.size.height));
			
			NSPoint topLeft = NSMakePoint(NSMinX(rect), NSMaxY(rect));
			NSPoint topRight = NSMakePoint(NSMaxX(rect), NSMaxY(rect));
			NSPoint bottomRight = NSMakePoint(NSMaxX(rect), NSMinY(rect));
			
			[self moveToPoint:NSMakePoint(NSMidX(rect), NSMaxY(rect))];
			[self appendBezierPathWithArcFromPoint:topLeft toPoint:rect.origin radius:clampedRadius];
			[self appendBezierPathWithArcFromPoint:rect.origin toPoint:bottomRight radius:clampedRadius]; 
			[self appendBezierPathWithArcFromPoint:bottomRight toPoint:topRight radius:clampedRadius]; 
			[self appendBezierPathWithArcFromPoint:topRight toPoint:topLeft radius:clampedRadius];
			[self closePath];
		} 
		else
		{
			// When radius == 0.0, this degenerates to the simple case of a plain rectangle.
			[self appendBezierPathWithRect:rect];
		}
    }
}
*/

- (void)appendBezierPathWithTopHalfRoundedRect:(NSRect)rect cornerRadius:(float)radius 
{
	if (NSIsEmptyRect(rect)) return;
	
	if (radius <= 0)
	{
		[self appendBezierPathWithRect: rect];
	}
	else
	{
		if (rect.size.width <= radius || rect.size.height <= radius)
			radius = rect.size.width < rect.size.height ? rect.size.width / 2 : rect.size.height / 2;
		
		// left top
		NSPoint topLeftCenter = rect.origin;
		topLeftCenter.x += radius;
		topLeftCenter.y += radius;
		[self appendBezierPathWithArcWithCenter: topLeftCenter radius: radius startAngle: 180 endAngle: 270];
		
		// top
		NSPoint topEnd = rect.origin;
		topEnd.x += rect.size.width - radius;
		[self lineToPoint: topEnd];
		
		// top right
		NSPoint topRightCenter = rect.origin;
		topRightCenter.x += rect.size.width - radius;
		topRightCenter.y += radius;
		[self appendBezierPathWithArcWithCenter: topRightCenter radius: radius startAngle: 270 endAngle: 360];
		
		// right
		NSPoint rightEnd = rect.origin;
		rightEnd.x += rect.size.width;
		rightEnd.y += rect.size.height / 2.0f;
		[self lineToPoint: rightEnd];
		
		// bottom
		NSPoint bottomEnd = rect.origin;
		//bottomEnd.x += rect.size.width - radius;
		bottomEnd.y += rect.size.height / 2.0f;
		[self lineToPoint: bottomEnd];
				
		[self closePath];
	}
}

- (void)appendBezierPathWithBottomHalfRoundedRect:(NSRect)rect cornerRadius:(float)radius 
{
	if (NSIsEmptyRect(rect)) return;
	
	if (radius <= 0)
	{
		[self appendBezierPathWithRect: rect];
	}
	else
	{
		if (rect.size.width <= radius || rect.size.height <= radius)
			radius = rect.size.width < rect.size.height ? rect.size.width / 2 : rect.size.height / 2;
		
		// bottom right
		NSPoint bottomRightCenter = rect.origin;
		 bottomRightCenter.x += rect.size.width - radius;
		 bottomRightCenter.y += rect.size.height - radius;
		 [self appendBezierPathWithArcWithCenter: bottomRightCenter radius: radius startAngle: 0 endAngle: 90];
		
		// bottom
		NSPoint bottomEnd = rect.origin;
		bottomEnd.x += rect.size.width - radius;
		bottomEnd.y += rect.size.height;
		[self lineToPoint: bottomEnd];
		
		// bottom left
		NSPoint bottomLeftCenter = rect.origin;
		 bottomLeftCenter.x += radius;
		 bottomLeftCenter.y += rect.size.height - radius;
		 [self appendBezierPathWithArcWithCenter: bottomLeftCenter radius: radius startAngle: 90 endAngle: 180];
		
		// left
		NSPoint rightEnd = rect.origin;
		//rightEnd.x += rect.size.width;
		rightEnd.y += rect.size.height / 2.0f;
		[self lineToPoint: rightEnd];
		
		// top
		NSPoint topEnd = rect.origin;
		topEnd.x += rect.size.width;
		topEnd.y += rect.size.height / 2.0f;
		[self lineToPoint: topEnd];
		
		[self closePath];
	}
}

- (void)appendBezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius 
{
	if (NSIsEmptyRect(rect)) return;
	
	if (radius <= 0)
	{
		[self appendBezierPathWithRect: rect];
	}
	else
	{
		if (rect.size.width <= radius || rect.size.height <= radius)
			radius = rect.size.width < rect.size.height ? rect.size.width / 2 : rect.size.height / 2;
		
		// left top
		NSPoint topLeftCenter = rect.origin;
		topLeftCenter.x += radius;
		topLeftCenter.y += radius;
		[self appendBezierPathWithArcWithCenter: topLeftCenter radius: radius startAngle: 180 endAngle: 270];
		
		// top
		NSPoint topEnd = rect.origin;
		topEnd.x += rect.size.width - radius;
		[self lineToPoint: topEnd];
		
		// top right
		NSPoint topRightCenter = rect.origin;
		topRightCenter.x += rect.size.width - radius;
		topRightCenter.y += radius;
		[self appendBezierPathWithArcWithCenter: topRightCenter radius: radius startAngle: 270 endAngle: 360];
		
		// right
		NSPoint rightEnd = rect.origin;
		rightEnd.x += rect.size.width;
		rightEnd.y += rect.size.height - radius;
		[self lineToPoint: rightEnd];
		
		// bottom right
		NSPoint bottomRightCenter = rect.origin;
		bottomRightCenter.x += rect.size.width - radius;
		bottomRightCenter.y += rect.size.height - radius;
		[self appendBezierPathWithArcWithCenter: bottomRightCenter radius: radius startAngle: 0 endAngle: 90];
		
		// bottom
		NSPoint bottomEnd = rect.origin;
		bottomEnd.x += rect.size.width - radius;
		bottomEnd.y += rect.size.height;
		[self lineToPoint: bottomEnd];
		
		// bottom left
		NSPoint bottomLeftCenter = rect.origin;
		bottomLeftCenter.x += radius;
		bottomLeftCenter.y += rect.size.height - radius;
		[self appendBezierPathWithArcWithCenter: bottomLeftCenter radius: radius startAngle: 90 endAngle: 180];
		
		[self closePath];
	}
	
	
}
@end