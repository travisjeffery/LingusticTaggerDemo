//
//  ViewController.m
//  LingusticTaggerDemo
//
//  Created by Travis Jeffery on 12/23/13.
//  Copyright (c) 2013 Travis Jeffery. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    [self loadTextView];
    [self loadSegmentedControl];
    [self loadLayoutContraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self highlightLinguisticTag:NSLinguisticTagNoun];
}

#pragma mark - Actions

- (void)selectTagType:(id)sender {
    NSString *tag = [self tagAtIndex:self.segmentedControl.selectedSegmentIndex];
    [self highlightLinguisticTag:tag];
}

#pragma mark - Private

- (void)loadTextView {
    self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.textView.editable = NO;
    [self.view addSubview:self.textView];
}

- (void)loadSegmentedControl {
    NSArray *items = @[NSLocalizedString(@"Nouns", nil), NSLocalizedString(@"Verbs", nil), NSLocalizedString(@"Adjectives", nil)];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    [self.view addSubview:self.segmentedControl];
    [self.segmentedControl addTarget:self action:@selector(selectTagType:) forControlEvents:UIControlEventValueChanged];
}

- (void)loadLayoutContraints {
    [self.textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.segmentedControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_segmentedControl]-[_textView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView, _segmentedControl)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_textView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_segmentedControl]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_segmentedControl)]];
}

- (void)highlightLinguisticTag:(NSString *)tag {
    self.textView.attributedText = [self attributedStringHighlightedForTag:tag];
}

- (NSAttributedString *)attributedStringHighlightedForTag:(NSString *)tag {
    NSString *string = @"Solemnly he came forward and mounted the round gunrest. He faced about and blessed gravely thrice the tower, the surrounding land and the awaking mountains. Then, catching sight of Stephen Dedalus, he bent towards him and made rapid crosses in the air, gurgling in his throat and shaking his head. Stephen Dedalus, displeased and sleepy, leaned his arms on the top of the staircase and looked coldly at the shaking gurgling face that blessed him, equine in its length, and at the light untonsured hair, grained and hued like pale oak.";
    NSRange stringRange = NSMakeRange(0, string.length);
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string attributes:nil];
    [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNext-Regular" size:17.f] range:stringRange];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:stringRange];
    
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:@[NSLinguisticTagSchemeLexicalClass] options:0];
    tagger.string = string;
    [tagger enumerateTagsInRange:stringRange scheme:NSLinguisticTagSchemeLexicalClass options:0 usingBlock:^(NSString *tokenTag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop) {
        if ([tokenTag isEqualToString:tag]) {
            [text addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:tokenRange];
        }
    }];
    
    return text;
}

- (NSString *)tagAtIndex:(NSInteger)index {
    return self.tags[index];
}

- (NSArray *)tags {
    return @[NSLinguisticTagNoun, NSLinguisticTagVerb, NSLinguisticTagAdjective];
}

@end
