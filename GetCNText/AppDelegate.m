//
//  AppDelegate.m
//  GetCNText
//
//  Created by xing on 2022/1/12.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "GetCNText-Swift.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

/**
 中文注释
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
	self.window.backgroundColor = UIColor.whiteColor;
	[self resetApp];
	[self.window makeKeyAndVisible];
	NSLog(@"%@",NSHomeDirectory());
    [self generationLocalizationStr];
	return YES;
}

- (void)resetApp {
//    NSLog(@"当前语言：%@",LanguageManager.currentLanguage);
	UITabBarController *tabBar = [[UITabBarController alloc] init];
	tabBar.viewControllers = @[[SettingVC new],[ViewController new],[ViewController1 new]];
	NSArray *titles = @[JJLocalized(@"设置"),@"测试1-(OC)",@"测试2-(Swift)"];
	[UINavigationBar appearance].translucent = NO;
	[tabBar.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
	         obj.tabBarItem.title = titles[idx];
	 }];
	self.window.rootViewController = tabBar;
}
/// 检测并生成本地化文案
- (void)generationLocalizationStr {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"py_cnStr" ofType:@"txt"];
	NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	NSArray *arr = [str componentsSeparatedByString:@"\n"];
	int num2 = 0;
	NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) objectAtIndex:0];
	NSString *enStringsPath = [docPath stringByAppendingPathComponent:@"waitingTranslation_en.strings"];
	NSString *cnStringsPath = [docPath stringByAppendingPathComponent:@"waitingTranslation_cn.strings"];
    // 英文 strings
	NSMutableArray *enStrArray = [@[] mutableCopy];
    // 中文 strings
	NSMutableArray *cnStrArray = [@[] mutableCopy];
	NSMutableArray *transStrArray = [@[] mutableCopy];
    // 包含中文字符串正则
	NSString *regex = @"[^\"]*[\u4E00-\u9FA5]+[^\"\n]*?";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	NSMutableDictionary *numDic = [NSMutableDictionary new];
    
	NSMutableDictionary * keyValue = [@{} mutableCopy];
    NSMutableSet *set = [NSMutableSet new];
	for (NSString *lineStr in arr) {
		NSArray *array = [lineStr componentsSeparatedByString:@"--*--"];
		NSString *originStr = array.lastObject;
		if (originStr.length < 2) {
			continue;
		}
		NSString *txt = [originStr substringWithRange:NSMakeRange(1, originStr.length-2)];
        // 用于检测是否已经有对应翻译了
		NSString *localizedTxt = [txt stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        localizedTxt = [localizedTxt stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
        localizedTxt = [localizedTxt stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
        if ([set containsObject:localizedTxt]) {
            continue;
        }
		NSString *tran = localizedTxt.localizedString;
		BOOL hasCN = [predicate evaluateWithObject:tran];
		NSString *fileName = [array.firstObject stringByDeletingPathExtension];
		NSString *hashCode = [NSString stringWithFormat:@"%lu",fileName.hash];
		hashCode = [hashCode substringToIndex:6];
		NSNumber *num = numDic[fileName];
		if (!num) {
			num = @0;
		}
		int num1 = [num intValue];
		NSString *classPre = fileName;
		classPre = [classPre stringByReplacingOccurrencesOfString:@"ViewController" withString:@"VC"];
		classPre = [classPre stringByReplacingOccurrencesOfString:@"Controller" withString:@"C"];
        classPre = [classPre stringByReplacingOccurrencesOfString:@"View" withString:@"V"];
		NSString *key = [NSString stringWithFormat:@"%@_%@_%d",classPre,hashCode,num1];
		if (hasCN) {
			NSLog(@"-->未多语言化%d:%@",num1,originStr);
			[enStrArray addObject:[NSString stringWithFormat:@"\"%@\" = \"\";//%@\n",key,txt]];
			[cnStrArray addObject:[NSString stringWithFormat:@"\"%@\" = \"%@\";\n",key,txt]];
			num1++;
			numDic[fileName] = @(num1);
            keyValue[key] = txt;
            [set addObject:txt];
		} else {
			NSLog(@"-->已多语言化%d:%@-%@",num2,originStr,tran);
			num2++;
		}
	}
	[enStrArray sortUsingSelector:@selector(compare:)];
	[cnStrArray sortUsingSelector:@selector(compare:)];
	[transStrArray sortUsingSelector:@selector(compare:)];
	NSString *enStr = [enStrArray componentsJoinedByString:@""];
	NSString *cnStr = [cnStrArray componentsJoinedByString:@""];
	[self writeStr:enStr toPath:enStringsPath];
	[self writeStr:cnStr toPath:cnStringsPath];
	NSString *keyValuePath = [docPath stringByAppendingPathComponent:@"keyValue.txt"];
	NSArray *sortArray = [keyValue.allKeys sortedArrayUsingSelector:@selector(compare:)];
	NSMutableString *keyValueStr = [@"" mutableCopy];
	for (NSString *key in sortArray) {
        [keyValueStr appendFormat:@"\"%@\": \"%@\",\n", keyValue[key],key];
// OC
//		[keyValueStr appendFormat:@"@\"%@\": @\"%@\",\n", keyValue[key],key];
	}
	[self writeStr:keyValueStr toPath:keyValuePath];
}


- (void)writeStr:(NSString *)str toPath:(NSString *)path {
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
	}
	[str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
