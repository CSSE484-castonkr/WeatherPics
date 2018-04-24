//
//  WeatherPic.swift
//  WeatherPics
//
//  Created by Kiana Caston on 4/23/18.
//  Copyright © 2018 Kiana Caston. All rights reserved.
//

import UIKit
import Firebase

class WeatherPic: NSObject {
    var id: String?
    var caption: String
    var imageURL: String
    var created: Date!

    let captionKey = "caption"
    let imageURLKey = "imageURL"
    let createdKey = "created"

    init(caption: String, imageURL: String) {
        self.caption = caption
        self.imageURL = imageURL
        self.created = Date()
    }

    init(documentSnapshot: DocumentSnapshot) {
        self.id = documentSnapshot.documentID
        let data = documentSnapshot.data()!
        self.caption = data[captionKey] as! String
        self.imageURL = data[imageURLKey] as! String

        if (data[createdKey] != nil) {
            self.created = data[createdKey] as! Date
        }
    }

    var data: [String: Any] {
        return [captionKey: self.caption,
                imageURLKey: self.imageURL,
                createdKey: self.created]
    }
}