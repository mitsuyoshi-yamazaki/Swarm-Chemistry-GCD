//
//  ViewController.swift
//  SwarmChemistryGCD
//
//  Created by Simon Gladman on 21/08/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    
    private var selectedGenomeIndex : Int = 0
    
    private let genomes : Array<SwarmGenome> = [Constants.genomeOne, Constants.genomeTwo, Constants.genomeThree, Constants.genomeFour]
    
    private var swarmMembers = [SwarmMember]()
    
    @IBOutlet private weak var renderView: SwarmRenderView!
    @IBOutlet private var propertyButtonBar: UISegmentedControl!
    @IBOutlet private var propertyValueSlider: UISlider!
    @IBOutlet private var genomeSelectionButtonBar: UISegmentedControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        setupSwarm()
    }
    
    private func setupSwarm() {
        SwarmMember.width = Double(renderView.frame.width)
        SwarmMember.height = Double(renderView.frame.height)
        
        let width = Int(SwarmMember.width)
        let height = Int(SwarmMember.height)
        
        for i in 0 ..< Constants.COUNT
        {
            let genome : SwarmGenome = genomes[i % 4]
            var swarmMember : SwarmMember = SwarmMember(genome: genome)
            
            swarmMember.x = Double(Int(arc4random()) % width)
            swarmMember.y = Double(Int(arc4random()) % height)
            
            swarmMembers.append(swarmMember)
        }
        
        setPropertSliderMinMax()
        setPropertySliderValue()
        
        dispatchSolve()    // TODO: stop when disappear
    }
    
    private func dispatchSolve()
    {
        DispatchQueue.global().async {
            for _ in 0..<5  // TODO: make it customizable
            {
                self.swarmMembers = solveSwarmChemistry(self.swarmMembers)
            }
            self.swarmMembers = solveSwarmChemistry(self.swarmMembers)
            self.renderView.swarmMembers = self.swarmMembers
            DispatchQueue.main.async {
                self.renderView.setNeedsDisplay()
                self.dispatchSolve()
            }
        }
    }
    
    private func setGenomeValue()
    {
        genomes[selectedGenomeIndex].setPropertyValueByIndex(propertyValueSlider.value, propertyIndex: propertyButtonBar.selectedSegmentIndex)
    }
    
    private func setPropertySliderValue()
    {
        propertyValueSlider.value = genomes[selectedGenomeIndex].getPropertyValueByIndex(propertyButtonBar.selectedSegmentIndex)
    }
    
    private func setPropertSliderMinMax()
    {
        propertyValueSlider.minimumValue = SwarmGenome.getMinMaxForProperty(propertyButtonBar.selectedSegmentIndex).min
        
        propertyValueSlider.maximumValue = SwarmGenome.getMinMaxForProperty(propertyButtonBar.selectedSegmentIndex).max
    }
    
    // event handlers
    
    @IBAction func genomeSelectionButtonBarChangeHandler(_ sender: AnyObject)
    {
        selectedGenomeIndex = genomeSelectionButtonBar.selectedSegmentIndex
        setPropertySliderValue()
    }
    
    @IBAction func propertyButtonBarChangeHandler(_ sender: AnyObject)
    {
        setPropertSliderMinMax()
        setPropertySliderValue()
    }
    
    @IBAction func propertySliderChangeHandler(_ sender: AnyObject)
    {
        setGenomeValue()
    }
}

