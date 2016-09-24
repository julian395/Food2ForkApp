//
//  ViewController.swift
//  f2fApp
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
    var refreshControl: UIRefreshControl!
    var titleText = ""
    var publisherText = ""
    var img: UIImage?
    var indicator: String? = "top rated"
    var imageCache = [String:UIImage]()
    var gifImg: UIImage?

    @IBAction func indexChanged(sender: UISegmentedControl) {
        if rateControl.selectedSegmentIndex == 0
        {
            rateControl.selectedSegmentIndex = 0
            self.indicator = "top rated"
            self.items.removeAll()
            self.tableView.reloadData()
            searchBar.endEditing(true)
            LoadData()
        }
        if rateControl.selectedSegmentIndex == 1
        {
            rateControl.selectedSegmentIndex = 1
            self.indicator = "trending"
            self.items.removeAll()
            self.tableView.reloadData()
            searchBar.endEditing(true)
            LoadData()
        }
    }
    func searchBarSearchButtonClicked( searchBar: UISearchBar!) {
        self.items.removeAll()
        self.tableView.reloadData()
        let searchText = "&q=" + (searchBar.text?.removeWhitespace())!
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
        searchBar.resignFirstResponder()
        if items.count < 1
        {
            let searchError = UIAlertView(title: "Search", message: "Nothing found", delegate: self, cancelButtonTitle: "Close")
            searchError.show()
        }
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
        if gifImg == nil
        {
            let gifURL : String = "https://s3.amazonaws.com/leadflow/assets/load.gif"
            gifImg = UIImage.gifImageWithURL(gifURL)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Reloading data")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    func refresh(sender:UIRefreshControl){
        self.tableView.reloadData()
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.refreshControl.endRefreshing()
        }
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
        searchBar.endEditing(true)
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
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CELLA")
            if let recipeCell = cell as? RecipeCell {
                let recipe = self.items[indexPath.row]
                if let imgUrl = NSURL(string: recipe.imgUrl) {
                    recipeCell.recipeImg.image = gifImg
                    if let img = imageCache[recipe.imgUrl] {
                        recipeCell.recipeImg!.image = img
                    }
                    else {
                    let request: NSURLRequest = NSURLRequest(URL: imgUrl)
                    let mainQueue = NSOperationQueue.mainQueue()
                    NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                        if error == nil {
                            let image = UIImage(data: data!)
                            self.imageCache[recipe.imgUrl] = image
                            dispatch_async(dispatch_get_main_queue(), {
                               tableView.reloadData()
                            })
                        }
                        else {
                            print("Error: \(error!.localizedDescription)")
                        }
                    })
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
