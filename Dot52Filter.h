//
//  Dot52Filter.h
//  Dot52
//
//  Copyright (c) 2013 Rafael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OsiriXAPI/PluginFilter.h>
#import "Dot52WindowController.h"
#import "Dot52RoiManager.h"

@interface Dot52Filter : PluginFilter {
    
}

- (long) filterImage:(NSString*) menuName;

@end
