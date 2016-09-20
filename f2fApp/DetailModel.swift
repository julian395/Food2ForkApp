//
//  DetailModel.swift
//  f2fApp
//
//  Created by Julian1 on 18.09.16.
//  Copyright © 2016 juliankob.com. All rights reserved.
//

import Foundation

class DetailModel {
    var ingredients: String!
    var imgUrl: String!
    var title: String!
    
    
    
    required init(json: JSON)
    {
        self.imgUrl = json["image_url"].stringValue
        self.ingredients = json["ingredients"].stringValue
        self.title = json["title"].stringValue
    }
    
}
