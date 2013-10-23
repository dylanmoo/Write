//
//  WriteNoteViewController.m
//  Write
//
//  Created by Dylan Moore on 10/22/13.
//  Copyright (c) 2013 Dylan Moore. All rights reserved.
//

#import "WriteNoteViewController.h"
#import "WriteAppDelegate.h"
#import "Store.h"

@interface WriteNoteViewController ()

@end

@implementation WriteNoteViewController

@synthesize noteView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.noteView becomeFirstResponder];
}

-(IBAction)doneButtonPressed:(id)sender{
    [[Store sharedStore] addNote:self.noteView.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
