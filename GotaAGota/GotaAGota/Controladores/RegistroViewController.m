//
//  RegistroViewController.m
//  GotaAGota
//
//  Created by rentamac on 10/31/25.
//

#import "RegistroViewController.h"
#import "AppDelegate.h"
#import "Consumo+CoreDataClass.h"
#import "Actividad+CoreDataClass.h"

@interface RegistroViewController ()

@end

@implementation RegistroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Asignar el contexto de Core Data desde AppDelegate
    AppDelegate *delegate = (AppDelegate *)NSApp.delegate;
    self.managedObjectContext = delegate.persistentContainer.viewContext;
    
    //[self eliminarActividadesAntiguas];
    [self crearActividadesPorDefecto];


}

- (IBAction)cambioActividad:(id)sender {
    NSString *actividadNombre = self.actividadPopUp.titleOfSelectedItem;
        if (actividadNombre.length == 0) return;

        NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Actividad"];
        fetch.predicate = [NSPredicate predicateWithFormat:@"nombre == %@", actividadNombre];

        NSError *error = nil;
        NSArray *resultados = [self.managedObjectContext executeFetchRequest:fetch error:&error];

        if (error) {
            NSLog(@"❌ Error al buscar actividad: %@", error);
            return;
        }

        Actividad *actividadSeleccionada = resultados.firstObject;
        if (actividadSeleccionada) {
            self.recomendacionLabel.stringValue = actividadSeleccionada.recomendacion ?: @"";
        } else {
            self.recomendacionLabel.stringValue = @"";
        }

}

- (IBAction)nuevoRegistro:(id)sender {
    
    self.tablaRegistros.enabled = NO;
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.3;
        self.panelView.animator.frame = NSMakeRect(0, 0, 300, 600);
    } completionHandler:nil];
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
    
    self.tablaRegistros.enabled = YES;

    NSError *error = nil;
    
    if (![context save:&error]) {
        NSLog(@"Error al guardar: %@", error);
    } else {
        [self mostrarConsumosGuardadas];
        NSLog(@"Guardado");
        [self.arrayController fetch:nil];
        [self limpiarFormulario];
        [self cerrar:nil];
    }

}

#pragma mark - Limpieza del Formulario

- (void)limpiarFormulario {
    self.litrosTextField.stringValue = @"";
    [self.actividadPopUp selectItemAtIndex:0];
    self.fechaPicker.dateValue = [NSDate date];
    self.comentarioTextField.stringValue = @"";
}


- (IBAction)cerrar:(id)sender {
    self.tablaRegistros.enabled = YES;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.3;
        self.panelView.animator.frame = NSMakeRect(-300, 0, 300, 600);
    } completionHandler:nil];
}

- (void)habilitar {
    self.tablaRegistros.enabled = NO;
}

- (void)mostrarConsumosGuardadas {
    NSManagedObjectContext *context = ((AppDelegate *)NSApp.delegate).persistentContainer.viewContext;

    NSFetchRequest *fetchRequest = [Consumo fetchRequest];

    NSError *error = nil;
    NSArray *resultados = [context executeFetchRequest:fetchRequest error:&error];

    if (error) {
        NSLog(@"Error al obtener consumos: %@", error);
    } else {
        NSLog(@"Consumos guardados:");
        for (Consumo *consumo in resultados) {
            NSLog(@"- Fecha: %@, Cantidad: %f, ID: %@", consumo.fecha, consumo.litros, consumo.objectID);
        }
    }
}

- (void)crearActividadesPorDefecto {
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Actividad"];
    NSError *error = nil;
    NSArray *existentes = [self.managedObjectContext executeFetchRequest:fetch error:&error];

    if (existentes.count == 0) {
        NSArray *actividades = @[
            @{@"nombre": @"Lavado de manos", @"categoria": @"Higiene", @"consumoPromedio": @50, @"recomendacion": @"Cierra el grifo mientras te enjabonas"},
            @{@"nombre": @"Lavar vegetales", @"categoria": @"Cocina", @"consumoPromedio": @100, @"recomendacion": @"Usa un recipiente en lugar de agua corriente"},
            @{@"nombre": @"Lavar platos", @"categoria": @"Cocina", @"consumoPromedio": @300, @"recomendacion": @"Agrupa los platos y usa agua tibia con moderación"},
            @{@"nombre": @"Ducha", @"categoria": @"Higiene", @"consumoPromedio": @800, @"recomendacion": @"Usa regadera de bajo flujo y limita el tiempo"},
            @{@"nombre": @"Ir al baño", @"categoria": @"Rutina diaria", @"consumoPromedio": @600, @"recomendacion": @"Evita descargas innecesarias y revisa fugas"},
            @{@"nombre": @"Riego de plantas", @"categoria": @"Hogar", @"consumoPromedio": @500, @"recomendacion": @"Riega en horarios frescos y reutiliza agua de enjuague"},
            @{@"nombre": @"Trapeado", @"categoria": @"Limpieza", @"consumoPromedio": @400, @"recomendacion": @"Usa agua reciclada si es posible y evita el exceso"}
        ];


        for (NSDictionary *datos in actividades) {
            NSManagedObject *act = [NSEntityDescription insertNewObjectForEntityForName:@"Actividad" inManagedObjectContext:self.managedObjectContext];
            [act setValue:datos[@"nombre"] forKey:@"nombre"];
            [act setValue:datos[@"categoria"] forKey:@"categoria"];
            [act setValue:datos[@"consumoPromedio"] forKey:@"consumoPromedio"];
            [act setValue:datos[@"recomendacion"] forKey:@"recomendacion"];
        }

        [self.managedObjectContext save:nil];
        NSLog(@"✅ Actividades por defecto creadas");
    }
}

- (void)eliminarActividadesAntiguas {
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Actividad"];
    NSError *error = nil;
    NSArray *actividades = [self.managedObjectContext executeFetchRequest:fetch error:&error];

    for (NSManagedObject *actividad in actividades) {
        [self.managedObjectContext deleteObject:actividad];
    }

    [self.managedObjectContext save:nil];
    NSLog(@"🗑️ Actividades antiguas eliminadas");
}



@end
