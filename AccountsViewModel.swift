// AccountsViewModel.swift
import Foundation
import Combine

class AccountsViewModel: ObservableObject {
    @Published var accounts: [Account] = []
    private var cancellables = Set<AnyCancellable>()

    func fetchAccounts() {
        guard let url = URL(string: "https://2e03-152-23-102-253.ngrok-free.app/get_accounts") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: AccountsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching accounts: \(error)")
                }
            }, receiveValue: { [weak self] response in
                self?.accounts = response.accounts
            })
            .store(in: &cancellables)
    }
}
