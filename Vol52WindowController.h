/*
 *  Vol52WindowController.h
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

#import <Cocoa/Cocoa.h>

@interface Vol52WindowController : NSWindowController
{
    NSTextView *_resultText;
    NSTextField *_customResultTextField;
    NSButton *_buttonCopyResult;
    NSImageView *_iconAp;
    NSImageView *_iconTrv;
    NSImageView *_iconLon;
    NSPopover *_popover;
    
    NSString *_customResultString;
    NSString *_resultString;
    NSString *_apDiameterString;
    NSString *_trvDiameterString;
    NSString *_lonDiameterString;
}

#pragma mark - IBOutlets
// ---------------------------------------------------------------------------
//  IBOutlets
// ---------------------------------------------------------------------------
@property (assign) IBOutlet NSTextView *resultText; ///< NSTextView to display result.
@property (assign) IBOutlet NSTextField *customResultTextField; ///< NSTextField to edit custom result.
@property (assign) IBOutlet NSButton *buttonCopyResult; ///< Button to let the user copy displayed result to clipboard.
@property (assign) IBOutlet NSImageView *iconAp; ///< Icon to give feedback of process of AP ROI creation.
@property (assign) IBOutlet NSImageView *iconTrv; ///< Icon to give feedback of process of TRV ROI creation.
@property (assign) IBOutlet NSImageView *iconLon; ///< Icon to give feedback of process of LON ROI creation.
@property (assign) IBOutlet NSPopover *popover; ///< NSPopover to edit customResultString.


#pragma mark - Class Properties
// ---------------------------------------------------------------------------
//  Class Properties
// ---------------------------------------------------------------------------
@property (copy) NSString *customResultString; ///< Custom string, defined by the user, to create the text containing the results.
@property (strong) NSString *resultString; ///< NSString to hold the result.
@property (strong) NSString *apDiameterString; ///< NSString to hold AP diameter.
@property (strong) NSString *trvDiameterString; ///< NSString to hold TRV diameter.
@property (strong) NSString *lonDiameterString; ///< NSString to hold LON diameter.


#pragma mark - Class Methods
// ---------------------------------------------------------------------------
//  Class Methods
// ---------------------------------------------------------------------------

/**
 *  Returns the shared instance of Vol52WindowController class.
 *
 *  @return id The shared instance.
 */
+ (id) sharedInstance;


#pragma mark - Instance Methods
// ---------------------------------------------------------------------------
//  Instance Methods
// ---------------------------------------------------------------------------
- (void) updateResultText;


#pragma mark - IBActions
// ---------------------------------------------------------------------------
//  IBActions
// ---------------------------------------------------------------------------
- (IBAction)selectCoefficient:(NSPopUpButton *)sender;

- (IBAction)buttonCreateApRoi:(NSButton *)sender;

- (IBAction)buttonCreateTrvRoi:(NSButton *)sender;

- (IBAction)buttonCreateLonRoi:(NSButton *)sender;

- (IBAction)copyResult:(NSButton *)sender;

- (IBAction)editResultText:(NSButton *)sender;

- (IBAction)insertPlaceholder:(NSButton *)sender;

- (IBAction)resetCustomResultString:(NSButton *)sender;

@end