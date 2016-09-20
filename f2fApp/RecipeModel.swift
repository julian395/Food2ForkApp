//
//  RecipeModel.swift
//  f2fApp
//
//  Created by Julian1 on 18.09.16.
//  Copyright © 2016 juliankob.com. All rights reserved.
//

import Foundation

class RecipeModel {
    var f2fUrl: String!
    var imgUrl: String!
    var publisher: String!
    var publisherUrl: String!
    var recipeID: String!
    var rank: String!
    var srcUrl: String!
    var title: String!
    
    required init(json: JSON) {
        f2fUrl = json["f2f_url"].stringValue
        imgUrl = json["image_url"].stringValue
        publisher = json["publisher"].stringValue
        publisherUrl = json["publisher_url"].stringValue
        recipeID = json["recipe_id"].stringValue
        rank = json["social_rank"].stringValue
        srcUrl = json["source_url"].stringValue
        title = json["title"].stringValue
    }
}