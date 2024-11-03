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
            
            AutoView()
                .tabItem {
                    Image(systemName: "car.fill")  // Icon for Auto tab
                    Text("Auto")
                }
            
            HouseView()
                .tabItem {
                    Image(systemName: "house.fill")  // Icon for House tab
                    Text("House")
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

struct AutoView: View {
    var body: some View {
        Text("Auto Screen")
            .font(.largeTitle)
            .foregroundColor(.green)
    }
}

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
