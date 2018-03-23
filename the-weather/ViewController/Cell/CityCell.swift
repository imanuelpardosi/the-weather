//
//  CityCell.swift
//  the-weather
//
//  Created by Mobile Jakarta Team on 05/03/18.
//  Copyright © 2018 moonshadow. All rights reserved.
//

import UIKit

class CityCell: UICollectionViewCell {

    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    
    func configureCell(data: String) {
        self.city.text = data
    }
}
