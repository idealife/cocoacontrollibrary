//
//  PresentationManager.m
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

#import "PresentationManager.h"

static PresentationManager *sharedInstance;

@implementation PresentationManager

+(id) Instance
{
	@synchronized(self)
	{
		if(nil == sharedInstance)
		{
			[[self alloc] init];
		}
	}
	return sharedInstance;	
}


+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized(self) 
	{
        if (sharedInstance == nil) 
		{
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id) copyWithZone:(NSZone *)zone
{
    return self;
}

- (id) retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void) release
{
    //do nothing
}

- (id) autorelease
{
    return self;
}

- (id) init
{
	if(self = [super init])
	{
		DrawerFactory *factory = [[DrawerFactory alloc] init];
		[self setM_DrawFactory:factory];
		[factory release];
	}
	return self;
}

- (void) dealloc
{
	[self setM_DrawFactory:nil];
	[super dealloc];
}


/*!
 @function	
 @abstract   Draw the presentation of the control specified in the args.
 @discussion Draw the presentation of the control specified in the args.
 @param      control The tobe drawn control
 @param		args Argument of the drawing
 @result     void
 */
- (void) DrawControl:(id<IPresentationSeparated>) control 
				Args:(PresentationArgs *) args
{
	id<IControlDrawer> controlDrawer = [m_DrawerFactory GetDrawer:[control class]];
	if(!controlDrawer)
	{
		return;
	}
	[controlDrawer DrawControl:control Args:args];
}

/*!
 @function	
 @abstract   Draw the presentation of the control with the specified style.
 @discussion Draw the presentation of the control with the specified style.
 @param      control The tobe drawn control.
 @param		args	Argument of the drawing.
 @param		styleId	The style id of the control.
 @result     void
 */
- (void) DrawControl:(id<IPresentationSeparated>) control 
				Args:(PresentationArgs *) args 
			   Style:(int) styleId
{
	id<IControlDrawer> controlDrawer = [m_DrawerFactory GetDrawer:[control class] StyleId:styleId];
	if(!controlDrawer)
	{
		return;
	}
	[controlDrawer DrawControl:control Args:args];
}


- (id<IDrawFactory>) m_DrawerFactory
{
	return m_DrawerFactory;
}
- (void) setM_DrawFactory:(id<IDrawFactory>) newFactory
{
	if(m_DrawerFactory != newFactory)
	{
		[m_DrawerFactory release];
		m_DrawerFactory = [newFactory retain];
	}
}

@end
