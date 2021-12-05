//
//  DLViewController.swift
//  basic_app
//
//  Created by Liaz Kamper on 01/06/2020.
//  Copyright © 2020 OneLink. All rights reserved.
//

import UIKit
import AppsFlyerLib

class DLViewController: UIViewController {
    
    var deepLinkData: DeepLink? = nil
    var viewControllerFirstLaunch: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //Prepare deep link data to be presented as a formatted string
    func attributionDataToString(data : [String: Any]) -> NSMutableAttributedString {
        let newString = NSMutableAttributedString()
        let boldAttribute = [
           NSAttributedString.Key.font: UIFont(name: "Avenir Next Bold", size: 18.0)!
        ]
        let regularAttribute = [
           NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 18.0)!
        ]
        let sortedKeys = Array(data.keys).sorted(by: <)
        for key in sortedKeys {
            print("ViewController", key, ":",data[key] ?? "null")
            let keyStr = key
            let boldKeyStr = NSAttributedString(string: keyStr, attributes: boldAttribute)
            newString.append(boldKeyStr)
            
            var valueStr: String
            switch data[key] {
            case let s as String:
                valueStr = s
            case let b as Bool:
                valueStr = b.description
            default:
                valueStr = "null"
            }
            
            let normalValueStr = NSAttributedString(string: ": \(valueStr)\n", attributes: regularAttribute)
            newString.append(normalValueStr)
        }
        return newString
    }
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: 20, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    //Generate a short link with given parameters and copy the shortlink to clipboard
    func copyShareInviteLink(fruitName: String){
        //Set the desired template
        AppsFlyerLib.shared().appInviteOneLinkID = "H5hv"

        AppsFlyerShareInviteHelper.generateInviteUrl(linkGenerator:
         {(_ generator: AppsFlyerLinkGenerator) -> AppsFlyerLinkGenerator in
            generator.addParameterValue(fruitName, forKey: "deep_link_value")
            generator.addParameterValue("user_referrer", forKey: "deep_link_sub1")
            generator.setCampaign("share_invite")
          return generator },
        completionHandler: {(_ url: URL?) -> Void in
            if url != nil{
                //Copy url to clipboard
                UIPasteboard.general.string = (url!.absoluteString)
                //Show toast to let the user know link has been copied to clipboard
                DispatchQueue.main.async {
                    self.showToast(message: "Link copied to clipboard", font: .systemFont(ofSize: 12.0))
                }
            }
            else{
                NSLog("url is nil")
            }
        })
    }
}

