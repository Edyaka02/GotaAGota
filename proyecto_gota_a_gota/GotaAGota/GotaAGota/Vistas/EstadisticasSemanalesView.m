//
//  EstadisticasSemanalesView.m
//  GotaAGota
//
//  Created by Guest User on 31/10/25.
//

#import "EstadisticasSemanalesView.h"

@implementation EstadisticasSemanalesView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    if (self.valores.count == 0) return;
    
    NSArray *diasSemana = @[@"Lun", @"Mar", @"Mié", @"Jue", @"Vie", @"Sáb", @"Dom"];
    
    CGFloat anchoTotal = dirtyRect.size.width;
    CGFloat altoTotal = dirtyRect.size.height;
    CGFloat anchoBarra = anchoTotal / self.valores.count;
    CGFloat maxValor = [[self.valores valueForKeyPath:@"@max.doubleValue"] doubleValue];
    
    NSDictionary *attrsDia = @{
        NSFontAttributeName: [NSFont systemFontOfSize:10 weight:NSFontWeightMedium],
        NSForegroundColorAttributeName: [NSColor secondaryLabelColor]
    };
    NSDictionary *attrsValor = @{
        NSFontAttributeName: [NSFont boldSystemFontOfSize:10],
        NSForegroundColorAttributeName: [NSColor labelColor]
    };
    
    for (NSInteger i = 0; i < self.valores.count; i++) {
        double valor = [self.valores[i] doubleValue];
        CGFloat altura = (valor / maxValor) * (altoTotal - 25);
        CGFloat x = i * anchoBarra + 5;
        
        // Dibujar barra
        NSRect barra = NSMakeRect(x, 20, anchoBarra - 10, altura);
        [[NSColor systemBlueColor] setFill];
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:barra xRadius:3 yRadius:3];
        [path fill];
        
        // Valor arriba
        NSString *textoValor = [NSString stringWithFormat:@"%.0f", valor];
        NSSize tamValor = [textoValor sizeWithAttributes:attrsValor];
        [textoValor drawAtPoint:NSMakePoint(x + (anchoBarra - tamValor.width) / 2 - 5,
                                            altura + 22)
                  withAttributes:attrsValor];
        
        // Día debajo
        NSString *dia = i < diasSemana.count ? diasSemana[i] : @"";
        NSSize tamDia = [dia sizeWithAttributes:attrsDia];
        [dia drawAtPoint:NSMakePoint(x + (anchoBarra - tamDia.width) / 2 - 5, 2)
          withAttributes:attrsDia];
    }
}

@end
