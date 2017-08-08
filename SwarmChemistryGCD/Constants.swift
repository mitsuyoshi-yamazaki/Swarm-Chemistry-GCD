//
//  Constants.swift
//  SwarmChemistryGCD
//
//  Created by Simon Gladman on 21/08/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//


import Foundation
import UIKit

struct Constants
{
    static let genomeOne = SwarmGenome(color: UIColor.cyan, radius: 25, c1_cohesion: 0.25, c2_alignment: 0.25, c3_seperation: 75, c4_steering: 0.35, c5_paceKeeping: 0.75)
    static let genomeTwo = SwarmGenome(color: UIColor.red, radius: 50, c1_cohesion: 0.165, c2_alignment: 1, c3_seperation: 35, c4_steering: 0.25, c5_paceKeeping: 0.5)
    static let genomeThree = SwarmGenome(color: UIColor.blue, radius: 15, c1_cohesion: 1.05, c2_alignment: 0.8, c3_seperation: 25, c4_steering: 0.333, c5_paceKeeping: 0.25)
    static let genomeFour = SwarmGenome(color: UIColor.yellow, radius: 20, c1_cohesion: 0.1150, c2_alignment: 0.8, c3_seperation: 50, c4_steering: 0.25, c5_paceKeeping: 0.675)
    
    static let COUNT = 800
}
