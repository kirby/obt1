//
//  Cell.swift
//  obt1
//
//  ref: http://en.wikipedia.org/wiki/Additive_color
//
//  Additive colors: Red, Green, Blue
//
//  Created by Kirby Shabaga on 9/28/14.
//  Copyright (c) 2014 Worxly. All rights reserved.
//

import Foundation
import UIKit

let ACTION_COLORS = [
    Action.XPlus : UIColor.blueColor().CGColor,
    Action.YPlus : UIColor.redColor().CGColor,
    Action.XYPlus : UIColor.purpleColor().CGColor,
    Action.Reset : UIColor.yellowColor().CGColor,
    Action.Mutate : UIColor.greenColor().CGColor,
    Action.Blackhole : UIColor.blackColor().CGColor
]

enum Action: Int {
    
    case XPlus = 0
    case YPlus
    case XYPlus
    case Reset
    case Mutate
    case Blackhole
    
    func simpleDescription() -> String {
        switch self {
        case .XPlus:
            return "add one to x"
        case .YPlus:
            return "add one to y"
        case .XYPlus:
            return "add one to x and y"
        case .Reset:
            return "reset"
        case .Mutate:
            return "mutate"
        case .Blackhole:
            return "blackhole"
        default:
            return String(self.toRaw())
        }
    }
}

class Cell {
    
    var x : Int!
    var y : Int!
    var action : Action!
    
    var color : CGColorRef! // derived from action
    
    init (x : Int, y: Int, action : Action) {
        self.x = x
        self.y = y
        self.setAction(action)
//        self.action = action
//        
//        self.color = ACTION_COLORS[action]
    }
    
    func setAction(action : Action) {
        self.action = action
        self.color = ACTION_COLORS[action]
    }
    
}