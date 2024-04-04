//
//  LogPageViewController.swift
//  Log-Project
//
//  Created by Uğur Polat on 4.04.2024.
//

import UIKit

class LogPageViewController: UIViewController {

    var viewModel = LogPageViewModel()
    var logList = [Log]()
    
    @IBOutlet weak var labelLog: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.logList.bind { [weak self] value in
            DispatchQueue.main.async {
                self?.logList = value!
                self!.labelLog.text = self!.logList.first?.log_level
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getLogs()
    }
    
    
}
