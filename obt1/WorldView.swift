//
//  WorldView.swift
//  obt1
//
//  Created by Kirby Shabaga on 9/28/14.
//  Copyright (c) 2014 Worxly. All rights reserved.
//

import UIKit

protocol WorldViewDelegate {
    func score(score : String)
    func gameOver(score : String)
    func movesLeft(touchesLeft : String)
}

class WorldView: UIView {
    
    var timeColor = UIColor(white: 1.0, alpha: 0.25)
    
    var soundManager = SoundManager()
    
    var worldSizeX = 1
    var worldSizeY = 2
    
    var numberOfCells = 2
    var currX = 0
    var currY = 0
    
    var generation = 0
    var numberOfTouches = 0
    
    var nextCellSplitDate : NSDate!
    
    var delegate : WorldViewDelegate!
    
    var cells = Dictionary<String, Cell>()       // index (x,y) -> cell
    
    var alertController : UIAlertController!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.setColorBasedOnTimeOfDay()
        self.backgroundColor = self.timeColor

        self.createRandomWorld()
    }

    override func drawRect(rect: CGRect) {
        if cells.isEmpty { return }
        
        var context = UIGraphicsGetCurrentContext()
        
        for cell in self.cells.values {
            self.drawBackgroundOnContext(context, cell: cell)
        }
    }
    
    func createRandomWorld() {
        
        self.worldSizeX = 1
        self.worldSizeY = 2
        
        self.numberOfCells = 2
        self.numberOfTouches = 0
        
        self.cells = Dictionary<String, Cell>()
        
        for x in 0..<self.worldSizeX {
            for y in 0..<self.worldSizeY {
                self.addRandomCell(x, y: y)
            }
        }
        
        if (self.delegate != nil) {
            self.delegate.movesLeft("10")
            self.delegate.score("\(self.getScore())")
        }
        
        self.setNeedsDisplay()
    }
    
    func addRandomCell(x : Int, y: Int) {
        var point = CGPoint(x: x, y: y)
        var key = "\(x),\(y)"

        self.cells[key] = self.generateRandomCell(point)
    }
    
    func generateRandomCell(point : CGPoint) -> Cell {
        var action = Int(arc4random_uniform(UInt32(ACTION_COLORS.count)))
        
        var i : Int = 0
        var a = Action(rawValue: action) == Action.Blackhole
        
        while (Action(rawValue: action) == Action.Blackhole) {
            action = Int(arc4random_uniform(UInt32(ACTION_COLORS.count)))
        }
        return Cell(
            x: Int(point.x),
            y: Int(point.y),
            action: Action(rawValue: action)!)
    }
    
    func drawBackgroundOnContext(context: CGContext, cell : Cell) {
        
        let h = Int(self.frame.height)
        let w = Int(self.frame.width)

        let xd = CGFloat(w / self.worldSizeX)
        let yd = CGFloat(h / self.worldSizeY)
        
        var xf = CGFloat(cell.x) * xd
        var yf = CGFloat(cell.y) * yd
        
        // Cell
        
        CGContextSetFillColorWithColor(context, cell.color)
        CGContextBeginPath(context)
        
        CGContextMoveToPoint(context, xf, yf)
        
        CGContextAddLineToPoint(context, (xf + xd), yf)
        CGContextAddLineToPoint(context, (xf + xd), (yf + yd))
        CGContextAddLineToPoint(context, xf, (yf + yd))
        CGContextAddLineToPoint(context, xf, yf)
        
        CGContextFillPath(context)
        
        // Border
        
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextSetLineWidth(context, 2.0)

        CGContextBeginPath(context)

        CGContextMoveToPoint(context, xf, yf)
        
        CGContextAddLineToPoint(context, (xf + xd), yf)
        CGContextAddLineToPoint(context, (xf + xd), (yf + yd))
        CGContextAddLineToPoint(context, xf, (yf + yd))
        CGContextAddLineToPoint(context, xf, yf)
        
        CGContextStrokePath(context)
    }
    
    func setColorBasedOnTimeOfDay() {
        var date = NSDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("%HH")
        let hour = NSString(string: dateFormatter.stringFromDate(date)).floatValue
        let shade = CGFloat(hour / 24.0)
        self.timeColor = UIColor(white: shade, alpha: 1.0)
    }
    
    func performAction(point : CGPoint) {
        
        self.numberOfTouches++
        
        self.delegate.movesLeft("\(10 - self.numberOfTouches)")
        
        if self.numberOfTouches == 10 {
            self.delegate.gameOver("\(self.getScore())")
        }
        
        let h = Int(self.frame.height)
        let w = Int(self.frame.width)
        
        let xd = CGFloat(w / self.worldSizeX)
        let yd = CGFloat(h / self.worldSizeY)
        
        self.currX = Int(floor(point.x / xd))
        self.currY = Int(floor(point.y / yd))
        
        var selectedCell = cells["\(self.currX),\(self.currY)"]
        
        switch selectedCell!.action! {
        case .XPlus:
            for y in 0..<self.worldSizeY {
                self.addRandomCell(self.worldSizeX, y: y)
            }
            self.worldSizeX++
    
        case .YPlus:
            for x in 0..<self.worldSizeX {
                self.addRandomCell(x, y: self.worldSizeY)
            }
            self.worldSizeY++
            
        case .XYPlus:
            for y in 0..<self.worldSizeY {
                self.addRandomCell(self.worldSizeX, y: y)
            }
            self.worldSizeX++
            for x in 0..<self.worldSizeX {
                self.addRandomCell(x, y: self.worldSizeY)
            }
            self.worldSizeY++
            
        case .Reset:
            self.worldSizeX = 1
            self.worldSizeY = 2
            for x in 0..<self.worldSizeX {
                for y in 0..<self.worldSizeY {
                    self.addRandomCell(x, y: y)
                }
            }
            
        case .Mutate:
            // mutate neighbouring cells
            var xMin = self.currX == 0 ? 0 : self.currX - 1
            var xMax = self.currX == self.worldSizeX - 1 ? self.currX : self.currX + 1
            
            var yMin = self.currY == 0 ? 0 : self.currY - 1
            var yMax = self.currY == self.worldSizeY - 1 ? self.currY : self.currY + 1
            
            for x in xMin...xMax {
                for y in yMin...yMax {
                    var key = "\(x),\(y)"
                    if self.cells[key]!.action == Action.Mutate {
                        self.cells[key]!.setAction(Action.Blackhole)
                    } else {
                        self.cells[key]!.setAction(Action.Mutate)
                    }
                }
            }
            
        case .Blackhole:
            println("Todo - shrink world")
            
        }
        
        self.delegate.score("\(self.getScore())")
    }
    
    func getScore() -> Int {
        var score = 0
        
        for x in 0..<self.worldSizeX {
            for y in 0..<self.worldSizeY {
                score += self.cells["\(x),\(y)"]!.points
            }
        }
        
        return score
    }

    // MARK: - UIResponder
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if let touch = touches.anyObject() as? UITouch {
            soundManager.playRandomKeylickSound()
            var point = touch.locationInView(self)
            self.performAction(point)
            self.setNeedsDisplay()
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        
    }
}
