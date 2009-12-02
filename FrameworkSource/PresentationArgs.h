//
//  PresentationArgs.h
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

#import <Cocoa/Cocoa.h>
#import "IControlPresentationInfo.h"

/*!
 @class
 @abstract    PresentationArgs
 @discussion  Which to hold the drawing args.
 */
@interface PresentationArgs : NSObject {
	CGContextRef					m_Context;
	id<IControlPresentationInfo>	m_PresentationInfo;
	NSRect							m_ClipRectangle;
}


/*! 
 The presentation info which holds additoinal draw arguments. 
 */
- (id) m_PresentationInfo;
- (void) setM_PresentationInfo: (id) newValue;

/*!
 The CGContextRef instance which to draw the control.
 */
- (CGContextRef) m_Context;
- (void) setM_Context: (CGContextRef) newValue;

/*!
 The clipping rectangle of the control.
 */
- (NSRect) m_ClipRectangle;
- (void) setM_ClipRectangle:(NSRect) newRect;
@end
