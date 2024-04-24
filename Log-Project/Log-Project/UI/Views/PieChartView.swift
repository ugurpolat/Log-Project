//
//  PieChart.swift
//  Log-Project
//
//  Created by Uğur Polat on 23.04.2024.
//

import Foundation
import UIKit


class PieChart: UIView {
    
    struct Segment {
        var color: UIColor
        var value: CGFloat
        var name: String
    }
    
    let segments: [Segment] = [
        Segment(color: .red, value: 1, name: "BTC"),
        Segment(color: .blue, value: 1, name: "ETH"),
        Segment(color: .green, value: 9, name: "TKC")
    ]
    
    private var tooltip: UILabel?  // Tooltip label
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        var startAngle: CGFloat = -CGFloat.pi
        
        for segment in segments {
            segment.color.setFill()
            let endAngle = startAngle + .pi * (segment.value / segments.reduce(0, {$0 + $1.value}))
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.close()
            path.fill()
            startAngle = endAngle
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let touchPoint = touches.first?.location(in: self) else { return }
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let touchVector = CGVector(dx: touchPoint.x - center.x, dy: touchPoint.y - center.y)
        let touchAngle = atan2(touchVector.dy, touchVector.dx)
        
        var startAngle: CGFloat = -CGFloat.pi
        for segment in segments {
            let endAngle = startAngle + .pi * (segment.value / segments.reduce(0, {$0 + $1.value}))
            if startAngle <= touchAngle && touchAngle <= endAngle {
                showTooltip(for: segment, at: touchPoint, startAngle: startAngle, endAngle: endAngle)
                break
            }
            startAngle = endAngle
        }
    }
    
    private func showTooltip(for segment: Segment, at point: CGPoint,startAngle: CGFloat, endAngle: CGFloat) {
        
        tooltip?.removeFromSuperview()
        
        // Calculate the middle angle of the segment
        let middleAngle = (startAngle + endAngle) / 2.0
        
        // Calculate the radius for the tooltip position (slightly inside the outer edge)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 20  // Reduce radius to place tooltip inside the pie
        
        // Calculate x and y coordinates using the middle angle
        let tooltipX = center.x + radius * cos(middleAngle)
        let tooltipY = center.y + radius * sin(middleAngle)
        
        // Create and configure tooltip label
        tooltip = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: 30))
        tooltip!.center = CGPoint(x: tooltipX, y: tooltipY)  // Position tooltip at calculated center
        tooltip!.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        tooltip!.textAlignment = .center
        tooltip!.text = "\(segment.name): \(segment.value)"
        tooltip!.layer.cornerRadius = 5
        tooltip!.clipsToBounds = true
        addSubview(tooltip!)
        
        // Animate tooltip appearance
        tooltip!.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.tooltip!.alpha = 1
        }
    }
}
class PieChart_2: UIView {
    
    struct Segment {
        var color: UIColor
        var value: CGFloat
        var name: String
    }
    
    let segments: [Segment] = [
        Segment(color: .red, value: 1, name: "BTC"),
        Segment(color: .blue, value: 1, name: "ETH"),
        
    ]
    
    private var tooltip: UILabel?  // Tooltip label
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        var startAngle: CGFloat = -CGFloat.pi
        
        for segment in segments {
            segment.color.setFill()
            let endAngle = startAngle + .pi * (segment.value / segments.reduce(0, {$0 + $1.value}))
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.close()
            path.fill()
            startAngle = endAngle
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let touchPoint = touches.first?.location(in: self) else { return }
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let touchVector = CGVector(dx: touchPoint.x - center.x, dy: touchPoint.y - center.y)
        let touchAngle = atan2(touchVector.dy, touchVector.dx)
        
        var startAngle: CGFloat = -CGFloat.pi
        for segment in segments {
            let endAngle = startAngle + .pi * (segment.value / segments.reduce(0, {$0 + $1.value}))
            if startAngle <= touchAngle && touchAngle <= endAngle {
                showTooltip(for: segment, at: touchPoint, startAngle: startAngle, endAngle: endAngle)
                break
            }
            startAngle = endAngle
        }
    }
    
    private func showTooltip(for segment: Segment, at point: CGPoint,startAngle: CGFloat, endAngle: CGFloat) {
        
        tooltip?.removeFromSuperview()
        
        // Calculate the middle angle of the segment
        let middleAngle = (startAngle + endAngle) / 2.0
        
        // Calculate the radius for the tooltip position (slightly inside the outer edge)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 20  // Reduce radius to place tooltip inside the pie
        
        // Calculate x and y coordinates using the middle angle
        let tooltipX = center.x + radius * cos(middleAngle)
        let tooltipY = center.y + radius * sin(middleAngle)
        
        // Create and configure tooltip label
        tooltip = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: 30))
        tooltip!.center = CGPoint(x: tooltipX, y: tooltipY)  // Position tooltip at calculated center
        tooltip!.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        tooltip!.textAlignment = .center
        tooltip!.text = "\(segment.name): \(segment.value)"
        tooltip!.layer.cornerRadius = 5
        tooltip!.clipsToBounds = true
        addSubview(tooltip!)
        
        // Animate tooltip appearance
        tooltip!.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.tooltip!.alpha = 1
        }
    }
}
