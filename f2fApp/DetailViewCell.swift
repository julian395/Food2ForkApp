//
//  DetailViewCell.swift
//  f2fApp
//
//  Created by Julian1 on 19.09.16.
//  Copyright © 2016 juliankob.com. All rights reserved.
//

import UIKit

class DetailViewCell: UITableViewCell {

    
    
    @IBOutlet weak var ingredientsText: UILabel!
    @IBOutlet weak var imgDetail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
