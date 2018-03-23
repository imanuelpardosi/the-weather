//
//  RootVC.swift
//  the-weather
//
//  Created by Mobile Jakarta Team on 22/03/18.
//  Copyright © 2018 moonshadow. All rights reserved.
//

import AKSideMenu

class RootVC: AKSideMenu, AKSideMenuDelegate {
    let weatherVC: WeatherVC = WeatherVC()
    let sideMenuVC: SideMenuVC = SideMenuVC()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.menuPreferredStatusBarStyle = .default
        self.contentViewShadowColor = .black
        self.contentViewShadowOffset = CGSize(width: 0, height: 0)
        self.contentViewShadowOpacity = 0.6
        self.contentViewShadowRadius = 12
        self.contentViewShadowEnabled = true
        
        self.contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "contentVC")
        self.leftMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "sideMenuVC")
        
        self.weatherVC.weatherDelegate = sideMenuVC
        self.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - <AKSideMenuDelegate>
    public func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {
        print("willShowMenuViewController")
        
        self.weatherVC.weatherDelegate?.doSomething()
        self.weatherVC.weatherDelegate?.sendTemperature(temp: ["21", "21", "21", "21"])
    }
    
    public func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController) {
        print("didShowMenuViewController")
    }
    
    public func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController) {
        print("willHideMenuViewController")
    }
    
    public func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController) {
        print("didHideMenuViewController")
    }
}
