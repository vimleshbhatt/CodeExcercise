//
//  QuickInfoCell.swift
//  CodeExcercise
//
//  Created by fgb on 2/12/18.
//  Copyright © 2018 vimlesh. All rights reserved.
//

import Foundation
import UIKit

class QuickInfoCell: UITableViewCell {
    
    // MARK: Properties
    var lblHeader : UILabel = UILabel()
    var lblDescription : UILabel = UILabel()
    var imgView : UIImageView = UIImageView()
    
    // MARK: Setup Methods
    
    //-----------------
    // MARK: VIEW FUNCTIONS
    //-----------------
    
    ///------------
    //Method: Init with Style
    //Purpose:
    //Notes: This will NOT get called unless you call "registerClass, forCellReuseIdentifier" on your tableview
    ///------------
    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        //First Call Super
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    ///------------
    //Method: Init with Coder
    //Purpose:
    //Notes: This function is apparently required; gets called by default if you don't call "registerClass, forCellReuseIdentifier" on your tableview
    ///------------
    required init?(coder aDecoder: NSCoder)
    {
        //Just Call Super
        super.init(coder: aDecoder)
    }
    
    ///------------
    //Method: Setup cell with InformationSummary
    //Purpose:
    //Notes: This function is called when the cells are created to set data on the cell using the passed info object.
    ///------------
    func setupWithInformation(info:InformationSummary){
        // Configure image, title and description.
        lblHeader.text = info.title
        lblDescription.text = info.description
    }
    
}
