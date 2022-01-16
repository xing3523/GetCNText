//
//  ViewController1.swift
//  GetCNText
//
//  Created by xing on 2022/1/12.
//

import UIKit

class ViewController1: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLayoutSubviews() {
        if let scrollView = stackView.superview as? UIScrollView {
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: stackView.frame.height)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.arrangedSubviews.first?.removeFromSuperview()
        assert(true, "断言提示")
        addText("苹果".localizedString)
        addText(JJLocalized("苹果"))
        addText("晚上好")
        addText("1111")
        addText("早安")
        addText("晚安")
        addText("测试\n换行")
        addText(String(format: "“特殊字符”%@%d个", "有",2))
        print("输出log")
        // Do any additional setup after loading the view.
    }
    
    func addText(_ text:String) {
        stackView.addArrangedSubview(UILabel.labelWithTitle(text))
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
