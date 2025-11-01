//
//  ViewController.m
//  GotaAGota
//
//  Created by Guest User on 31/10/25.
//

#import "ViewController.h"
#import "RegistroViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSWindowController *registroWC = [storyboard instantiateControllerWithIdentifier:@"RegistroWindow"];
    [registroWC showWindow:nil];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (IBAction)abrirREgistro:(id)sender {
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSWindowController *registroWC = [storyboard instantiateControllerWithIdentifier:@"RegistroWindow"];
    [registroWC showWindow:nil];

}
@end
