//
//  Persona+CoreDataProperties.h
//  GotaAGota
//
//  Created by rentamac on 10/31/25.
//
//

#import "Persona+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Persona (CoreDataProperties)

+ (NSFetchRequest<Persona *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, retain) NSData *avantar;
@property (nullable, nonatomic, copy) NSString *colorTema;
@property (nullable, nonatomic, copy) NSString *nombre;
@property (nullable, nonatomic, retain) NSSet<Consumo *> *consumos;

@end

@interface Persona (CoreDataGeneratedAccessors)

- (void)addConsumosObject:(Consumo *)value;
- (void)removeConsumosObject:(Consumo *)value;
- (void)addConsumos:(NSSet<Consumo *> *)values;
- (void)removeConsumos:(NSSet<Consumo *> *)values;

@end

NS_ASSUME_NONNULL_END
