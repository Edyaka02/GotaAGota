//
//  Consumo+CoreDataProperties.h
//  GotaAGota
//
//  Created by rentamac on 10/31/25.
//
//

#import "Consumo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Consumo (CoreDataProperties)

+ (NSFetchRequest<Consumo *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nonatomic) BOOL alertaGenerada;
@property (nullable, nonatomic, copy) NSString *comentario;
@property (nullable, nonatomic, copy) NSDate *fecha;
@property (nonatomic) double litros;
@property (nullable, nonatomic, retain) Actividad *actividad;
@property (nullable, nonatomic, retain) Persona *persona;

@end

NS_ASSUME_NONNULL_END
