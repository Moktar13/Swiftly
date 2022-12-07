//  INFO49635 - CAPSTONE FALL 2022
//  InterstitialView.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import GoogleMobileAds
import SwiftUI
import UIKit


//class used to handle interstitial advertisements
final class Interstitial:NSObject, GADFullScreenContentDelegate {
  var interstitial:GADInterstitialAd?

    
  //initializer
  override init() {
    super.init()
    self.loadInterstitial()
  }

    //loads the interstital ad
    func loadInterstitial(){
        let request = GADRequest()
        request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        
        
        //interstitial ad, with test ad ID
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910",
                               request: request,
                               completionHandler: { [self] ad, error in
                                if let error = error {
                                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                    return
                                }
                                interstitial = ad
                                interstitial?.fullScreenContentDelegate = self
                               })
    }

    //displays the advertisement
    func showAd(){
        if self.interstitial != nil {
            let root = UIApplication.shared.windows.first?.rootViewController
            self.interstitial?.present(fromRootViewController: root!)
        }
        else{
            print("Not Ready")
        }
    }
    
    //used for handling full screen content
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        self.loadInterstitial()
    }
    
}

