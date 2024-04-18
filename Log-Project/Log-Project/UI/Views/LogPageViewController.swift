//
//  LogPageViewController.swift
//  Log-Project
//
//  Created by Uğur Polat on 4.04.2024.
//

import UIKit

class LogPageViewController: UIViewController {

    @IBOutlet weak var logTableView: UITableView!
    var viewModel = LogPageViewModel()
    var logList = [Log]()
  
    @IBOutlet weak var popUpLogButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopUpButton()
        logTableView.delegate = self
        logTableView.dataSource = self
        
        viewModel.logList.bind { [weak self] value in
            DispatchQueue.main.async {
                self?.logList = value!
                print(self!.logList)
                self?.logTableView.reloadData()
                
            }
        }
    }
    
    func setupPopUpButton() {
        let popUpButtonClosure = { (action: UIAction) in
            if action.title != "All" {
                self.viewModel.getParticularLog(log_Level: action.title)
            } else {
                self.viewModel.getLogs()
            }
        }
                
        popUpLogButton.menu = UIMenu(children: [
            UIAction(title: "All", handler: popUpButtonClosure),
            UIAction(title: LogLevel.error.rawValue, handler: popUpButtonClosure),
            UIAction(title: LogLevel.warning.rawValue, handler: popUpButtonClosure),
            UIAction(title: LogLevel.info.rawValue, handler: popUpButtonClosure),
            UIAction(title: LogLevel.debug.rawValue, handler: popUpButtonClosure),
            UIAction(title: LogLevel.verbose.rawValue, handler: popUpButtonClosure)
        ])
        popUpLogButton.showsMenuAsPrimaryAction = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getLogs()
        //viewModel.filterOldLogs()
    }
    
}

extension LogPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let log = logList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell") as! LogCell
        cell.labelLogLevel.text = log.log_level
        cell.labelLogTime.text = log.log_timestamp
        cell.log = log
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { contextualAction, view, bool in
            
            let log = self.logList[indexPath.row]
            
            let alert = UIAlertController(title: "Silme Islemi", message: "\(log.log_id!) silinsin mi?", preferredStyle: .alert)
            
            let iptalAction = UIAlertAction(title: "Iptal", style: .cancel)
            
            let evetAction = UIAlertAction(title: "Sil", style: .destructive) { action in
                // kisi silme
                self.viewModel.deleteLog(log_id: log.log_id!)
            }
            
            alert.addAction(iptalAction)
            alert.addAction(evetAction)
            
            self.present(alert, animated: true)
        }
        
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
