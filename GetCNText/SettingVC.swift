//
//  SettingVC.swift
//  GetCNText
//
//  Created by xing on 2022/1/13.
//

import UIKit

class SettingVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLabel = UILabel(frame: CGRect(x: 80, y: 40, width: 60, height: 30))
        titleLabel.text = JJLocalized("设置")
        view.addSubview(titleLabel)
        
        let changeToCNBtn = buttonWithTitle(title: (LanguageManager.languageType == LanguageType.cn ? "✅ " : "") + "切换中文")
        changeToCNBtn.frame = CGRect(x: 0, y: 100, width: 200, height: 30)
        changeToCNBtn.addTarget(self, action: #selector(changeToCNClick), for: .touchUpInside)
        let changeToENBtn = buttonWithTitle(title: (LanguageManager.languageType == LanguageType.en ? "✅ " : "") + "切换英文")
        changeToENBtn.addTarget(self, action: #selector(changeToENClick), for: .touchUpInside)
        changeToENBtn.frame = CGRect(x: 0, y: 140, width: 200, height: 30)
        view.addSubview(changeToCNBtn)
        view.addSubview(changeToENBtn)
    }

    @objc func changeToCNClick() {
        LanguageManager.languageType = .cn
    }

    @objc func changeToENClick() {
        LanguageManager.languageType = .en
    }

    func buttonWithTitle(title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.contentHorizontalAlignment = .right
        btn.setTitle(title, for: .normal)
        return btn
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
