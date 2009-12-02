//
//  KACustomViewCustomDrawer.m
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

#import "KACustomViewCustomDrawer.h"
#import "KACustomView.h"
#import "KAGradient.h"

@implementation KACustomViewCustomDrawer

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
	KACustomView *_customView = (KACustomView *) control;
	NSRect bounds = [args m_ClipRectangle];
	if ([_customView BackImage] != nil && [[_customView BackImage] isValid])
	{
		// draw background image
		[[_customView BackImage] drawInRect: bounds 
								   fromRect: NSZeroRect 
								  operation: NSCompositeCopy
								   fraction: 1.0];
	}
	else if(nil != [_customView startColor] && nil != [_customView endColor])
	{			
		KAGradient* gradient = [[KAGradient alloc] initWithStartingColor: [_customView startColor]
															 endingColor: [_customView endColor]];
		[gradient addColorStop:[_customView startColor] atPosition:[_customView position]];
		[gradient drawInRect:bounds angle:90.0f];
		[gradient release];
	}
}

@end
