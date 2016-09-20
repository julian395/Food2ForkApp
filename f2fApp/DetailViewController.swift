//
//  DetailViewController.swift
//  f2fApp
//
//  Created by Julian1 on 18.09.16.
//  Copyright © 2016 juliankob.com. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var items = [String]()
    var ingredients: String? = ""
    var ingredient: String? = ""
    @IBOutlet weak var imgDetail: UIImageView!
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var publisherText: UILabel!
    @IBOutlet weak var srcUrlText: UILabel!
    @IBOutlet weak var rankText: UILabel!
    @IBOutlet weak var ingredTextView: UITextView!
    
    var tableView: UITableView!
    var id: String? = ""
    var imageUrl: String? = ""
    var rank: String? = ""
    var publisher: String? = ""
    var recipeTitle: String? = ""
    var sourceUrl: String? = ""
    
    override func viewWillAppear(animated: Bool) {
        addData()
    }
    
    func addData() {
        var idCode = "&rId=" + id!
        RestApiManager.sharedInstance.getRecipeId(idCode)
        RestApiManager.sharedInstance.getDetailRequest { (json: JSON) in
            if let results = json["recipe"]["ingredients"].array{
                for entry in results {
                    self.ingredient = entry.rawString()
                    self.items.append(self.ingredient!)
                }
                self.items.flatMap{$0}
                for elements in self.items
                {
                    self.ingredients = self.ingredients! + "\n" + String(elements)
                }

                dispatch_async(dispatch_get_main_queue(), {
                   self.ingredTextView.text = self.ingredients
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         titleText.text = recipeTitle
         if let imgUrl = NSURL(string: imageUrl!) {
            if let data = NSData(contentsOfURL: imgUrl) {
                imgDetail.image = UIImage(data: data)
            }
         }
         publisherText.text = publisher
         rankText.text = rank
         srcUrlText.text = sourceUrl
        
        publisherText.userInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didTapPublisher))
        publisherText.addGestureRecognizer(tap)
        
        srcUrlText.userInteractionEnabled = true
        let tapSrc: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didTapSrcUrl))
        srcUrlText.addGestureRecognizer(tapSrc)

    }
    
    func didTapSrcUrl() {
        UIApplication.sharedApplication().openURL(NSURL(string: sourceUrl!)!)
    }
    
    
    func didTapPublisher() {
        let publisherShow = UIAlertView(title: "Publisher", message: (publisher), delegate: self, cancelButtonTitle: "Close")
        publisherShow.show()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        return cell!
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

