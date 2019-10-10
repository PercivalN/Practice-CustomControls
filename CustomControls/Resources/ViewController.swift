//
//  ViewController.swift
//  CustomControls
//
//  Created by Percy Ngan on 10/10/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}


	@IBAction func changeBackground(_ sender: ColorPicker) {
		view.backgroundColor = sender.selectedColor
	}
}

