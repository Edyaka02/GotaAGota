//
//  EstadisticasMensualesView.m
//  GotaAGota
//
//  Created by Guest User on 31/10/25.
//

#import "EstadisticasMensualesView.h"

@implementation EstadisticasMensualesView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    if (self.valoresMensuales.count == 0) return;
    
    NSArray *meses = @[@"Ene", @"Feb", @"Mar", @"Abr", @"May", @"Jun",
                       @"Jul", @"Ago", @"Sep", @"Oct", @"Nov", @"Dic"];
    
    CGFloat anchoTotal = dirtyRect.size.width;
    CGFloat altoTotal = dirtyRect.size.height;
    CGFloat anchoBarra = anchoTotal / self.valoresMensuales.count;
    CGFloat maxValor = [[self.valoresMensuales valueForKeyPath:@"@max.doubleValue"] doubleValue];
    
    NSDictionary *attrsMes = @{
        NSFontAttributeName: [NSFont systemFontOfSize:10 weight:NSFontWeightMedium],
        NSForegroundColorAttributeName: [NSColor secondaryLabelColor]
    };
    NSDictionary *attrsValor = @{
        NSFontAttributeName: [NSFont boldSystemFontOfSize:10],
        NSForegroundColorAttributeName: [NSColor labelColor]
    };
    
    for (NSInteger i = 0; i < self.valoresMensuales.count; i++) {
        double valor = [self.valoresMensuales[i] doubleValue];
        CGFloat altura = (valor / maxValor) * (altoTotal - 25);
        CGFloat x = i * anchoBarra + 5;
        
        // Dibujar barra
        NSRect barra = NSMakeRect(x, 20, anchoBarra - 10, altura);
        [[NSColor systemGreenColor] setFill];
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:barra xRadius:3 yRadius:3];
        [path fill];
        
        // Valor arriba
        NSString *textoValor = [NSString stringWithFormat:@"%.0f", valor];
        NSSize tamValor = [textoValor sizeWithAttributes:attrsValor];
        [textoValor drawAtPoint:NSMakePoint(x + (anchoBarra - tamValor.width) / 2 - 5,
                                            altura + 22)
                  withAttributes:attrsValor];
        
        // Mes debajo
        NSString *mes = i < meses.count ? meses[i] : @"";
        NSSize tamMes = [mes sizeWithAttributes:attrsMes];
        [mes drawAtPoint:NSMakePoint(x + (anchoBarra - tamMes.width) / 2 - 5, 2)
          withAttributes:attrsMes];
    }
}



@end
