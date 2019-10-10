//
//  ColorWheel.swift
//  CustomControls
//
//  Created by Percy Ngan on 10/10/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import UIKit

class ColorWheel: UIView {

	//var color: UIColor = .white
	var brightness: CGFloat = 0.8 {
		// SetNeedDisplay recalls the draw function
		didSet {
			setNeedsDisplay()
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		isUserInteractionEnabled = false

		// Any subview you add to this view that is beyond the frame will not be visible
		clipsToBounds = true
		let radius = frame.width / 2.0
		layer.cornerRadius = radius
		layer.borderColor = UIColor.black.cgColor
		layer.borderWidth = 1.0
	}

	// Only override draw() if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func draw(_ rect: CGRect) {
		// Drawing code
		let colorSize: CGFloat = 3

		if let context = UIGraphicsGetCurrentContext() {

			// Use through instead of to because we want to include the maxY
			for x in stride(from: 0, through: rect.maxX, by: colorSize) {
				for y in stride(from: 0, through: rect.maxY, by: colorSize) {
					let color = self.color(for: CGPoint(x: x, y: y))
					let pixelRect = CGRect(x: x, y: y, width: colorSize, height: colorSize)

					context.setFillColor(color.cgColor)
					context.fill(pixelRect)
				}
			}
		}
	}

	// Find the offset from the center of the color wheel and give it to the getHueSaturation function
	// Difference between frame and bound: Frame is in relation to the view and bound is in relation to itself.
	func color(for location: CGPoint) -> UIColor {
		let wheelCenter = CGPoint(x: bounds.midX, y: bounds.midY)
		let dy = location.y - wheelCenter.y
		let dx = location.x - wheelCenter.x
		let offset = CGPoint(x: dx / wheelCenter.x, y: dy / wheelCenter.y)

		// Lets us store multiple values in a single constant
		let (hue, saturation) = getHueSaturation(at: offset)

		let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha:  1.0)

		return color
	}

	func getHueSaturation(at offset: CGPoint) -> (hue: CGFloat, saturation: CGFloat) {
		if offset == CGPoint.zero {
			return (hue: 0, saturation: 0)
		} else {
			// the further away from the center you are, the more saturated the color
			let saturation = sqrt(offset.x * offset.x + offset.y * offset.y)
			// the offset angle is determined to figure out what hue to use within the full spectrum
			var hue = acos(offset.x / saturation) / (2.0 * CGFloat.pi)
			if offset.y < 0 { hue = 1.0 - hue }
			return (hue: hue, saturation: saturation)
		}
	}
}


