//
//  Vol52RoiCreator.h
//  Vol52
//
//  Created by Rafael Cruz on 15/12/13.
//
//

#import <Foundation/Foundation.h>
#import "Vol52Filter.h"
#import <OsiriXAPI/Notifications.h>

/** "Kind of" a singleton class, but it may be released.
 Its object must be accessed by using sharedInstance class method and the caller must retain it.
**/
@interface Vol52RoiManager : NSObject

{
    long _vol52RoiType;
    NSString *_vol52RoiName;
    NSColor *_vol52RoiColor;
    NSMutableDictionary *_vol52ManagedRois;
}

@property (readonly) long vol52RoiType;
@property (strong, readonly) NSString *vol52RoiName;
@property (strong, readonly) NSColor *vol52RoiColor;
@property (strong, readonly) NSMutableDictionary *vol52ManagedRois;

/*!
 This method returns the shared instance of Vol52RoiManager Class.
 Create the instance if not already created.
 Return the instance.
 Caller must retain the object (at this moment).
 Custom init method add instance as observer to OsiriX ROI notifications.
 Custom dealloc method removes observer.
 */
+ (id) sharedInstance;

- (void) searchForRoisToManage: (NSMutableArray*) arrayOfNames;

- (void) createRoiType: (long) roiType withName: (NSString*) roiName withColor: (NSColor*) roiColor;

- (void) newRoiCreated: (NSNotification*) notification;

- (void) roiWasChanged: (NSNotification*) notification;

- (void) roiWasDeleted: (NSNotification*) notification;

- (void) roiToolChanged: (NSNotification*) notification;

- (void) cancelRoiCreation;

- (void) deleteRoiWithName: (NSString*) roiName;

- (void) updateRoiWithName: (NSString*) roiName withColor: (NSColor*) roiColor;

@end