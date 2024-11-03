/*
import SwiftUI

struct CreditCardTransactionsView: View {
    @StateObject private var viewModel = CreditCardTransactionsViewModel()
    let accessToken: String

    var body: some View {
        NavigationView {
            List(viewModel.transactions) { transaction in
                VStack(alignment: .leading) {
                    Text(transaction.name)
                        .font(.headline)
                    Text("Amount: $\(transaction.amount, specifier: "%.2f")")
                    Text("Date: \(transaction.date)")
                    if let category = transaction.category {
                        Text("Category: \(category.joined(separator: ", "))")
                    }
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("Credit Card Transactions")
            .onAppear {
                viewModel.fetchCreditCardTransactions(accessToken: accessToken)
            }
        }
        .alert(isPresented: .constant(viewModel.errorMessage != nil), content: {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        })
    }
}
*/
