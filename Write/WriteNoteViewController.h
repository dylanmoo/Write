//
//  WriteNoteViewController.h
//  Write
//
//  Created by Dylan Moore on 10/22/13.
//  Copyright (c) 2013 Dylan Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteNoteViewController : UIViewController

-(IBAction)doneButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *noteView;

@end
