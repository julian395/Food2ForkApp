//
//  RecipeCell.swift
//  f2fApp
//
//  Created by Julian1 on 18.09.16.
//  Copyright © 2016 juliankob.com. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var rank: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
