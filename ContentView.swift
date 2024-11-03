import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false  // Track login state

    var body: some View {
        NavigationView {
            if isLoggedIn {
                MainTabView()  // Show the tab bar after logging in
            } else {
                LoginView(isLoggedIn: $isLoggedIn)  // Login view as initial view
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            PlaidView()
                .tabItem {
                    Image(systemName: "link.circle")  // Icon for Plaid tab
                    Text("Plaid")
                }
            AccountsView()
                .tabItem {
                    Image(systemName: "list.bullet")  // Icon for Accounts tab
                    Text("Accounts")
                }
            QuizView()
                .tabItem {
                    Image(systemName: "questionmark.circle")  // Icon for Accounts tab
                    Text("Quiz")
                }
            
            AutoView()
                .tabItem {
                    Image(systemName: "dollarsign.circle.fill")  // Icon for Auto tab
                    Text("Loan")
                }
            
            DashboardView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")  // Icon for Dashboard tab
                    Text("Dashboard")
                }
        }
    }
}

// Placeholder views for each tab
/*
struct PlaidView: View {
    var body: some View {
        Text("Plaid Screen")
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}
*/
/*
struct AutoView: View {
    var body: some View {
        Text("AutoView Content")
    }
}
*/
struct HouseView: View {
    var body: some View {
        Text("House Screen")
            .font(.largeTitle)
            .foregroundColor(.purple)
    }
}

struct DashboardView: View {
    var body: some View {
        Text("Dashboard Screen")
            .font(.largeTitle)
            .foregroundColor(.orange)
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
