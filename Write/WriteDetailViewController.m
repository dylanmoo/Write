//
//  WriteDetailViewController.m
//  Write
//
//  Created by Dylan Moore on 10/22/13.
//  Copyright (c) 2013 Dylan Moore. All rights reserved.
//

#import "WriteDetailViewController.h"
#import "Sentence.h"

@interface WriteDetailViewController ()
- (void)configureView;
@end

@implementation WriteDetailViewController

@synthesize sentenceView;
@synthesize tagObject = _tagObject;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_tagObject != newDetailItem) {
        _tagObject = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.tagObject) {
        NSSet *sentenceSet = self.tagObject.appears_in;
        NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"created_at" ascending:YES];
        NSArray *sortedSentences = [sentenceSet sortedArrayUsingDescriptors:[NSArray arrayWithObject:dateDescriptor]];
        
        NSString *allSentences = @"  ";
        for(Sentence *sentence in sortedSentences){
            if(sentence.sentence){
                allSentences = [allSentences stringByAppendingString:[NSString stringWithFormat:@"%@.\n  ",sentence.sentence]];
            }
        }
        [self.sentenceView setText:allSentences];
       // [self highlightTag];
    }
}

- (void)highlightTag{
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:self.sentenceView.text];
    
    NSArray *words=[self.sentenceView.text componentsSeparatedByString:@" "];
    
    for (NSString *word in words) {
        if ([word isEqualToString:self.tagObject.word]) {
            NSRange range=[self.sentenceView.text rangeOfString:word];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
        }
    }
    [self.sentenceView setAttributedText:string];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    [self.navigationItem setTitle:self.tagObject.word];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
