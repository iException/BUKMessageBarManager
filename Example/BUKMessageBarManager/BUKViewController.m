//
//  BUKViewController.m
//  BUKMessageBarManager
//
//  Created by monzy613 on 07/01/2016.
//  Copyright (c) 2016 monzy613. All rights reserved.
//

#import "BUKViewController.h"
#import "BUKMessageBarManager/BUKMessageBarManager.h"

@interface BUKViewController ()

@property (nonatomic, strong) BUKMessageBar *bar;

@end

@implementation BUKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)toggle:(id)sender {
    UIButton *copyButton = [[UIButton alloc] init];
    [copyButton setTitle:@"copy" forState:UIControlStateNormal];
    [copyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    copyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    UIButton *dismissButton = [[UIButton alloc] init];
    [dismissButton setTitle:@"dismiss" forState:UIControlStateNormal];
    [dismissButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    dismissButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.bar = [BUKMessageBarManager showMessageWithTitle:@"/home" 
                                                   detail:@"home view did selectedhome view did selectedhome view did selectedhome view did selectedhome view did selectedhome view did selected" 
                                                  buttons:@[copyButton, dismissButton] 
                                                  handler:^(UIButton *button, NSInteger buttonIndex) {
                                                      if (buttonIndex == 0) {
                                                      } else if (buttonIndex == 1) {
                                                          [self.bar dismissAnimated:YES completion:nil];
                                                      }
                                                  } 
                                                     type:BUKMessageBarTypeSuccess 
                                                 duration:3.0];
}
@end
