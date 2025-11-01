//
//  GraficaSemanalView.m
//  GotaAGota
//
//  Created by rentamac on 11/1/25.
//

#import "GraficaSemanalView.h"
#import "AppDelegate.h"
#import "Consumo+CoreDataClass.h"

@implementation GraficaSemanalView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    CGContextRef ctx = [[NSGraphicsContext currentContext] CGContext];
    CGContextSetFillColorWithColor(ctx, [[NSColor whiteColor] CGColor]);
    CGContextFillRect(ctx, self.bounds);

    CGFloat maxLitros = 200.0;
    CGFloat barWidth = 30.0;
    CGFloat spacing = 20.0;
    CGFloat startX = 40.0;
    CGFloat baseY = 50.0;

    NSArray *fechasOrdenadas = [[self.datosPorDia allKeys] sortedArrayUsingSelector:@selector(compare:)];

    for (NSInteger i = 0; i < fechasOrdenadas.count; i++) {
        NSString *fecha = fechasOrdenadas[i];
        CGFloat litros = [self.datosPorDia[fecha] floatValue];
        CGFloat altura = (litros / maxLitros) * 150.0;
        CGFloat x = startX + i * (barWidth + spacing);
        CGFloat y = baseY;

        NSRect barRect = NSMakeRect(x, y, barWidth, altura);
        NSBezierPath *barPath = [NSBezierPath bezierPathWithRect:barRect];
        [[NSColor colorWithRed:0.31 green:0.76 blue:0.97 alpha:1.0] setFill]; // #4FC3F7
        [barPath fill];

        NSDictionary *attrs = @{NSFontAttributeName: [NSFont systemFontOfSize:10]};
            [fecha drawAtPoint:NSMakePoint(x, y - 15) withAttributes:attrs];
    }

    NSDictionary *tituloAttrs = @{NSFontAttributeName: [NSFont boldSystemFontOfSize:16]};
    [@"Consumo semanal de agua" drawAtPoint:NSMakePoint(40, 220) withAttributes:tituloAttrs];
}



@end
