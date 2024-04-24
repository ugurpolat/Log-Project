//
//  ViewController.swift
//  Log-Project
//
//  Created by Uğur Polat on 26.03.2024.
//

import UIKit

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var coinTableView: UITableView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    var pie_1 = PieChart()
    var pie_2 = PieChart_2()
    var coinList = [Coin]()
    var pieCharts = [UIView]()
    var viewModel = MainPageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        pieCharts.append(pie_1)
        pieCharts.append(pie_2)
        
        coinTableView.delegate = self
        coinTableView.dataSource = self
        
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        
        viewModel.coinList.bind { [weak self] value in
            DispatchQueue.main.async {
                self?.coinList = value!
                self?.coinTableView.reloadData()
                self?.sliderCollectionView.reloadData()
                
            }
        }
    }
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: sliderCollectionView.frame.size.width, height: sliderCollectionView.frame.size.height)
        layout.minimumLineSpacing = 0 // Ensure there's no space between cells if paging is enabled
        sliderCollectionView.collectionViewLayout = layout
        sliderCollectionView.isPagingEnabled = true // This ensures that each cell is centered in the view when scrolled
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getCoins()
    }
    
    private func goCoinDetail(coin: Coin) {
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
    
    @IBAction func getMyAssets(_ sender: UIButton) {
        let firstIndexPath = IndexPath(item: 0, section: 0)
        sliderCollectionView.scrollToItem(at: firstIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func getMyTransactions(_ sender: UIButton) {
        let secondIndexPath = IndexPath(item: 1, section: 0)
        sliderCollectionView.scrollToItem(at: secondIndexPath, at: .centeredHorizontally, animated: true)
        
    }
}

extension MainPageViewController: UITableViewDelegate, UITableViewDataSource,CoinCellProtocol {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coin = coinList[indexPath.row]
        let viewModel = Coin(symbol:coin.symbol!, name: coin.name!, isFavorite: coin.isFavorite!, id: coin.id!)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell") as! CoinCell
        
        /*BEST PRACTISE
         bu tip yerlerde de tek tek cellin propertylerini setlemek yerine cell.configure(with: viewmodel)
         yapmak her zaman daha iyidir
         cell.labelCoinName.text = coin.name
         cell.labelCoinSymbol.text = coin.symbol
         //cell.coin = coin
         */
        cell.configure(with: viewModel)
        cell.cellProtocol = self
        cell.indexPath = indexPath
        
        cell.selectionStyle = .none
        return cell
    }
    
    // SORULACAK
    // manuel olarak deselectRow çağırmak yerine selectionstyle = .none yapabiliniyor tableviewde veya cellde best practice hangisi?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goCoinDetail(coin: coinList[indexPath.row])
        let coin = coinList[indexPath.row]
        print(coin.isFavorite!)
        //tableView.deselectRow(at: indexPath, animated: true)
        //CoinCell.appearance().selectionStyle = .none
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
                    print("User entered: \(inputText)")
                    self.present(confirmAlert,animated: true)
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
    
}
