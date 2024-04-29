//
//  ViewController.swift
//  Log-Project
//
//  Created by Uğur Polat on 26.03.2024.
//

import UIKit

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var pieChartHeight: NSLayoutConstraint!
    @IBOutlet weak var coinSegment: UISegmentedControl!
    @IBOutlet weak var coinTableView: UITableView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    
    @IBOutlet weak var coinSearchBar: UISearchBar!
    var pie_1 = PieChart()
    //var pie_2 = PieChart_2()
    var coinList = [Coin]()
    var pieCharts = [UIView]()
    var viewModel = MainPageViewModel()
    var transactionSection = ["Alis","Satis"]
    var transactionData:[Transaction]?
    var alisTransactions: [Transaction] = []
    var satisTransactions: [Transaction] = []
    var searchCoinResult = [Coin]()
    var searchTransactionData = [Transaction]()
    var isSearching = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTransactionFilter()
        setupCollectionView()
        pieCharts.append(pie_1)
        setView()
        
        viewModel.coinList.bind { [weak self] value in
            DispatchQueue.main.async {
                self?.coinList = value!
                self?.coinTableView.reloadData()
                self?.sliderCollectionView.reloadData()
                
            }
        }
    }
    
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0  {
            pieChartHeight.constant = 180
            getMyAssets()
        } else {
            pieChartHeight.constant = 0
            getMyTransactions()
        }
        filterDataBasedOnSearchAndSegment(searchText: coinSearchBar.text ?? "")
        
    }
    
    func setView() {
        coinTableView.delegate = self
        coinTableView.dataSource = self
        coinSearchBar.delegate = self
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
    }
    
    private func fetchTransactionFilter () {
        
        if coinSegment.selectedSegmentIndex == 1 {
            if isSearching {
                alisTransactions = searchTransactionData.filter { $0.type == "Alis" }
                satisTransactions = searchTransactionData.filter { $0.type == "Satis" }
            } else {
                alisTransactions = transactionData?.filter { $0.type == "Alis" } ?? []
                satisTransactions = transactionData?.filter { $0.type == "Satis" } ?? []
            }
            
        }
        
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: sliderCollectionView.frame.size.width, height: sliderCollectionView.frame.size.height)
        layout.minimumLineSpacing = 0
        
        sliderCollectionView.collectionViewLayout = layout
        sliderCollectionView.isPagingEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getCoins()
    }
    
    func goCoinDetail(coin: Coin) {
        performSegue(withIdentifier: "toCoinDetail", sender: coin)
    }
    func goMyTransactions(transactions: [Transaction]){
        performSegue(withIdentifier: "toMyTransactions", sender: transactions)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCoinDetail" {
            if let coin = sender as? Coin {
                let targetVC = segue.destination as! DetailViewController
                targetVC.coinDetail = coin
            }
        }else if segue.identifier == "toMyTransactions" {
            if let transactions = sender as? [Transaction] {
                let targetVC = segue.destination as! TransactionViewController
                targetVC.transactionData = transactions
            }
        }
    }
    
    func getMyAssets() {
        let firstIndexPath = IndexPath(item: 0, section: 0)
        sliderCollectionView.scrollToItem(at: firstIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    func getMyTransactions() {
        let test = loadTransactions()
        transactionData = test
        fetchTransactionFilter()
    }
    func saveTransaction(_ transactionData: Data) {
        let defaults = UserDefaults.standard
        var transactions = defaults.object(forKey: "transactionList") as? [Data] ?? [Data]()
        transactions.append(transactionData)
        defaults.set(transactions, forKey: "transactionList")
        
    }
    func loadTransactions() -> [Transaction]? {
        let defaults = UserDefaults.standard
        guard let encodedData = defaults.object(forKey: "transactionList") as? [Data] else {
            return nil
        }
        
        let decoder = JSONDecoder()
        return encodedData.compactMap { try? decoder.decode(Transaction.self, from: $0) }
    }
    
    private func filterDataBasedOnSearchAndSegment(searchText: String) {
        if coinSegment.selectedSegmentIndex == 0 {
            searchCoinResult = searchText.isEmpty ? coinList : coinList.filter { $0.name!.lowercased().contains(searchText.lowercased()) }
        } else {
            let filteredTransactions = searchText.isEmpty ? transactionData! : transactionData!.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            alisTransactions = filteredTransactions.filter { $0.type == "Alis" }
            satisTransactions = filteredTransactions.filter { $0.type == "Satis" }
        }
        coinTableView.reloadData()
    }
}



extension MainPageViewController: UITableViewDelegate, UITableViewDataSource,CoinCellProtocol {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return coinSegment.selectedSegmentIndex == 0 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let index = coinSegment.selectedSegmentIndex
        
        if isSearching {
            return searchCoinResult.count
        } else {
            if index != 0  {
                if section == 0{
                    return alisTransactions.count
                } else if section == 1 {
                    return satisTransactions.count
                }
            }
            
            return coinList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if coinSegment.selectedSegmentIndex == 0 {
            
            return nil
        } else {
            
            return transactionSection[section]
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = coinSegment.selectedSegmentIndex
        if index == 0 {
            let coin: Coin = isSearching ? searchCoinResult[indexPath.row] : coinList[indexPath.row]
            let viewModel = Coin(symbol: coin.symbol!, name: coin.name!, isFavorite: coin.isFavorite!, id: coin.id!)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath) as? CoinCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel)
            cell.cellProtocol = self
            cell.indexPath = indexPath
            cell.selectionStyle = .none
            return cell
        } else {
            let transactionList = indexPath.section == 0 ? alisTransactions : satisTransactions
            guard indexPath.row < transactionList.count else {
                return UITableViewCell()
            }
            let transaction = transactionList[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as? TransactionCell else {
                return UITableViewCell()
            }
            cell.configure(with: transaction)
            return cell
        }
        /*
         if isSearching {
         
         if index == 0  {
         let coin = searchCoinResult[indexPath.row]
         let viewModel = Coin(symbol:coin.symbol!, name: coin.name!, isFavorite: coin.isFavorite!, id: coin.id!)
         let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell") as! CoinCell
         
         cell.configure(with: viewModel)
         cell.cellProtocol = self
         cell.indexPath = indexPath
         cell.selectionStyle = .none
         
         return cell
         }else {
         print("ERlse")
         let transaction = (indexPath.section == 0 ? alisTransactions : satisTransactions)[indexPath.row]
         if let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as? TransactionCell {
         
         cell.configure(with: transaction)
         return cell // Return a default cell if casting fails
         } else {
         
         return UITableViewCell()
         }
         
         }
         return UITableViewCell()
         } else {
         if index == 0  {
         let coin = coinList[indexPath.row]
         let viewModel = Coin(symbol:coin.symbol!, name: coin.name!, isFavorite: coin.isFavorite!, id: coin.id!)
         let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell") as! CoinCell
         
         cell.configure(with: viewModel)
         cell.cellProtocol = self
         cell.indexPath = indexPath
         cell.selectionStyle = .none
         
         return cell
         
         } else {
         
         let transaction = (indexPath.section == 0 ? alisTransactions : satisTransactions)[indexPath.row]
         if let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as? TransactionCell {
         
         cell.configure(with: transaction)
         return cell // Return a default cell if casting fails
         } else {
         
         return UITableViewCell()
         }
         
         }
         return UITableViewCell()
         }
         */
    }
    
    // SORULACAK
    // manuel olarak deselectRow çağırmak yerine selectionstyle = .none yapabiliniyor tableviewde veya cellde best practice hangisi?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = coinSegment.selectedSegmentIndex
        
        if index == 0  {
            goCoinDetail(coin: coinList[indexPath.row])
            let coin = coinList[indexPath.row]
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let alertAction = UIContextualAction(style: .normal, title: "Al") { contextualAction, view, bool in
            
            let coin = self.coinList[indexPath.row]
            
            let alert = UIAlertController(title: "Alim Islemi", message: "\(coin.name!): \(String(format: "%.2f", Double(coin.priceUsd!)!))", preferredStyle: .alert)
            let confirmAlert = UIAlertController(title: "", message: "Alim emriniz isleme alinmistir.", preferredStyle: .alert)
            
            alert.addTextField { textField in
                textField.keyboardType = .numberPad
            }
            
            let cancelAction = UIAlertAction(title: "Iptal", style: .destructive)
            let confirmAction = UIAlertAction(title: "Kapat", style: .destructive)
            let evetAction = UIAlertAction(title: "Islem Gir", style: .default) { action in
                if let inputText = alert.textFields?.first?.text {
                    
                    self.present(confirmAlert,animated: true)
                    let newTransaction = Transaction(id: coin.id!,amount: Int(inputText)!,name: coin.name!, price: Double(coin.priceUsd!)! * Double(inputText)!, time: Date().getDateAndHours(),type: "Alis")
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(newTransaction)
                        self.saveTransaction(data)
                    } catch {
                        print("Unable to Encode Note (\(error))")
                    }
                    
                }
            }
            
            alert.addAction(cancelAction)
            alert.addAction(evetAction)
            confirmAlert.addAction(confirmAction)
            
            self.present(alert, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [alertAction])
    }
    
    func clickedfavorite(indexPath: IndexPath) {
        guard indexPath.row < coinList.count, let coinId = coinList[indexPath.row].id else { return }
        
        var favoriteCoinList = UserDefaults.standard.array(forKey: "favoriteCoinList") as? [String] ?? [String]()
        
        let isFavorite = favoriteCoinList.contains(coinId)
        
        if isFavorite {
            favoriteCoinList.removeAll{ $0 == coinId }
        } else {
            favoriteCoinList.append(coinId)
        }
        UserDefaults.standard.set(favoriteCoinList,forKey: "favoriteCoinList")
        
        coinList[indexPath.row].isFavorite = !isFavorite
        coinTableView.reloadRows(at: [indexPath], with: .none)
        
    }
    
}

extension MainPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pieCharts.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pieChart = pieCharts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCollectionViewCell
        
        cell.pieChart = pieChart
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.row == 1 {
            let test = loadTransactions()
            goMyTransactions(transactions: test!)
            print(test!)
        }
        
    }
    
}

extension MainPageViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        isSearching = !searchText.isEmpty
        filterDataBasedOnSearchAndSegment(searchText: searchText)
    }
}



