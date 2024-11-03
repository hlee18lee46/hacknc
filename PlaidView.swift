import SwiftUI
import LinkKit

struct PlaidView: View {
    @State private var bankInfo: String = "Bank information will appear here."
    @State private var linkController: LinkController?
    @ObservedObject var viewModel = PlaidViewModel()
    @State private var publicToken = "PUBLIC_TOKEN_RECEIVED_FROM_PLAID_LINK" // Replace with actual token from Plaid Link


    var body: some View {
        VStack {
            Text("Plaid Bank Information")
                .font(.largeTitle)
                .padding()

            Text(bankInfo)
                .padding()
                .multilineTextAlignment(.center)
            
            Text(viewModel.balanceInfo)
                .padding()
                .multilineTextAlignment(.center)
            


            Button(action: {
                bankInfo = "Fetching link token..."
                fetchLinkToken { linkToken in
                    guard let token = linkToken else {
                        bankInfo = "Failed to fetch link token"
                        return
                    }
                    initializeLinkController(with: token)
                }
            }) {
                Text("Connect Bank Account")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .fullScreenCover(
            isPresented: Binding<Bool>(
                get: { self.linkController != nil },
                set: { newValue in
                    if !newValue {
                        self.linkController = nil
                    }
                }
            ),
            content: {
                if let linkController = linkController {
                    linkController
                        .ignoresSafeArea()
                }
            }
        )
    }

    private func fetchLinkToken(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://2e03-152-23-102-253.ngrok-free.app/create_link_token") else {
            print("Invalid URL for link token endpoint.")
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching link token: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let linkToken = json["link_token"] as? String else {
                print("Failed to parse link token from response.")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            print("Fetched link token: \(linkToken)")
            DispatchQueue.main.async {
                completion(linkToken)
            }
        }.resume()
    }

    private func initializeLinkController(with linkToken: String) {
        DispatchQueue.main.async {
            var linkConfiguration = LinkTokenConfiguration(token: linkToken) { success in
                print("onSuccess: public-token: \(success.publicToken) metadata: \(success.metadata)")
                self.bankInfo = "Successfully linked account! Public token: \(success.publicToken)"
                // Additional success logic...
            }

            linkConfiguration.onExit = { exit in
                if let error = exit.error {
                    print("onExit with error: \(error)\nMetadata: \(exit.metadata)")
                } else {
                    print("onExit without error. Metadata: \(exit.metadata)")
                }
                self.bankInfo = "Plaid Link process exited."
                self.linkController = nil // Dismiss LinkController after exit
            }

            // Create and assign the Link handler
            switch Plaid.create(linkConfiguration) {
            case .success(let handler):
                print("Handler created successfully.")
                self.linkController = LinkController(handler: handler)
            case .failure(let error):
                print("Failed to create Plaid Link handler: \(error)")
                self.bankInfo = "Failed to initialize LinkController: \(error.localizedDescription)"
            }
        }
    }



}
