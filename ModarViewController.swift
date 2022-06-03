//
//  ModarViewController.swift
//  TrueSpot
//
//  Created by Steeven Sylveus on 10/20/20.
//  Copyright © 2020 TrueSpot. All rights reserved.
//

import UIKit
import AVFoundation

class ModarViewController: UIViewController {
    
    @IBOutlet var speakerOffButton: UIBarButtonItem!
    
    @IBOutlet var speakerOnButton: UIBarButtonItem!
    
    @IBOutlet weak var lastSeenLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    @IBOutlet weak var farView: UIView! {
        didSet {
            //1.5 represents = the equal width constraint multiplier on the storyboard
            self.farView.layer.cornerRadius = (UIScreen.main.bounds.width * 1.5) / 2
            self.farView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nearView: UIView! {
        didSet {
            //1.3 = the equal width constraint multiplier on the storyboard
            self.nearView.layer.cornerRadius = (UIScreen.main.bounds.width * 1.3) / 2
            self.nearView.clipsToBounds = true
        }
    }

    @IBOutlet weak var immediateView: UIView! {
        didSet {
            //1.5 = the equal width constraint multiplier on the storyboard
            self.immediateView.layer.cornerRadius = (UIScreen.main.bounds.width * 1.5) / 2
            self.immediateView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var tagViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagView: UIView!
    
    var farViewHeight: CGFloat!
    var farViewYPos: CGFloat!
    var nearViewHeight: CGFloat!
    var nearViewYPos: CGFloat!
    var immediateViewHeight: CGFloat!
    var immediateViewYPos: CGFloat!
    
    var audioPlayer: AVAudioPlayer?
    var beaconsObservable: NSObjectProtocol?
    var beacon: TSBeacon?
    var farRSSILocationDictionary = [Int: CGFloat]()
    var nearRSSILocationDictionary = [Int: CGFloat]()
    var immediateRSSILocationDictionary = [Int: CGFloat]()
    let upperRange = -30
    let lowerRange = -85
    //let feasyManager = FeasyManager()
    var lastSeenDate: Date?
    var modarTimer: Timer?
    var beaconDetectionTimer: Timer?
    var device: TSDevice?
    
    static func create(device: TSDevice) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "TrueSpot", bundle: Bundle.trueSpotBundle)
        let navController = storyboard.instantiateViewController(withIdentifier: "ModarRootNav") as! UINavigationController
        navController.modalPresentationStyle = .fullScreen
        let vc = navController.viewControllers.first as! ModarViewController
        vc .device = device
        
        return navController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initializeAVPlayer()
        calculateValuesForRSSILocationDictionary()
        initializeBeaconObserver()
        resetBeaconDetectionTimer()
        
        if let timeStamp = device?.locationUpdateTimestamp {
            lastSeenLabel.text = "Last seen: \(timeStamp)"
        }
        
        navigationItem.rightBarButtonItems = [speakerOnButton]
   
        modarTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (_) in
            guard let beaconIdentifier = self.device?.tagIdentifier else {
                return
            }
            
            //self.feasyManager.startFastBroadcast(beaconIdentifier: beaconIdentifier)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let observer = beaconsObservable {
            NotificationCenter.default.removeObserver(observer)
        }
        //feasyManager.stopFastBroadcast()
        modarTimer?.invalidate()
        super.viewWillDisappear(animated)
    }
    
    func calculateValuesForRSSILocationDictionary() {
        //RSSI ranges from - 50 to -100
        
        farViewYPos = 0
        farViewHeight = nearView.frame.origin.y
        
        nearViewYPos = nearView.frame.origin.y
        nearViewHeight = immediateView.frame.origin.y - nearView.frame.origin.y
        
        immediateViewYPos = immediateView.frame.origin.y
        immediateViewHeight = self.view.frame.size.height - immediateView.frame.origin.y
        
        let farUpperRange = -100
        let farlowerRange = -75
        
        let nearUpperRange = -74
        let nearLowerRange = -53
        
        let immediateUpperRange = -52
        let immediateLowerRange = -30
        
        addValuesToRSSIDict(dict: &farRSSILocationDictionary, upperRange: farUpperRange, lowerRange: farlowerRange, viewYPOS: farViewYPos, viewHeight: farViewHeight)
        
        addValuesToRSSIDict(dict: &nearRSSILocationDictionary, upperRange: nearUpperRange, lowerRange: nearLowerRange, viewYPOS: nearViewYPos, viewHeight: nearViewHeight)
        
        addValuesToRSSIDict(dict: &immediateRSSILocationDictionary, upperRange: immediateUpperRange, lowerRange: immediateLowerRange, viewYPOS: immediateViewYPos, viewHeight: immediateViewHeight)
    }
    
    func addValuesToRSSIDict(dict: inout [Int: CGFloat], upperRange: Int, lowerRange: Int, viewYPOS: CGFloat, viewHeight: CGFloat)   {
        let screenSegments = viewHeight / CGFloat((lowerRange - upperRange))
        var initialYValue: CGFloat = viewYPOS
        
        for i in upperRange..<lowerRange {
            initialYValue += screenSegments
            dict[i] = initialYValue
            print(initialYValue)
        }
    }
    
    func resetBeaconDetectionTimer() {
        beaconDetectionTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false, block: { (_) in
            
            let alertController = UIAlertController(title: "Tag Not Found", message: "This tag could not be located at this time.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    func initializeBeaconObserver() {
        guard let beaconIdentifier = device?.tagIdentifier else {
            let alertController = UIAlertController(title: "Unable to locate TrueTag", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        //feasyManager.startFastBroadcast(beaconIdentifier: beaconIdentifier)
        self.title = beaconIdentifier
        beaconsObservable = TSBeaconManager.shared.observeBeaconRSSI(beaconIdentifier: beaconIdentifier) { (beacon) in
            
            self.beaconDetectionTimer?.invalidate()
            self.resetBeaconDetectionTimer()
            
            if TrueSpot.isDebugMode {
                print("Proximity: \(beacon.proximity)")
            }
            self.beacon = beacon
            self.tagView.isHidden = false
            if let rssi = beacon.RSSI {
                self.rssiLabel.text = "\(rssi) rssi"
            }
            
            self.updateTagView()
            self.playSound()
            
            if self.lastSeenDate == nil {
                self.lastSeenDate = Date()
            }
            
            if let date = self.lastSeenDate {
                self.lastSeenLabel.text = "Last Seen: \(date.getElapsedInterval())"
                self.lastSeenDate = Date()
            }
        }
    }

    func updateTagView() {
        guard let beacon = self.beacon, let rssi = beacon.RSSI else {
            return
        }
        
        let padding: CGFloat = 70.0 // Padding from bottom of screen to top of signal streng icon
        if let topValue = farRSSILocationDictionary[rssi] {
            tagViewTopConstraint.constant = topValue - tagView.bounds.size.height
        } else if let topValue = nearRSSILocationDictionary[rssi] {
            tagViewTopConstraint.constant = topValue - tagView.bounds.size.height
        } else if let topValue = immediateRSSILocationDictionary[rssi] {
            tagViewTopConstraint.constant = topValue - (tagView.bounds.size.height + padding)
        } else {
            if rssi > upperRange && rssi != 0  {
                if let lastKey = immediateRSSILocationDictionary.keys.sorted().last {
                tagViewTopConstraint.constant = (immediateRSSILocationDictionary[lastKey] ?? 0) - (tagView.bounds.size.height + padding)
                }
            }
            
        }
        
        
        UIView.animate(withDuration: 0.8) {
            self.view.layoutIfNeeded()
        } completion: { (_) in
            
        }
    }
    
    private func initializeAVPlayer() {
        do {
            if let fileURL = Bundle.main.path(forResource: "hollow", ofType: "mp3") {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
            } else {
                print("No file with specified name exists")
            }
        } catch let error {
            print("Can't play the audio file failed with an error \(error.localizedDescription)")
        }
    }
    
    private func playSound() {
        audioPlayer?.play()
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func speakerOffButtonPressed(_ sender: Any) {
        audioPlayer?.volume = 1.0
        navigationItem.rightBarButtonItems = [speakerOnButton]
    }
    
    @IBAction func soundButtonPressed(_ sender: Any) {
        audioPlayer?.volume = 0
        navigationItem.rightBarButtonItems = [speakerOffButton]
    }
    
}
