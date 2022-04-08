//
//  PairBeaconsViewController.swift
//  TSRTLS_Example
//
//  Created by Steeven Sylveus on 4/5/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import TSRTLS

class PairBeaconsViewController: UIViewController {

    var beacons = [TSBeacon]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var selectedRow: Int? = nil
    var beaconsObservable: NSObjectProtocol?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beaconsObservable = TrueSpot.shared.observeBeaconRanged(completion: { (beacons) in
            
            self.beacons = beacons
            
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let observer = beaconsObservable {
            NotificationCenter.default.removeObserver(observer)
        }
        
        super.viewWillDisappear(animated)
    }
    
    @IBAction func pair(_ sender: Any) {
        guard let row = selectedRow, let assetIdentifier = beacons[row].assetIdentifier,
              let asetType = beacons[row].assetType, let tagId = beacons[row].beaconIdentifier else {
            return
        }
        
        TrueSpot.shared.pair(assetIdentifier: assetIdentifier, assetType: asetType, tagId: tagId) { device, error in
            print(device)
        }
    }
    

}

extension PairBeaconsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beacons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if self.selectedRow == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = beacons[indexPath.row].beaconIdentifier
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRow = indexPath.row
        tableView.reloadData()
    }
}
