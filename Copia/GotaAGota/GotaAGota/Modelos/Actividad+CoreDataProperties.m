//
//  Actividad+CoreDataProperties.m
//  GotaAGota
//
//  Created by rentamac on 10/31/25.
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
