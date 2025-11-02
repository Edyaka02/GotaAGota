//
//  Consumo+CoreDataProperties.m
//  GotaAGota
//
//  Created by Guest User on 31/10/25.
//
//

#import "Consumo+CoreDataProperties.h"

@implementation Consumo (CoreDataProperties)

+ (NSFetchRequest<Consumo *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Consumo"];
}

@dynamic alertaGenerada;
@dynamic comentario;
@dynamic fecha;
@dynamic litros;
@dynamic actividad;

@end
