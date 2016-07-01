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

@end

@implementation BUKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)toggle:(id)sender {
    [BUKMessageBarManager showMessageWithTitle:@"/home" detail:@"home view did selectedhome view did selectedhome view did selected" duration:2.0];
}
@end
