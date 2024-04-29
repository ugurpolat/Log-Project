//
//  SettingsViewController.swift
//  Log-Project
//
//  Created by Uğur Polat on 22.04.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var lblSettings: UILabel!
    
    @IBOutlet weak var switchDarkMode: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        switchDarkMode.isOn = UserDefaults.standard.bool(forKey: "isDarkMode")
        NotificationCenter.default.addObserver(self, selector: #selector(updateForDarkMode), name: NSNotification.Name("didChangeTheme"), object: nil)
        // Do any additional setup after loading the view.
        let line = UIView()
        view.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.topAnchor.constraint(equalTo: lblSettings.bottomAnchor, constant: 16).isActive = true
        
        line.backgroundColor = .gray
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func updateForDarkMode() {
        // Code to update the UI components according to the new theme
        self.view.backgroundColor = UserDefaults.standard.bool(forKey: "isDarkMode") ? .darkGray : .white
    }
    
    @IBAction func changeToDarkMode(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "isDarkMode")
        UserDefaults.standard.synchronize()
        
        NotificationCenter.default.post(name: NSNotification.Name("didChangeTheme"), object: nil)
        updateInterfaceStyle()
    }
    
    private func updateInterfaceStyle(){
        let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkMode")
        
        if #available(iOS 13.0, *) {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
            }
        } else {
            print("iOS version is below 13, no action taken.")
        }
    }
    
    
    
}
