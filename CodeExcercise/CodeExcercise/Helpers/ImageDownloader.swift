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

/**
 * An extension to the UIImageView class which contains a method to download and apply the downloaded image on the imageView
 * AlamofireImage is used to download the image from the remote server. A placeholde image is applied when no image is received from the server or in case of an error oe the imageUrl is incorrect.
 */
extension UIImageView{
    
    /**
     * Class method to download an image from a remote server.
     * @param imageUrlString The string path for the image to download.
     *
     */
    public func imageWithUrl(imageUrlString: String?) {
        
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
    
    /**
     * Class method to return a placeholder image in-case the image is not downloaded from the server.
     * @param imageUrlString The string path for the image to download.
     *
     */
    fileprivate func getPlaceholderImage() -> UIImage {
        return UIImage(imageLiteralResourceName: "placeholder")
    }
}
