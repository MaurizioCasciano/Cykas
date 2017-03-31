//
//  File.swift
//  Cykas
//
//  Created by Domenico Antonio Tropeano on 29/03/2017.
//  Copyright © 2017 Maurizio Casciano. All rights reserved.
//

import UIKit


class RenderView:UIView {
    
    var pointsToDraw:[Int] = [] {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.clear(self.bounds)
        context!.setLineWidth(10.0)
        
        
        if pointsToDraw.count > 4 {
            
            context?.move(to: CGPoint(x: CGFloat(pointsToDraw[0]), y: CGFloat(pointsToDraw[1])))
            
            for i in 2..<pointsToDraw.count {
                if i % 2 == 0 {
                    context?.addLine(to: CGPoint(x: CGFloat(pointsToDraw[i]), y: CGFloat(pointsToDraw[i + 1])))
                }
            }
        }
        
        // Draw
        context!.strokePath();
    }
}
