//
//  ViewController.swift
//  BookOfRecipes
//
//  Created by Julian1 on 15.09.16.
//  Copyright © 2016 juliankob.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    var items = [RecipeModel]()
    var temp = 1
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rateControl: UISegmentedControl!
    @IBOutlet weak var searchShow: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    var titleText = ""
    var publisherText = ""
    var img: UIImage?
    var indicator: String? = "top rated"

    @IBAction func indexChanged(sender: UISegmentedControl) {
        if rateControl.selectedSegmentIndex == 0
        {
            rateControl.selectedSegmentIndex = 0
            self.indicator = "top rated"
            self.items.removeAll()
            LoadData()
        }
        if rateControl.selectedSegmentIndex == 1
        {
            rateControl.selectedSegmentIndex = 1
            self.indicator = "trending"
            self.items.removeAll()
            LoadData()
        }
    }
    func searchBarSearchButtonClicked( searchBar: UISearchBar!) {
        self.items.removeAll()
        let searchText = "&q=" + (searchBar.text?.removeWhitespace())!
        if (searchBar.text == "")
            {
                let searchError = UIAlertView(title: "Error", message: "Try to enter some text", delegate: self, cancelButtonTitle: "Close")
                searchError.show()
            }
            else
            {
                RestApiManager.sharedInstance.getRecipesPage(searchText)
                RestApiManager.sharedInstance.getSearchRequestByPage { (json: JSON) in
                    if let recipes = json["recipes"].array {
                        for entry in recipes {
                            self.items.append(RecipeModel(json: entry))
                        }
                        dispatch_async(dispatch_get_main_queue(),{
                            self.tableView.reloadData()
                        })
                    }
                }
            }
            searchBar.resignFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        searchShow.setImage(UIImage(named: "search"), forState: UIControlState.Normal)
        searchBar.hidden = true
        if (rateControl.hidden)
        {
            searchBar.hidden = false
        }
        LoadData()
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lastElement = items.count - 1
        if indexPath.row == lastElement {
            temp=temp+1
            if indicator == "top rated" {
                let pageNum = "&sort=r&page=" + String(temp)
                RestApiManager.sharedInstance.getRecipesPage(pageNum)
            }
            if indicator == "trending" {
                let pageNum = "&sort=t&page=" + String(temp)
                RestApiManager.sharedInstance.getRecipesPage(pageNum)
            }
            RestApiManager.sharedInstance.getSearchRequestByPage { (json: JSON) in
                if let recipes = json["recipes"].array {
                    for entry in recipes {
                        self.items.append(RecipeModel(json: entry))
                    }
                    dispatch_async(dispatch_get_main_queue(),{
                        self.tableView.reloadData()
                    })
                }
            }
        }
    }
   
    func LoadData() {
        if indicator == "top rated" {
            let s = "&sort=r&page=1"
            RestApiManager.sharedInstance.getRecipesPage(s)
            RestApiManager.sharedInstance.getSearchRequestByPage { (json: JSON) in
                if let recipes = json["recipes"].array {
                    for entry in recipes {
                        self.items.append(RecipeModel(json: entry))
                    }
                    dispatch_async(dispatch_get_main_queue(),{
                        self.tableView.reloadData()
                    })
                }
            }
        }
        if indicator == "trending" {
            let s = "&sort=t&page=1"
            RestApiManager.sharedInstance.getRecipesPage(s)
            RestApiManager.sharedInstance.getSearchRequestByPage { (json: JSON) in
                if let recipes = json["recipes"].array {
                    for entry in recipes {
                        self.items.append(RecipeModel(json: entry))
                    }
                    dispatch_async(dispatch_get_main_queue(),{
                        self.tableView.reloadData()
                    })
                }
            }
        }
    }
    
    
    @IBAction func searchBtnAction(sender: AnyObject) {
        if (searchBar.hidden)
        {
            searchBar.hidden = false
            rateControl.hidden = true
            searchShow.setImage(UIImage(named: "star"), forState: UIControlState.Normal)
        }
        else
        {
            searchBar.hidden = true
            rateControl.hidden = false
            searchShow.setImage(UIImage(named: "search"), forState: UIControlState.Normal)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail"
        {
            let detailVC: DetailViewController = segue.destinationViewController as! DetailViewController
            let rowIndex = tableView.indexPathForSelectedRow?.row
            let recipes = self.items[rowIndex!]
            detailVC.imageUrl = recipes.imgUrl
            detailVC.rank = recipes.rank
            detailVC.publisher = recipes.publisher
            detailVC.id = recipes.recipeID
            detailVC.recipeTitle = recipes.title
            detailVC.sourceUrl = recipes.srcUrl
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("CELLA")
        
            if let recipeCell = cell as? RecipeCell {
                let recipe = self.items[indexPath.row]
                if let imgUrl = NSURL(string: recipe.imgUrl) {
                    if let data = NSData(contentsOfURL: imgUrl) {
                        recipeCell.recipeImg!.image = UIImage(data: data)
                        img = recipeCell.recipeImg!.image
                    }
                }
                recipeCell.title.text = recipe.title
                recipeCell.rank.text = recipe.rank
                publisherText = recipe.publisher
                titleText = recipe.title
            }
        return cell!
    }
}

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "&")
    }
}



