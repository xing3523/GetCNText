//
//  LanguageManager.swift
//  GetCNText
//
//  Created by xing on 2022/1/13.
//

import Foundation

enum LanguageType: String {
    case en = "en"
    case cn = "zh-Hans"
}

class LanguageManager: NSObject {
    static var languageType: LanguageType = LanguageType(rawValue: UserDefaults.standard.string(forKey: "cacheLanguage") ?? "zh-Hans") ?? .cn {
        didSet {
            if languageType != oldValue {
                currentLanguage = languageType.rawValue
            }
        }
    }

    private static var currentLanguage: String =  languageType.rawValue {
        didSet {
            UserDefaults.standard.setValue(currentLanguage, forKey: "cacheLanguage")
            currentBundle = Bundle(path: Bundle.main.path(forResource: currentLanguage, ofType: "lproj") ?? "")
            let app = UIApplication.shared.delegate as? AppDelegate
            app?.resetApp()
        }
    }

    @objc static func localized(_ key: String) -> String {
        return JJLocalized(key)
    }

    fileprivate static var currentBundle: Bundle? = Bundle(path: Bundle.main.path(forResource: currentLanguage, ofType: "lproj") ?? "")
}

extension String {
    var localizedString: String {
        return JJLocalized(self)
    }
}

private func JJLocalized(_ key: String) -> String {
    return NSLocalizedString(key, tableName: nil, bundle: LanguageManager.currentBundle ?? .main, value: "", comment: "")
}
