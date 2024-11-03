import SwiftUI

struct AutoView: View {
    @State private var income: Double = 50000
    @State private var loanAmount: Double = 25000  // Renamed from 'debt' to 'loanAmount'
    @State private var duration: Double = 12
    @State private var approvalPercentage: String = "0%"

    var body: some View {
        VStack {
            Text("Quick Loan Assessment")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)

            VStack(alignment: .leading) {
                Text("Income: \(Int(income))")
                Slider(value: $income, in: 0...500000, step: 1000)
                    .accentColor(.blue)
            }
            .padding()

            VStack(alignment: .leading) {
                Text("Loan Amount: \(Int(loanAmount))")
                Slider(value: $loanAmount, in: 0...200000, step: 1000)
                    .accentColor(.red)
            }
            .padding()

            VStack(alignment: .leading) {
                Text("Duration (Months): \(Int(duration))")
                Slider(value: $duration, in: 0...360, step: 1)
                    .accentColor(.green)
            }
            .padding()
            
            Button("Check Loan Approval Probability") {
                checkLoanApproval()
            }
            .buttonStyle(ActionButtonStyle(color: .orange))
            .padding(.top)

            Text("Approval Probability: \(approvalPercentage)")
                .font(.title)
                .padding(.top, 20)
        }
    }

    func checkLoanApproval() {
        guard let url = URL(string: "http://127.0.0.1:5000/predict_loan_approval") else {
            approvalPercentage = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: Any] = [
            "income": income,
            "loan_amount": loanAmount,
            "duration": duration
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    approvalPercentage = "Error: \(error.localizedDescription)"
                }
                return
            }
            
            if let data = data {
                do {
                    if let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let probability = result["approval_probability"] as? Double {
                        DispatchQueue.main.async {
                            // Format the probability as xx.xx%
                            approvalPercentage = String(format: "%.2f%%", probability * 100)
                        }
                    } else {
                        DispatchQueue.main.async {
                            approvalPercentage = "Unexpected response format"
                        }
                        print("Unexpected response format:", String(data: data, encoding: .utf8) ?? "nil")
                    }
                } catch {
                    DispatchQueue.main.async {
                        approvalPercentage = "Failed to parse JSON response: \(error)"
                    }
                    print("Failed to parse JSON response:", error)
                }
            }
        }.resume()
    }

}
