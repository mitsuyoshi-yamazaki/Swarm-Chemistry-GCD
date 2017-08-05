//
//  RenderViewController.swift
//  SwarmChemistryGCD
//
//  Created by Yamazaki Mitsuyoshi on 2017/08/06.
//  Copyright © 2017 Simon Gladman. All rights reserved.
//

import UIKit

class RenderViewController: UIViewController {

    @IBOutlet private weak var renderView: SwarmRenderView!

    override var shouldAutorotate: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
