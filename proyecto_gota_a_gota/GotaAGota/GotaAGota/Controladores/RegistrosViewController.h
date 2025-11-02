//
//  RegistrosViewController.h
//  GotaAGota
//
//  Created by Guest User on 31/10/25.
//

#import <Cocoa/Cocoa.h>
#import "EstadisticasSemanalesView.h"
#import "EstadisticasMensualesView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegistrosViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (strong) NSManagedObjectContext *managedObjectContext;


@property (weak) IBOutlet NSTextField *litrosTextField;
@property (weak) IBOutlet NSPopUpButton *actividadPopUp;
@property (weak) IBOutlet NSDatePicker *fechaPicker;
@property (weak) IBOutlet NSTextField *comentarioTextField;
@property (weak) IBOutlet NSTableView *tablaRegistros;
@property (weak) IBOutlet NSView *panelView;
@property (weak) IBOutlet NSView *panelEstadisticaView;
@property (weak) IBOutlet NSTextField *recomendacionLabel;
@property (weak) IBOutlet EstadisticasSemanalesView *vistaSemanal;
@property (weak) IBOutlet EstadisticasMensualesView *vistaMensual;

@property (strong) NSArray *consumos;
@property (strong) NSArray *actividades;


- (IBAction)estadisticas:(id)sender;
- (IBAction)cerrarEstadistica:(id)sender;
- (IBAction)cerrar:(id)sender;
- (IBAction)guardarRegistro:(id)sender;
- (IBAction)nuevoRegistro:(id)sender;
- (IBAction)cambioActividad:(id)sender;
- (IBAction)alertas:(id)sender;




@end

NS_ASSUME_NONNULL_END
