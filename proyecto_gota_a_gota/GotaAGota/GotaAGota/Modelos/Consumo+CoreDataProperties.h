//
//  Consumo+CoreDataProperties.h
//  GotaAGota
//
//  Created by Guest User on 31/10/25.
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

@end

NS_ASSUME_NONNULL_END
