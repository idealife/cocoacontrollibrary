//
//  _NSGradient.m
//  AiOControls
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

#import "_NSGradient.h"


@implementation _NSGradient

- (void) dealloc
{
	[self setM_Colors:nil];
	[self setM_Gradient:nil];
	[self setM_Locations:nil];
	
	[super dealloc];
}

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
		[self setM_Colors:[NSMutableArray array]];
		[self setM_Locations:[NSMutableArray array]];
		
		[self addColor:startingColor andLocation:0.0f];
		[self addColor:endingColor andLocation:1.0f];
	}
	return self;
}

- (void) addColorStop: (NSColor*) stopColor
		   atPosition: (CGFloat) position
{
	[self addColor:stopColor andLocation:position];
}

- (void) drawFromPoint: (NSPoint) startingPoint
			   toPoint: (NSPoint) endingPoint
{
	[self _initGradientInstance];
	[m_Gradient drawFromPoint:startingPoint 
					  toPoint:endingPoint 
					  options:NSGradientDrawsAfterEndingLocation];
}

- (void) drawFromCenter: (NSPoint) startingCenter
				 radius: (CGFloat) startRadius
			   toCenter: (NSPoint) endCenter
				 radius: (CGFloat) endRadius
{
	[self _initGradientInstance];
	[m_Gradient drawFromCenter:startingCenter 
						radius:startRadius 
					  toCenter:endCenter 
						radius:endRadius 
					   options:NSGradientDrawsAfterEndingLocation];
}

- (void) drawInRect: (NSRect) rect 
			  angle: (CGFloat) angle
{
	[self _initGradientInstance];
	[m_Gradient drawInRect:rect angle:angle];
}

- (void) drawInBezierPath: (NSBezierPath*) path 
					angle: (CGFloat) angle
{
	[self _initGradientInstance];
	[m_Gradient drawInBezierPath:path angle:angle];
}

- (void) drawRadialInRect: (NSRect) rect
{
	[self _initGradientInstance];
	[m_Gradient drawInRect:rect relativeCenterPosition:NSZeroPoint];
}

- (void) drawRadialInBezierPath: (NSBezierPath*) path
{
	[self _initGradientInstance];
	[m_Gradient drawInBezierPath:path relativeCenterPosition:NSZeroPoint];
}


#pragma mark Private Methods
/*!
    @function
    @abstract   The private method to init the gradient instance.
    @discussion Beacuse we need to add color after initialization, we can't init
				the gradient instance before starting drawing. The method should
				only be invoked when drawing.
    @param      nil
    @result     void
	@exception	NSInvalidArgumentException If the graident have less than 2 color
				stops, it will raise this exception.
*/
- (void) _initGradientInstance
{
	// Gradients must have at least two color stops: one defining the location of the start color and one defining the location of the end color.
	// Gradients may have additional color stops located at different transition points in between the start and end stops.
	if(__colorsCount < 2)
		[NSException raise:NSInvalidArgumentException format:@"Color stop of Gradient must be more than 2. We only have %i now.", __colorsCount];
	
	if(nil == [self m_Gradient])
	{
		CGFloat *locations = malloc(sizeof(CGFloat)*__colorsCount);
		for(int i = 0; i < __colorsCount; i++)
		{
			locations[i] = [[m_Locations objectAtIndex:i] floatValue];
		}
		NSGradient *tempGradient = [[NSGradient alloc] initWithColors:m_Colors
														  atLocations:locations 
														   colorSpace:[NSColorSpace deviceRGBColorSpace]];
		[self setM_Gradient:tempGradient];
		[tempGradient release];
		free(locations);
	}
}


- (void) addColor:(NSColor *) color andLocation:(CGFloat) location
{
	if(nil == color)
		[NSException raise:NSInvalidArgumentException format:@"The incoming color can't be nil"];
	if(location < 0.0f || location > 1.0f)
		[NSException raise:NSInvalidArgumentException format:@"Location value should > 0.0f and < 1.0f. It can't be %f", location];
	
	[m_Colors insertObject:color atIndex:__colorsCount];
	[m_Locations insertObject:[NSNumber numberWithFloat:location] atIndex:__colorsCount];
	
	__colorsCount ++;
}

#pragma mark Accessors

- (NSGradient *) m_Gradient {
	return m_Gradient;
}

- (void) setM_Gradient: (NSGradient *) newValue {
	[m_Gradient autorelease];
	m_Gradient = [newValue retain];
}


- (NSMutableArray *) m_Colors {
	return m_Colors;
}

- (void) setM_Colors: (NSMutableArray *) newValue {
	[m_Colors autorelease];
	m_Colors = [newValue retain];
}


- (NSMutableArray *) m_Locations {
	return m_Locations;
}

- (void) setM_Locations: (NSMutableArray *) newValue {
	[m_Locations autorelease];
	m_Locations = [newValue retain];
}

@end
