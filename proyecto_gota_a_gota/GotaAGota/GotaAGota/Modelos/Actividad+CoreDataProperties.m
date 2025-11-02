//
//  Actividad+CoreDataProperties.m
//  GotaAGota
//
//  Created by Guest User on 31/10/25.
//
//

#import "Actividad+CoreDataProperties.h"

@implementation Actividad (CoreDataProperties)

+ (NSFetchRequest<Actividad *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Actividad"];
}

@dynamic categoria;
@dynamic consumoPromedio;
@dynamic nombre;
@dynamic recomendacion;
@dynamic consumos;

@end
