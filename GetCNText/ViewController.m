//
//  ViewController.m
//  GetCNText
//
//  Created by xing on 2022/1/12.
//

#import "ViewController.h"
#import "GetCNText-Swift.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIStackView *stackView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [_stackView.arrangedSubviews.firstObject removeFromSuperview];
    NSAssert(YES, @"断言提示");
    [self addText:@"苹果".localizedString];
    [self addText:JJLocalized(@"苹果")];
    [self addText:@"早上好"];
    [self addText:@"中午好"];
    [self addText:@"晚上好"];
}

- (void)addText:(NSString *)text {
    [self.stackView addArrangedSubview:[UILabel labelWithTitle:text]];
}

@end
