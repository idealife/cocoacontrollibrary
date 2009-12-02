//
//  KAButtonInspector.m
//  AiOControlIBPlugin
//
//  Created by Edward.Chen on 11/16/09.
//  Copyright 2009 Eastman Kodak Company. All rights reserved.
//

#import "KAButtonInspector.h"

@implementation KAButtonInspector

- (NSString *)viewNibName {
    return @"KAButtonInspector";
}

- (void)refresh {
	// Synchronize your inspector's content view with the currently selected objects
	[super refresh];
}

- (NSString *) label
{
	return @"KAButton";
}

@end
