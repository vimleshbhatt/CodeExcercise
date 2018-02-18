//
//  QuickInfoCell.swift
//  CodeExcercise
//
//  Created by fgb on 2/12/18.
//  Copyright © 2018 vimlesh. All rights reserved.
//

import Foundation
import UIKit

/**
 * A UITableViewCell cell class which creates and returns a cell for reuse.
 *
 */

class QuickInfoCell: UITableViewCell {
    
    /** The label to display the header on the cell. */
    var lblHeader : UILabel = UILabel()
    
    /** The label to display the description on the cell. */
    var lblDescription : UILabel = UILabel()
    
    /** The imageView on which the image will be downloaded and set. */
    var imgView : UIImageView = UIImageView()
    
    /**
     * Initialization method.
     * This will NOT get called unless you call "registerClass, forCellReuseIdentifier" on your tableview.
     *
     * @param style The style used for the cell.
     * @param reuseIdentifier The reusable identifier which is registered with the class.
     *
     */
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        // Add header, description and image to the  cell.
        self.contentView.addSubview(lblHeader)
        self.contentView.addSubview(lblDescription)
        self.contentView.addSubview(imgView)
        
        lblHeader.textColor = .black
        lblHeader.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure Title
        lblHeader.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(imgView.snp.right).offset(10)
            make.top.equalTo(marginGuide.snp.top)
            make.right.equalTo(marginGuide.snp.right)
        }
        lblHeader.numberOfLines = 0
        lblHeader.font = UIFont(name: "AvenirNext-DemiBold", size: 16)

        // Configure Description
        lblDescription.textColor = .lightGray
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        lblDescription.numberOfLines = 0
        lblDescription.font = UIFont(name: "Avenir-Book", size: 12)
        lblDescription.textColor = UIColor.lightGray
        lblDescription.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(lblHeader.snp.left)
            make.top.equalTo(lblHeader.snp.bottom)
            make.right.equalTo(marginGuide.snp.right)
            make.bottom.equalTo(marginGuide.snp.bottom)
        }
        
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        
        imgView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(60)
            make.left.equalTo(marginGuide.snp.left)
            make.top.equalTo(marginGuide.snp.top)
            make.bottom.equalTo(marginGuide.snp.bottom)
        }
        
        self.contentView.backgroundColor = .white
    }
    
    /**
     * Required initializer method
     * This function is apparently required; gets called by default if you don't call "registerClass, forCellReuseIdentifier" on your tableview
     *
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     * Configuration or Setup method for the cell.
     * This function is called when the cells are created to set data on the cell using the passed info object.
     *
     * @param info The InformationSummary model object to be used for populating the data on the cell.
     *
     */
    func setupWithInformation(info:InformationSummary) {
        // Configure image, title and description.
        lblHeader.text = info.title
        lblDescription.text = info.description
        imgView.imageWithUrl(imageUrlString: info.imageRef)
    }
}
