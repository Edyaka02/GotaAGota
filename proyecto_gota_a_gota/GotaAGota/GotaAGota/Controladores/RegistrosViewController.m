//
//  RegistrosViewController.m
//  GotaAGota
//
//  Created by Guest User on 31/10/25.
//

#import "RegistrosViewController.h"
#import "AppDelegate.h"
#import "Consumo+CoreDataClass.h"
#import "Actividad+CoreDataClass.h"
#import "EstadisticasSemanalesView.h"
#import "EstadisticasMensualesView.h"

@implementation RegistrosViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *delegate = (AppDelegate *)NSApp.delegate;
    self.managedObjectContext = delegate.persistentContainer.viewContext;

    // Configurar tabla
    self.tablaRegistros.dataSource = self;
    self.tablaRegistros.delegate = self;
    
    [self limpiarDatos];
    [self generarDatosDePruebaMasivos];

    // Crear actividades si no existen
    [self crearActividadesPorDefecto];
    [self cargarActividades];
    [self cargarConsumos];
    [self actualizarGraficas];
}

#pragma mark - Carga de Datos

- (void)cargarConsumos {
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Consumo"];

    // Agregamos un "sort descriptor" para ordenar por fecha descendente (más reciente primero)
    NSSortDescriptor *ordenPorFecha = [NSSortDescriptor sortDescriptorWithKey:@"fecha" ascending:NO];
    fetch.sortDescriptors = @[ordenPorFecha];

    NSError *error = nil;
    self.consumos = [self.managedObjectContext executeFetchRequest:fetch error:&error];
    
    if (!error) {
        [self.tablaRegistros reloadData];
    }
}

- (void)cargarActividades {
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Actividad"];
    NSError *error = nil;
    self.actividades = [self.managedObjectContext executeFetchRequest:fetch error:&error];

    [self.actividadPopUp removeAllItems];
    for (Actividad *act in self.actividades) {
        [self.actividadPopUp addItemWithTitle:act.nombre];
    }

}

#pragma mark - Guardar y Crear

- (IBAction)guardarRegistro:(id)sender {
    if (self.litrosTextField.stringValue.length == 0 || self.actividadPopUp.indexOfSelectedItem == -1) {
        NSAlert *alerta = [[NSAlert alloc] init];
        alerta.messageText = @"Faltan datos";
        alerta.informativeText = @"Por favor completa los campos obligatorios.";
        [alerta runModal];
        return;
    }
    
    // 🔹 Validar que los litros sean numéricos y positivos
    NSString *valor = self.litrosTextField.stringValue;
    double litros = valor.doubleValue;
    NSCharacterSet *noNumeros = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.,"] invertedSet];

    if ([valor rangeOfCharacterFromSet:noNumeros].location != NSNotFound || litros <= 0) {
        NSAlert *alerta = [[NSAlert alloc] init];
        alerta.alertStyle = NSAlertStyleWarning;
        alerta.messageText = @"Valor inválido";
        alerta.informativeText = @"Por favor ingresa solo números positivos en el campo de litros.";
        [alerta runModal];
        return;
    }

    NSManagedObjectContext *context = self.managedObjectContext;
    Consumo *nuevo = [NSEntityDescription insertNewObjectForEntityForName:@"Consumo" inManagedObjectContext:context];

    nuevo.litros = self.litrosTextField.doubleValue;
    nuevo.fecha = self.fechaPicker.dateValue;
    nuevo.comentario = self.comentarioTextField.stringValue;

    NSString *actividadNombre = self.actividadPopUp.titleOfSelectedItem;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"nombre == %@", actividadNombre];
    Actividad *actividadSeleccionada = [[self.actividades filteredArrayUsingPredicate:pred] firstObject];

    if (actividadSeleccionada) {
        nuevo.actividad = actividadSeleccionada;
    }

    NSError *error = nil;
    if (![context save:&error]) {
        NSAlert *alerta = [[NSAlert alloc] init];
        alerta.alertStyle = NSAlertStyleCritical;
        alerta.messageText = @"Error al guardar el consumo";
        alerta.informativeText = [NSString stringWithFormat:@"Ocurrió un error: %@", error.localizedDescription];
        [alerta runModal];
    } else {
        [self limpiarFormulario];
        [self cargarConsumos];
        [self actualizarGraficas];
        [self cerrar:nil];
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
            Actividad *act = [NSEntityDescription insertNewObjectForEntityForName:@"Actividad" inManagedObjectContext:self.managedObjectContext];
            act.nombre = datos[@"nombre"];
            act.categoria = datos[@"categoria"];
            act.consumoPromedio = [datos[@"consumoPromedio"] doubleValue];
            act.recomendacion = datos[@"recomendacion"];
        }

        [self.managedObjectContext save:nil];
    }
}

- (IBAction)alertas:(id)sender {
    [self actualizarGraficas];
}

- (IBAction)cambioActividad:(id)sender {
    NSString *actividadNombre = self.actividadPopUp.titleOfSelectedItem;
        if (!actividadNombre) return;

        NSPredicate *pred = [NSPredicate predicateWithFormat:@"nombre == %@", actividadNombre];
        Actividad *seleccionada = [[self.actividades filteredArrayUsingPredicate:pred] firstObject];

        if (seleccionada) {
            self.recomendacionLabel.stringValue = seleccionada.recomendacion ?: @"";
        } else {
            self.recomendacionLabel.stringValue = @"";
        }
}

#pragma mark - Formulario y Panel
- (IBAction)nuevoRegistro:(id)sender {
    self.tablaRegistros.enabled = NO;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.3;
        self.panelView.animator.frame = NSMakeRect(0, 0, 300, 600);
    } completionHandler:nil];
}

- (IBAction)cerrar:(id)sender {
    self.tablaRegistros.enabled = YES;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.3;
        self.panelView.animator.frame = NSMakeRect(-300, 0, 300, 600);
    } completionHandler:nil];
}

- (IBAction)cerrarEstadistica:(id)sender {
    self.tablaRegistros.enabled = YES;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.3;
        self.panelEstadisticaView.animator.frame = NSMakeRect(800, 0, 800, 600);
    } completionHandler:nil];
}

- (IBAction)estadisticas:(id)sender {
    self.tablaRegistros.enabled = YES;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.3;
        self.panelEstadisticaView.animator.frame = NSMakeRect(0, 0, 800, 600);
    } completionHandler:nil];
}

- (void)limpiarFormulario {
    self.litrosTextField.stringValue = @"";
    [self.actividadPopUp selectItemAtIndex:0];
    self.fechaPicker.dateValue = [NSDate date];
    self.comentarioTextField.stringValue = @"";
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.consumos.count;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row
{
    Consumo *consumo = self.consumos[row];
    NSString *columnaID = tableColumn.identifier;

    NSTableCellView *cellView = [tableView makeViewWithIdentifier:columnaID owner:self];
    if (!cellView) return nil;

    if ([columnaID isEqualToString:@"fecha"]) {
        NSDateFormatter *formato = [[NSDateFormatter alloc] init];
        formato.dateStyle = NSDateFormatterShortStyle;
        cellView.textField.stringValue = [formato stringFromDate:consumo.fecha] ?: @"";
    } else if ([columnaID isEqualToString:@"litros"]) {
        cellView.textField.stringValue = [NSString stringWithFormat:@"%.2f", consumo.litros];
    } else if ([columnaID isEqualToString:@"actividad"]) {
        cellView.textField.stringValue = consumo.actividad.nombre ?: @"";
    } else if ([columnaID isEqualToString:@"comentario"]) {
        cellView.textField.stringValue = consumo.comentario ?: @"";
    } else {
        cellView.textField.stringValue = @"";
    }

    return cellView;
}

#pragma mark - Obtener datos desde Core Data

- (NSDictionary *)obtenerConsumoSemanal {
    NSManagedObjectContext *context = self.managedObjectContext;
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDate *hoy = [NSDate date];
        NSDate *hace7Dias = [cal dateByAddingUnit:NSCalendarUnitDay value:-7 toDate:hoy options:0];

        NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Consumo"];
        fetch.predicate = [NSPredicate predicateWithFormat:@"fecha >= %@", hace7Dias];

        NSError *error = nil;
        NSArray *resultados = [context executeFetchRequest:fetch error:&error];

        NSMutableDictionary *consumoPorDia = [NSMutableDictionary dictionary];
        for (Consumo *c in resultados) {
            NSString *clave = [self formatearFecha:c.fecha formato:@"EEE"];
            double litros = c.litros;
            consumoPorDia[clave] = @([consumoPorDia[clave] doubleValue] + litros);
        }
        return consumoPorDia;
}

- (NSDictionary *)obtenerConsumoMensual {
    NSManagedObjectContext *context = self.managedObjectContext;
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDate *hoy = [NSDate date];
        NSDate *hace12Meses = [cal dateByAddingUnit:NSCalendarUnitMonth value:-12 toDate:hoy options:0];

        NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Consumo"];
        fetch.predicate = [NSPredicate predicateWithFormat:@"fecha >= %@", hace12Meses];

        NSError *error = nil;
        NSArray *resultados = [context executeFetchRequest:fetch error:&error];

        NSMutableDictionary *consumoPorMes = [NSMutableDictionary dictionary];
        for (Consumo *c in resultados) {
            NSString *clave = [self formatearFecha:c.fecha formato:@"MMM"];
            double litros = c.litros;
            consumoPorMes[clave] = @([consumoPorMes[clave] doubleValue] + litros);
        }
        return consumoPorMes;
}

- (NSString *)formatearFecha:(NSDate *)fecha formato:(NSString *)formato {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"es_ES"];
    formatter.dateFormat = formato;
    return [formatter stringFromDate:fecha];
}

#pragma mark - Actualización de gráficas

- (void)actualizarGraficas {

    NSDictionary *consumoSemanal = [self obtenerConsumoSemanal];
    NSDictionary *consumoMensual = [self obtenerConsumoMensual];

    NSArray *dias = [[consumoSemanal allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *valoresSemana = [NSMutableArray array];
    for (NSString *dia in dias) {
        [valoresSemana addObject:consumoSemanal[dia]];
    }

    NSArray *meses = [[consumoMensual allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *valoresMes = [NSMutableArray array];
    for (NSString *mes in meses) {
        [valoresMes addObject:consumoMensual[mes]];
    }

    self.vistaSemanal.valores = valoresSemana;
    self.vistaMensual.valoresMensuales = valoresMes;

    [self.vistaSemanal setNeedsDisplay:YES];
    [self.vistaMensual setNeedsDisplay:YES];



    // Análisis de estadísticas
    double totalSemana = [[valoresSemana valueForKeyPath:@"@sum.self"] doubleValue];
    double promedioDia = valoresSemana.count > 0 ? totalSemana / valoresSemana.count : 0.0;

    double totalMes = [[valoresMes valueForKeyPath:@"@sum.self"] doubleValue];

    NSString *mensaje = @"";
    NSString *titulo = @"Estadísticas";

    if (totalSemana == 0 && totalMes == 0) {
        mensaje = @"Aún no hay datos de consumo registrados.";
    } else if (promedioDia < 200) {
        mensaje = [NSString stringWithFormat:@"Excelente \nTu consumo diario promedio es de %.1f L. ¡Sigue así!", promedioDia];
    } else if (promedioDia < 600) {
        mensaje = [NSString stringWithFormat:@"Moderado \nTu consumo diario promedio es de %.1f L. Puedes mejorar.", promedioDia];
    } else {
        mensaje = [NSString stringWithFormat:@"Alto \nTu consumo diario promedio es de %.1f L. Intenta reducir el tiempo o frecuencia de uso.", promedioDia];
    }

    // También puedes comparar el mes actual vs el anterior
    if (valoresMes.count > 1) {
        double mesActual = [[valoresMes lastObject] doubleValue];
        double mesAnterior = [[valoresMes objectAtIndex:valoresMes.count - 2] doubleValue];

        if (mesActual < mesAnterior) {
            mensaje = [mensaje stringByAppendingFormat:@"\n\n ¡Redujiste tu consumo mensual en %.1f L respecto al mes anterior!", (mesAnterior - mesActual)];
        } else if (mesActual > mesAnterior) {
            mensaje = [mensaje stringByAppendingFormat:@"\n\n Tu consumo mensual aumentó %.1f L respecto al mes anterior.", (mesActual - mesAnterior)];
        }
    }

    // Mostrar alerta visual
    [self mostrarAlertaConTitulo:titulo mensaje:mensaje];
}

// Método de ayuda para mostrar mensajes fácilmente
- (void)mostrarAlertaConTitulo:(NSString *)titulo mensaje:(NSString *)mensaje {
    NSAlert *alerta = [[NSAlert alloc] init];
    alerta.messageText = titulo;
    alerta.informativeText = mensaje;
    [alerta addButtonWithTitle:@"OK"];
    [alerta runModal];
}
- (void)limpiarDatos {
    NSFetchRequest *fetchConsumo = [NSFetchRequest fetchRequestWithEntityName:@"Consumo"];
    NSFetchRequest *fetchActividad = [NSFetchRequest fetchRequestWithEntityName:@"Actividad"];

    NSError *error = nil;
    NSArray *consumos = [self.managedObjectContext executeFetchRequest:fetchConsumo error:&error];
    for (NSManagedObject *obj in consumos) {
        [self.managedObjectContext deleteObject:obj];
    }

    NSArray *actividades = [self.managedObjectContext executeFetchRequest:fetchActividad error:&error];
    for (NSManagedObject *obj in actividades) {
        [self.managedObjectContext deleteObject:obj];
    }

}

- (void)generarDatosDePruebaMasivos {
    NSArray *actividades = self.actividades;
    if (actividades.count == 0) {
        [self crearActividadesPorDefecto];
        [self cargarActividades];
        actividades = self.actividades;
    }

    NSManagedObjectContext *context = self.managedObjectContext;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *hoy = [NSDate date];

    NSInteger total = 300; // cantidad de registros
    double minLitros = 5.0;
    double maxLitros = 50.0;

    for (NSInteger i = 0; i < total; i++) {
        Consumo *nuevo = [NSEntityDescription insertNewObjectForEntityForName:@"Consumo"
                                                      inManagedObjectContext:context];

        // Fecha aleatoria dentro del último año
        NSInteger diasAtras = arc4random_uniform(365);
        NSDate *fechaRandom = [cal dateByAddingUnit:NSCalendarUnitDay
                                              value:-diasAtras
                                             toDate:hoy
                                            options:0];
        nuevo.fecha = fechaRandom;

        // Actividad aleatoria
        Actividad *actividad = actividades[arc4random_uniform((uint32_t)actividades.count)];
        nuevo.actividad = actividad;

        // Litros realistas (entre 5 y 50)
        double litros = ((double)arc4random() / UINT32_MAX) * (maxLitros - minLitros) + minLitros;
        nuevo.litros = litros;

        // Comentario
        nuevo.comentario = [NSString stringWithFormat:@"%@ (%.1f L)", actividad.nombre, litros];
    }

    [self cargarConsumos];
    [self actualizarGraficas];
}

@end
