//
//  Config.swift
//  the-weather
//
//  Created by Mobile Jakarta Team on 25/03/18.
//  Copyright © 2018 moonshadow. All rights reserved.
//

import UIKit

enum FontType : String {
    case HindMedium        = "Hind-Medium"
}

struct Font {
    static func setCustomFont(fontType: FontType, fontSize: CGFloat) -> UIFont {
        print("\(fontType.rawValue)")
        return UIFont(name: "\(fontType.rawValue)", size: fontSize)!
    }
}

