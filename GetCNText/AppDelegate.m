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


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
	self.window.backgroundColor = UIColor.whiteColor;
	[self resetApp];
	[self.window makeKeyAndVisible];
	NSLog(@"%@",NSHomeDirectory());
	return YES;
}

- (void)resetApp {
//    NSLog(@"当前语言：%@",LanguageManager.currentLanguage);
	UITabBarController *tabBar = [[UITabBarController alloc] init];
	tabBar.viewControllers = @[[SettingVC new],[ViewController new],[ViewController1 new]];
	NSArray *titles = @[@"设置".localizedString,@"测试xib".localizedString,@"测试代码".localizedString];
	[UINavigationBar appearance].translucent = NO;
	[tabBar.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
	         obj.tabBarItem.title = titles[idx];
	 }];
	self.window.rootViewController = tabBar;
}

- (void)checkStr {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"py_cnStr" ofType:@"txt"];
	NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	NSArray *arr = [str componentsSeparatedByString:@"\n"];
	int num2 = 0;
	NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) objectAtIndex:0];
	NSString *path1 = [docPath stringByAppendingPathComponent:@"waitingTranslation_en.strings"];
	NSString *path2 = [docPath stringByAppendingPathComponent:@"waitingTranslation_ch.strings"];
	NSString *path3 = [docPath stringByAppendingPathComponent:@"waitingTranslation_trans.strings"];
	NSMutableArray *strArray1 = [@[] mutableCopy];
	NSMutableArray *strArray2 = [@[] mutableCopy];
	NSMutableArray *strArray3 = [@[] mutableCopy];

	NSString *regex = @"[^\"]*[\u4E00-\u9FA5]+[^\"\n]*?";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	NSMutableDictionary *dic = [NSMutableDictionary new];


	NSMutableDictionary * keyValue = [@{} mutableCopy];
	for (NSString *lineStr in arr) {
		NSArray *array = [lineStr componentsSeparatedByString:@"--x--"];
		NSString *originStr = array.firstObject;
		if (originStr.length < 2) {
			continue;
		}
		NSString *txt = [originStr substringWithRange:NSMakeRange(1, originStr.length-2)];
		txt = [txt stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
		txt = [txt stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
		txt = [txt stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
		NSString *tran = txt.localizedString;
		BOOL hasCH = [predicate evaluateWithObject:tran];
		NSString *fileName = [array.lastObject stringByDeletingPathExtension];
		NSString *hashCode = [NSString stringWithFormat:@"%lu",fileName.hash];
		hashCode = [hashCode substringToIndex:7];
		NSNumber *num = dic[fileName];
		if (!num) {
			num = @0;
		}
		int num1 = [num intValue];
		NSString *classPre = fileName;
		classPre = [classPre substringFromIndex:2];
		classPre = [classPre stringByReplacingOccurrencesOfString:@"ViewController" withString:@""];
		classPre = [classPre stringByReplacingOccurrencesOfString:@"Controller" withString:@""];
		NSString *key = [NSString stringWithFormat:@"%@_%@_%d",classPre,hashCode,num1];
		if (hasCH) {
			NSLog(@"-->no-%d:%@",num1,originStr);
			[strArray1 addObject:[NSString stringWithFormat:@"\"%@\" = \"\";//%@\n",key,txt]];
			[strArray2 addObject:[NSString stringWithFormat:@"\"%@\" = \"%@\";//%@\n",key,txt,txt]];
			[strArray3 addObject:[NSString stringWithFormat:@"\"%@\" = \"%@\";\n",key,txt]];
			num1++;
			dic[fileName] = @(num1);
		} else {
			NSLog(@"-->yes-%d:%@-%@",num2,originStr,tran);
			num2++;
		}
		keyValue[key] = txt;
	}
	[strArray1 sortUsingSelector:@selector(compare:)];
	[strArray2 sortUsingSelector:@selector(compare:)];
	[strArray3 sortUsingSelector:@selector(compare:)];
	NSString *str1 = [strArray1 componentsJoinedByString:@""];
	NSString *str2 = [strArray2 componentsJoinedByString:@""];
	NSString *str3 = [strArray3 componentsJoinedByString:@""];
	[self writeStr:str1 toPath:path1];
	[self writeStr:str2 toPath:path2];
	[self writeStr:str3 toPath:path3];
	NSString *keyValuePath = [docPath stringByAppendingPathComponent:@"keyvalue.txt"];
	NSArray *sortArray = [keyValue.allKeys sortedArrayUsingSelector:@selector(compare:)];
	NSMutableString *keyValueStr = [@"" mutableCopy];
//    NSLog(@"====>%@",str1);
//    NSLog(@"====>%@",keyValue);
//    keyValue enb
	for (NSString *key in sortArray) {
		[keyValueStr appendFormat:@"@\"%@\": @\"%@\",\n", keyValue[key],key];
	}
	[self writeStr:keyValueStr toPath:keyValuePath];
}

- (void)writeStr:(NSString *)str toPath:(NSString *)path {
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
	}
	[str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"-->%@",path);
}

@end
