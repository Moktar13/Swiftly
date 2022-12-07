//  INFO49635 - CAPSTONE FALL 2022
//  BannerAd.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import SwiftUI
import GoogleMobileAds

//Struct to hold banner type advertisements
struct BannerAd: UIViewRepresentable{
    
    var unitID: String
    
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    //creates the UIView that holds banner ad
    func makeUIView(context: Context) -> GADBannerView{
        let adView = GADBannerView(adSize: GADAdSizeBanner)
        
        adView.adUnitID = unitID 
        adView.rootViewController = UIApplication.shared.getRootViewController()
        adView.delegate = context.coordinator
        let request = GADRequest()
        request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        adView.load(request)
        
        
        return adView
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {
        
    }
    
    //coordinator class that holds all logs involving the banner ad
    class Coordinator: NSObject, GADBannerViewDelegate{
        
        
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
          print("bannerViewDidReceiveAd")
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
          print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        }

        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
          print("bannerViewDidRecordImpression")
        }

        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
          print("bannerViewWillPresentScreen")
        }

        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
          print("bannerViewWillDIsmissScreen")
        }

        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
          print("bannerViewDidDismissScreen")
        }
    }
}

//extending UIApplication to retrieve rootview
extension UIApplication{
    func getRootViewController()->UIViewController{
        
        
        
        guard let screen = self.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        
        return root
    }
}

