//
//  Consumo+CoreDataProperties.m
//  GotaAGota
//
//  Created by rentamac on 10/31/25.
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
@dynamic persona;

@end
