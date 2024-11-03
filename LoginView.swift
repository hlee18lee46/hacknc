import SwiftUI
import Foundation

struct User: Codable {
    var username: String
    var password: String
}

struct AuthResponse: Codable {
    var message: String
}



import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var username = ""
    @State private var password = ""
    @State private var authMessage = ""
    @State private var isLogin = true
    @State private var logoScale: CGFloat = 0.5  // Initial scale for animation
    @State private var logoOpacity: Double = 0.0  // Initial opacity for animation

    var body: some View {
        VStack {
            // Animated logo
            Image(uiImage: UIImage(named: "1Finance.png")!)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                .onAppear {
                    withAnimation(.easeOut(duration: 1.5)) {
                        logoScale = 1.8  // Scale up to original size
                        logoOpacity = 1.0  // Fade in to full opacity
                    }
                }
                .padding(.top, 40)

            Text(isLogin ? "" : "Registration")
                .font(.largeTitle)
                .padding()

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                if isLogin {
                    login()
                } else {
                    register()
                }
            }) {
                Text(isLogin ? "Login" : "Register")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }

            Text(authMessage)
                .padding()
                .foregroundColor(authMessage == "Login successful" ? .green : .red)

            // Ping button to test backend connectivity
            /*
            Button(action: {
                pingDB()
            }) {
                Text("Ping Database")
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .padding()
            }
*/
            Button(action: {
                isLogin.toggle()
            }) {
                Text(isLogin ? "Don't have an account? Register" : "Already have an account? Login")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .padding()
    }

    // MARK: - Backend Calls

    func register() {
        let user = User(username: username, password: password)
        sendAuthRequest(to: "http://127.0.0.1:5000/register", user: user)
    }

    func login() {
        let user = User(username: username, password: password)
        sendAuthRequest(to: "http://127.0.0.1:5000/login", user: user)
    }

    // Ping database to check connection
    func pingDB() {
        guard let url = URL(string: "http://127.0.0.1:5000/ping_db") else {
            authMessage = "Invalid URL"
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    authMessage = "Error: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    authMessage = "No data in response"
                }
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let message = jsonResponse["message"] as? String {
                    DispatchQueue.main.async {
                        authMessage = message
                    }
                } else {
                    DispatchQueue.main.async {
                        authMessage = "Unexpected response format"
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    authMessage = "Failed to parse JSON response"
                }
            }
        }.resume()
    }

    // Existing sendAuthRequest function
    func sendAuthRequest(to url: String, user: User) {
        guard let requestUrl = URL(string: url) else {
            authMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            authMessage = "Failed to encode user data"
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    authMessage = "Error: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    authMessage = "No data in response"
                }
                return
            }

            do {
                let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                DispatchQueue.main.async {
                    authMessage = authResponse.message
                    if authMessage == "Login successful" {
                        isLoggedIn = true  // Update login state to navigate to HomeView
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    authMessage = "Invalid User Credentials"
                }
            }
        }.resume()
    }
}
