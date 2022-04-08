//
//  ViewController.swift
//  TSRTLS
//
//  Created by Steeven Sylveus on 03/14/2022.
//  Copyright (c) 2022 Steeven Sylveus. All rights reserved.
//

import UIKit
import TSRTLS

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TrueSpot.shared.requestLocationPermission()
        
    }
}

