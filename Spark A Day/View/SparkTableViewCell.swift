//
//  SparkTableViewCell.swift
//  Spark A Day
//
//  Created by Malcom Jones on 3/1/20.
//  Copyright © 2020 Malcom Jones. All rights reserved.
//

import UIKit

class SparkTableViewCell: UITableViewCell {

    //MARK: UI Properties
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
