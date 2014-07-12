//
//  Dot52RoiCreator.m
//  Dot52
//
//  Created by Rafael Cruz on 15/12/13.
//
//

#import "Dot52RoiManager.h"

Dot52WindowController *dot52WindowController; //  A pointer to the Dot52WindowController sharedInstance.

@implementation Dot52RoiManager

@synthesize dot52RoiType = _dot52RoiType;
@synthesize dot52RoiName = _dot52RoiName;
@synthesize dot52RoiColor = _dot52RoiColor;
@synthesize dot52ManagedRois = _dot52ManagedRois;

static Dot52RoiManager *dot52RoiManager = nil;

+ (id) sharedInstance {
    @synchronized(self) {
        if (dot52RoiManager == nil)
            dot52RoiManager = [[self alloc] init];
    }
    [dot52RoiManager autorelease];
    return dot52RoiManager;
}

- (id) init {
    if (self = [super init]) {
        _dot52ManagedRois = [[NSMutableDictionary alloc] init];
        dot52WindowController = [Dot52WindowController sharedInstance];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newRoiCreated:) name:OsirixAddROINotification object:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roiWasChanged:) name:OsirixROIChangeNotification object:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roiWasDeleted:) name:OsirixRemoveROINotification object:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roiToolChanged:) name:OsirixDefaultToolModifiedNotification object:NULL];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"[Dot52] dot52RoiManager dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_dot52ManagedRois release];
    [super dealloc];
}

- (void) searchForRoisToManage: (NSMutableArray*) arrayOfNames {
//  Method would look for ROIs if dot52RoiManager were relased. But it is not released in this implementation at this moment.
    
}

- (void) createRoiType: (long) roiType withName: (NSString*) roiName withColor: (NSColor*) roiColor {
    
    ROI *alredyCreatedRoi = [self.dot52ManagedRois objectForKey:roiName];
    
    if (alredyCreatedRoi) { //Aqui tenho que ver, pois a condição é baseada apenas no nome e não no tipo de ROI. Tenho que pensar.
        
        NSLog(@"[Dot52] Already Created: %@",alredyCreatedRoi.name);
        
        DCMView *dcmView = [alredyCreatedRoi curView];
        ViewerController *viewerControler = [dcmView windowController];
        int imageIndexOfROI = [viewerControler imageIndexOfROI:alredyCreatedRoi];
        short numberOfImages = [viewerControler getNumberOfImages];
        
        if ([dcmView flippedData]) {
            NSLog(@"[Dot52] Flipped");
            long imageIndex = numberOfImages -imageIndexOfROI -1;
            [viewerControler setImageIndex:imageIndex];
        }
        else {
            NSLog(@"[Dot52] Not Flipped");
            long imageIndex = imageIndexOfROI;
            [viewerControler setImageIndex:imageIndex];
        }
        
        [[dcmView window] makeKeyAndOrderFront:self];
        [viewerControler selectROI:alredyCreatedRoi deselectingOther:YES];
    }
    else {
        NSLog(@"[Dot52] Not Created: %@",alredyCreatedRoi.name);
        _dot52RoiType = roiType;
        _dot52RoiName = roiName;
        _dot52RoiColor = roiColor;
        for (ViewerController *viewer in [ViewerController getDisplayed2DViewers]) { // Select ROI tool to each viewer.
            [viewer setROIToolTag:roiType];
        }
        [[[ViewerController frontMostDisplayed2DViewer] window] makeKeyAndOrderFront:self]; // Makes viewer key window.
        [dot52WindowController updateResultText]; // Update pluginu interface.
    }
}

- (void) newRoiCreated: (NSNotification*) notification {
    
    ROI *newRoi = [[notification userInfo] objectForKey:@"ROI"];
    ROI *alredyCreatedRoi = [self.dot52ManagedRois objectForKey:self.dot52RoiName];
    NSLog(@"[Dot52] Notification NEWROI: %@", [newRoi name]);
    
    if (alredyCreatedRoi) { //Check if the ROI is already created.
        return;
    } else if ([newRoi type] == self.dot52RoiType) {
        [newRoi setName:self.dot52RoiName];
        [newRoi setNSColor:self.dot52RoiColor globally:NO];
        NSLog(@"[Dot52] dot52ManagedRois ADDING: %@", newRoi.name);
        [self.dot52ManagedRois setObject:newRoi forKey:self.dot52RoiName];
        [dot52WindowController updateResultText]; // Update plugin interface.
    }
}

- (void) roiWasChanged: (NSNotification*) notification {
    
    ROI* changedRoi = [notification object];
    NSArray *allKeysForRoi = [self.dot52ManagedRois allKeysForObject:changedRoi];
    NSLog(@"[Dot52] Notification CHANGED: %@", [changedRoi name]);
    
    if ([allKeysForRoi count] > 0) { //Check if the ROI is managed.
        [dot52WindowController updateResultText]; // Update plugin interface.
    }
}

- (void) roiWasDeleted: (NSNotification*) notification {
    
    ROI* deletedRoi = [notification object];
    NSArray *allKeysForRoi = [self.dot52ManagedRois allKeysForObject:deletedRoi];
    NSLog(@"[Dot52] Notification DELETED: %@", [deletedRoi name]);
    
    if ([allKeysForRoi count] > 0) { // Check if the ROI is managed.
        for (NSString *keyForRoi in allKeysForRoi) { // Maybe unecessary. Probably there will be only one key for each ROI.
            NSLog(@"[Dot52] dot52ManagedRois REMOVING: %@", [deletedRoi name]);
            [self.dot52ManagedRois removeObjectForKey:keyForRoi];
        }
        [dot52WindowController updateResultText]; // Update plugin interface.
    }
}

- (void) roiToolChanged: (NSNotification*) notification {
    
    long toolType = [[[ViewerController frontMostDisplayed2DViewer] imageView] currentTool];
    
    if (toolType != self.dot52RoiType) {
        [self cancelRoiCreation];
    }
}

- (void) cancelRoiCreation {
    _dot52RoiType = nil;
    _dot52RoiName = nil;
    _dot52RoiColor = nil;
    [dot52WindowController updateResultText]; // Update plugin interface.
}

- (void) deleteRoiWithName: (NSString*) roiName {
    
    ROI *roiToDelete = [self.dot52ManagedRois objectForKey:roiName];
    DCMView *view = [roiToDelete curView];
    ViewerController *viewerControler = [view windowController];
    
    if (roiToDelete) {
        [viewerControler deleteROI:roiToDelete];
    }
}

- (void) updateRoiWithName: (NSString*) roiName withColor: (NSColor*) roiColor {
    
    ROI *roiToUpdate = [self.dot52ManagedRois objectForKey:roiName]; //tenho que ver esse lance do objectKey e nome do Roi... como vou identificar.
    
    if (roiToUpdate) {
        [roiToUpdate setName:self.dot52RoiName];
        [roiToUpdate setNSColor:self.dot52RoiColor globally:NO];
        [self.dot52ManagedRois setObject:roiToUpdate forKey:self.dot52RoiName]; //tenho que ver como vou mudar a key dentro do dictionary.
        [self cancelRoiCreation];
    }
}

@end
