//
//  FeasyManager.swift
//  TrueSpot
//
//  Created by Steeven Sylveus on 12/7/20.
//  Copyright © 2020 TrueSpot. All rights reserved.
//

import Foundation

class FeasyManager {
    
    var didActivateEnhanceModar = false
    var fastBroadcastTimer: Timer?
    var feasyAPI: FscBleCentralApi!
    let timerValue: TimeInterval = 60.0
    
    init() {
        setupFeasyAPI()
    }
        
    func setupFeasyAPI() {
        feasyAPI = FscBleCentralApi.share()
        feasyAPI.moduleType = BEACONMODULE
        feasyAPI.searchType = CONFIGURATION
        
        feasyAPI.isBtEnabled { (manager) in
            if manager?.state == .poweredOn {
                self.feasyAPI.startScan()
            }
        }
        
        fastBroadcastTimer = Timer.scheduledTimer(withTimeInterval: timerValue, repeats: true) { (timer) in
            self.didActivateEnhanceModar = false
        }
    }
    
    func startFastBroadcast(beaconIdentifier: String)  {
        feasyAPI.blePeripheralFound { (central, peripheral, advertisementData, rssi, peripheralWrapper) in
            if let name = peripheralWrapper?.name, name.contains(beaconIdentifier), !self.didActivateEnhanceModar {
                self.feasyAPI.connect(peripheralWrapper, withPin: "111111")
                self.didActivateEnhanceModar = true
            }
        }
    }
    
    func stopFastBroadcast() {
        fastBroadcastTimer?.invalidate()
    }
}
