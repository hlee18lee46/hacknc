//
//  AccountsView.swift
//  hacknc
//
//  Created by Han Lee on 11/3/24.
//


// AccountsView.swift
import SwiftUI

struct AccountsView: View {
    @StateObject private var viewModel = AccountsViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.accounts) { account in
                VStack(alignment: .leading) {
                    Text(account.name)
                        .font(.headline)
                    Text("Account Type: \(account.type.capitalized), \(account.subtype.capitalized)")
                    Text("Mask: \(account.mask)")
                    Text("Balance: \(account.balances.current, specifier: "%.2f")")
                    if let available = account.balances.available {
                        Text("Available Balance: \(available, specifier: "%.2f")")
                    }
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("Accounts")
            .onAppear {
                viewModel.fetchAccounts()
            }
        }
    }
}
