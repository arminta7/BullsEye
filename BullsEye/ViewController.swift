//
//  ViewController.swift
//  BullsEye
//
//  Created by Sarah Anderson on 11/19/14.
//  Copyright (c) 2014 Sarah Anderson. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
	var currentValue: Int = 50
	var targetValue: Int = 0
	var roundScore = 0
	var score: Int = 0
	var round: Int = 0
	
	@IBOutlet weak var hitMeButton: UIButton!
	@IBOutlet weak var slider: UISlider!
	@IBOutlet weak var targetLabel: UILabel!
	@IBOutlet weak var roundLabel: UILabel!
	@IBOutlet weak var scoreLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		startNewGame()
		updateLabels()
		
		// Customize the slider
		let thumbImageNormal = UIImage(named: "SliderThumb-Normal")
		slider.setThumbImage(thumbImageNormal, forState: .Normal)
		
		let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")
		slider.setThumbImage(thumbImageHighlighted, forState: .Highlighted)
		
		let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
		
		let trackLeftImage = UIImage(named: "SliderTrackLeft")
		let trackLeftResizable = trackLeftImage?.resizableImageWithCapInsets(insets)
		
		slider.setMinimumTrackImage(trackLeftResizable, forState: .Normal)
		
		let trackRightImage = UIImage(named: "SliderTrackRight")
		let trackRightResizable = trackRightImage?.resizableImageWithCapInsets(insets)
		
		slider.setMaximumTrackImage(trackLeftResizable, forState: .Normal)
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	func startNewRound() {
		targetValue = 1 + Int(arc4random_uniform(100))
		currentValue = 50
		slider.value = Float(currentValue)
		round++
		score = score + roundScore
	}
	
	func updateLabels() {
		targetLabel.text = String(targetValue)
		roundLabel.text = String(round)
		scoreLabel.text = String(score)
	}
	
	func startNewGame() {
		round = 0
		roundScore = 0
		score = 0
		currentValue = 50
		startNewRound()
		updateLabels()
		
		let transition = CATransition()
		transition.type = kCATransitionFade
		transition.duration = 1
		transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
		view.layer.addAnimation(transition, forKey: nil)
	}
	
	func calculateScore() {
		let valueDifference = abs(currentValue - targetValue)
		
		roundScore = 100 - valueDifference
		
		if valueDifference == 0 {
			roundScore += 100
		} else if valueDifference == 1 {
			roundScore += 50
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	//Alert popup
	@IBAction func showAlert() {
		calculateScore()
		
		var title: String
		if roundScore == 200 {
			title = "Perfect!"
		} else if roundScore > 95 {
			title = "You almost had it!"
		} else if roundScore > 90 {
			title = "Pretty good!"
		} else {
			title = "Not even close..."
		}
		
		let message = "You scored \(roundScore) points"
		let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		let action = UIAlertAction(title: "OK", style: .Default, handler: { action in
			self.startNewRound()
			self.updateLabels()
			})
		alert.addAction(action)
		presentViewController(alert, animated: true, completion: nil)
		
		//startNewRound()
		//updateLabels()
	}
	
	@IBAction func sliderMoved(slider: UISlider) {
		//lroudf rounds the value to the nearest integer
		currentValue = lroundf(slider.value)
	}
	
	@IBAction func refreshButton() {
		startNewGame()
	}

}

