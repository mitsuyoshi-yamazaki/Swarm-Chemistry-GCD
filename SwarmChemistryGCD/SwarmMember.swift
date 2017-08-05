//
//  SwarmChemistryMember.swift
//  SwarmChemistryGCD
//
//  Created by Simon Gladman on 21/08/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Foundation

struct SwarmMember
{
    static var width: Double = 100.0
    static var height: Double = 100.0
    
    var genome : SwarmGenome
    
    var x : Double = 0.0
    var y : Double = 0.0
    
    var dx : Double = 0.0
    var dy : Double = 0.0
    
    var dx2 : Double = 0.0
    var dy2 : Double = 0.0

    init(genome : SwarmGenome)
    {
        self.genome = genome
    }

    mutating func move()
    {
        dx = dx2
        dy = dy2
        
        x = x + dx
        y = y + dy
        
        if y < 0
        {
            y = SwarmMember.height
        }
        else if y > SwarmMember.height
        {
            y = 0
        }
        
        if x < 0
        {
            x = SwarmMember.width
        }
        else if x > SwarmMember.width
        {
            x =  0
        }
    }
    
    mutating func accelerate(ax : Double, ay : Double, maxMove : Double)
    {
        dx2 += ax
        dy2 += ay
        
        let d : Double = hypot(dx2, dy2)
        
        if d > maxMove * maxMove
        {
            let normalizationFactor : Double = maxMove / d
            dx2 *= normalizationFactor
            dy2 *= normalizationFactor
        }
    }

}
