//
//  SwiftCommon.swift
//  GetCNText
//
//  Created by xing on 2022/1/13.
//

import Foundation


extension UILabel {
    @objc static func labelWithTitle(_ title:String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = title
        label.numberOfLines = 0
        return label
    }
}
