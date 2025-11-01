//
//  RegistroViewController.h
//  GotaAGota
//
//  Created by rentamac on 10/31/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegistroViewController : NSViewController

@property (weak) IBOutlet NSTextField *litrosTextField;
@property (weak) IBOutlet NSPopUpButton *actividadPopUp;
@property (weak) IBOutlet NSDatePicker *fechaPicker;
@property (weak) IBOutlet NSTextField *comentarioTextField;
@property (weak) IBOutlet NSScrollView *tablaRegistros;
@property (weak) IBOutlet NSArrayController *arrayController;
@property (weak) IBOutlet NSView *panelView;


- (IBAction)cerrar:(id)sender;
- (IBAction)guardarRegistro:(id)sender;



@end

NS_ASSUME_NONNULL_END
