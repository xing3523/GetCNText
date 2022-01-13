//
//  ViewController1.swift
//  GetCNText
//
//  Created by xing on 2022/1/12.
//

import UIKit

class ViewController1: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLayoutSubviews() {
        if let scrollView = stackView.superview as? UIScrollView {
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: stackView.frame.height)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.arrangedSubviews.first?.removeFromSuperview()
        addText("中文1".localizedString)
        addText("11221")
        addText("中文2")
        addText("中文3")
        
        // Do any additional setup after loading the view.
    }
    
    func addText(_ text:String) {
        stackView.addArrangedSubview(labelWithTitle(text))
    }
    
    func labelWithTitle(_ title:String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = title
        return label
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
