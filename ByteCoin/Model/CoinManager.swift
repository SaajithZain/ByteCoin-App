//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didReceiveCoinData(_ coinManager : CoinManager, _ lastPrice: Double, _ currency: String )
    func didFailwithError(error: Error)
}
struct CoinManager {
    var delegate: CoinManagerDelegate?
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let apiUrl = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    
    
    //get coinData from API for a given currency
    func getCoinPrice(for currency: String){
        let url = "\(apiUrl)\(currency)"
               
        if let safeUrl = URL(string: url){
            let session = URLSession(configuration: .default)
            let sessionTask = session.dataTask(with: safeUrl) { (data, response, error) in
                if error != nil {
                    print("error")
                }
                
                if let safeData = data {
                    if let lastPrice = self.parseJSON(safeData){
                        self.delegate?.didReceiveCoinData(self, lastPrice, currency)
                    }
                }
            }
            
            sessionTask.resume()
        }
        
    }
    
    
    func parseJSON(_ data: Data) -> Double?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.last
            return lastPrice
        }catch {
            self.delegate?.didFailwithError(error: error)
           return nil
        }
    }
}
