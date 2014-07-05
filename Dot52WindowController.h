//
//  Dot52WindowController.h
//  Dot52
//
//  Created by Rafael Cruz on 15/12/13.
//
//

#import <Cocoa/Cocoa.h>

@interface Dot52WindowController : NSWindowController

{
    NSTextView *resultText;
    NSButton *buttonCopyResult;
    NSTextField *textDiameterAp;
    NSTextField *textDiamaterTrv;
    NSTextField *textDiamaterLon;
    NSImageView *iconAp;
    NSImageView *iconTrv;
    NSImageView *iconLon;
    
    NSMutableString *customResultString;
    NSString *resultString;
    NSString *ApDiameterString;
    NSString *TrvDiameterString;
    NSString *LonDiameterString;
}

#pragma mark - IBOutlets
// ---------------------------------------------------------------------------
//  IBOutlets
// ---------------------------------------------------------------------------
@property (assign) IBOutlet NSTextView *resultText; // NSTextView to display result.
@property (assign) IBOutlet NSButton *buttonCopyResult; // Button to let the user copy displayed result to clipboard.
@property (assign) IBOutlet NSTextField *textDiameterAp; // NSTextField to display AP diameter.
@property (assign) IBOutlet NSTextField *textDiamaterTrv; // NSTextField to display TRV diameter.
@property (assign) IBOutlet NSTextField *textDiamaterLon; // NSTextField to display LON diameter.
@property (assign) IBOutlet NSImageView *iconAp; // Icon to give feedback of process of AP ROI creation.
@property (assign) IBOutlet NSImageView *iconTrv; // Icon to give feedback of process of TRV ROI creation.
@property (assign) IBOutlet NSImageView *iconLon; // Icon to give feedback of process of LON ROI creation.


#pragma mark - Class Properties
// ---------------------------------------------------------------------------
//  Class Properties
// ---------------------------------------------------------------------------
@property (strong) NSMutableString *customResultString; // Custom string, defined by the user, to create the text containing the results.
@property (strong) NSString *resultString; // NSString to hold the result.
@property (strong) NSString *ApDiameterString; // NSString to hold AP diameter.
@property (strong) NSString *TrvDiameterString; // NSString to hold TRV diameter.
@property (strong) NSString *LonDiameterString; // NSString to hold LON diameter.


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

@end