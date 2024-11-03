//
//  CreditCardTransactionsViewModel.swift
//  hacknc
//
//  Created by Han Lee on 11/3/24.
//
/*

import SwiftUI
import Combine

class CreditCardTransactionsViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var errorMessage: String?
    
    func fetchCreditCardTransactions(accessToken: String) {
        guard let url = URL(string: "https://2e03-152-23-102-253.ngrok-free.app/get_credit_card_transactions") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        let requestData: [String: Any] = [
            "access_token": accessToken,
            "start_date": "2022-01-01",
            "end_date": "2022-12-31"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestData)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch transactions: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data,
                  let response = try? JSONDecoder().decode(TransactionsResponse.self, from: data) else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode transactions data."
                }
                return
            }
            
            DispatchQueue.main.async {
                self.transactions = response.transactions
            }
        }.resume()
    }
}

struct Transaction: Identifiable, Codable {
    let id = UUID()
    let transaction_id: String
    let amount: Double
    let date: String
    let name: String
    let category: [String]?
}

struct TransactionsResponse: Codable {
    let transactions: [Transaction]
}
*/
