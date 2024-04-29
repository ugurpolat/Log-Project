//
//  SliderCollectionViewCell.swift
//  Log-Project
//
//  Created by Uğur Polat on 23.04.2024.
//

import UIKit
extension Notification.Name {
    static let didChangeTheme = Notification.Name("didChangeTheme")
}

class SliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sliderView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNotifications()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNotifications()
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updatePieChartAppearance), name: .didChangeTheme, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var pieChart: UIView? {
        willSet {
            pieChart?.removeFromSuperview()
        }
        didSet {
            setupPieChart()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setupPieChart() {
        guard let chart = pieChart else { return }
        
        chart.translatesAutoresizingMaskIntoConstraints = false
        sliderView.addSubview(chart)
        
        NSLayoutConstraint.activate([
            chart.centerXAnchor.constraint(equalTo: sliderView.centerXAnchor),
            chart.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor, constant: 90),
            chart.widthAnchor.constraint(equalTo: sliderView.widthAnchor, multiplier: 0.9),
            chart.heightAnchor.constraint(equalTo: chart.widthAnchor)
        ])
        
        updatePieChartAppearance()

    }
    @objc private func updatePieChartAppearance() {
        pieChart?.backgroundColor = UserDefaults.standard.bool(forKey: "isDarkMode") ? .black : .white
    }
}
