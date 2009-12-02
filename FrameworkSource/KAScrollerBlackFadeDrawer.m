//
//  KAScrollerBlackFadeDrawer.m
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

#import "KAScrollerBlackFadeDrawer.h"
#import "KAScroller.h"
#import "KAGradient.h"

float BGCenterX(NSRect aRect) {
	return (aRect.size.width / 2);
}

float BGCenterY(NSRect aRect) {
	return (aRect.size.height / 2);
}

@implementation KAScrollerBlackFadeDrawer
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
	KAScroller *scroller = (KAScroller *) control;
	
	internalScrollerFlag = [scroller scrollerFlags];
	arrowPosition = [[[NSUserDefaults standardUserDefaults] 
					  persistentDomainForName: NSGlobalDomain] 
					 valueForKey: @"AppleScrollBarVariant"];
	
	if(arrowPosition == nil) {
		
		arrowPosition = @"DoubleMax";
	}
	
	if([scroller bounds].size.width > [scroller bounds].size.height) {
		
		internalScrollerFlag.isHoriz = 1;
		internalScrollerFlag.partsUsable = NSAllScrollerParts;
		
		//Now Figure out if we can actually show all parts
		float arrowSpace = NSWidth([scroller rectForPart: NSScrollerIncrementLine]) 
		+ NSWidth([scroller rectForPart: NSScrollerDecrementLine]) 
		+ BGCenterY([scroller rectForPart: NSScrollerIncrementLine]);
		float knobSpace = NSWidth([scroller rectForPart: NSScrollerKnob]);
		
		if((arrowSpace + knobSpace) > NSWidth([scroller bounds])) 
		{
			if(arrowSpace > NSWidth([scroller bounds])) 
			{
				internalScrollerFlag.partsUsable = NSNoScrollerParts;
			} 
			else 
			{
				internalScrollerFlag.partsUsable = NSOnlyScrollerArrows;
			}
		}
		
	} else {
		
		internalScrollerFlag.isHoriz = 0;
		internalScrollerFlag.partsUsable = NSAllScrollerParts;
		
		//Now Figure out if we can actually show all parts
		float arrowSpace = NSHeight([scroller rectForPart: NSScrollerIncrementLine]) 
		+ NSHeight([scroller rectForPart: NSScrollerDecrementLine]) 
		+ BGCenterX([scroller rectForPart: NSScrollerIncrementLine]);
		float knobSpace = NSHeight([scroller rectForPart: NSScrollerKnob]);
		
		if((arrowSpace + knobSpace) > NSHeight([scroller bounds])) {
			
			if(arrowSpace > NSHeight([scroller bounds])) {
				
				internalScrollerFlag.partsUsable = NSNoScrollerParts;
			} else {
				
				internalScrollerFlag.partsUsable = NSOnlyScrollerArrows;
			}
		}
	}
	
	[scroller setScrollerFlags:internalScrollerFlag];
	internalScrollerFlag = [scroller scrollerFlags];
	
	NSDisableScreenUpdates();
	
	[[NSColor colorWithCalibratedWhite: 0.0f alpha: 0.7f] set];
	NSRectFill([scroller bounds]);
	
	// Draw knob-slot.
	[self drawKnobSlotInRect: [scroller bounds] highlight: YES];
	
	// Draw knob
	[self drawKnob:scroller];
	
	// Draw arrows
	[self drawArrow: NSScrollerIncrementArrow highlightPart:([scroller hitPart] == NSScrollerIncrementLine) withScroller:scroller];
	[self drawArrow: NSScrollerDecrementArrow highlightPart:([scroller hitPart] == NSScrollerDecrementLine) withScroller:scroller];
	
	[[scroller window] invalidateShadow];
	
	NSEnableScreenUpdates();
}


- (void)drawKnob:(KAScroller *) scroller {
	if ([scroller knobProportion] < 0.01) return;
	
	if(internalScrollerFlag.isHoriz == 0) {
		//Draw Knob
		NSBezierPath *knob = [[NSBezierPath alloc] init];
		NSRect knobRect = [scroller rectForPart: NSScrollerKnob];
		
		[knob appendBezierPathWithArcWithCenter: NSMakePoint(knobRect.origin.x + ((knobRect.size.width - .5f) /2), (knobRect.origin.y + ((knobRect.size.width -2) /2)))
										 radius: (knobRect.size.width -2) /2
									 startAngle: 180
									   endAngle: 0];
		
		[knob appendBezierPathWithArcWithCenter: NSMakePoint(knobRect.origin.x + ((knobRect.size.width - .5f) /2), ((knobRect.origin.y + knobRect.size.height) - ((knobRect.size.width -2) /2)))
										 radius: (knobRect.size.width -2) /2
									 startAngle: 0
									   endAngle: 180];
		
		[[NSColor colorWithDeviceRed: 90.0/255 green: 90.0/255 blue: 90.0/255 alpha: 1.0f] set];
		[knob fill];
		
		knobRect.origin.x += 1;
		knobRect.origin.y += 1;
		knobRect.size.width -= 2;
		knobRect.size.height -= 2;
		
		[knob release];
		knob = [[NSBezierPath alloc] init];
		
		[knob appendBezierPathWithArcWithCenter: NSMakePoint(knobRect.origin.x + ((knobRect.size.width - .5f) /2), (knobRect.origin.y + ((knobRect.size.width -2) /2)))
										 radius: (knobRect.size.width -2) /2
									 startAngle: 180
									   endAngle: 0];
		
		[knob appendBezierPathWithArcWithCenter: NSMakePoint(knobRect.origin.x + ((knobRect.size.width - .5f) /2), ((knobRect.origin.y + knobRect.size.height) - ((knobRect.size.width -2) /2)))
										 radius: (knobRect.size.width -2) /2
									 startAngle: 0
									   endAngle: 180];
		
		if ([scroller mMouseEntered])
		{
			KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 153.0/255.0 green: 153.0/255.0 blue: 153.0/255.0 alpha: 1.0f]
																 endingColor:[NSColor colorWithDeviceRed: 153.0/255.0 green: 153.0/255.0 blue: 153.0/255.0 alpha: 1.0f]];
			[gradient drawInBezierPath: knob angle: 0];
			[gradient release];
		}
		else
		{
			KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 90.0/255.0 green: 90.0/255.0 blue: 90.0/255.0 alpha: 1.0f]
																 endingColor:[NSColor colorWithDeviceRed: 90.0/255.0 green: 90.0/255.0 blue: 90.0/255.0 alpha: 1.0f]];
			[gradient drawInBezierPath: knob angle: 0];
			[gradient release];
		}
		
		[knob release];
	} else {
		//Draw Knob
		NSBezierPath *knob = [[NSBezierPath alloc] init];
		NSRect knobRect = [scroller rectForPart: NSScrollerKnob];
		
		[knob appendBezierPathWithArcWithCenter: NSMakePoint(knobRect.origin.x + ((knobRect.size.height - .5f) /2), (knobRect.origin.y + ((knobRect.size.height -1) /2)))
										 radius: (knobRect.size.height -1) /2
									 startAngle: 90
									   endAngle: 270];
		
		[knob appendBezierPathWithArcWithCenter: NSMakePoint((knobRect.origin.x + knobRect.size.width) - ((knobRect.size.height - .5f) /2), (knobRect.origin.y + ((knobRect.size.height -1) /2)))
										 radius: (knobRect.size.height -1) /2
									 startAngle: 270
									   endAngle: 90];
		
		[[NSColor colorWithDeviceRed: 90.0/255 green: 90.0/255 blue: 90.0/255 alpha: 1.0f] set];
		[knob fill];
		
		knobRect.origin.x += 1;
		knobRect.origin.y += 1;
		knobRect.size.width -= 2;
		knobRect.size.height -= 2;
		
		[knob release];
		knob = [[NSBezierPath alloc] init];
		
		[knob appendBezierPathWithArcWithCenter: NSMakePoint(knobRect.origin.x + ((knobRect.size.height - .5f) /2), (knobRect.origin.y + ((knobRect.size.height -1) /2)))
										 radius: (knobRect.size.height -1) /2
									 startAngle: 90
									   endAngle: 270];
		
		[knob appendBezierPathWithArcWithCenter: NSMakePoint((knobRect.origin.x + knobRect.size.width) - ((knobRect.size.height - .5f) /2), (knobRect.origin.y + ((knobRect.size.height -1) /2)))
										 radius: (knobRect.size.height -1) /2
									 startAngle: 270
									   endAngle: 90];
		
		if ([scroller mMouseEntered])
		{
			KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 153.0/255.0 green: 153.0/255.0 blue: 153.0/255.0 alpha: 1.0f]
																 endingColor:[NSColor colorWithDeviceRed: 153.0/255.0 green: 153.0/255.0 blue: 153.0/255.0 alpha: 1.0f]];
			[gradient drawInBezierPath: knob angle: 90];
			[gradient release];
		}
		else
		{
			KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 90.0/255.0 green: 90.0/255.0 blue: 90.0/255.0 alpha: 1.0f]
																 endingColor:[NSColor colorWithDeviceRed: 90.0/255.0 green: 90.0/255.0 blue: 90.0/255.0 alpha: 1.0f]];
			[gradient drawInBezierPath: knob angle: 90];
			[gradient release];
		}
		
		[knob release];
	}
}

- (void)drawArrow:(NSScrollerArrow)arrow highlightPart:(int)part withScroller:(KAScroller*) scroller{
	
	if(arrow == NSScrollerDecrementArrow) {
		
		if(part == -1 || part == 0) {
			
			[self drawDecrementArrow:NO withScroller:scroller];
		} else {
			
			[self drawDecrementArrow:YES withScroller:scroller];
		}
	}
	
	if(arrow == NSScrollerIncrementArrow) {
		
		if(part == 0 || part == -1) {
			
			[self drawIncrementArrow:NO withScroller:scroller];
		} else {
			
			[self drawIncrementArrow:YES withScroller:scroller];
		}
	}
}

- (void)drawKnobSlotInRect:(NSRect)rect highlight:(BOOL)highlight {
	
	if(internalScrollerFlag.isHoriz == 0) {
		
		KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 48.0/255.0 green: 48.0/255.0 blue: 48.0/255.0 alpha: .75f]
															 endingColor: [NSColor colorWithDeviceRed: 48.0/255.0 green: 48.0/255.0 blue: 48.0/255.0 alpha: .75f]];
		//Draw Knob Slot
		[gradient drawInRect: rect angle: 0];
		[gradient release];
		
		if([arrowPosition isEqualToString: @"DoubleMax"]) {
			
			//Adjust rect height for top base
			rect.size.height = 8;
			
			//Draw Top Base
			NSBezierPath *path = [[NSBezierPath alloc] init];
			NSPoint basePoints[4];
			
			[path appendBezierPathWithArcWithCenter: NSMakePoint(rect.size.width /2, rect.size.height + (rect.size.width /2) -5)
											 radius: (rect.size.width ) /2
										 startAngle: 180
										   endAngle: 0];
			
			//Add the rest of the points
			basePoints[3] = NSMakePoint( rect.origin.x, rect.origin.y + rect.size.height);
			basePoints[2] = NSMakePoint( rect.origin.x, rect.origin.y);
			basePoints[1] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y);
			basePoints[0] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
			
			[path appendBezierPathWithPoints: basePoints count: 4];
			
			gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 95.0/255.0f green: 95.0/255.0 blue: 95.0/255.0 alpha: .25f]
																 endingColor:[NSColor colorWithDeviceRed: 85.0/255.0 green: 85.0/255.0 blue: 85.0/255.0 alpha: .25f]];
			[gradient drawInBezierPath: path angle: 0];
			[gradient release];
			
			[path release];
		}
	} else {
		
		KAGradient *gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 48.0/255.0 green: 48.0/255.0 blue: 48.0/255.0 alpha: .75f]
												 endingColor: [NSColor colorWithDeviceRed: 48.0/255.0 green: 48.0/255.0 blue: 48.0/255.0 alpha: .75f]];
		//Draw Knob Slot
		[gradient drawInRect: rect angle: 90];
		[gradient release];
		
		if([arrowPosition isEqualToString: @"DoubleMax"]) {
			
			//Adjust rect height for top base
			rect.size.width = 8;
			
			//Draw Top Base
			NSBezierPath *path = [[NSBezierPath alloc] init];
			NSPoint basePoints[4];
			
			[path appendBezierPathWithArcWithCenter: NSMakePoint((rect.size.height /2) +5, rect.origin.y + (rect.size.height /2) )
											 radius: (rect.size.height ) /2
										 startAngle: 90
										   endAngle: 270];
			
			//Add the rest of the points
			basePoints[2] = NSMakePoint( rect.origin.x, rect.origin.y + rect.size.height);
			basePoints[1] = NSMakePoint( rect.origin.x, rect.origin.y);
			basePoints[0] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y);
			basePoints[3] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
			
			[path appendBezierPathWithPoints: basePoints count: 4];
			
			gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 95.0/255.0f green: 95.0/255.0 blue: 95.0/255.0 alpha: .25f]
																 endingColor:[NSColor colorWithDeviceRed: 85.0/255.0 green: 85.0/255.0 blue: 85.0/255.0 alpha: .25f]];
			[gradient drawInBezierPath: path angle: 0];
			[gradient release];
			
			[path release];
		}
	}
}

- (void)drawDecrementArrow:(BOOL)highlighted withScroller:(KAScroller*) scroller{
	
	if(internalScrollerFlag.isHoriz == 0) {
		
		if([arrowPosition isEqualToString: @"DoubleMax"]) {
			
			//Draw Decrement Button
			NSRect rect = [scroller rectForPart: NSScrollerDecrementLine];
			NSBezierPath *path = [[NSBezierPath alloc] init];
			NSPoint basePoints[4];
			
			//Add Notch
			[path appendBezierPathWithArcWithCenter: NSMakePoint((rect.size.width ) /2, (rect.origin.y  - ((rect.size.width ) /2) + 1))
											 radius: (rect.size.width ) /2
										 startAngle: 0
										   endAngle: 180];
			
			//Add the rest of the points
			basePoints[0] = NSMakePoint( rect.origin.x, rect.origin.y);
			basePoints[1] = NSMakePoint( rect.origin.x, rect.origin.y + rect.size.height);
			basePoints[2] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
			basePoints[3] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y);
			
			//Add Points to Path
			[path appendBezierPathWithPoints: basePoints count: 4];
			
			//Fill Path
			if(!highlighted) 
			{
				KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 95.0/255.0f green: 95.0/255.0 blue: 95.0/255.0 alpha: .25f]
																	 endingColor:[NSColor colorWithDeviceRed: 85.0/255.0 green: 85.0/255.0 blue: 85.0/255.0 alpha: .25f]];
				[gradient drawInBezierPath: path angle: 0];
				[gradient release];
			} else 
			{
				KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 158.0/255.0 green: 158.0/255.0 blue: 158.0/255.0 alpha: 0.5f] 
																	 endingColor:[NSColor colorWithDeviceRed: 148.0/255.0 green: 148.0/255.0 blue: 148.0/255.0 alpha: 0.5f]];
				[gradient drawInBezierPath: path angle: 0];
				[gradient release];
			}
			
			//Create Arrow Glyph
			NSBezierPath *arrow = [[NSBezierPath alloc] init];
			
			NSPoint points[3];
			points[0] = NSMakePoint( rect.size.width /2, rect.origin.y + (rect.size.height /2) -3);
			points[1] = NSMakePoint( (rect.size.width /2) +3.5f, rect.origin.y + (rect.size.height /2) +3);
			points[2] = NSMakePoint( (rect.size.width /2) -3.5f, rect.origin.y + (rect.size.height /2) +3);
			
			[arrow appendBezierPathWithPoints: points count: 3];
			
			//[[scroller scrollerStroke] set];
			[[NSColor colorWithDeviceRed: 90.0/255 green: 90.0/255 blue: 90.0/255 alpha: 1.0f] set];
			[arrow fill];
			
			//Create Devider Line
			[[NSColor colorWithDeviceRed: 90.0/255 green: 90.0/255 blue: 90.0/255 alpha: 1.0f] set];
			
			[NSBezierPath strokeLineFromPoint: NSMakePoint(0, (rect.origin.y + rect.size.height) +.5f)
									  toPoint: NSMakePoint(rect.size.width, (rect.origin.y + rect.size.height) +.5f)];
			
			[path release];
			[arrow release];
			
		} else {
			
			NSRect rect = [scroller rectForPart: NSScrollerDecrementLine];
			
			NSBezierPath *path = [[NSBezierPath alloc] init];
			NSPoint basePoints[4];
			
			[path appendBezierPathWithArcWithCenter: NSMakePoint(rect.size.width /2, rect.size.height + (rect.size.width /2) -3)
											 radius: (rect.size.width ) /2
										 startAngle: 180
										   endAngle: 0];
			
			//Add the rest of the points
			basePoints[3] = NSMakePoint( rect.origin.x, rect.origin.y + rect.size.height);
			basePoints[2] = NSMakePoint( rect.origin.x, rect.origin.y);
			basePoints[1] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y);
			basePoints[0] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
			
			[path appendBezierPathWithPoints: basePoints count: 4];
			
			//Fill Path
			if(!highlighted) {
				KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 95.0/255.0f green: 95.0/255.0 blue: 95.0/255.0 alpha: .25f]
																	 endingColor:[NSColor colorWithDeviceRed: 85.0/255.0 green: 85.0/255.0 blue: 85.0/255.0 alpha: .25f]];
				[gradient drawInBezierPath: path angle: 0];
				[gradient release];
			} else {
				KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 158.0/255.0 green: 158.0/255.0 blue: 158.0/255.0 alpha: 0.5f] 
																	 endingColor:[NSColor colorWithDeviceRed: 148.0/255.0 green: 148.0/255.0 blue: 148.0/255.0 alpha: 0.5f]];
				[gradient drawInBezierPath: path angle: 0];
				[gradient release];
			}
			
			//Create Arrow Glyph
			NSBezierPath *arrow = [[NSBezierPath alloc] init];
			
			NSPoint points[3];
			points[0] = NSMakePoint( rect.size.width /2, rect.origin.y + (rect.size.height /2) -3);
			points[1] = NSMakePoint( (rect.size.width /2) +3.5f, rect.origin.y + (rect.size.height /2) +3);
			points[2] = NSMakePoint( (rect.size.width /2) -3.5f, rect.origin.y + (rect.size.height /2) +3);
			
			[arrow appendBezierPathWithPoints: points count: 3];
			
			[[NSColor colorWithDeviceRed: 90.0/255 green: 90.0/255 blue: 90.0/255 alpha: 1.0f] set];
			[arrow fill];
			
			[path release];
			[arrow release];
		}
	} else {
		
		if([arrowPosition isEqualToString: @"DoubleMax"]) {
			
			//Draw Decrement Button
			NSRect rect = [scroller rectForPart: NSScrollerDecrementLine];
			NSBezierPath *path = [[NSBezierPath alloc] init];
			NSPoint basePoints[4];
			
			//Add Notch
			[path appendBezierPathWithArcWithCenter: NSMakePoint(rect.origin.x - ((rect.size.height ) /2), (rect.origin.y  + ((rect.size.height ) /2) ))
											 radius: (rect.size.height ) /2
										 startAngle: 270
										   endAngle: 90];
			
			//Add the rest of the points
			basePoints[3] = NSMakePoint( rect.origin.x - (((rect.size.height ) /2) -1), rect.origin.y);
			basePoints[0] = NSMakePoint( rect.origin.x - (((rect.size.height ) /2) -1), rect.origin.y + rect.size.height);
			basePoints[1] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
			basePoints[2] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y);
			
			//Add Points to Path
			[path appendBezierPathWithPoints: basePoints count: 4];
			
			//Fill Path
			if(!highlighted) {
				KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 95.0/255.0f green: 95.0/255.0 blue: 95.0/255.0 alpha: .25f]
																	 endingColor:[NSColor colorWithDeviceRed: 85.0/255.0 green: 85.0/255.0 blue: 85.0/255.0 alpha: .25f]];
				[gradient drawInBezierPath: path angle: 90];
				[gradient release];
			} else {
				KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 158.0/255.0 green: 158.0/255.0 blue: 158.0/255.0 alpha: 0.5f] 
																	 endingColor:[NSColor colorWithDeviceRed: 148.0/255.0 green: 148.0/255.0 blue: 148.0/255.0 alpha: 0.5f]];
				[gradient drawInBezierPath: path angle: 90];
				[gradient release];
			}
			
			//Create Arrow Glyph
			NSBezierPath *arrow = [[NSBezierPath alloc] init];
			
			NSPoint points[3];
			points[0] = NSMakePoint( rect.origin.x + (rect.size.width /2) -3, rect.size.height /2);
			points[1] = NSMakePoint( rect.origin.x + (rect.size.height /2) +3, (rect.size.height /2) +3.5f);
			points[2] = NSMakePoint( rect.origin.x + (rect.size.height /2) +3, (rect.size.height /2) -3.5f);
			
			[arrow appendBezierPathWithPoints: points count: 3];
			
			[[NSColor colorWithDeviceRed: 90.0/255 green: 90.0/255 blue: 90.0/255 alpha: 1.0f] set];
			[arrow fill];
			
			//Create Devider Line
			[[NSColor colorWithDeviceRed: 90.0/255 green: 90.0/255 blue: 90.0/255 alpha: 1.0f] set];
			
			[NSBezierPath strokeLineFromPoint: NSMakePoint(rect.origin.x + rect.size.width -.5f, rect.origin.y)
									  toPoint: NSMakePoint(rect.origin.x + rect.size.width -.5f, rect.origin.y + rect.size.height)];
			
			[path release];
			[arrow release];
			
		} else {
			
			NSRect rect = [scroller rectForPart: NSScrollerDecrementLine];
			
			NSBezierPath *path = [[NSBezierPath alloc] init];
			NSPoint basePoints[4];
			
			[path appendBezierPathWithArcWithCenter: NSMakePoint(rect.origin.x + (rect.size.width -2) + ((rect.size.height ) /2), (rect.origin.y  + ((rect.size.height ) /2) ))
											 radius: (rect.size.height ) /2
										 startAngle: 90
										   endAngle: 270];
			
			//Add the rest of the points
			basePoints[2] = NSMakePoint( rect.origin.x, rect.origin.y + rect.size.height);
			basePoints[1] = NSMakePoint( rect.origin.x, rect.origin.y);
			basePoints[0] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y);
			basePoints[3] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
			
			[path appendBezierPathWithPoints: basePoints count: 4];
			
			//Fill Path
			if(!highlighted) {
				KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 95.0/255.0f green: 95.0/255.0 blue: 95.0/255.0 alpha: .25f]
																	 endingColor:[NSColor colorWithDeviceRed: 85.0/255.0 green: 85.0/255.0 blue: 85.0/255.0 alpha: .25f]];
				[gradient drawInBezierPath: path angle: 90];
				[gradient release];
			} else {
				KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 158.0/255.0 green: 158.0/255.0 blue: 158.0/255.0 alpha: 0.5f] 
																	 endingColor:[NSColor colorWithDeviceRed: 148.0/255.0 green: 148.0/255.0 blue: 148.0/255.0 alpha: 0.5f]];
				[gradient drawInBezierPath: path angle: 90];
				[gradient release];
			}
			
			//Create Arrow Glyph
			NSBezierPath *arrow = [[NSBezierPath alloc] init];
			
			NSPoint points[3];
			points[0] = NSMakePoint( rect.origin.x + (rect.size.width /2) -3, rect.size.height /2);
			points[1] = NSMakePoint( rect.origin.x + (rect.size.height /2) +3, (rect.size.height /2) +3.5f);
			points[2] = NSMakePoint( rect.origin.x + (rect.size.height /2) +3, (rect.size.height /2) -3.5f);
			
			[arrow appendBezierPathWithPoints: points count: 3];
			
			[[NSColor colorWithDeviceRed: 90.0/255 green: 90.0/255 blue: 90.0/255 alpha: 1.0f] set];
			[arrow fill];
			
			[path release];
			[arrow release];
		}
	}
}

- (void)drawIncrementArrow:(BOOL)highlighted withScroller:(KAScroller*) scroller{
	
	if(internalScrollerFlag.isHoriz == 0) {
		
		if([arrowPosition isEqualToString: @"DoubleMax"]) {
			
			//Draw Increment Button
			NSRect rect = [scroller rectForPart: NSScrollerIncrementLine];
			
			if(!highlighted) {
				KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 95.0/255.0f green: 95.0/255.0 blue: 95.0/255.0 alpha: .25f]
																	 endingColor:[NSColor colorWithDeviceRed: 85.0/255.0 green: 85.0/255.0 blue: 85.0/255.0 alpha: .25f]];
				[gradient drawInRect: rect angle: 0];
				[gradient release];
			} else {
				KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 158.0/255.0 green: 158.0/255.0 blue: 158.0/255.0 alpha: 0.5f] 
																	 endingColor:[NSColor colorWithDeviceRed: 148.0/255.0 green: 148.0/255.0 blue: 148.0/255.0 alpha: 0.5f]];
				[gradient drawInRect: rect angle: 0];
				[gradient release];
			}
			
			//Create Arrow Glyph
			NSBezierPath *arrow = [[NSBezierPath alloc] init];
			
			NSPoint points[3];
			points[0] = NSMakePoint( rect.size.width /2, rect.origin.y + (rect.size.height /2) +3);
			points[1] = NSMakePoint( (rect.size.width /2) +3.5f, rect.origin.y + (rect.size.height /2) -3);
			points[2] = NSMakePoint( (rect.size.width /2) -3.5f, rect.origin.y + (rect.size.height /2) -3);
			
			[arrow appendBezierPathWithPoints: points count: 3];
			
			[[NSColor colorWithDeviceRed: 90.0/255 green: 90.0/255 blue: 90.0/255 alpha: 1.0f] set];
			[arrow fill];
			
			[arrow release];
		} else {
			
			//Draw Decrement Button
			NSRect rect = [scroller rectForPart: NSScrollerIncrementLine];
			NSBezierPath *path = [[NSBezierPath alloc] init];
			NSPoint basePoints[4];
			
			//Add Notch
			[path appendBezierPathWithArcWithCenter: NSMakePoint((rect.size.width ) /2, (rect.origin.y  - ((rect.size.width ) /2) + 2))
											 radius: (rect.size.width ) /2
										 startAngle: 0
										   endAngle: 180];
			
			//Add the rest of the points
			basePoints[0] = NSMakePoint( rect.origin.x, rect.origin.y);
			basePoints[1] = NSMakePoint( rect.origin.x, rect.origin.y + rect.size.height);
			basePoints[2] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
			basePoints[3] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y);
			
			//Add Points to Path
			[path appendBezierPathWithPoints: basePoints count: 4];
			
			//Fill Path
			if(!highlighted) {
				KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 95.0/255.0f green: 95.0/255.0 blue: 95.0/255.0 alpha: .25f]
																	 endingColor:[NSColor colorWithDeviceRed: 85.0/255.0 green: 85.0/255.0 blue: 85.0/255.0 alpha: .25f]];
				[gradient drawInBezierPath: path angle: 0];
				[gradient release];
			} else {
				KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 158.0/255.0 green: 158.0/255.0 blue: 158.0/255.0 alpha: 0.5f] 
																	 endingColor:[NSColor colorWithDeviceRed: 148.0/255.0 green: 148.0/255.0 blue: 148.0/255.0 alpha: 0.5f]];
				[gradient drawInBezierPath: path angle: 0];
				[gradient release];
			}
			
			//Create Arrow Glyph
			NSBezierPath *arrow = [[NSBezierPath alloc] init];
			
			NSPoint points[3];
			points[0] = NSMakePoint( rect.size.width /2, rect.origin.y + (rect.size.height /2) +3);
			points[1] = NSMakePoint( (rect.size.width /2) +3.5f, rect.origin.y + (rect.size.height /2) -3);
			points[2] = NSMakePoint( (rect.size.width /2) -3.5f, rect.origin.y + (rect.size.height /2) -3);
			
			[arrow appendBezierPathWithPoints: points count: 3];
			
			[[NSColor colorWithDeviceRed: 90.0/255 green: 90.0/255 blue: 90.0/255 alpha: 1.0f] set];
			[arrow fill];
			
			[path release];
			[arrow release];
		}
	} else {
		
		if([arrowPosition isEqualToString: @"DoubleMax"]) {
			
			//Draw Increment Button
			NSRect rect = [scroller rectForPart: NSScrollerIncrementLine];
			
			if(!highlighted) {
				KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 95.0/255.0f green: 95.0/255.0 blue: 95.0/255.0 alpha: .25f]
																	 endingColor:[NSColor colorWithDeviceRed: 85.0/255.0 green: 85.0/255.0 blue: 85.0/255.0 alpha: .25f]];
				[gradient drawInRect: rect angle: 90];
				[gradient release];
			} else {
				KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 158.0/255.0 green: 158.0/255.0 blue: 158.0/255.0 alpha: 0.5f] 
																	 endingColor:[NSColor colorWithDeviceRed: 148.0/255.0 green: 148.0/255.0 blue: 148.0/255.0 alpha: 0.5f]];
				[gradient drawInRect: rect angle: 90];
				[gradient release];
			}
			
			//Create Arrow Glyph
			NSBezierPath *arrow = [[NSBezierPath alloc] init];
			
			NSPoint points[3];
			points[0] = NSMakePoint( rect.origin.x + (rect.size.width /2) +3, rect.size.height /2);
			points[1] = NSMakePoint( rect.origin.x + (rect.size.height /2) -3, (rect.size.height /2) +3.5f);
			points[2] = NSMakePoint( rect.origin.x + (rect.size.height /2) -3, (rect.size.height /2) -3.5f);
			
			[arrow appendBezierPathWithPoints: points count: 3];
			
			[[NSColor colorWithDeviceRed: 90.0/255 green: 90.0/255 blue: 90.0/255 alpha: 1.0f] set];
			[arrow fill];
			
			[arrow release];
		} else {
			
			//Draw Decrement Button
			NSRect rect = [scroller rectForPart: NSScrollerIncrementLine];
			NSBezierPath *path = [[NSBezierPath alloc] init];
			NSPoint basePoints[4];
			
			//Add Notch
			[path appendBezierPathWithArcWithCenter: NSMakePoint(rect.origin.x - (((rect.size.height ) /2) -2), (rect.origin.y  + ((rect.size.height ) /2) ))
											 radius: (rect.size.height ) /2
										 startAngle: 270
										   endAngle: 90];
			
			//Add the rest of the points
			basePoints[3] = NSMakePoint( rect.origin.x - (((rect.size.height ) /2) -1), rect.origin.y);
			basePoints[0] = NSMakePoint( rect.origin.x - (((rect.size.height ) /2) -1), rect.origin.y + rect.size.height);
			basePoints[1] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
			basePoints[2] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y);
			
			//Add Points to Path
			[path appendBezierPathWithPoints: basePoints count: 4];
			
			//Fill Path
			if(!highlighted) {
				KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 95.0/255.0f green: 95.0/255.0 blue: 95.0/255.0 alpha: .25f]
																	 endingColor:[NSColor colorWithDeviceRed: 85.0/255.0 green: 85.0/255.0 blue: 85.0/255.0 alpha: .25f]];
				[gradient drawInBezierPath: path angle: 0];
				[gradient release];
			} else {
				KAGradient* gradient = [[KAGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 158.0/255.0 green: 158.0/255.0 blue: 158.0/255.0 alpha: 0.5f] 
																	 endingColor:[NSColor colorWithDeviceRed: 148.0/255.0 green: 148.0/255.0 blue: 148.0/255.0 alpha: 0.5f]];
				[gradient drawInBezierPath: path angle: 0];
				[gradient release];
			}
			
			//Create Arrow Glyph
			NSBezierPath *arrow = [[NSBezierPath alloc] init];
			
			NSPoint points[3];
			points[0] = NSMakePoint( rect.origin.x + (rect.size.width /2) +3, rect.size.height /2);
			points[1] = NSMakePoint( rect.origin.x + (rect.size.height /2) -3, (rect.size.height /2) +3.5f);
			points[2] = NSMakePoint( rect.origin.x + (rect.size.height /2) -3, (rect.size.height /2) -3.5f);
			
			[arrow appendBezierPathWithPoints: points count: 3];
			
			[[NSColor colorWithDeviceRed: 90.0/255 green: 90.0/255 blue: 90.0/255 alpha: 1.0f] set];
			[arrow fill];
			
			[path release];
			[arrow release];
		}
	}
}



@end
