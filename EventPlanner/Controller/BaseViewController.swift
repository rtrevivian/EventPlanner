//
//  BaseViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/24/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit
import MapKit

extension UIViewController {
    
    func presentSimpleAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func presentTextFieldAlert(title: String?, message: String?, textFields: [UITextField]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler(nil)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: Applications or Web
    
    func openApplicationOrWeb(appURL: String, webURL: String) {
        let appURL = NSURL(string: appURL)!
        let webURL = NSURL(string: webURL)!
        let application = UIApplication.sharedApplication()
        application.openURL(application.canOpenURL(appURL) ? appURL : webURL)
    }
    
    func openFacebookPage(str: String) {
        // http://stackoverflow.com/questions/5707722/what-are-all-the-custom-url-schemes-supported-by-the-facebook-iphone-app
        openApplicationOrWeb("fb://page?id=" + str, webURL: "https://www.facebook.com/" + str)
    }
    
    func openInstagramWithHastag(str: String) {
        guard !str.isEmpty else {
            presentSimpleAlert(nil, message: "Enter a hastag")
            return
        }
        // https://www.instagram.com/developer/mobile-sharing/iphone-hooks/
        let hashtag = str.stringByReplacingOccurrencesOfString("#", withString: "")
        openApplicationOrWeb("instagram://tag?name=" + str, webURL: "https://www.instagram.com/explore/tags/" + hashtag)

    }
    
    func editInstagram() {
        
    }
    
    func openMaps(address: String) {
        guard !address.isEmpty else {
            presentSimpleAlert(nil, message: "Enter an address")
            return
        }
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = address
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler({ (response, error) -> Void in
            guard error == nil else {
                self.presentSimpleAlert("Change address", message: "Could not find " + address)
                return
            }
            let coordinate = CLLocationCoordinate2D(latitude: response!.boundingRegion.center.latitude, longitude: response!.boundingRegion.center.longitude)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
            mapItem.name = address
            mapItem.openInMapsWithLaunchOptions(nil)
        })
    }
    
    func openTwitterWithHashtag(str: String) {
        guard !str.isEmpty else {
            presentSimpleAlert(nil, message: "Enter a hastag")
            return
        }
        let hashtag = str.stringByReplacingOccurrencesOfString("#", withString: "")
        openApplicationOrWeb("twitter://search?query=%23hashtag" + hashtag, webURL: "https://mobile.twitter.com/search/?q=%23" + hashtag)
    }
    
    // MARK: Applications
    
    func openApplication(str: String) {
        let url = NSURL(string: str)!
        if UIApplication.sharedApplication().canOpenURL(url) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func openPhone(str: String) {
        guard !str.isEmpty else {
            presentSimpleAlert(nil, message: "Enter a phone number")
            return
        }
        openApplication("tel:" + str)
    }
    
    func openEmail(str:String) {
        guard !str.isEmpty else {
            presentSimpleAlert(nil, message: "Enter an email address")
            return
        }
        openApplication("mailto:" + str)
    }
    
    func openURL(var str: String) {
        guard !str.isEmpty else {
            presentSimpleAlert(nil, message: "Enter an website URL")
            return
        }
        let http = "http://"
        if str.characters.count > 3 {
            if (str as NSString).substringToIndex(4) != http {
                str = http + str
            }
        } else {
            str = http + str
        }
        openApplication(str)
    }
    
}
