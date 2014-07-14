//
//  Vol52Filter.h
//  Vol52
//
//  Copyright (c) 2013 Rafael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OsiriXAPI/PluginFilter.h>
#import "Vol52WindowController.h"
#import "Vol52RoiManager.h"

@interface Vol52Filter : PluginFilter {
    
}

- (long) filterImage:(NSString*) menuName;

@end
