//
//  BUKViewController.m
//  BUKMessageBarManager
//
//  Created by monzy613 on 07/01/2016.
//  Copyright (c) 2016 monzy613. All rights reserved.
//

#import "BUKViewController.h"
#import "BUKMessageBarManager.h"

@interface BUKViewController ()

@property (nonatomic, strong) BUKMessageBar *bar;

@end

@implementation BUKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)toggle:(id)sender {    
    self.bar = [BUKMessageBarManager showMessageWithTitle:@"/home" 
                                                   detail:@"home view did selectedhome view did selectedhome view did selectedhome view did selectedhome view did selectedhome view did selected home view did selectedhome view did selectedhome view did selectedhome view did selectedhome view did selectedhome view did selected" 
                                                  buttons:@[
                                                            [BUKMessageBarButton buttonWithTitle:@"copy" 
                                                                                            type:BUKMessageBarButtonTypeDefault 
                                                                                         handler:^(BUKMessageBarButton *button) {
                                                                                             [button.bar dismissAnimated:YES completion:nil];
                                                                                         }],
                                                            [BUKMessageBarButton buttonWithTitle:@"dismiss" 
                                                                                            type:BUKMessageBarButtonTypeDestructive 
                                                                                         handler:^(BUKMessageBarButton *button) {
                                                                                             [button.bar dismissAnimated:YES completion:nil];
                                                                                         }]
                                                            ] 
                                               tapHandler:^(BUKMessageBar *bar) {
                                                   [bar dismissAnimated:YES completion:nil];
                                               } type:BUKMessageBarTypeInfo
                                                 expanded:NO 
                                                 duration:10.0];
}
@end
