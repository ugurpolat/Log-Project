//
//  TransactionViewController.swift
//  Log-Project
//
//  Created by Uğur Polat on 24.04.2024.
//

import UIKit

class TransactionViewController: UIViewController {
    
    @IBOutlet weak var transactionTableView: UITableView!
    var transactionSection = ["Alis","Satis"]
    var transactionData:[Transaction]?
    var alisTransactions: [Transaction] = []
    var satisTransactions: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alisTransactions = transactionData?.filter { $0.type == "Alis" } ?? []
        satisTransactions = transactionData?.filter { $0.type == "Satis" } ?? []
        
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        
        DispatchQueue.main.async {
            self.transactionTableView.reloadData()
        }
    }
}

extension TransactionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return alisTransactions.count
        } else {
            return satisTransactions.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return transactionSection[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        
        let transaction = (indexPath.section == 0 ? alisTransactions : satisTransactions)[indexPath.row]
        cell.configure(with: transaction)
        
        return cell
    }
    
    
}
