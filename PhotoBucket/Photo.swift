//
//  Photo.swift
//  PhotoBucket
//
//  Created by CSSE Department on 4/16/18.
//  Copyright © 2018 CSSE Department. All rights reserved.
//

import UIKit

class Photo: NSObject {
    var caption : String
    var imageURL: String
    
    init(caption : String, image : String){
        self.caption = caption;
        self.imageURL = image;
    }

}
