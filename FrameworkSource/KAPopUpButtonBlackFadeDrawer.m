//
//  KAPopUpButtonBlackFadeDrawer.m
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

#import "KAPopUpButtonBlackFadeDrawer.h"
#import "KAGradient.h"
#import "NSBezierPath+RoundedRect.h"

@implementation KAPopUpButtonBlackFadeDrawer

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
	buttonCell = (KAPopUpButtonCell *) control;
	
	NSRect cellFrame = [args m_ClipRectangle];
	NSView *controlView = [[args m_PresentationInfo] controlView];
	
	if ([buttonCell pullsDown])
	{
		[self drawPullDownWithFrame: cellFrame inView: controlView];
	}
	else
	{
		[self drawPopUpWithFrame: cellFrame inView: controlView];
	}
}

- (NSColor *)colorVlaueWithRed: (int)red green: (int)green blue: (int)blue
{
	return [NSColor colorWithDeviceRed: red/255.0 green: green/255.0 blue: blue/255.0 alpha: 1.0f];
}

-(float)disabledAlphaValue 
{
	return 0.2f;
}

-(NSColor *)selectionTextActiveColor
{
	
	return [NSColor whiteColor];
}

-(NSColor *)selectionTextInActiveColor 
{
	
	return [NSColor whiteColor];
}

-(NSShadow *)dropShadow 
{
	
	NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowColor: [NSColor blackColor]];
	[shadow setShadowBlurRadius: 2];
	[shadow setShadowOffset: NSMakeSize( 0, -1)];
	
	return [shadow autorelease];
}

-(NSColor *)darkStrokeColor
{
	
	return [NSColor colorWithDeviceRed: 0.141f green: 0.141f blue: 0.141f alpha: 0.5f];
}

-(NSColor *)strokeColor
{
	
	return [NSColor colorWithDeviceRed: 0.141f green: 0.141f blue: 0.141f alpha: 1.0f];
}

-(NSColor *)disabledStrokeColor
{
	
	return [NSColor colorWithDeviceRed: 0.749f green: 0.761f blue: 0.788f alpha: [self disabledAlphaValue]];
}

-(NSColor *)textColor 
{
	
	return [NSColor whiteColor];
}

-(NSColor *)disabledTextColor
{
	
	return [NSColor colorWithDeviceRed: 1 green: 1 blue: 1 alpha: [self disabledAlphaValue]];
}

- (void)drawPullDownWithFrame:(NSRect)cellFrame inView:(NSView *)controlView 
{
	
	NSRect frame = cellFrame;
	//Adjust frame by .5 so lines draw true
	frame.origin.x += .5f;
	frame.origin.y += .5f;
	frame.size.height = [buttonCell cellSize].height;
	
	//Make Adjustments to Frame based on Cell Size
	switch ([buttonCell controlSize]) {
			
		case NSRegularControlSize:
			
			frame.origin.x += 3;
			frame.size.width -= 7;
			frame.origin.y += 2;
			frame.size.height -= 7;
			break;
			
		case NSSmallControlSize:
			
			frame.origin.y += 1;
			frame.size.height -= 6;
			frame.origin.x += 3;
			frame.size.width -= 7;
			break;
			
		case NSMiniControlSize:
			
			frame.origin.x += 1;
			frame.size.width -= 4;
			frame.size.height -= 2;
			break;
	}
	if([buttonCell isBordered]) {		
		NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: frame
														cornerRadius: 4];
		
		[path closePath];
		
		
		[NSGraphicsContext saveGraphicsState];
		[[self dropShadow] set];
		//[[buttonCell darkStrokeColor] set];
		[path stroke];
		[NSGraphicsContext restoreGraphicsState];
		
		if([buttonCell isEnabled]) {						
			KAGradient *btnGradient = [[[KAGradient alloc] initWithStartingColor: [self colorVlaueWithRed: 87 green: 87 blue: 90]
																	 endingColor: [self colorVlaueWithRed: 60 green: 60 blue: 60]] autorelease];
			[btnGradient addColorStop: [self colorVlaueWithRed: 40 green: 40 blue: 40] atPosition: 0.5f];
			[btnGradient drawInBezierPath: path angle: 90];		
			
		} else {
			
			[[self disabledStrokeColor] set];
			[path fill];
		}
		
		[path setLineWidth: 1.0f ];
		[path stroke];
		
		//[path release];
	}
	
	//Draw the arrows
	[self drawArrowsInRect: frame];
	
	//Adjust rect for title drawing
	switch ([buttonCell controlSize]) {
			
		case NSRegularControlSize:
			
			frame.origin.x += 8;
			frame.origin.y += 1;
			frame.size.width -= 29;
			break;
			
		case NSSmallControlSize:
			
			frame.origin.x += 8;
			frame.origin.y += 2;
			frame.size.width -= 29;
			break;
			
		case NSMiniControlSize:
			
			frame.origin.x += 8;
			frame.origin.y += .5f;
			frame.size.width -= 26;
			break;
	}
	
	NSMutableAttributedString *aTitle = [[NSMutableAttributedString alloc] initWithString: [buttonCell titleOfSelectedItem]];
	
	//Make sure aTitle actually contains something
	if([aTitle length] > 0) {
		
		[aTitle beginEditing];
		
		[aTitle removeAttribute: NSForegroundColorAttributeName range: NSMakeRange(0, [aTitle length])];
		
		if([buttonCell isEnabled]){
			
			if([buttonCell isHighlighted]) {
				
				if([[[buttonCell controlView] window] isKeyWindow])
				{
					
					[aTitle addAttribute: NSForegroundColorAttributeName
								   value: [self selectionTextActiveColor]
								   range: NSMakeRange(0, [aTitle length])];
				} else {
					
					[aTitle addAttribute: NSForegroundColorAttributeName
								   value: [self selectionTextInActiveColor]
								   range: NSMakeRange(0, [aTitle length])];
				}
			} else {
				
				[aTitle addAttribute: NSForegroundColorAttributeName
							   value: [self textColor]
							   range: NSMakeRange(0, [aTitle length])];
			}
		} else {
			
			[aTitle addAttribute: NSForegroundColorAttributeName
						   value: [self disabledTextColor]
						   range: NSMakeRange(0, [aTitle length])];
		}
		
		[aTitle endEditing];
		
		int arrowAdjustment = 0;
		
		if([buttonCell isBordered]) {
			
			cellFrame.size.height -= 2;
			cellFrame.origin.x += 5;
		} else {
			
			switch ([buttonCell controlSize]) {
					
				case NSRegularControlSize:
					
					arrowAdjustment = 11;
					break;
					
				case NSSmallControlSize:
					
					arrowAdjustment = 8;
					break;
					
				case NSMiniControlSize:
					
					arrowAdjustment = 5;
					break;
			}
		}
		
		NSRect newFrame = NSMakeRect(cellFrame.origin.x + 5, NSMidY(cellFrame) - ([aTitle size].height/2), cellFrame.size.width - (arrowAdjustment + 10), [aTitle size].height);
		
		[aTitle drawInRect:newFrame];
		//[super drawTitle: aTitle withFrame: newFrame inView: controlView];
	}
	
	[aTitle release];
}

- (void)drawArrowsInRect:(NSRect) frame {
	
	float arrowsWidth;
	float arrowsHeight;
	float arrowWidth;
	float arrowHeight;
	
	int arrowAdjustment = 0;
	
	//Adjust based on Control size
	switch ([buttonCell controlSize]) {
		default: // Silence uninitialized variable warnings
		case NSRegularControlSize:
			
			if([buttonCell isBordered]) {
				
				arrowAdjustment = 21;
			} else {
				
				arrowAdjustment = 11;
			}
			
			arrowWidth = 3.5f;
			arrowHeight = 2.5f;
			arrowsHeight = 2;
			arrowsWidth = 2.5f;
			break;
			
		case NSSmallControlSize:
			
			if([buttonCell isBordered]) {
				
				arrowAdjustment = 18;
			} else {
				
				arrowAdjustment = 8;
			}
			
			arrowWidth = 3.5f;
			arrowHeight = 2.5f;
			arrowsHeight = 2;
			arrowsWidth = 2.5f;
			
			break;
			
		case NSMiniControlSize:
			
			if([buttonCell isBordered]) {
				
				arrowAdjustment = 15;
			} else {
				
				arrowAdjustment = 5;
			}
			
			arrowWidth = 2.5f;
			arrowHeight = 1.5f;
			arrowsHeight = 1.5f;
			arrowsWidth = 2;
			break;
	}
	//?
	//arrowAdjustment = 9.0f;
	frame.origin.x += (frame.size.width - arrowAdjustment);
	frame.size.width = arrowAdjustment;
	
	if([buttonCell pullsDown]) {
		
		NSBezierPath *arrow = [[NSBezierPath alloc] init];
		
		NSPoint points[3];
		
		points[0] = NSMakePoint(frame.origin.x + ((frame.size.width /2) - arrowWidth), frame.origin.y + ((frame.size.height /2) - arrowHeight));
		points[1] = NSMakePoint(frame.origin.x + ((frame.size.width /2) + arrowWidth), frame.origin.y + ((frame.size.height /2) - arrowHeight));
		points[2] = NSMakePoint(frame.origin.x + (frame.size.width /2), frame.origin.y + ((frame.size.height /2) + arrowHeight));
		
		[arrow appendBezierPathWithPoints: points count: 3];
		
		if([buttonCell isEnabled]) {
			
			if([buttonCell isHighlighted]) {
				
				if([[[buttonCell controlView] window] isKeyWindow])
				{
					
					[[self selectionTextActiveColor] set];
				} else {
					
					[[self selectionTextInActiveColor] set];
				}
			} else {
				
				[[self textColor] set];
			}
		} else {
			
			[[self disabledTextColor] set];
		}
		
		[arrow fill];
		
		[arrow release];
		
	} else {
		
		NSBezierPath *topArrow = [[NSBezierPath alloc] init];
		
		NSPoint topPoints[3];
		
		topPoints[0] = NSMakePoint(frame.origin.x + ((frame.size.width /2) - arrowsWidth), frame.origin.y + ((frame.size.height /2) - arrowsHeight));
		topPoints[1] = NSMakePoint(frame.origin.x + ((frame.size.width /2) + arrowsWidth), frame.origin.y + ((frame.size.height /2) - arrowsHeight));
		topPoints[2] = NSMakePoint(frame.origin.x + (frame.size.width /2), frame.origin.y + ((frame.size.height /2) - ((arrowsHeight * 2) + 2)));
		
		[topArrow appendBezierPathWithPoints: topPoints count: 3];
		
		if([buttonCell isEnabled]) {
			
			if([buttonCell isHighlighted]) {
				
				if([[[buttonCell controlView] window] isKeyWindow])
				{
					[[self selectionTextActiveColor] set];
				} else {
					[[self selectionTextInActiveColor] set];
				}
			} else {
				[[self colorVlaueWithRed: 175 green: 174 blue: 174] set];
				//[[buttonCell textColor] set];
			}
		} else {
			
			[[self disabledTextColor] set];
		}
		[topArrow fill];
		
		NSBezierPath *bottomArrow = [[NSBezierPath alloc] init];
		
		NSPoint bottomPoints[3];
		
		bottomPoints[0] = NSMakePoint(frame.origin.x + ((frame.size.width /2) - arrowsWidth), frame.origin.y + ((frame.size.height /2) + arrowsHeight));
		bottomPoints[1] = NSMakePoint(frame.origin.x + ((frame.size.width /2) + arrowsWidth), frame.origin.y + ((frame.size.height /2) + arrowsHeight));
		bottomPoints[2] = NSMakePoint(frame.origin.x + (frame.size.width /2), frame.origin.y + ((frame.size.height /2) + ((arrowsHeight * 2) + 2)));
		
		[bottomArrow appendBezierPathWithPoints: bottomPoints count: 3];
		
		if([buttonCell isEnabled]) {
			
			if([buttonCell isHighlighted]) {
				
				if([[[buttonCell controlView] window] isKeyWindow])
				{
					[[NSColor whiteColor] set];
				} else {
					[[NSColor whiteColor] set];
				}
			} else {
				[[self colorVlaueWithRed: 175 green: 174 blue: 174] set];
				//[[buttonCell textColor] set];
			}
		} else {
			
			[[self disabledTextColor] set];
		}
		[bottomArrow fill];
		
		[topArrow release];
		[bottomArrow release];
	}
}

- (void)drawPopUpWithFrame:(NSRect)cellFrame inView:(NSView *)controlView 
{
	
	NSRect frame = cellFrame;
	//Adjust frame by .5 so lines draw true
	frame.origin.x += .5f;
	frame.origin.y += .5f;
	frame.size.height = [buttonCell cellSize].height;
	
	//Make Adjustments to Frame based on Cell Size
	switch ([buttonCell controlSize]) {
			
		case NSRegularControlSize:
			
			frame.origin.x += 3;
			frame.size.width -= 7;
			frame.origin.y += 2;
			frame.size.height -= 7;
			break;
			
		case NSSmallControlSize:
			
			frame.origin.y += 1;
			frame.size.height -= 6;
			frame.origin.x += 3;
			frame.size.width -= 7;
			break;
			
		case NSMiniControlSize:
			
			frame.origin.x += 1;
			frame.size.width -= 4;
			frame.size.height -= 2;
			break;
	}
	
	if([buttonCell isBordered]) {		
		//Draw top half
		NSBezierPath *topPath = [NSBezierPath bezierPathWithTopHalfRoundedRect: frame
																  cornerRadius: 4];
		[topPath closePath];
		[NSGraphicsContext saveGraphicsState];
		[[self colorVlaueWithRed: 81 green: 82 blue: 84] set];
		[topPath fill];
		[NSGraphicsContext restoreGraphicsState];
		
		//Draw bottom half
		NSBezierPath *bottomPath = [NSBezierPath bezierPathWithBottomHalfRoundedRect: frame
																		cornerRadius: 4];
		
		[bottomPath closePath];
		[NSGraphicsContext saveGraphicsState];
		[[self colorVlaueWithRed: 56 green: 55 blue: 57] set];
		[bottomPath fill];
		[NSGraphicsContext restoreGraphicsState];
		
		
		[NSGraphicsContext saveGraphicsState];
		[[self dropShadow] set];
		[NSGraphicsContext restoreGraphicsState];		
	}
	
	//Draw the arrows
	[self drawArrowsInRect: frame];
	
	//Adjust rect for title drawing
	switch ([buttonCell controlSize]) {
			
		case NSRegularControlSize:
			
			frame.origin.x += 8;
			frame.origin.y += 1;
			frame.size.width -= 29;
			break;
			
		case NSSmallControlSize:
			
			frame.origin.x += 8;
			frame.origin.y += 2;
			frame.size.width -= 29;
			break;
			
		case NSMiniControlSize:
			
			frame.origin.x += 8;
			frame.origin.y += .5f;
			frame.size.width -= 26;
			break;
	}
	
	NSMutableAttributedString *aTitle = [[NSMutableAttributedString alloc] initWithString: [buttonCell titleOfSelectedItem]];
	
	//Make sure aTitle actually contains something
	if([aTitle length] > 0) {
		
		[aTitle beginEditing];
		
		[aTitle removeAttribute: NSForegroundColorAttributeName range: NSMakeRange(0, [aTitle length])];
		[aTitle addAttribute: NSFontAttributeName
					   value: [NSFont fontWithName: @"Arial" size: 11.0f]
					   range: NSMakeRange(0, [aTitle length])];
		
		if([buttonCell isEnabled]){
			
			if([buttonCell isHighlighted]) {
				
				if([[[buttonCell controlView] window] isKeyWindow])
				{
					
					[aTitle addAttribute: NSForegroundColorAttributeName
								   value: [self colorVlaueWithRed: 175 green: 174 blue: 174]//[NSColor blackColor]//[buttonCell selectionTextActiveColor]
								   range: NSMakeRange(0, [aTitle length])];
				} else {
					
					[aTitle addAttribute: NSForegroundColorAttributeName
								   value: [self colorVlaueWithRed: 175 green: 174 blue: 174]//[NSColor blackColor]//[buttonCell selectionTextInActiveColor]
								   range: NSMakeRange(0, [aTitle length])];
				}
			} else {
				
				[aTitle addAttribute: NSForegroundColorAttributeName
							   value: [self colorVlaueWithRed: 175 green: 174 blue: 174]//[NSColor blackColor]//[buttonCell textColor]
							   range: NSMakeRange(0, [aTitle length])];
			}
		} else {
			
			[aTitle addAttribute: NSForegroundColorAttributeName
						   value: [self disabledTextColor]
						   range: NSMakeRange(0, [aTitle length])];
		}
		
		[aTitle endEditing];
		
		int arrowAdjustment = 0;
		
		if([buttonCell isBordered]) {
			
			cellFrame.size.height -= 2;
			cellFrame.origin.x += 5;
		} else {
			
			switch ([buttonCell controlSize]) {
					
				case NSRegularControlSize:
					
					arrowAdjustment = 11;
					break;
					
				case NSSmallControlSize:
					
					arrowAdjustment = 8;
					break;
					
				case NSMiniControlSize:
					
					arrowAdjustment = 5;
					break;
			}
		}
		
		NSRect newFrame = NSMakeRect(cellFrame.origin.x + 5, NSMidY(cellFrame) - ([aTitle size].height/2), cellFrame.size.width - (arrowAdjustment + 10), [aTitle size].height);
		
		[aTitle drawInRect:newFrame];
		//[super drawTitle: aTitle withFrame: newFrame inView: controlView];
	}
	
	[aTitle release];
}

@end
