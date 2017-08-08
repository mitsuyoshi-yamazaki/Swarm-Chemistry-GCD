//
//  RenderView.swift
//  SwarmChemistryGCD
//
//  Created by Yamazaki Mitsuyoshi on 2017/08/06.
//  Copyright © 2017 Simon Gladman. All rights reserved.
//

import UIKit

class SwarmRenderView: UIView {
    
    var swarmMembers = [SwarmMember]()
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()!
        let size = 2.0
        
        for swarmMember in swarmMembers {
            swarmMember.genome.color.setFill()
            context.fillEllipse(in: CGRect(x: swarmMember.x, y: swarmMember.y, width: size, height: size))
        }
    }
}
