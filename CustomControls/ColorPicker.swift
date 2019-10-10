//
//  Color.swift
//  CustomControls
//
//  Created by Percy Ngan on 10/10/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ColorPicker: UIControl {

	// These variables will let us reference the views on the screen in other parts of this color picker.
	var colorWheel: ColorWheel!
	var brightnessSlider: UISlider!
	var selectedColor: UIColor = .white

	// Used when initializing this ColorPicker in code
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupSubviews()
	}

	// Used when initializing from the storyboard
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupSubviews()
	}


	func setupSubviews() {
		backgroundColor = .clear

		let colorWheel = ColorWheel()

		colorWheel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(colorWheel)

		NSLayoutConstraint.activate([
			colorWheel.leadingAnchor.constraint(equalTo: leadingAnchor),
			colorWheel.topAnchor.constraint(equalTo: topAnchor),
			colorWheel.trailingAnchor.constraint(equalTo: trailingAnchor),
			colorWheel.heightAnchor.constraint(equalTo: widthAnchor)
			])

		self.colorWheel = colorWheel

		let brightnessSlider = UISlider()
		brightnessSlider.minimumValue = 0
		brightnessSlider.maximumValue = 1
		brightnessSlider.value = Float(colorWheel.brightness)

		brightnessSlider.translatesAutoresizingMaskIntoConstraints = false
		addSubview(brightnessSlider)

		NSLayoutConstraint.activate([
			brightnessSlider.leadingAnchor.constraint(equalTo: leadingAnchor),
			brightnessSlider.topAnchor.constraint(equalTo: colorWheel.bottomAnchor, constant: 8),
			brightnessSlider.trailingAnchor.constraint(equalTo: trailingAnchor)
			])

		brightnessSlider.addTarget(self, action: #selector(changeBrightness),for: .valueChanged)
		self.brightnessSlider = brightnessSlider
	}

	@objc func changeBrightness() {
		colorWheel.brightness = CGFloat(brightnessSlider.value)
	}

	// MARK: - Touch Tracking
	override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {

		let touchPoint = touch.location(in: self)

		if bounds.contains(touchPoint) {
			selectedColor = colorWheel.color(for: touchPoint)
			sendActions(for: .valueChanged)
		}
		sendActions(for: .touchDown)
		return true
	}


	override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {

		let touchPoint = touch.location(in: self)

		if bounds.contains(touchPoint) {
			selectedColor = colorWheel.color(for: touchPoint)
			sendActions(for: [.valueChanged, .touchDragInside])
		} else {
			sendActions(for: .touchDragOutside)
		}

		print(touchPoint)
		return true
	}

	override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
		super.endTracking(touch, with: event)

		guard let touch = touch else { return }

		let touchPoint = touch.location(in: self)

		if bounds.contains(touchPoint) {

			selectedColor = colorWheel.color(for: touchPoint)
			sendActions(for: [.valueChanged, .touchDragInside])
		} else {
			sendActions(for: .touchUpOutside)
		}
	}

	// Only gets call when an outside action gets called
	override func cancelTracking(with event: UIEvent?) {
		sendActions(for: .touchCancel)
	}

}
