//
//  SliderCollectionViewCell.swift
//  Log-Project
//
//  Created by Uğur Polat on 23.04.2024.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sliderView: UIView!
    var pieChart: PieChart?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupPieChart()
    }
    
    private func setupPieChart() {
        /*
         // Initialize and set up the PieChart
         pieChart = PieChart(frame: sliderView.bounds) // Adjust the frame according to your needs
         pieChart?.autoresizingMask = [.flexibleWidth, .flexibleHeight] // Or use Auto Layout constraints
         pieChart?.backgroundColor = .gray
         if let chart = pieChart {
         sliderView.addSubview(chart)
         }
         }
         */
        pieChart = PieChart()
        if let chart = pieChart {
            chart.translatesAutoresizingMaskIntoConstraints = false // Disable autoresizing mask
            sliderView.addSubview(chart)
            
            // Set Auto Layout constraints to center the PieChart in sliderView
            NSLayoutConstraint.activate([
                chart.centerXAnchor.constraint(equalTo: sliderView.centerXAnchor),
                chart.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor, constant: 90),
                chart.widthAnchor.constraint(equalTo: sliderView.widthAnchor, multiplier: 0.9), // PieChart width is 80% of sliderView width
                chart.heightAnchor.constraint(equalTo: chart.widthAnchor) // Keep the PieChart aspect ratio 1:1
            ])
            
            chart.backgroundColor = .white // Set the background color to visually verify it's centered
        }
    }
}


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

/*
 override func prepareForReuse() {
 super.prepareForReuse()
 // Clean up or reset any configurations like resetting the pie chart or removing subviews
 pieChart?.removeFromSuperview()
 pieChart = nil
 }
 */

/*
 //   override func viewDidLoad() {
 //      super.viewDidLoad()
 
 //        let pieChartView = PieChartView()
 //        pieChartView.frame = CGRect(x: (sliderView.frame.size.width - 200) / 2,
 //                                    y: (sliderView.frame.size.height - 200) / 2, width: 200,
 //                                    height: 200)
 //        pieChartView.backgroundColor = .white
 //        sliderView.addSubview(pieChartView)
 //    }
 */



/*
 class PieChartView: UIView {
 
 struct Segment {
 var color: UIColor
 var value: CGFloat
 var name: String
 }
 
 // Data to display
 let segments: [Segment] = [
 Segment(color: .red, value: 1,name: "Red Segment"),
 Segment(color: .blue, value: 1, name: "Blue Segment"),
 Segment(color: .black, value: 9, name: "Black Segment")
 ]
 
 private var tooltip: UILabel?  // Tooltip label
 
 override func draw(_ rect: CGRect) {
 // Start angle is at the top left (West, -90 degrees rotated to top for half-pie)
 var startAngle: CGFloat = -CGFloat.pi
 
 // Define the total value as the sum of all segment values
 let totalValue = segments.reduce(0) { $0 + $1.value }
 // Only cover half of the circle
 let halfTotalValue = totalValue
 
 // Get the center point of the view
 let center = CGPoint(x: rect.midX, y: rect.midY)
 // Set radius as half the smallest side of the view
 let radius = min(rect.width, rect.height) / 2
 
 // Calculate the total visible proportion of segments (scale to half)
 var cumulativeValue: CGFloat = 0
 for segment in segments {
 // Ensure we do not draw beyond half the pie
 if cumulativeValue >= halfTotalValue {
 break
 }
 
 // Set the fill color
 segment.color.setFill()
 
 // Calculate the end angle for this segment
 let segmentValueContribution = min(segment.value, halfTotalValue - cumulativeValue)
 let endAngle = startAngle + .pi * (segmentValueContribution / totalValue)
 
 // Create a path for the segment
 let path = UIBezierPath()
 path.move(to: center)
 path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
 path.close()
 
 // Draw the segment
 path.fill()
 
 // Increment the start angle for the next segment
 startAngle = endAngle
 cumulativeValue += segment.value
 }
 }
 
 
 }
 */



