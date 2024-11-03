import SwiftUI
import Combine

class PlaidViewModel: ObservableObject {
    @Published var balanceInfo: String = "Balances will appear here."
    @Published var transactions: [[String: Any]] = []  // New property to store transactions
    
    func exchangePublicToken(publicToken: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://2e03-152-23-102-253.ngrok-free.app/exchange_public_token") else {
            print("Invalid URL for token exchange.")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json: [String: Any] = ["public_token": publicToken]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error exchanging public token: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data,
                  let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let accessToken = jsonResponse["access_token"] as? String else {
                print("Failed to parse access token from response.")
                completion(nil)
                return
            }
            
            print("Access token received: \(accessToken)")
            completion(accessToken)
        }.resume()
    }
    
    func getCreditCardTransactions(accessToken: String, completion: @escaping ([[String: Any]]?) -> Void) {
        guard let url = URL(string: "https://2e03-152-23-102-253.ngrok-free.app/get_credit_card_transactions") else {
            print("Invalid URL for getting transactions.")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json: [String: Any] = ["access_token": accessToken]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching transactions: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data,
                  let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let transactions = jsonResponse["transactions"] as? [[String: Any]] else {
                print("Failed to parse transactions data from response.")
                completion(nil)
                return
            }
            
            print("Transactions data received: \(transactions)")
            completion(transactions)
        }.resume()
    }
}
