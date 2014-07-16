/*
 *  Vol52WindowController.m
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


#import "Vol52WindowController.h"
#import "Vol52RoiManager.h"

float _corrCoeff; // Will store the value of the selected correction coefficient.
NSString *_apRoiName; // Name to the ROI created with the "AP" button. Will be used as key for this ROI in vol52ManagedRois NSMutableDictionary.
NSString *_trvRoiName; // Name to the ROI created with the "TRV" button. Will be used as key for this ROI in vol52ManagedRois NSMutableDictionary.
NSString *_lonRoiName; // Name to the ROI created with the "LON" button. Will be used as key for this ROI in vol52ManagedRois NSMutableDictionary.
Vol52RoiManager *vol52RoiManager; // Pointer to Vol52RoiManager sharedInstance.

@implementation Vol52WindowController
@synthesize popover = _popover;

@synthesize resultText = _resultText;
@synthesize customResultTextField = _customResultTextField;
@synthesize buttonCopyResult = _buttonCopyResult;
@synthesize iconAp = _iconAp;
@synthesize iconTrv = _iconTrv;
@synthesize iconLon = _iconLon;

@synthesize customResultString = _customResultString;
@synthesize resultString = _resultString;
@synthesize apDiameterString = _apDiameterString;
@synthesize trvDiameterString = _trvDiameterString;
@synthesize lonDiameterString = _lonDiameterString;

#pragma mark - Class Methods
// ---------------------------------------------------------------------------
//  Class Methods
// ---------------------------------------------------------------------------
+ (id) sharedInstance {
    static Vol52WindowController *vol52Window = nil;
    @synchronized(self) {
        if (vol52Window == nil)
            vol52Window = [[self alloc] initWithWindowNibName:@"Vol52WindowController"];
    }
    //[vol52Window autorelease];
    return vol52Window;
}

#pragma mark - Instance Methods
// ---------------------------------------------------------------------------
//  Instance Methods
// ---------------------------------------------------------------------------
- (id)initWithWindow:(NSWindow *)window {
    NSLog(@"Yes, was called!");
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)dealloc {
    NSLog(@"vol52WindowControler dealloc");
    [vol52RoiManager release];
    [super dealloc];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after vol52Window has been loaded from its nib file.
    
    _corrCoeff = M_PI/6;
    _apRoiName = @"Anteroposterior";
    _trvRoiName = @"Transverse";
    _lonRoiName = @"Longitudinal";
    vol52RoiManager = [[Vol52RoiManager sharedInstance] retain];

    [self updateResultText];
}

// Custom setter to read from the customResultString.txt file.
- (NSString *) customResultString {
    if (_customResultString == nil) {
        NSURL *pluginResourcesURL = [[NSBundle bundleForClass:[self class]] resourceURL];
        NSURL *fileUrl = [pluginResourcesURL URLByAppendingPathComponent:@"customResultString.txt"];
        self.customResultString = [NSString stringWithContentsOfURL:fileUrl encoding:NSUTF8StringEncoding error:nil];
    }
    return _customResultString;
}

// Custom setter to save customResultString to the customResultString.txt file.
- (void)setCustomResultString:(NSString *)newString {
    if (newString != _customResultString) {
        [_customResultString release];
        _customResultString = [newString copy];
        
        NSURL *pluginResourcesURL = [[NSBundle bundleForClass:[self class]] resourceURL];
        NSURL *fileUrl = [pluginResourcesURL URLByAppendingPathComponent:@"customResultString.txt"];
        [_customResultString writeToURL:fileUrl atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        [self updateResultText];
    }
}

- (void) updateResultText {
    
    // Updating status icons of managed ROIs.
    NSString *roiBeingCreated = [vol52RoiManager vol52RoiName];
    ROI *apRoi = [[vol52RoiManager vol52ManagedRois] objectForKey:_apRoiName];
    ROI *trvRoi = [[vol52RoiManager vol52ManagedRois] objectForKey:_trvRoiName];
    ROI *lonRoi = [[vol52RoiManager vol52ManagedRois] objectForKey:_lonRoiName];
    
    if (apRoi) {
        [self.iconAp setImage:[NSImage imageNamed:@"NSStatusAvailable"]];
    } else if (roiBeingCreated == _apRoiName) {
        [self.iconAp setImage:[NSImage imageNamed:@"NSStatusPartiallyAvailable"]];
    } else {
        [self.iconAp setImage:[NSImage imageNamed:@"NSStatusNone"]];
    }
    
    if (trvRoi) {
        [self.iconTrv setImage:[NSImage imageNamed:@"NSStatusAvailable"]];
    } else if (roiBeingCreated == _trvRoiName) {
        [self.iconTrv setImage:[NSImage imageNamed:@"NSStatusPartiallyAvailable"]];
    } else {
        [self.iconTrv setImage:[NSImage imageNamed:@"NSStatusNone"]];
    }
    
    if (lonRoi) {
        [self.iconLon setImage:[NSImage imageNamed:@"NSStatusAvailable"]];
    } else if (roiBeingCreated == _lonRoiName) {
        [self.iconLon setImage:[NSImage imageNamed:@"NSStatusPartiallyAvailable"]];
    } else {
        [self.iconLon setImage:[NSImage imageNamed:@"NSStatusNone"]];
    }
    
    // Updating NSTextFields and NSTextView
    float apRoiLength = [self lengthForRoiName:_apRoiName];
    float trvRoiLength = [self lengthForRoiName:_trvRoiName];
    float lonRoiLength = [self lengthForRoiName:_lonRoiName];
    float estimatedVolume = apRoiLength * trvRoiLength * lonRoiLength * _corrCoeff;
    
    if (apRoiLength > 0) {
        self.apDiameterString = [NSString stringWithFormat:@"= %@ cm", [self stringFromFloat:apRoiLength]];
    } else {
        self.apDiameterString = @"Set AP.";
    }
    
    if (trvRoiLength > 0) {
        self.trvDiameterString = [NSString stringWithFormat:@"= %@ cm", [self stringFromFloat:trvRoiLength]];
    } else {
        self.trvDiameterString = @"Set TRV.";
    }
    
    if (lonRoiLength > 0) {
        self.lonDiameterString = [NSString stringWithFormat:@"= %@ cm", [self stringFromFloat:lonRoiLength]];
    } else {
        self.lonDiameterString = @"Set LON.";
    }
    
    if (estimatedVolume > 0) {
        
        NSString *stringToReplace; // I'm using this local string because resultString is bound to the user interface and I want to avoid updates on the user interface during the for loop below.
        stringToReplace = self.customResultString;
        
        NSDictionary *replacements = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [self stringFromFloat:apRoiLength], @"@AP",
                                      [self stringFromFloat:trvRoiLength], @"@TRV",
                                      [self stringFromFloat:lonRoiLength], @"@LON",
                                      [self stringFromFloat:estimatedVolume], @"@VOL",
                                      nil];
        
        for (NSString *toReplace in replacements) {
            stringToReplace = [stringToReplace stringByReplacingOccurrencesOfString:toReplace
                                                                         withString:[replacements objectForKey:toReplace]];
        }
        self.resultString = stringToReplace;
        [self.buttonCopyResult setEnabled:YES];
    } else {
        self.resultString = @"Set anteroposterior, transverse and longitudinal diameters to estimate volume.";
        [self.buttonCopyResult setEnabled:NO];
    }
}

- (NSString *) stringFromFloat:(float)myFloat {
    NSNumber *floatNSNumber = [NSNumber numberWithFloat:myFloat];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:1];
    NSString *floatString = [numberFormatter stringFromNumber:floatNSNumber];
    return floatString;
}

#pragma mark - IBActions
// ---------------------------------------------------------------------------
//  IBActions
// ---------------------------------------------------------------------------
- (IBAction)selectCoefficient:(NSPopUpButton *)sender {
    switch ([sender indexOfSelectedItem]) {
        case 0:
            _corrCoeff = M_PI/6;
            break;
        case 1:
            _corrCoeff = 0.625;
            break;
        case 2:
            _corrCoeff = 0.71;
            break;
        default:
            _corrCoeff = M_PI/6;
            [sender selectItemAtIndex:0];
            break;
    }
    [self updateResultText];
}

- (IBAction)buttonCreateApRoi:(NSButton *)sender {
    [vol52RoiManager createRoiType:tMesure withName:_apRoiName withColor:[NSColor blueColor]];
}

- (IBAction)buttonCreateTrvRoi:(NSButton *)sender {
    [vol52RoiManager createRoiType:tMesure withName:_trvRoiName withColor:[NSColor redColor]];
}

- (IBAction)buttonCreateLonRoi:(NSButton *)sender {
    [vol52RoiManager createRoiType:tMesure withName:_lonRoiName withColor:[NSColor yellowColor]];
}

- (IBAction)copyResult:(NSButton *)sender {
    NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
    NSArray *types = [NSArray arrayWithObjects:NSStringPboardType, nil];
    [pasteBoard declareTypes:types owner:self];
    [pasteBoard setString:self.resultString forType:NSStringPboardType];
}

- (IBAction)editResultText:(NSButton *)sender {
    [self.popover showRelativeToRect:[self.resultText bounds] ofView:self.resultText preferredEdge:NSMinXEdge];
}

- (IBAction)insertPlaceholder:(NSButton *)sender {
    NSMutableString *stringToInsert = [NSMutableString stringWithString:@"@"];
    NSString *stringToAppend = [sender title];
    [stringToInsert appendString:stringToAppend];
    [self.customResultTextField.currentEditor insertText:stringToInsert];
}

- (IBAction)resetCustomResultString:(NSButton *)sender {
    self.customResultString = [[NSMutableString alloc] initWithString:@"Measures @AP x @TRV x @LON cm, with an estimated volume of about @VOL ml."];
    [self.customResultTextField.currentEditor setString:self.customResultString];
}

#pragma mark - Tweaks...
// ---------------------------------------------------------------------------
//  This method was created to get [roi MesureLength] avoiding exceptions.
//
//  * Check the number of points. Theres an exception when the user select and
//  deletes a single point.
//  * In this case we should not call [ROI MesureLength] before the ROI is
//  completely deleted, because the ROI will still exists and this method will
//  not check the number of points - raising an exception.
// ---------------------------------------------------------------------------
- (float) lengthForRoiName: (NSString*) roiName {
    NSDictionary *vol52ManagedRois = [vol52RoiManager vol52ManagedRois];
    ROI *roi = [vol52ManagedRois objectForKey:roiName];
    int numberOfPoints = [[roi points] count];
    float roiLength = 0;
    if (numberOfPoints > 1) { // See comments.
        roiLength = [roi MesureLength:NULL];
    }
    
    return roiLength;
}

@end
