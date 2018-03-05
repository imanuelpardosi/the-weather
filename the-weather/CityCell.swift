//
//  CityCell.swift
//  the-weather
//
//  Created by Mobile Jakarta Team on 05/03/18.
//  Copyright © 2018 moonshadow. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet weak var city: UILabel!
    
    func configureCell(data: String) {
        self.city.text = data
    }
}
