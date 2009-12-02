//
//  KACustomView.h
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

#import <Cocoa/Cocoa.h>
#import "IPresentationSeparated.h"
/*!
 @class
 @abstract    Kodak custom view class.
 @discussion  This custom view inherits from NSView and user can use image,
 gradient colors to custom the style. And also can select the 
 buildin styles.
 */
@interface KACustomView : NSView <IPresentationSeparated>
{
	NSString	*m_BackgroundImage;
	NSImage		*m_BackImage;
	
	NSColor		*m_StartColor;
	NSColor		*m_EndColor;
	
	NSString	*kastyle;
	int			__style;
	CGFloat		m_GrandientPosition;
	
	NSArray		*kastyles;
}

/*!
 @function
 @abstract   The style of the class.
 @discussion The style makes custom view use the build in colors to display.
 @param      void.
 @result     The style name of the control.
 */
- (NSString *) kastyle;
- (void) setKastyle: (NSString *) newValue;

/*!
 @function
 @abstract   The path of the image.
 @discussion This path is the absolute path to the file in XCode project.
 And when running, class will use the file name to find the 
 image in MainBunlde.
 @param      void.
 @result     The absolute path of the image.
 */
- (NSString *) backgroundImage;
- (void) setBackgroundImage: (NSString *) image;
- (NSColor *) startColor;
- (void) setStartColor: (NSColor *) newValue;
- (NSColor *) endColor;
- (void) setEndColor: (NSColor *) newValue;
- (CGFloat) position;
- (void) setPosition: (CGFloat) newValue;
- (NSImage *) BackImage;
- (void) setBackImage: (NSImage *) newValue;
- (NSArray *) kastyles;
- (void) setKastyles: (NSArray *) newValue;
@end
