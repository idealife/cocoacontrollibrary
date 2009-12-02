//
//  KABlackFadeTabView.m
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

#import "KATabView.h"
#import "KAGradient.h"

#define Radius 3 
@implementation KATabView

static NSString *grayTab = @"graytab.png";
static NSString *redTab = @"redtab.png";

-(void)_drawThemeTab:(id) tabItem withState:(unsigned int) state inRect:(NSRect) aRect {
	
	int index = [self indexOfTabViewItem: tabItem];
	int gradientAngle = 90;
	NSBezierPath *path;
	
	aRect = NSInsetRect(aRect, 0.2f, (aRect.size.height - 20)/2);
	
	
	if([self tabViewType] == NSLeftTabsBezelBorder) {
		
		gradientAngle = 0;
	} else if([self tabViewType] == NSRightTabsBezelBorder) {
		
		gradientAngle = 180;
	}
	if(index == 0 && index == ([self numberOfTabViewItems] -1))
	{
		path = [[NSBezierPath alloc] init];
		
		if([self tabViewType] == NSRightTabsBezelBorder ||
		   [self tabViewType] == NSLeftTabsBezelBorder) {
			
			[path moveToPoint: NSMakePoint(NSMaxX(aRect)-Radius, NSMaxY(aRect))];
			[path lineToPoint: NSMakePoint(NSMinX(aRect)+Radius, NSMaxY(aRect))];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(aRect)+Radius, NSMaxY(aRect)-Radius)
											 radius: Radius
										 startAngle: 90 
										   endAngle: 180];
			[path lineToPoint: NSMakePoint(NSMinX(aRect), NSMinY(aRect) +Radius)];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(aRect) +Radius, NSMinY(aRect) +Radius)
											 radius: Radius
										 startAngle: 180
										   endAngle: 270];
			[path lineToPoint: NSMakePoint(NSMaxX(aRect) -Radius, NSMinY(aRect))];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(aRect) -Radius, NSMinY(aRect) +Radius)
											 radius: Radius
										 startAngle: 270
										   endAngle: 0];
			[path lineToPoint: NSMakePoint(NSMaxX(aRect), NSMaxY(aRect)-Radius)];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(aRect) -Radius, NSMaxY(aRect) -Radius)
											 radius: Radius
										 startAngle: 0
										   endAngle: 90];
		} 
		else 
		{
			
			[path moveToPoint: NSMakePoint(NSMaxX(aRect), NSMinY(aRect) +Radius)];
			[path lineToPoint: NSMakePoint(NSMaxX(aRect), NSMaxY(aRect) -Radius)];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(aRect) -Radius, NSMaxY(aRect) -Radius)
											 radius: Radius
										 startAngle: 0
										   endAngle: 90];
			[path lineToPoint: NSMakePoint(NSMinX(aRect) + Radius, NSMaxY(aRect))];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(aRect) +Radius, NSMaxY(aRect) -Radius)
											 radius: Radius
										 startAngle: 90
										   endAngle: 180];
			[path lineToPoint: NSMakePoint(NSMinX(aRect), NSMinY(aRect) +Radius)];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(aRect) +Radius, NSMinY(aRect) +Radius)
											 radius: Radius
										 startAngle: 180
										   endAngle: 270];
			[path lineToPoint: NSMakePoint(NSMaxX(aRect) - Radius, NSMinY(aRect))];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(aRect) -Radius, NSMinY(aRect) +Radius)
											 radius: Radius
										 startAngle: 270
										   endAngle: 0];
		}
		
		[path closePath];
		
		if(state == 0) {
			
			KAGradient *mygradient = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithCalibratedRed:0.855f green:0.133f blue:0.0f alpha:1.0]
																	endingColor: [NSColor colorWithCalibratedRed:0.246f green:0.125f blue:0.0977f alpha:1.0]] autorelease];
			[mygradient drawInBezierPath:path angle:gradientAngle];
			//NSRect picBox = {{0,0},{0,0}};
			//picBox.size = [unSelectTab size];
		//	NSImage *toBeDraw = [NSImage imageNamed:redTab];
			//[toBeDraw setSize:NSMakeSize(aRect.size.width-20, aRect.size.height)];
		//	[toBeDraw drawInRect:aRect fromRect:NSZeroRect operation:1 fraction:1.0];
			//[[NSImage imageNamed:redTab] ;
		} else {
			KAGradient *unSelectTab = [[[KAGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.3398 
																										   green:0.3398
																											blue:0.3516 
																										   alpha:1.0]
																	 endingColor:[NSColor colorWithCalibratedRed:0.2353 
																										   green:0.2353
																											blue:0.2353 
																										   alpha:1.0]
										] autorelease];
			[unSelectTab addColorStop:[NSColor colorWithCalibratedRed:0.1569 
																green:0.1569 
																 blue:0.1569 
																alpha:1.0] 
						   atPosition:0.5];
			[unSelectTab drawInRect:aRect angle:gradientAngle];
			
/*******************************************************************************
 * KAGradient *mygradient = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithCalibratedRed:0.3398f green:0.3437f blue:0.3516f alpha:1.0]
 * 																	endingColor: [NSColor colorWithCalibratedRed:0.234f green:0.234f blue:0.234f alpha:1.0]] autorelease];
 * 			//[mygradient drawInBezierPath:path angle:gradientAngle];
 * 			
 * 			NSString *file = [[NSBundle mainBundle] pathForImageResource:@"UnselectedTab"];
 * 			NSImage *unSelectTab = [[NSImage alloc] initWithContentsOfFile:file];
 * 			NSRect picBox = {{0,0},{0,0}};
 * 			picBox.size = [unSelectTab size];
 * 			[unSelectTab drawInRect:aRect fromRect:picBox operation:NSCompositeCopy fraction:1.0];
 * 			[unSelectTab release];
 ******************************************************************************/
		}
		
		[[NSColor blackColor] set];
		//[[NSColor colorWithCalibratedRed:0.361f green:0.361f blue:0.361f alpha:1] set];
		[path stroke];
		
		[path release];
	}
	else if(index == 0 && index != ([self numberOfTabViewItems] -1)) 
	{
		
		path = [[NSBezierPath alloc] init];
		
		if([self tabViewType] == NSRightTabsBezelBorder ||
		   [self tabViewType] == NSLeftTabsBezelBorder) {
			
			[path moveToPoint: NSMakePoint(NSMaxX(aRect), NSMaxY(aRect))];
			[path lineToPoint: NSMakePoint(NSMinX(aRect), NSMaxY(aRect))];
			[path lineToPoint: NSMakePoint(NSMinX(aRect), NSMinY(aRect) +Radius)];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(aRect) +Radius, NSMinY(aRect) +Radius)
											 radius: Radius
										 startAngle: 180
										   endAngle: 270];
			[path lineToPoint: NSMakePoint(NSMaxX(aRect) -Radius, NSMinY(aRect))];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(aRect) -Radius, NSMinY(aRect) +Radius)
											 radius: Radius
										 startAngle: 270
										   endAngle: 0];
		} else {
			
			[path moveToPoint: NSMakePoint(NSMaxX(aRect), NSMinY(aRect))];
			
			[path lineToPoint: NSMakePoint(NSMaxX(aRect), NSMaxY(aRect))];
			[path lineToPoint: NSMakePoint(NSMinX(aRect) + Radius, NSMaxY(aRect))];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(aRect) +Radius, NSMaxY(aRect) -Radius)
											 radius: Radius
										 startAngle: 90
										   endAngle: 180];
			[path lineToPoint: NSMakePoint(NSMinX(aRect), NSMinY(aRect) +Radius)];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(aRect) +Radius, NSMinY(aRect) +Radius)
											 radius: Radius
										 startAngle: 180
										   endAngle: 270];
		}
		
		[path closePath];
		
		if(state == 0) {
			
			//KAGradient *mygradient = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithCalibratedRed:0.855f green:0.133f blue:0.0f alpha:1.0]
			//														endingColor: [NSColor colorWithCalibratedRed:0.246f green:0.125f blue:0.0977f alpha:1.0]] autorelease];
			//[mygradient drawInBezierPath:path angle:gradientAngle];
			NSString *file = [[NSBundle bundleForClass:[self class]]  pathForImageResource:redTab];
			NSImage *tempTab = [[NSImage alloc] initWithContentsOfFile:file];
			[tempTab drawInRect:aRect fromRect:NSMakeRect(0, 0, aRect.size.width, aRect.size.height) operation:5 fraction:1.0];
			[tempTab release];
		} else {
			/*KAGradient *unSelectTab = [[[KAGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.3398 
																										   green:0.3398
																											blue:0.3516 
																										   alpha:1.0]
																	 endingColor:[NSColor colorWithCalibratedRed:0.2353 
																										   green:0.2353
																											blue:0.2353 
																										   alpha:1.0]
										] autorelease];
			[unSelectTab addColorStop:[NSColor colorWithCalibratedRed:0.1569 
																green:0.1569 
																 blue:0.1569 
																alpha:1.0] 
						   atPosition:0.5];
			[unSelectTab drawInBezierPath:path angle:gradientAngle];*/
			NSString *file = [[NSBundle bundleForClass:[self class]] pathForImageResource:grayTab];
			NSImage *tempTab = [[NSImage alloc] initWithContentsOfFile:file];
			[tempTab drawInRect:aRect fromRect:NSMakeRect(0, 0, aRect.size.width, aRect.size.height) operation:5 fraction:1.0];
			[tempTab release];
			
/*******************************************************************************
 * KAGradient *mygradient = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithCalibratedRed:0.3398f green:0.3437f blue:0.3516f alpha:1.0]
 * 																	endingColor: [NSColor colorWithCalibratedRed:0.234f green:0.234f blue:0.234f alpha:1.0]] autorelease];
 * 			//[mygradient drawInBezierPath:path angle:gradientAngle];			
 * 			NSString *file = [[NSBundle mainBundle] pathForImageResource:@"UnselectedTab"];
 * 			NSImage *unSelectTab = [[NSImage alloc] initWithContentsOfFile:file];
 * 			NSRect picBox = {{0,0},{0,0}};
 * 			picBox.size = [unSelectTab size];
 * 			[unSelectTab drawInRect:aRect fromRect:picBox operation:NSCompositeCopy fraction:1.0];
 * 			[unSelectTab release];
 ******************************************************************************/
		}
		
		[[NSColor blackColor] set];
		//[[NSColor colorWithCalibratedRed:0.361f green:0.361f blue:0.361f alpha:1] set];
		[path stroke];
		
		[path release];
	} else if(index > 0 && index < ([self numberOfTabViewItems] -1)) {
		
		/*if([self tabViewType] == NSRightTabsBezelBorder ||
		   [self tabViewType] == NSLeftTabsBezelBorder) {
			
			aRect.origin.y -= 0.5f;
			aRect.size.height += 0.5f;
			
		} else {
			
			aRect.origin.x -= 0.5f;
			aRect.size.width += 0.5f;
		}*/
		
		if(state == 0) {
			
			//KAGradient *mygradient = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithCalibratedRed:0.855f green:0.133f blue:0.0f alpha:1.0]
			//														endingColor: [NSColor colorWithCalibratedRed:0.246f green:0.125f blue:0.0977f alpha:1.0]] autorelease];
			//[mygradient drawInRect:aRect angle:gradientAngle];
			NSString *file = [[NSBundle bundleForClass:[self class]] pathForImageResource:redTab];
			NSImage *tempTab = [[NSImage alloc] initWithContentsOfFile:file];
			[tempTab drawInRect:aRect fromRect:NSMakeRect(5, 0, aRect.size.width+5, aRect.size.height) operation:5 fraction:1.0];
			[tempTab release];
		} else {
			/*KAGradient *unSelectTab = [[[KAGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.3398 
																										   green:0.3398
																											blue:0.3516 
																										   alpha:1.0]
																	 endingColor:[NSColor colorWithCalibratedRed:0.2353 
																										   green:0.2353
																											blue:0.2353 
																										   alpha:1.0]
										] autorelease];
			[unSelectTab addColorStop:[NSColor colorWithCalibratedRed:0.1569 
																green:0.1569 
																 blue:0.1569 
																alpha:1.0] 
						   atPosition:0.5];
			[unSelectTab drawInRect:aRect angle:gradientAngle];*/
			NSString *file = [[NSBundle bundleForClass:[self class]] pathForImageResource:grayTab];
			NSImage *tempTab = [[NSImage alloc] initWithContentsOfFile:file];
			[tempTab drawInRect:aRect fromRect:NSMakeRect(5, 0, aRect.size.width+5, aRect.size.height) operation:5 fraction:1.0];
			[tempTab release];
			
/*******************************************************************************
 * KAGradient *mygradient = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithCalibratedRed:0.3398f green:0.3437f blue:0.3516f alpha:1.0]
 * 																	endingColor: [NSColor colorWithCalibratedRed:0.234f green:0.234f blue:0.234f alpha:1.0]] autorelease];
 * 			//[mygradient drawInRect:aRect angle:gradientAngle];			
 * 			NSString *file = [[NSBundle mainBundle] pathForImageResource:@"UnselectedTab"];
 * 			NSImage *unSelectTab = [[NSImage alloc] initWithContentsOfFile:file];
 * 			NSRect picBox = {{0,0},{0,0}};
 * 			picBox.size = [unSelectTab size];
 * 			[unSelectTab drawInRect:aRect fromRect:picBox operation:NSCompositeCopy fraction:1.0];
 * 			[unSelectTab release];
 ******************************************************************************/
		}
		
		//[[NSColor colorWithCalibratedRed:0.361f green:0.361f blue:0.361f alpha:1] set];
		[[NSColor blackColor] set];
		
		if([self tabViewType] == NSRightTabsBezelBorder ||
		   [self tabViewType] == NSLeftTabsBezelBorder) {
			
			[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMinX(aRect), NSMinY(aRect))
									  toPoint: NSMakePoint(NSMinX(aRect), NSMaxY(aRect))];
			[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMinX(aRect), NSMaxY(aRect))
									  toPoint: NSMakePoint(NSMaxX(aRect), NSMaxY(aRect))];
			[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMaxX(aRect), NSMaxY(aRect))
									  toPoint: NSMakePoint(NSMaxX(aRect), NSMinY(aRect))];
			
		} else {
			
			[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMinX(aRect), NSMinY(aRect))
									  toPoint: NSMakePoint(NSMaxX(aRect), NSMinY(aRect))];
			[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMaxX(aRect), NSMinY(aRect))
									  toPoint: NSMakePoint(NSMaxX(aRect), NSMaxY(aRect))];
			[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMinX(aRect), NSMaxY(aRect))
									  toPoint: NSMakePoint(NSMaxX(aRect), NSMaxY(aRect))];
		}
		
	} else if(index == ([self numberOfTabViewItems] -1) && index != 0) {
		
		path = [[NSBezierPath alloc] init];
		
		if([self tabViewType] == NSRightTabsBezelBorder ||
		   [self tabViewType] == NSLeftTabsBezelBorder) {
			
			aRect.origin.y -= 1;
			
			[path moveToPoint: NSMakePoint(NSMaxX(aRect), NSMinY(aRect))];
			[path lineToPoint: NSMakePoint(NSMinX(aRect), NSMinY(aRect))];
			[path lineToPoint: NSMakePoint(NSMinX(aRect), NSMaxY(aRect) -Radius)];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(aRect) +Radius, NSMaxY(aRect) -Radius)
											 radius: Radius
										 startAngle: 180
										   endAngle: 90
										  clockwise: YES];
			[path lineToPoint: NSMakePoint(NSMaxX(aRect) -Radius, NSMaxY(aRect))];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(aRect) -Radius, NSMaxY(aRect) -Radius)
											 radius: Radius
										 startAngle: 90
										   endAngle: 0
										  clockwise: YES];
			
		} else {
			aRect.origin.x -= 1;
			aRect.size.width += 1;
			[path moveToPoint: NSMakePoint(NSMinX(aRect), NSMinY(aRect))];
			[path lineToPoint: NSMakePoint(NSMinX(aRect), NSMaxY(aRect))];
			[path lineToPoint: NSMakePoint(NSMaxX(aRect) - Radius, NSMaxY(aRect))];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(aRect) -Radius, NSMaxY(aRect) -Radius)
											 radius: Radius
										 startAngle: 90
										   endAngle: 0
										  clockwise: YES];
			[path lineToPoint: NSMakePoint(NSMaxX(aRect), NSMinY(aRect) +Radius)];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(aRect) -Radius, NSMinY(aRect) +Radius)
											 radius: Radius
										 startAngle: 0
										   endAngle: 270
										  clockwise: YES];
		}
		
		[path closePath];
		
		if(state == 0) {
			
			//KAGradient *mygradient = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithCalibratedRed:0.851f green:0.137f blue:0.0f alpha:1.0]
			//														endingColor: [NSColor colorWithCalibratedRed:0.251f green:0.129f blue:0.122f alpha:1.0]] autorelease];
			//[mygradient drawInBezierPath:path angle:gradientAngle];
			NSString *file = [[NSBundle bundleForClass:[self class]] pathForImageResource:redTab];
			NSImage *tempTab = [[NSImage alloc] initWithContentsOfFile:file];
			[tempTab drawInRect:aRect fromRect:NSMakeRect(tempTab.size.width - aRect.size.width, 0, aRect.size.width, aRect.size.height) operation:5 fraction:1.0];
			//NSLog(@"%f,%f",tobeDraw.size.width , aRect.size.width);
			[tempTab release];
			
		} else {
			
			/*KAGradient *unSelectTab = [[[KAGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.3398 
																										   green:0.3398
																											blue:0.3516 
																										   alpha:1.0]
																	 endingColor:[NSColor colorWithCalibratedRed:0.2353 
																										   green:0.2353
																											blue:0.2353 
																										   alpha:1.0]
									   ] autorelease];
			[unSelectTab addColorStop:[NSColor colorWithCalibratedRed:0.1569 
																green:0.1569 
																 blue:0.1569 
																alpha:1.0] 
						   atPosition:0.5];
			[unSelectTab drawInBezierPath:path angle:gradientAngle];*/
									   
			NSString *file = [[NSBundle bundleForClass:[self class]] pathForImageResource:grayTab];
			NSImage *tempTab = [[NSImage alloc] initWithContentsOfFile:file];
			[tempTab drawInRect:aRect fromRect:NSMakeRect(tempTab.size.width - aRect.size.width, 0, aRect.size.width, aRect.size.height) operation:5 fraction:1.0];	
			//NSLog(@"%f,%f",aRect.size.width,tobeDraw.size.width);
			[tempTab release];
			//KAGradient *mygradient = [[[KAGradient alloc] initWithStartingColor: [NSColor colorWithCalibratedRed:0.3398f green:0.3437f blue:0.3516f alpha:1.0]
//																	endingColor: [NSColor colorWithCalibratedRed:0.234f green:0.234f blue:0.234f alpha:1.0]] autorelease];
//			//[mygradient drawInBezierPath:path angle:gradientAngle];
//			NSString *file = [[NSBundle mainBundle] pathForImageResource:@"UnselectedTab"];
//			NSImage *unSelectTab = [[NSImage alloc] initWithContentsOfFile:file];
//			NSRect picBox = {{0,0},{0,0}};
//			picBox.size = [unSelectTab size];
//			[unSelectTab drawInRect:aRect fromRect:picBox operation:NSCompositeCopy fraction:0.0];		
//			[unSelectTab release];
		}
		[[NSColor blackColor] set];
		//[[NSColor colorWithCalibratedRed:0.361f green:0.361f blue:0.361f alpha:1] set];
		[path stroke];
		
		[path release];
	}	
}

- (NSShadow*) bottomLeftBorderShadow
{
	NSShadow* theShadow = [[NSShadow alloc] init];
	[theShadow setShadowColor: [NSColor colorWithCalibratedRed: 0.0 green: 0.0 blue:0.0 alpha: 1.0f]];
	[theShadow setShadowOffset: NSMakeSize(-1, -1)];
	[theShadow setShadowBlurRadius: 3];
	
	return [theShadow autorelease];
}

- (NSShadow*) topRightBorderShadow
{
	
	NSShadow* theShadow = [[NSShadow alloc] init];
	[theShadow setShadowColor: [NSColor colorWithCalibratedRed: 0.4 green: 0.4 blue:0.4 alpha: 1.0f]];
	[theShadow setShadowOffset: NSMakeSize(1, 1)];
	[theShadow setShadowBlurRadius: 1];
	
	return [theShadow autorelease];
}

#define KAPointWithOffset(pt,xOffset,yOffset) NSMakePoint((pt).x + (xOffset), (pt).y + (yOffset))

- (void)_drawBorder:(id)arg1 inRect:(NSRect)arg2
{
	return;
	//KAInfo(@"_drawBorder arg1:%@, arg2:%f, %f, %f, %f", arg1, arg2.origin.x, arg2.origin.y, arg2.size.width, arg2.size.height);
	NSRect borderRect = [self contentRect];
	borderRect = NSInsetRect(borderRect, -15, 0);
	borderRect.origin.y -= 15;
	borderRect.size.height += 35;
	
	static const int cornerRadius = 5;
	NSColor* borderColor = [NSColor colorWithCalibratedRed: 0.2f green: 0.2f blue: 0.2f alpha: 1.0];
	// point stones
	NSPoint stone0 = borderRect.origin;
	NSPoint stone1 = KAPointWithOffset(stone0, 0, borderRect.size.height);
	NSPoint stone2 = KAPointWithOffset(stone0, borderRect.size.width, borderRect.size.height);
	NSPoint stone3 = KAPointWithOffset(stone0, borderRect.size.width, 0);
	
	NSPoint corner0Begin = KAPointWithOffset(stone0,  cornerRadius,  0);
	NSPoint corner0End = KAPointWithOffset(stone0, 0, cornerRadius);
	NSPoint corner1Begin = KAPointWithOffset(stone1, 0, -cornerRadius);
	NSPoint corner1End = KAPointWithOffset(stone1,  cornerRadius, 0);
	NSPoint corner2Begin = KAPointWithOffset(stone2, -cornerRadius,  0);
	NSPoint corner2End = KAPointWithOffset(stone2,  0, -cornerRadius);
	NSPoint corner3Begin = KAPointWithOffset(stone3, 0, cornerRadius);
	NSPoint corner3End = KAPointWithOffset(stone3, -cornerRadius, 0);
	
	if ([self isFlipped])
	{
		// bottom left border
		NSBezierPath* blPath = [NSBezierPath bezierPath];
		[blPath moveToPoint: corner0Begin];
		[blPath appendBezierPathWithArcFromPoint: stone0 toPoint: corner0End radius: cornerRadius];
		[blPath lineToPoint: corner1Begin];
		[blPath appendBezierPathWithArcFromPoint: stone1 toPoint: corner1End radius: cornerRadius];
		[blPath lineToPoint: corner2Begin];
		[borderColor set];
		[[self bottomLeftBorderShadow] set];
		[blPath stroke];
		
		// top left border
		NSBezierPath* trPath = [NSBezierPath bezierPath];
		[trPath moveToPoint: corner2Begin];
		[trPath appendBezierPathWithArcFromPoint: stone2 toPoint: corner2End radius: cornerRadius];
		[trPath lineToPoint: corner3Begin];
		[trPath appendBezierPathWithArcFromPoint: stone3 toPoint: corner3End radius: cornerRadius];
		[trPath lineToPoint: corner0Begin];
		[borderColor set];
		[[self topRightBorderShadow] set];
		[trPath stroke];
	}
	else
	{
		// bottom left border
		NSBezierPath* blPath = [NSBezierPath bezierPath];
		[blPath moveToPoint: corner0Begin];
		[blPath appendBezierPathWithArcFromPoint: stone0 toPoint: corner0End radius: cornerRadius];
		[blPath lineToPoint: corner1Begin];
		[blPath appendBezierPathWithArcFromPoint: stone1 toPoint: corner1End radius: cornerRadius];
		[blPath moveToPoint: corner3End];
		[blPath lineToPoint: corner0Begin];
		[borderColor set];
		[[self bottomLeftBorderShadow] set];
		[blPath stroke];
		
		// top right border
		NSBezierPath* trPath = [NSBezierPath bezierPath];
		[trPath moveToPoint: corner1End];
		[trPath lineToPoint: corner2Begin];
		[trPath appendBezierPathWithArcFromPoint: stone2 toPoint: corner2End radius: cornerRadius];
		[trPath lineToPoint: corner3Begin];
		[trPath appendBezierPathWithArcFromPoint: stone3 toPoint: corner3End radius: cornerRadius];
		[borderColor set];
		[[self topRightBorderShadow] set];
		[trPath stroke];
	}
}

@end
