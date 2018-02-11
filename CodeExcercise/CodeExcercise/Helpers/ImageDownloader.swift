//
//  ImageDownloader.swift
//  CodeExcercise
//
//  Created by fgb on 2/12/18.
//  Copyright © 2018 vimlesh. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

extension UIImageView{
    
    public func imageWithUrl(imageUrlString: String?){
        
        // Adding an progress indicator on the imageview to update the progress of the downloading image.
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        
        var activityIndicatorFrame = activityIndicator.frame
        activityIndicatorFrame.origin.x = (self.frame.size.width/2 - activityIndicatorFrame.size.width/2)
        activityIndicatorFrame.origin.y = (self.frame.size.height/2 - activityIndicatorFrame.size.height/2)
        activityIndicator.frame = activityIndicatorFrame
        
        // Start the activity indicator when the image starts downloading
        activityIndicator.startAnimating()
        
        guard imageUrlString != nil else{
            self.image = getPlaceholderImage()
            activityIndicator.stopAnimating()
            return
        }
        
        Alamofire.request(imageUrlString!).responseImage { response in
            if let image = response.result.value {
                activityIndicator.stopAnimating()
                self.image = image
            }else{
                activityIndicator.stopAnimating()
                self.image = self.getPlaceholderImage()
            }
        }
    }
    
    func getPlaceholderImage()->UIImage{
        return UIImage(imageLiteralResourceName: "placeholder")
    }
}
