/*
 *  Vol52RoiManager.h
 *  Ellipsoid Volume Plugin
 *
 *  Created by Rafael Cruz on 15/12/13.
 *  Copyright (c) 2013, 2014 Rafael Cruz. All rights reserved.
 *
 *
 *  This file is part of Ellipsoid Volume, a OsiriX Plugin.
 *
 *  Ellipsoid Volume is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  Ellipsoid Volume is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Ellipsoid Volume.  If not, see <http://www.gnu.org/licenses/>.
 */

#import <Foundation/Foundation.h>
#import "Vol52Filter.h"
#import <OsiriXAPI/Notifications.h>

/* "Kind of" a singleton class, but it may be released.
 Its object must be accessed by using sharedInstance class method and the caller must retain it.
 */
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
 * @brief This method returns the instance of Vol52RoiManager Class.
 * @discussion
 * Creates the instance if not already created.
 * Return the instance.
 * Caller must retain the object (at this moment).
 * @code
 * [[Vol52RoiManager sharedInstance] retain]
 * @endcode
 * @return A shared instance of this class.
 */
+ (id) sharedInstance;

- (void) searchForRoisToManage: (NSMutableArray*) arrayOfNames;

/*!
 * @brief Use this method to allow the user to create a ROI managed by this class.
 * @discussion
 * This method selects the right ROI tool in the user interface and makes the instance waits for the creation of a ROI to manage. When the user creates a ROI OsiriX will post a notification that will call newRoiCreated method.
 * @param roiType The ROI type.
 * @param roiName The ROI name.
 * @param roiColor The ROI color.
 */
- (void) createRoiType: (long) roiType withName: (NSString*) roiName withColor: (NSColor*) roiColor;

- (void) newRoiCreated: (NSNotification*) notification;

- (void) roiWasChanged: (NSNotification*) notification;

- (void) roiWasDeleted: (NSNotification*) notification;

- (void) roiToolChanged: (NSNotification*) notification;

- (void) cancelRoiCreation;

- (void) deleteRoiWithName: (NSString*) roiName;

- (void) updateRoiWithName: (NSString*) roiName withColor: (NSColor*) roiColor;

@end