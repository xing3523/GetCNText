//
//  NSString+Category.m
//  GetCNText
//
//  Created by xing on 2022/1/13.
//

#import "NSString+Category.h"

#import "GetCNText-Swift.h"
@implementation NSString (Category)
- (NSString *)localizedString {
    
    return [LanguageManager localized:self];
}
@end
