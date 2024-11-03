//
//  TransactionsViewModel.swift
//  hacknc
//
//  Created by Han Lee on 11/3/24.
//

/*
import SwiftUI
import Combine

class TransactionsViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func fetchTransactions(accessToken: String) {
        guard let url = URL(string: "https://2e03-152-23-102-253.ngrok-free.app/get_credit_card_transactions") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        let requestData: [String: Any] = [
            "access_token": accessToken,
            "start_date": "2022-01-01", // Set your desired start date
            "end_date": "2022-12-31"    // Set your desired end date
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestData)

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: TransactionsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = "Failed to fetch transactions: \(error.localizedDescription)"
                }
            }, receiveValue: { response in
                self.transactions = response.transactions
            })
            .store(in: &cancellables)
    }
}

*/
