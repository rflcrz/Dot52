//
//  Vol52WindowController.h
//  Vol52
//
//  Created by Rafael Cruz on 15/12/13.
//
//

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
@property (assign) IBOutlet NSTextView *resultText; // NSTextView to display result.
@property (assign) IBOutlet NSTextField *customResultTextField; // NSTextField to edit custom result.
@property (assign) IBOutlet NSButton *buttonCopyResult; // Button to let the user copy displayed result to clipboard.
@property (assign) IBOutlet NSImageView *iconAp; // Icon to give feedback of process of AP ROI creation.
@property (assign) IBOutlet NSImageView *iconTrv; // Icon to give feedback of process of TRV ROI creation.
@property (assign) IBOutlet NSImageView *iconLon; // Icon to give feedback of process of LON ROI creation.
@property (assign) IBOutlet NSPopover *popover; // NSPopover to edit customResultString.


#pragma mark - Class Properties
// ---------------------------------------------------------------------------
//  Class Properties
// ---------------------------------------------------------------------------
@property (copy) NSString *customResultString; // Custom string, defined by the user, to create the text containing the results.
@property (strong) NSString *resultString; // NSString to hold the result.
@property (strong) NSString *apDiameterString; // NSString to hold AP diameter.
@property (strong) NSString *trvDiameterString; // NSString to hold TRV diameter.
@property (strong) NSString *lonDiameterString; // NSString to hold LON diameter.


#pragma mark - Class Methods
// ---------------------------------------------------------------------------
//  Class Methods
// ---------------------------------------------------------------------------
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