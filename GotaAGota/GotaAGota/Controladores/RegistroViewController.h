//
//  RegistroViewController.h
//  GotaAGota
//
//  Created by rentamac on 10/31/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegistroViewController : NSViewController

@property (strong) NSManagedObjectContext *managedObjectContext;


@property (weak) IBOutlet NSTextField *litrosTextField;
@property (weak) IBOutlet NSPopUpButton *actividadPopUp;
@property (weak) IBOutlet NSDatePicker *fechaPicker;
@property (weak) IBOutlet NSTextField *comentarioTextField;
@property (weak) IBOutlet NSTableView *tablaRegistros;
@property (weak) IBOutlet NSArrayController *arrayController;
@property (weak) IBOutlet NSView *panelView;
@property (weak) IBOutlet NSTextField *recomendacionLabel;
@property (weak) IBOutlet NSArrayController *actividadArrayController;


- (IBAction)cerrar:(id)sender;
- (IBAction)guardarRegistro:(id)sender;
- (IBAction)nuevoRegistro:(id)sender;
- (IBAction)cambioActividad:(id)sender;



@end

NS_ASSUME_NONNULL_END
