//
//  WeatherPic.swift
//  WeatherPics
//
//  Created by Kiana Caston on 4/13/18.
//  Copyright © 2018 Kiana Caston. All rights reserved.
//

import UIKit

class WeatherPic: NSObject {
    
    var caption : String
    var imageURL : String
    
    init(caption : String, imageURL : String) {
        self.caption = caption
        self.imageURL = imageURL
    }
    
}
