/*
 *  Vol52RoiManager.m
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

#import "Vol52RoiManager.h"

Vol52WindowController *vol52WindowController; //  A pointer to the Vol52WindowController sharedInstance.

@implementation Vol52RoiManager

@synthesize vol52RoiType = _vol52RoiType;
@synthesize vol52RoiName = _vol52RoiName;
@synthesize vol52RoiColor = _vol52RoiColor;
@synthesize vol52ManagedRois = _vol52ManagedRois;

static Vol52RoiManager *vol52RoiManager = nil;

+ (id) sharedInstance {
    @synchronized(self) {
        if (vol52RoiManager == nil)
            vol52RoiManager = [[self alloc] init];
    }
    [vol52RoiManager autorelease];
    return vol52RoiManager;
}

- (id) init {
    if (self = [super init]) {
        _vol52ManagedRois = [[NSMutableDictionary alloc] init];
        vol52WindowController = [Vol52WindowController sharedInstance];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newRoiCreated:) name:OsirixAddROINotification object:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roiWasChanged:) name:OsirixROIChangeNotification object:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roiWasDeleted:) name:OsirixRemoveROINotification object:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roiToolChanged:) name:OsirixDefaultToolModifiedNotification object:NULL];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"[Vol52] vol52RoiManager dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_vol52ManagedRois release];
    [super dealloc];
}

- (void) searchForRoisToManage: (NSMutableArray*) arrayOfNames {
//  Method would look for ROIs if vol52RoiManager were relased. But it is not released in this implementation at this moment.
    
}

- (void) createRoiType: (long) roiType withName: (NSString*) roiName withColor: (NSColor*) roiColor {
    
    ROI *alredyCreatedRoi = [self.vol52ManagedRois objectForKey:roiName];
    
    if (alredyCreatedRoi) { //Aqui tenho que ver, pois a condição é baseada apenas no nome e não no tipo de ROI. Tenho que pensar.
        
        NSLog(@"[Vol52] Already Created: %@",alredyCreatedRoi.name);
        
        DCMView *dcmView = [alredyCreatedRoi curView];
        ViewerController *viewerControler = [dcmView windowController];
        int imageIndexOfROI = [viewerControler imageIndexOfROI:alredyCreatedRoi];
        short numberOfImages = [viewerControler getNumberOfImages];
        
        if ([dcmView flippedData]) {
            NSLog(@"[Vol52] Flipped");
            long imageIndex = numberOfImages -imageIndexOfROI -1;
            [viewerControler setImageIndex:imageIndex];
        }
        else {
            NSLog(@"[Vol52] Not Flipped");
            long imageIndex = imageIndexOfROI;
            [viewerControler setImageIndex:imageIndex];
        }
        
        [[dcmView window] makeKeyAndOrderFront:self];
        [viewerControler selectROI:alredyCreatedRoi deselectingOther:YES];
    }
    else {
        NSLog(@"[Vol52] Not Created: %@",alredyCreatedRoi.name);
        _vol52RoiType = roiType;
        _vol52RoiName = roiName;
        _vol52RoiColor = roiColor;
        for (ViewerController *viewer in [ViewerController getDisplayed2DViewers]) { // Select ROI tool to each viewer.
            [viewer setROIToolTag:roiType];
        }
        [[[ViewerController frontMostDisplayed2DViewer] window] makeKeyAndOrderFront:self]; // Makes viewer key window.
        [vol52WindowController updateResultText]; // Update pluginu interface.
    }
}

- (void) newRoiCreated: (NSNotification*) notification {
    
    ROI *newRoi = [[notification userInfo] objectForKey:@"ROI"];
    ROI *alredyCreatedRoi = [self.vol52ManagedRois objectForKey:self.vol52RoiName];
    NSLog(@"[Vol52] Notification NEWROI: %@", [newRoi name]);
    
    if (alredyCreatedRoi) { //Check if the ROI is already created.
        return;
    } else if ([newRoi type] == self.vol52RoiType) {
        [newRoi setName:self.vol52RoiName];
        [newRoi setNSColor:self.vol52RoiColor globally:NO];
        NSLog(@"[Vol52] vol52ManagedRois ADDING: %@", newRoi.name);
        [self.vol52ManagedRois setObject:newRoi forKey:self.vol52RoiName];
        [vol52WindowController updateResultText]; // Update plugin interface.
    }
}

- (void) roiWasChanged: (NSNotification*) notification {
    
    ROI* changedRoi = [notification object];
    NSArray *allKeysForRoi = [self.vol52ManagedRois allKeysForObject:changedRoi];
    NSLog(@"[Vol52] Notification CHANGED: %@", [changedRoi name]);
    
    if ([allKeysForRoi count] > 0) { //Check if the ROI is managed.
        [vol52WindowController updateResultText]; // Update plugin interface.
    }
}

- (void) roiWasDeleted: (NSNotification*) notification {
    
    ROI* deletedRoi = [notification object];
    NSArray *allKeysForRoi = [self.vol52ManagedRois allKeysForObject:deletedRoi];
    NSLog(@"[Vol52] Notification DELETED: %@", [deletedRoi name]);
    
    if ([allKeysForRoi count] > 0) { // Check if the ROI is managed.
        for (NSString *keyForRoi in allKeysForRoi) { // Maybe unecessary. Probably there will be only one key for each ROI.
            NSLog(@"[Vol52] vol52ManagedRois REMOVING: %@", [deletedRoi name]);
            [self.vol52ManagedRois removeObjectForKey:keyForRoi];
        }
        [vol52WindowController updateResultText]; // Update plugin interface.
    }
}

- (void) roiToolChanged: (NSNotification*) notification {
    
    long toolType = [[[ViewerController frontMostDisplayed2DViewer] imageView] currentTool];
    
    if (toolType != self.vol52RoiType) {
        [self cancelRoiCreation];
    }
}

- (void) cancelRoiCreation {
    _vol52RoiType = nil;
    _vol52RoiName = nil;
    _vol52RoiColor = nil;
    [vol52WindowController updateResultText]; // Update plugin interface.
}

- (void) deleteRoiWithName: (NSString*) roiName {
    
    ROI *roiToDelete = [self.vol52ManagedRois objectForKey:roiName];
    DCMView *view = [roiToDelete curView];
    ViewerController *viewerControler = [view windowController];
    
    if (roiToDelete) {
        [viewerControler deleteROI:roiToDelete];
    }
}

- (void) updateRoiWithName: (NSString*) roiName withColor: (NSColor*) roiColor {
    
    ROI *roiToUpdate = [self.vol52ManagedRois objectForKey:roiName]; //tenho que ver esse lance do objectKey e nome do Roi... como vou identificar.
    
    if (roiToUpdate) {
        [roiToUpdate setName:self.vol52RoiName];
        [roiToUpdate setNSColor:self.vol52RoiColor globally:NO];
        [self.vol52ManagedRois setObject:roiToUpdate forKey:self.vol52RoiName]; //tenho que ver como vou mudar a key dentro do dictionary.
        [self cancelRoiCreation];
    }
}

@end
