//
//  Actividad+CoreDataProperties.h
//  GotaAGota
//
//  Created by Guest User on 31/10/25.
//
//

#import "Actividad+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Actividad (CoreDataProperties)

+ (NSFetchRequest<Actividad *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *categoria;
@property (nonatomic) double consumoPromedio;
@property (nullable, nonatomic, copy) NSString *nombre;
@property (nullable, nonatomic, copy) NSString *recomendacion;
@property (nullable, nonatomic, retain) NSSet<Consumo *> *consumos;

@end

@interface Actividad (CoreDataGeneratedAccessors)

- (void)addConsumosObject:(Consumo *)value;
- (void)removeConsumosObject:(Consumo *)value;
- (void)addConsumos:(NSSet<Consumo *> *)values;
- (void)removeConsumos:(NSSet<Consumo *> *)values;

@end

NS_ASSUME_NONNULL_END
