//
//  Persona+CoreDataProperties.m
//  GotaAGota
//
//  Created by rentamac on 10/31/25.
//
//

#import "Persona+CoreDataProperties.h"

@implementation Persona (CoreDataProperties)

+ (NSFetchRequest<Persona *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Persona"];
}

@dynamic avantar;
@dynamic colorTema;
@dynamic nombre;
@dynamic consumos;

@end
