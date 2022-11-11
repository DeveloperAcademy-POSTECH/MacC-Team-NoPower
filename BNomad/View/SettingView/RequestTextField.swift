//
//  RequestTextField.swift
//  BNomad
//
//  Created by 박성수 on 2022/11/10.
//

import UIKit

final class RequestTextField: UITextField {

    init(placehold: String) {
        super.init(frame: .zero)
        
        self.backgroundColor = CustomColor.nomadGray3
        self.layer.cornerRadius = 12
        self.leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 50)))
        self.leftViewMode = .always
        self.clearButtonMode = .whileEditing
        self.placeholder = placehold
        self.setHeight(50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
