//
//  RestApiManager.swift
//  BookOfRecipes
//
//  Created by Julian1 on 15.09.16.
//  Copyright © 2016 juliankob.com. All rights reserved.
//

import Foundation

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    
    var searchApi = "http://food2fork.com/api/search?key=52575f1f6c6b0fd7d2bff775e3e83e59"
    var recipePage = ""
    var getApi = "http://food2fork.com/api/get?key=52575f1f6c6b0fd7d2bff775e3e83e59"
    var recipeId = ""
    
    func getRecipesPage(s: String) -> String {
        recipePage = searchApi + s
        return recipePage
    }
    
    func getSearchRequestByPage(onCompletion: (JSON) -> Void) {
        let route = recipePage
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    func getRecipeId(s: String) -> String {
        recipeId = getApi + s
        return recipeId
    }
    
    func getDetailRequest(onCompletion: (JSON) -> Void) {
        let route = recipeId
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    private func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                onCompletion(json, error)
            } else {
                onCompletion(nil, error)
            }
        })
        task.resume()
    }
}