//
//  EstadisticasView.h
//  GotaAGota
//
//  Created by Victor Manuel Tijerina Garnica on 01/11/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface EstadisticasView : NSView

@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *> *datosSemanales;

- (void)setDatosSemanales:(NSDictionary<NSString *, NSNumber *> *)datos;

@end

NS_ASSUME_NONNULL_END
