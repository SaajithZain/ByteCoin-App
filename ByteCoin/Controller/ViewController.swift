//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    var coinManager = CoinManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        coinManager.delegate = self
        // Do any additional setup after loading the view.
    }

    
}

//MARK:- CoinManagerDelegate

extension ViewController: CoinManagerDelegate{
    func didReceiveCoinData(_ coinManager: CoinManager, _ lastPrice: Double, _ currency: String) {
        DispatchQueue.main.async {
                   self.bitcoinLabel.text = String(lastPrice)
            self.currencyLabel.text = currency
               }
    }
    
    func didFailwithError(error: Error) {
        print(error)
    }

}

//MARK:- UIPickerViewDelegate, UIPickerViewDataSource

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return self.coinManager.currencyArray.count
       }

       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return coinManager.currencyArray[row]
       }
    
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           self.coinManager.getCoinPrice(for: coinManager.currencyArray[row])
       }
}
