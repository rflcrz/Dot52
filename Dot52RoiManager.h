//
//  Dot52RoiCreator.h
//  Dot52
//
//  Created by Rafael Cruz on 15/12/13.
//
//

#import <Foundation/Foundation.h>
#import "Dot52Filter.h"
#import <OsiriXAPI/Notifications.h>

/** "Kind of" a singleton class, but it may be released.
 Its object must be accessed by using getDot52RoiManager class method and the caller must retain it.
**/
@interface Dot52RoiManager : NSObject

{
    long dot52RoiType;
    NSString *dot52RoiName;
    NSColor *dot52RoiColor;
    NSMutableDictionary *dot52ManagedRois;
}

@property (readonly) long dot52RoiType;
@property (strong, readonly) NSString *dot52RoiName;
@property (strong, readonly) NSColor *dot52RoiColor;
@property (strong, readonly) NSMutableDictionary *dot52ManagedRois;

/*!
 The singleton getter.
 Create the instance if not already created.
 Return the instance.
 Caller must retain the object (at this moment).
 Custom init method add instance as observer to OsiriX ROI notifications.
 Custom dealloc method removes observer.
 */
+ (id) getDot52RoiManager;

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