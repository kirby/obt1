//
//  ViewController.swift
//  obt1
//
//  Created by Kirby Shabaga on 9/27/14.
//  Copyright (c) 2014 Worxly. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITabBarDelegate, WorldViewDelegate {

    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var worldView: WorldView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cellCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.delegate = self
        self.worldView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UITabBarDelegate
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        
        if let item = tabBar.selectedItem {
            println(item.tag)
            if (item.tag == 0) {
                self.worldView.createRandomWorld()
            }
        }
        
    }
    
    // MARK: WorldViewDelegate
    
    func currentLocation(location : String) {
        self.locationLabel.text = location
    }
    
    func cellCount(count: String) {
        self.cellCountLabel.text = "There are \(count) cells"
    }

}

