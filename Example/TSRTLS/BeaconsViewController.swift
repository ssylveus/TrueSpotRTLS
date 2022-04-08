//
//  BeaconsViewController.swift
//  TSRTLS_Example
//
//  Created by Steeven Sylveus on 4/5/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import TSRTLS

class BeaconsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var beacons = [TSDevice]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBeacons()
    }
    
    
    private func getBeacons() {
        TrueSpot.shared.getTrackingDevices {[weak self] devices, error in
            self?.beacons = devices
            self?.tableView.reloadData()
        }
    }
}

extension BeaconsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beacons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = beacons[indexPath.row].tagIdentifier
        return cell
    }
}
