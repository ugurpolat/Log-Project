//
//  ViewController.swift
//  Log-Project
//
//  Created by Uğur Polat on 26.03.2024.
//

import UIKit

class MainPageViewController: UIViewController {

    @IBOutlet weak var coinTableView: UITableView!
    
    var coinList = [Coin]()
    var viewModel = MainPageViewModel()
   
    //let logEntry_2 = Log(id: UUID(), logLevel: .error, moduleName: "Test_2", logMessage: "Bu bir deneme logu")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinTableView.delegate = self
        coinTableView.dataSource = self
        
        SQLiteClient().addLog(log_timestamp: "test", log_level: "test", log_moduleName: "test", log_message: "test")
        
        viewModel.coinList.bind { [weak self] value in
            DispatchQueue.main.async {
                self?.coinList = value!
                self?.coinTableView.reloadData()

            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getCoins()
    }

    
    func goCoinDetail(coin: Coin) {
        performSegue(withIdentifier: "toCoinDetail", sender: coin)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCoinDetail" {
            if let coin = sender as? Coin {
                let targetVC = segue.destination as! DetailViewController
                targetVC.coinDetail = coin
            }
        }
    }
}


extension MainPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coin = coinList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell") as! CoinCell
        cell.labelCoinName.text = coin.name
        cell.labelCoinSymbol.text = coin.symbol
        cell.coin = coin
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        goCoinDetail(coin: coinList[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
