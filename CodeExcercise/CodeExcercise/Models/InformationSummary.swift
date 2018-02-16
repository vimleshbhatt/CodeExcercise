//
//  InformationSummary.swift
//  CodeExcercise
//
//  Created by fgb on 2/12/18.
//  Copyright © 2018 vimlesh. All rights reserved.
//

import Foundation

/**
 * A sample class demonstrating good Objective-C style. All interfaces,
 * categories, and protocols (read: all non-trivial top-level declarations
 * in a header) MUST be commented. Comments must also be adjacent to the
 * object they're documenting.
 */

class InformationSummary {
    
    /** The retained Bar. */
    var title:String?
    
    /** The retained Bar. */
    var description:String?
    
    /** The retained Bar. */
    var imageRef:String?
    
    init(title:String?, description:String?, imageRef:String?){
        self.title = title
        self.description = description
        self.imageRef = imageRef
    }
}
