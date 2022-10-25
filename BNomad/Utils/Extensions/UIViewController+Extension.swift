//
//  UIViewController+Extension.swift
//  BNomad
//
//  Created by Eunbee Kang on 2022/10/25.
//

import UIKit

extension UIViewController {
    
    // 화면 빈 곳 터치하면 키보드 내리기
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
