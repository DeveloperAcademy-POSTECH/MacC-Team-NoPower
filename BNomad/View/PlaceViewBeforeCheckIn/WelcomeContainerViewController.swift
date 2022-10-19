//
//  WelcomeContainerViewController.swift
//  BottomSheet
//
//  Created by Zafar on 8/13/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import UIKit

final class WelcomeContainerViewController: BottomSheetContainerViewController
<MapViewController, MyCustomViewController> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do something
    }
    
}


//WelcomeContainerViewController(contentViewController: HelloViewController(), bottomSheetViewController: MyCustomViewController(), bottomSheetConfiguration: .init(height: UIScreen.main.bounds.height * 0.6, initialOffset: 60 + window!.safeAreaInsets.bottom)
//)
