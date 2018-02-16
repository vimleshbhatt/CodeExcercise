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
        
        // Add header, description and image to the  cell.
        self.contentView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(80)
            make.left.equalTo(10)
            make.top.equalTo(self.contentView).offset(10)
        }
        
        self.contentView.addSubview(lblHeader)
        lblHeader.textColor = .black
        
        lblHeader.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(imgView.snp.right).offset(10)
            make.top.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
        }
        
        lblDescription.numberOfLines = 0
        lblDescription.lineBreakMode = .byWordWrapping
        lblDescription.clipsToBounds = true
        lblDescription.textColor = .lightGray
        
        self.contentView.addSubview(lblDescription)
        
        lblDescription.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(lblHeader)
            make.top.equalTo(lblHeader.snp.bottom).offset(10)
            make.bottom.equalTo(self.contentView).offset(-10)
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
