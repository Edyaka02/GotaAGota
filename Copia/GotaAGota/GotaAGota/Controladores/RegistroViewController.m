//
//  RegistroViewController.m
//  GotaAGota
//
//  Created by rentamac on 10/31/25.
//

#import "RegistroViewController.h"
#import "AppDelegate.h"

@interface RegistroViewController ()

@end

@implementation RegistroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSManagedObjectContext *)managedObjectContext {
    AppDelegate *delegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    return delegate.persistentContainer.viewContext;
}


- (IBAction)guardarRegistro:(id)sender {
    if (self.litrosTextField.stringValue.length == 0 || self.actividadPopUp.indexOfSelectedItem == -1) {
            NSAlert *alerta = [[NSAlert alloc] init];
            alerta.messageText = @"Faltan datos";
            alerta.informativeText = @"Por favor completa los campos obligatorios.";
            [alerta runModal];
            return;
        }

        NSManagedObjectContext *context = [self managedObjectContext];
        NSManagedObject *nuevoRegistro = [NSEntityDescription insertNewObjectForEntityForName:@"Consumo" inManagedObjectContext:context];

        [nuevoRegistro setValue:@(self.litrosTextField.doubleValue) forKey:@"litros"];
        [nuevoRegistro setValue:self.fechaPicker.dateValue forKey:@"fecha"];
        [nuevoRegistro setValue:self.comentarioTextField.stringValue forKey:@"comentario"];

        NSString *actividadNombre = self.actividadPopUp.titleOfSelectedItem;
        NSFetchRequest *actividadFetch = [NSFetchRequest fetchRequestWithEntityName:@"Actividad"];
        actividadFetch.predicate = [NSPredicate predicateWithFormat:@"nombre == %@", actividadNombre];
        NSArray *resultados = [context executeFetchRequest:actividadFetch error:nil];
        if (resultados.count > 0) {
            [nuevoRegistro setValue:resultados.firstObject forKey:@"actividad"];
        }

        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Error al guardar: %@", error);
        } else {
            [self.arrayController fetch:nil];
            [self limpiarFormulario];
            [self cerrarFormulario:nil];
        }

}

- (IBAction)mostrarFormulario:(id)sender {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.3;
        self.panelView.animator.frame = NSMakeRect(500, 0, 300, 600);
    } completionHandler:nil];
}

- (IBAction)cerrarFormulario:(id)sender {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.3;
        self.panelView.animator.frame = NSMakeRect(800, 0, 300, 600);
    } completionHandler:nil];
}

#pragma mark - Limpieza del Formulario

- (void)limpiarFormulario {
    self.litrosTextField.stringValue = @"";
    [self.actividadPopUp selectItemAtIndex:0];
    self.fechaPicker.dateValue = [NSDate date];
    self.comentarioTextField.stringValue = @"";
}


- (IBAction)cerrar:(id)sender {
}
@end
