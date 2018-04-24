//
//  Photo.swift
//  PhotoBucket
//
//  Created by CSSE Department on 4/23/18.
//  Copyright © 2018 CSSE Department. All rights reserved.
//

import UIKit
import Firebase

class Photo: NSObject {
    //imageURL, caption, timestamp
    var id: String?
    var imageURL: String
    var caption: String
    var timestamp: Date!
    
    let imageKey = "imageURL"
    let captionKey = "caption"
    let timestampKey = "timestamp"

    init(imageURL: String, caption: String) {
        self.imageURL = imageURL
        self.caption = caption
        self.timestamp = Date()
    }
    
    init(documentSnapshot: DocumentSnapshot) {
        self.id = documentSnapshot.documentID
        let data = documentSnapshot.data()!
        self.caption = data[captionKey] as! String
        self.imageURL = data[imageKey] as! String
        if (data[timestampKey] != nil) {
            self.timestamp = data[timestampKey] as! Date
        }
    }

    var data: [String: Any] {
        return [imageKey: self.imageURL,
                captionKey: self.caption,
                timestampKey: self.timestamp]
    }
    
    
}
