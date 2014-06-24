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
    NSTextField *resultText;
    NSButton *buttonCopyResult;
    NSTextField *textDiameterAp;
    NSTextField *textDiamaterTrv;
    NSTextField *textDiamaterLon;
    NSImageView *iconAp;
    NSImageView *iconTrv;
    NSImageView *iconLon;
}

@property (assign) IBOutlet NSTextField *resultText; // NSTextfield to display result.
@property (assign) IBOutlet NSButton *buttonCopyResult; // Button to let the user copy displayed result to clipboard.
@property (assign) IBOutlet NSTextField *textDiameterAp; // NSTextField to display AP diameter.
@property (assign) IBOutlet NSTextField *textDiamaterTrv; // NSTextField to display TRV diameter.
@property (assign) IBOutlet NSTextField *textDiamaterLon; // NSTextField to display LON diameter.
@property (assign) IBOutlet NSImageView *iconAp; // Icon to give feedback of process of AP ROI creation.
@property (assign) IBOutlet NSImageView *iconTrv; // Icon to give feedback of process of TRV ROI creation.
@property (assign) IBOutlet NSImageView *iconLon; // Icon to give feedback of process of LON ROI creation.

+ (id) getDot52Window;

- (IBAction)selectMethod:(NSPopUpButton *)sender;

- (IBAction)buttonCreateApRoi:(NSButton *)sender;

- (IBAction)buttonCreateTrvRoi:(NSButton *)sender;

- (IBAction)buttonCreateLonRoi:(NSButton *)sender;

- (IBAction)copyResult:(NSButton *)sender;

- (void) updateResultText;

@end
