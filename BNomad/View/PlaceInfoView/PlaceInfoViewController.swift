//
//  PlaceViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/17.
//

import UIKit

class PlaceInfoViewController: UIViewController, UISheetPresentationControllerDelegate {

    override func viewDidLoad() {
            super.viewDidLoad()
            
            let btn = UIButton(type: .system)
            view.addSubview(btn)
            btn.frame = .init(x: 100, y: 100, width: 100, height: 100)
            btn.setTitle("장소핀", for: .normal)
            btn.addTarget(self, action: #selector(presentModalBtnTap), for: .touchUpInside)
        }
        
        @objc private func presentModalBtnTap() {
            
            let vc = UIViewController()
            vc.view.backgroundColor = .white
            vc.view.layer.cornerRadius = 12
            vc.modalPresentationStyle = .pageSheet
            
            if let sheet = vc.sheetPresentationController {
                
                //지원할 크기 지정
                sheet.detents = [.medium(), .large()]
                //크기 변하는거 감지
                sheet.delegate = self
               
                //시트 상단에 그래버 표시 (기본 값은 false)
                sheet.prefersGrabberVisible = true
                
                //처음 크기 지정 (기본 값은 가장 작은 크기)
                //sheet.selectedDetentIdentifier = .large
                
                //뒤 배경 흐리게 제거 (기본 값은 모든 크기에서 배경 흐리게 됨)
                //sheet.largestUndimmedDetentIdentifier = .medium
                
            }
            
            present(vc, animated: true, completion: nil)
        }
        
    }
