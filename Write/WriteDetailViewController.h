//
//  WriteDetailViewController.h
//  Write
//
//  Created by Dylan Moore on 10/22/13.
//  Copyright (c) 2013 Dylan Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"

@interface WriteDetailViewController : UIViewController

@property (strong, nonatomic) Tag *tagObject;
@property (weak, nonatomic) IBOutlet UITextView *sentenceView;
@end
