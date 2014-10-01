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
    @IBOutlet weak var cellCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var movesLeftLabel: UILabel!
    
    var alertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.delegate = self
        self.worldView.delegate = self
        
        self.alertController = UIAlertController(title: "Game Over", message: "Your score was: ", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.worldView.createRandomWorld()
        }
        self.alertController.addAction(okAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UITabBarDelegate
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        
        if let item = tabBar.selectedItem {
            if (item.tag == 0) {
                self.worldView.createRandomWorld()
            }
        }
        
    }
    
    // MARK: WorldViewDelegate
    
    func score(score: String) {
        self.scoreLabel.text = score
    }
    
    func gameOver(score: String) {
        self.scoreLabel.text = score
        self.alertController.message = "Your score was \(score)!"
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func movesLeft(touchesLeft: String) {
        self.movesLeftLabel.text = "\(touchesLeft) Moves Left"
    }

}

