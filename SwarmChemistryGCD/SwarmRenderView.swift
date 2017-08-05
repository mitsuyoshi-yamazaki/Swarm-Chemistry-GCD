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
    
    for swarmMember in swarmMembers {
      swarmMember.genome.color.setFill()
      context.fill(CGRect(x: swarmMember.x, y: swarmMember.y, width: 1.0, height: 1.0))
    }
  }
}
