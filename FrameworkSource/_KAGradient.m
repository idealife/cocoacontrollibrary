//
//  _KAGradient.m
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

#import "_KAGradient.h"

@interface  _KAGradient (PrivateMethods)

- (void)_commonInit;

- (void)setBlendingMode:(KAGradientBlendingMode)mode;
- (KAGradientBlendingMode)blendingMode;

- (void)addElement:(KAGradientElement*)newElement;
- (KAGradientElement *)elementAtIndex:(unsigned)index;
- (KAGradientElement)removeElementAtIndex:(unsigned)index;
- (KAGradientElement)removeElementAtPosition:(float)position;

@end

//C Fuctions for color blending
static void linearEvaluation   (void *info, const float *in, float *out);
static void chromaticEvaluation(void *info, const float *in, float *out);
static void inverseChromaticEvaluation(void *info, const float *in, float *out);
static void transformRGB_HSV(float *components);
static void transformHSV_RGB(float *components);
static void resolveHSV(float *color1, float *color2);

@implementation _KAGradient

+ gradientWithStartingColor: (NSColor*) startingColor
				endingColor: (NSColor*) endingColor
{
	_KAGradient* instance = [[[self class] alloc] init];
	
	KAGradientElement color1;
	KAGradientElement color2;
	
	[[startingColor colorUsingColorSpaceName: NSCalibratedRGBColorSpace] getRed: &color1.red 
																		  green: &color1.green
																		   blue: &color1.blue 
																		  alpha: &color1.alpha];
	[[endingColor colorUsingColorSpaceName: NSCalibratedRGBColorSpace] getRed: &color2.red
																		green: &color2.green
																		 blue: &color2.blue
																		alpha: &color2.alpha];
	color1.position = 0;
	color2.position = 1;
	
	[instance addElement: &color1];
	[instance addElement: &color2];
	
	return [instance autorelease];
}

- (id) init
{
	if (self = [super init])
	{
		[self _commonInit];
		[self setBlendingMode: KALinearBlendingMode];
	}
	return self;
}

- (id) initWithStartingColor: (NSColor*) startingColor
				 endingColor: (NSColor*) endingColor
{
	self = [super init];
	
	if (self)
	{
		[self _commonInit];
		[self setBlendingMode: KALinearBlendingMode];
		
		KAGradientElement color1;
		KAGradientElement color2;
		
		[[startingColor colorUsingColorSpaceName: NSCalibratedRGBColorSpace] getRed: &color1.red 
																			  green: &color1.green
																			   blue: &color1.blue 
																			  alpha: &color1.alpha];
		[[endingColor colorUsingColorSpaceName: NSCalibratedRGBColorSpace] getRed: &color2.red
																			green: &color2.green
																			 blue: &color2.blue
																			alpha: &color2.alpha];
		color1.position = 0;
		color2.position = 1;
		
		[self addElement: &color1];
		[self addElement: &color2];
	}
	
	
	return self;
}

- (void) dealloc
{
	CGFunctionRelease(gradientFunction);
	
	KAGradientElement* elementToRemove = elementList;
	while (elementList != nil)
	{
		elementToRemove = elementList;
		elementList = elementList->nextElement;
		free(elementToRemove);
	}
	
	[super dealloc];
}

- (id) copyWithZone: (NSZone*) zone
{
	_KAGradient *copy = [[[self class] allocWithZone: zone] init];
	
	// now just copy my elementList
	KAGradientElement* currentElement = elementList;
	while (currentElement)
	{
		[copy addElement: currentElement];
		currentElement = currentElement->nextElement;
	}
	
	[copy setBlendingMode: blendingMode];
	
	return copy;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	if([coder allowsKeyedCoding])
	{
		unsigned count = 0;
		KAGradientElement *currentElement = elementList;
		while(currentElement != nil)
		{
			[coder encodeValueOfObjCType:@encode(float) at:&(currentElement->red)];
			[coder encodeValueOfObjCType:@encode(float) at:&(currentElement->green)];
			[coder encodeValueOfObjCType:@encode(float) at:&(currentElement->blue)];
			[coder encodeValueOfObjCType:@encode(float) at:&(currentElement->alpha)];
			[coder encodeValueOfObjCType:@encode(float) at:&(currentElement->position)];
			
			count++;
			currentElement = currentElement->nextElement;
		}
		[coder encodeInt:count forKey:@"KAGradientElementCount"];
		[coder encodeInt:blendingMode forKey:@"KAGradientBlendingMode"];
	}
	else
		[NSException raise:NSInvalidArchiveOperationException format:@"Only supports NSKeyedArchiver coders"];
}

- (id)initWithCoder:(NSCoder *)coder
{
	[self _commonInit];
	
	[self setBlendingMode:[coder decodeIntForKey:@"KAGradientBlendingMode"]];
	unsigned count = [coder decodeIntForKey:@"KAGradientElementCount"];
	
	while(count != 0)
	{
		KAGradientElement newElement;
		
		[coder decodeValueOfObjCType:@encode(float) at:&(newElement.red)];
		[coder decodeValueOfObjCType:@encode(float) at:&(newElement.green)];
		[coder decodeValueOfObjCType:@encode(float) at:&(newElement.blue)];
		[coder decodeValueOfObjCType:@encode(float) at:&(newElement.alpha)];
		[coder decodeValueOfObjCType:@encode(float) at:&(newElement.position)];
		
		count--;
		[self addElement:&newElement];
	}
	return self;
}
#pragma mark -

#pragma mark [PrivateMethods]
- (void)_commonInit
{
	elementList = nil;
}

- (void)setBlendingMode:(KAGradientBlendingMode)mode
{
	blendingMode = mode;
	
	//Choose what blending function to use
	void *evaluationFunction;
	switch(blendingMode)
	{
		case KALinearBlendingMode:
			evaluationFunction = &linearEvaluation;			break;
		case KAChromaticBlendingMode:
			evaluationFunction = &chromaticEvaluation;			break;
		case KAInverseChromaticBlendingMode:
			evaluationFunction = &inverseChromaticEvaluation;	break;
	}
	
	//replace the current CoreGraphics Function with new one
	if(gradientFunction != NULL)
		CGFunctionRelease(gradientFunction);
    
	CGFunctionCallbacks evaluationCallbackInfo = {0 , evaluationFunction, NULL};	//Version, evaluator function, cleanup function
	
	static const float input_value_range   [2] = { 0, 1 };						//range  for the evaluator input
	static const float output_value_ranges [8] = { 0, 1, 0, 1, 0, 1, 0, 1 };		//ranges for the evaluator output (4 returned values)
	
	gradientFunction = CGFunctionCreate(&elementList,					//the two transition colors
										1, input_value_range  ,		//number of inputs (just fraction of progression)
										4, output_value_ranges,		//number of outputs (4 - RGBa)
										&evaluationCallbackInfo);		//info for using the evaluator function
	
}
- (KAGradientBlendingMode)blendingMode
{
	return blendingMode;
}

- (void)addElement:(KAGradientElement*)newElement
{
	if (elementList == nil || newElement->position < elementList->position)
	{
		// insert at the beginning
		KAGradientElement* tmpNext = elementList;
		elementList = malloc(sizeof(KAGradientElement));
		*elementList = *newElement;
		elementList->nextElement = tmpNext;
	}
	else
	{
		KAGradientElement* currentElement = elementList;
		while (currentElement->nextElement != nil 
			   && !((currentElement->position <= newElement->position) 
					&& (newElement->position < currentElement->nextElement->position)))
		{
			currentElement = currentElement->nextElement;
		}
		
		KAGradientElement* tmpNext = currentElement->nextElement;
		currentElement->nextElement = malloc(sizeof(KAGradientElement));
		*(currentElement->nextElement) = *newElement;
		currentElement->nextElement->nextElement = tmpNext;
	}
}
- (KAGradientElement *)elementAtIndex:(unsigned)index
{
	unsigned count = 0;
	KAGradientElement *currentElement = elementList;
	
	while (currentElement != nil)
	{
		if (count == index)
			return currentElement;
		
		count++;
		currentElement = currentElement->nextElement;
	}
	
	return nil;
}
- (KAGradientElement)removeElementAtIndex:(unsigned)index
{
	KAGradientElement removedElement;
	
	if(elementList != nil)
	{
		if(index == 0)
		{
			KAGradientElement *tmpNext = elementList;
			elementList = elementList->nextElement;
			
			removedElement = *tmpNext;
			free(tmpNext);
			
			return removedElement;
		}
		
		unsigned count = 1;		//we want to start one ahead
		KAGradientElement *currentElement = elementList;
		while(currentElement->nextElement != nil)
		{
			if(count == index)
			{
				KAGradientElement *tmpNext  = currentElement->nextElement;
				currentElement->nextElement = currentElement->nextElement->nextElement;
				
				removedElement = *tmpNext;
				free(tmpNext);
				
				return removedElement;
			}
			
			count++;
			currentElement = currentElement->nextElement;
		}
	}
	
	//element is not found, return empty element
	removedElement.red   = 0.0;
	removedElement.green = 0.0;
	removedElement.blue  = 0.0;
	removedElement.alpha = 0.0;
	removedElement.position = NAN;
	removedElement.nextElement = nil;
	
	return removedElement;
}
- (KAGradientElement)removeElementAtPosition:(float)position
{
	KAGradientElement removedElement;
	
	if(elementList != nil)
	{
		if(elementList->position == position)
		{
			KAGradientElement *tmpNext = elementList;
			elementList = elementList->nextElement;
			
			removedElement = *tmpNext;
			free(tmpNext);
			
			return removedElement;
		}
		else
		{
			KAGradientElement *curElement = elementList;
			while(curElement->nextElement != nil)
			{
				if(curElement->nextElement->position == position)
				{
					KAGradientElement *tmpNext = curElement->nextElement;
					curElement->nextElement = curElement->nextElement->nextElement;
					
					removedElement = *tmpNext;
					free(tmpNext);
					
					return removedElement;
				}
			}
		}
	}
	
	//element is not found, return empty element
	removedElement.red   = 0.0;
	removedElement.green = 0.0;
	removedElement.blue  = 0.0;
	removedElement.alpha = 0.0;
	removedElement.position = NAN;
	removedElement.nextElement = nil;
	
	return removedElement;
}

#pragma mark [color stop]
- (void) addColorStop: (NSColor*) stopColor
		   atPosition: (CGFloat) position
{
	if(nil == stopColor)
		[NSException raise:NSInvalidArgumentException format:@"The incoming color can't be nil"];
	if(position < 0.0f || position > 1.0f)
		[NSException raise:NSInvalidArgumentException format:@"Location value should > 0.0f and < 1.0f. It can't be %f", position];
	
	KAGradientElement newElement;
	
	// put the components of color into the newElement 
	//- must make sure it is a RGB color (not gray or CMYK)
	[[stopColor colorUsingColorSpaceName: NSCalibratedRGBColorSpace] getRed: &newElement.red
																	  green: &newElement.green
																	   blue: &newElement.blue 
																	  alpha: &newElement.alpha];
	newElement.position = position;
	[self addElement: &newElement];
}

#pragma mark [Draw functions]
// draw
- (void) drawFromPoint: (NSPoint) startingPoint
			   toPoint: (NSPoint) endingPoint
{
	
}
- (void) drawFromCenter: (NSPoint) startingCenter
				 radius: (CGFloat) startRadius
			   toCenter: (NSPoint) endCenter
				 radius: (CGFloat) endRadius
{
	
}

- (void) drawInRect: (NSRect) rect 
			  angle: (CGFloat) angle
{
	//First Calculate where the beginning and ending points should be
	CGPoint startPoint;
	CGPoint endPoint;
	
	if(angle == 0)		//screw the calculations - we know the answer
  	{
		startPoint = CGPointMake(NSMinX(rect), NSMinY(rect));	//right of rect
		endPoint   = CGPointMake(NSMaxX(rect), NSMinY(rect));	//left  of rect
  	}
	else if(angle == 90)	//same as above
  	{
		startPoint = CGPointMake(NSMinX(rect), NSMinY(rect));	//bottom of rect
		endPoint   = CGPointMake(NSMinX(rect), NSMaxY(rect));	//top    of rect
  	}
	else						//ok, we'll do the calculations now 
  	{
		float x,y;
		float sina, cosa, tana;
		
		float length;
		float deltax,
		deltay;
		
		float rangle = angle * pi/180;	//convert the angle to radians
		
		if(fabsf(tan(rangle))<=1)	//for range [-45,45], [135,225]
		{
			x = NSWidth(rect);
			y = NSHeight(rect);
			
			sina = sin(rangle);
			cosa = cos(rangle);
			tana = tan(rangle);
			
			length = x/fabsf(cosa)+(y-x*fabsf(tana))*fabsf(sina);
			
			deltax = length*cosa/2;
			deltay = length*sina/2;
		}
		else						//for range [45,135], [225,315]
		{
			x = NSHeight(rect);
			y = NSWidth(rect);
			
			sina = sin(rangle - 90*pi/180);
			cosa = cos(rangle - 90*pi/180);
			tana = tan(rangle - 90*pi/180);
			
			length = x/fabsf(cosa)+(y-x*fabsf(tana))*fabsf(sina);
			
			deltax =-length*sina/2;
			deltay = length*cosa/2;
		}
		
		startPoint = CGPointMake(NSMidX(rect)-deltax, NSMidY(rect)-deltay);
		endPoint   = CGPointMake(NSMidX(rect)+deltax, NSMidY(rect)+deltay);
	}
	
	//Calls to CoreGraphics
	CGContextRef currentContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(currentContext);
#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_4
	CGColorSpaceRef colorspace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
#else
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
#endif
	CGShadingRef myCGShading = CGShadingCreateAxial(colorspace, startPoint, endPoint, gradientFunction, false, false);
	
	CGContextClipToRect (currentContext, *(CGRect *)&rect);	//This is where the action happens
	CGContextDrawShading(currentContext, myCGShading);
	
	CGShadingRelease(myCGShading);
	CGColorSpaceRelease(colorspace );
	CGContextRestoreGState(currentContext);
}
- (void) drawInBezierPath: (NSBezierPath*) path 
					angle: (CGFloat) angle
{
	NSGraphicsContext *currentContext = [NSGraphicsContext currentContext];
	[currentContext saveGraphicsState];
	NSAffineTransform *transform = [[NSAffineTransform alloc] init];
	
	[transform rotateByDegrees:-angle];
	[path transformUsingAffineTransform:transform];
	[transform invert];
	[transform concat];
	
	[path addClip];
	[self drawInRect:[path bounds] angle:0];
	[path transformUsingAffineTransform:transform];
	[transform release];
	[currentContext restoreGraphicsState];
}

- (void) drawRadialInRect: (NSRect) rect
{
	CGPoint startPoint, endPoint;
	float startRadius, endRadius;
	float scalex, scaley, transx, transy;
	
	startPoint = endPoint = CGPointMake(NSMidX(rect), NSMidY(rect));
	
	startRadius = -1;
	if(NSHeight(rect)>NSWidth(rect))
	{
		scalex = NSWidth(rect)/NSHeight(rect);
		transx = rect.origin.x + (NSHeight(rect)-NSWidth(rect))/2;
		scaley = 1;
		transy = 1;
		endRadius = NSHeight(rect)/2;
	}
	else
	{
		scalex = 1;
		transx = 1;
		scaley = NSHeight(rect)/NSWidth(rect);
		transy = rect.origin.y + (NSWidth(rect)-NSHeight(rect))/2;
		endRadius = NSWidth(rect)/2;
	}
	
	//Calls to CoreGraphics
	CGContextRef currentContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(currentContext);
#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_4
	CGColorSpaceRef colorspace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
#else
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
#endif
	CGShadingRef myCGShading = CGShadingCreateRadial(colorspace, startPoint, startRadius, endPoint, endRadius, gradientFunction, true, true);
	
	CGContextClipToRect  (currentContext, *(CGRect *)&rect);
	CGContextScaleCTM    (currentContext, scalex, scaley);
	CGContextTranslateCTM(currentContext, transx, transy);
	CGContextDrawShading (currentContext, myCGShading);		//This is where the action happens
	
	CGShadingRelease(myCGShading);
	CGColorSpaceRelease(colorspace);
	CGContextRestoreGState(currentContext);
}
- (void) drawRadialInBezierPath: (NSBezierPath*) path
{
	NSGraphicsContext *currentContext = [NSGraphicsContext currentContext];
	[currentContext saveGraphicsState];
	[path addClip];
	[self drawRadialInRect:[path bounds]];
	[currentContext restoreGraphicsState];
}
#pragma mark -

#pragma mark Core Graphics
//////////////////////////////////////Blending Functions/////////////////////////////////////
void linearEvaluation (void *info, const float *in, float *out)
{
	float position = *in;
	
	if(*(KAGradientElement **)info == nil)	//if elementList is empty return clear color
	{
		out[0] = out[1] = out[2] = out[3] = 1;
		return;
	}
	
	//This grabs the first two colors in the sequence
	KAGradientElement *color1 = *(KAGradientElement **)info;
	KAGradientElement *color2 = color1->nextElement;
	
	//make sure first color and second color are on other sides of position
	while(color2 != nil && color2->position < position)
  	{
		color1 = color2;
		color2 = color1->nextElement;
  	}
	//if we don't have another color then make next color the same color
	if(color2 == nil)
    {
		color2 = color1;
    }
	
	//----------FailSafe settings----------
	//color1->red   = 1; color2->red   = 0;
	//color1->green = 1; color2->green = 0;
	//color1->blue  = 1; color2->blue  = 0;
	//color1->alpha = 1; color2->alpha = 1;
	//color1->position = .5;
	//color2->position = .5;
	//-------------------------------------
	
	if(position <= color1->position)			//Make all below color color1's position equal to color1
  	{
		out[0] = color1->red; 
		out[1] = color1->green;
		out[2] = color1->blue;
		out[3] = color1->alpha;
  	}
	else if (position >= color2->position)	//Make all above color color2's position equal to color2
  	{
		out[0] = color2->red; 
		out[1] = color2->green;
		out[2] = color2->blue;
		out[3] = color2->alpha;
  	}
	else										//Interpolate color at postions between color1 and color1
  	{
		//adjust position so that it goes from 0 to 1 in the range from color 1 & 2's position 
		position = (position-color1->position)/(color2->position - color1->position);
		
		out[0] = (color2->red   - color1->red  )*position + color1->red; 
		out[1] = (color2->green - color1->green)*position + color1->green;
		out[2] = (color2->blue  - color1->blue )*position + color1->blue;
		out[3] = (color2->alpha - color1->alpha)*position + color1->alpha;
	}
	
	//Premultiply the color by the alpha.
	out[0] *= out[3];
	out[1] *= out[3];
	out[2] *= out[3];
}

//Chromatic Evaluation - 
//	This blends colors by their Hue, Saturation, and Value(Brightness) right now I just 
//	transform the RGB values stored in the KAGradientElements to HSB, in the future I may
//	streamline it to avoid transforming in and out of HSB colorspace *for later*
//
//	For the chromatic blend we shift the hue of color1 to meet the hue of color2. To do
//	this we will add to the hue's angle (if we subtract we'll be doing the inverse
//	chromatic...scroll down more for that). All we need to do is keep adding to the hue
//  until we wrap around the colorwheel and get to color2.
void chromaticEvaluation(void *info, const float *in, float *out)
{
	float position = *in;
	
	if(*(KAGradientElement **)info == nil)	//if elementList is empty return clear color
	{
		out[0] = out[1] = out[2] = out[3] = 1;
		return;
	}
	
	//This grabs the first two colors in the sequence
	KAGradientElement *color1 = *(KAGradientElement **)info;
	KAGradientElement *color2 = color1->nextElement;
	
	float c1[4];
	float c2[4];
    
	//make sure first color and second color are on other sides of position
	while(color2 != nil && color2->position < position)
  	{
		color1 = color2;
		color2 = color1->nextElement;
  	}
	//if we don't have another color then make next color the same color
	if(color2 == nil)
    {
		color2 = color1;
    }
	
	
	c1[0] = color1->red; 
	c1[1] = color1->green;
	c1[2] = color1->blue;
	c1[3] = color1->alpha;
	
	c2[0] = color2->red; 
	c2[1] = color2->green;
	c2[2] = color2->blue;
	c2[3] = color2->alpha;
	
	transformRGB_HSV(c1);
	transformRGB_HSV(c2);
	resolveHSV(c1,c2);
	
	if(c1[0] > c2[0]) //if color1's hue is higher than color2's hue then 
		c2[0] += 360;	//	we need to move c2 one revolution around the wheel
	
	
	if(position <= color1->position)			//Make all below color color1's position equal to color1
  	{
		out[0] = c1[0]; 
		out[1] = c1[1];
		out[2] = c1[2];
		out[3] = c1[3];
  	}
	else if (position >= color2->position)	//Make all above color color2's position equal to color2
  	{
		out[0] = c2[0]; 
		out[1] = c2[1];
		out[2] = c2[2];
		out[3] = c2[3];
  	}
	else										//Interpolate color at postions between color1 and color1
  	{
		//adjust position so that it goes from 0 to 1 in the range from color 1 & 2's position 
		position = (position-color1->position)/(color2->position - color1->position);
		
		out[0] = (c2[0] - c1[0])*position + c1[0]; 
		out[1] = (c2[1] - c1[1])*position + c1[1];
		out[2] = (c2[2] - c1[2])*position + c1[2];
		out[3] = (c2[3] - c1[3])*position + c1[3];
  	}
    
	transformHSV_RGB(out);
	
	//Premultiply the color by the alpha.
	out[0] *= out[3];
	out[1] *= out[3];
	out[2] *= out[3];
}

//Inverse Chromatic Evaluation - 
//	Inverse Chromatic is about the same story as Chromatic Blend, but here the Hue
//	is strictly decreasing, that is we need to get from color1 to color2 by decreasing
//	the 'angle' (i.e. 90º -> 180º would be done by subtracting 270º and getting -180º...
//	which is equivalent to 180º mod 360º
void inverseChromaticEvaluation(void *info, const float *in, float *out)
{
    float position = *in;
	
	if(*(KAGradientElement **)info == nil)	//if elementList is empty return clear color
	{
		out[0] = out[1] = out[2] = out[3] = 1;
		return;
	}
	
	//This grabs the first two colors in the sequence
	KAGradientElement *color1 = *(KAGradientElement **)info;
	KAGradientElement *color2 = color1->nextElement;
	
	float c1[4];
	float c2[4];
	
	//make sure first color and second color are on other sides of position
	while(color2 != nil && color2->position < position)
  	{
		color1 = color2;
		color2 = color1->nextElement;
  	}
	//if we don't have another color then make next color the same color
	if(color2 == nil)
    {
		color2 = color1;
    }
	
	c1[0] = color1->red; 
	c1[1] = color1->green;
	c1[2] = color1->blue;
	c1[3] = color1->alpha;
	
	c2[0] = color2->red; 
	c2[1] = color2->green;
	c2[2] = color2->blue;
	c2[3] = color2->alpha;
	
	transformRGB_HSV(c1);
	transformRGB_HSV(c2);
	resolveHSV(c1,c2);
	
	if(c1[0] < c2[0]) //if color1's hue is higher than color2's hue then 
		c1[0] += 360;	//	we need to move c2 one revolution back on the wheel
	
	
	if(position <= color1->position)			//Make all below color color1's position equal to color1
  	{
		out[0] = c1[0]; 
		out[1] = c1[1];
		out[2] = c1[2];
		out[3] = c1[3];
  	}
	else if (position >= color2->position)	//Make all above color color2's position equal to color2
  	{
		out[0] = c2[0]; 
		out[1] = c2[1];
		out[2] = c2[2];
		out[3] = c2[3];
  	}
	else										//Interpolate color at postions between color1 and color1
  	{
		//adjust position so that it goes from 0 to 1 in the range from color 1 & 2's position 
		position = (position-color1->position)/(color2->position - color1->position);
		
		out[0] = (c2[0] - c1[0])*position + c1[0]; 
		out[1] = (c2[1] - c1[1])*position + c1[1];
		out[2] = (c2[2] - c1[2])*position + c1[2];
		out[3] = (c2[3] - c1[3])*position + c1[3];
  	}
    
	transformHSV_RGB(out);
	
	//Premultiply the color by the alpha.
	out[0] *= out[3];
	out[1] *= out[3];
	out[2] *= out[3];
}


void transformRGB_HSV(float *components) //H,S,B -> R,G,B
{
	float H, S, V;
	float R = components[0],
	G = components[1],
	B = components[2];
	
	float MAX = R > G ? (R > B ? R : B) : (G > B ? G : B),
	MIN = R < G ? (R < B ? R : B) : (G < B ? G : B);
	
	if(MAX == MIN)
		H = NAN;
	else if(MAX == R)
		if(G >= B)
			H = 60*(G-B)/(MAX-MIN)+0;
		else
			H = 60*(G-B)/(MAX-MIN)+360;
		else if(MAX == G)
			H = 60*(B-R)/(MAX-MIN)+120;
		else if(MAX == B)
			H = 60*(R-G)/(MAX-MIN)+240;
	
	S = MAX == 0 ? 0 : 1 - MIN/MAX;
	V = MAX;
	
	components[0] = H;
	components[1] = S;
	components[2] = V;
}

void transformHSV_RGB(float *components) //H,S,B -> R,G,B
{
	float R, G, B;
	float H = fmodf(components[0],359),	//map to [0,360)
	S = components[1],
	V = components[2];
	
	int   Hi = (int)floorf(H/60.) % 6;
	float f  = H/60-Hi,
	p  = V*(1-S),
	q  = V*(1-f*S),
	t  = V*(1-(1-f)*S);
	
	switch (Hi)
	{
		case 0:	R=V;G=t;B=p;	break;
		case 1:	R=q;G=V;B=p;	break;
		case 2:	R=p;G=V;B=t;	break;
		case 3:	R=p;G=q;B=V;	break;
		case 4:	R=t;G=p;B=V;	break;
		case 5:	R=V;G=p;B=q;	break;
	}
	
	components[0] = R;
	components[1] = G;
	components[2] = B;
}

void resolveHSV(float *color1, float *color2)	//H value may be undefined (i.e. graycale color)
{											//	we want to fill it with a sensible value
	if(isnan(color1[0]) && isnan(color2[0]))
		color1[0] = color2[0] = 0;
	else if(isnan(color1[0]))
		color1[0] = color2[0];
	else if(isnan(color2[0]))
		color2[0] = color1[0];
}

@end
