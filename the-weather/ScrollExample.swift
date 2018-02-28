//
//  ScrollExample.swift
//  the-weather
//
//  Created by Mobile Jakarta Team on 28/02/18.
//  Copyright © 2018 moonshadow. All rights reserved.
//

import UIKit

class ScrollExample: UIViewController, UIScrollViewDelegate {
    
    var imageView1: UIImageView!
    var imageView2: UIImageView!
    
    var scrollView1: UIScrollView!
    var scrollView2: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView1 = UIImageView(image: UIImage(named: "Rainy"))
        imageView2 = UIImageView(image: UIImage(named: "Windy"))
        
        scrollView1 = UIScrollView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 200)))
        scrollView1.contentSize = CGSize(width: self.scrollView1.frame.width * 4, height: self.scrollView1.frame.height)
        scrollView1.addSubview(imageView1)
        view.addSubview(scrollView1)
        
        scrollView2 = UIScrollView(frame: CGRect(origin: CGPoint(x: 0, y: 210), size: CGSize(width: 200, height: 200)))
        scrollView2.contentSize = CGSize(width: self.scrollView2.frame.width * 4, height: self.scrollView2.frame.height)
        scrollView2.addSubview(imageView2)
        view.addSubview(scrollView2)
        
        scrollView2.delegate = self
        scrollView1.delegate = self
    }
    
    func scrollViewDidScroll(_ scrolled: UIScrollView) {
        // both scrollViews call this when scrolled, so determine which was scrolled before adjusting
        if scrolled === scrollView1 {
            scrollView1.contentOffset.x = scrolled.contentOffset.x + 100
            print("1")
        } else if scrolled === scrollView2 {
            scrollView1.contentOffset.x = scrolled.contentOffset.x - 100
            print("2")
        }
    }
    
}
