//
//  FeedingLogCell.swift
//  Feeder
//
//  Created by Jason Andrae on 3/30/16.
//  Copyright © 2016 Jason Andrae. All rights reserved.
//

import UIKit

class FeedingLogCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var user: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
