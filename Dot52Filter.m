//
//  Dot52Filter.m
//  Dot52
//
//  Copyright (c) 2013 Rafael. All rights reserved.
//

#import "Dot52Filter.h"

@implementation Dot52Filter

- (void) initPlugin
{
}

- (long) filterImage:(NSString*) menuName
{
	//Menu clicked.
    [[Dot52WindowController getDot52Window] showWindow:nil];
    return 0;
}

@end
