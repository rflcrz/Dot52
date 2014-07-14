//
//  Vol52Filter.m
//  Vol52
//
//  Copyright (c) 2013 Rafael. All rights reserved.
//

#import "Vol52Filter.h"

@implementation Vol52Filter

- (void) initPlugin
{
}

- (long) filterImage:(NSString*) menuName
{
	//Menu clicked.
    [[Vol52WindowController sharedInstance] showWindow:nil];
    return 0;
}

@end
