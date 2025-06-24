import SwiftUI

struct RootView: View {
    @StateObject private var appState = AppState()
    
    var body: some View {
        ZStack {
            switch appState.currentScreen {
            case .splash:
                SplashView()
                    .environmentObject(appState)
                    .transition(.opacity)
                
            case .login:
                LoginView()
                    .environmentObject(appState)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                
            case .dashboard:
                DashboardView()
                    .environmentObject(appState)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
        }
        .frame(minWidth: 800, minHeight: 600)
        .animation(.easeInOut(duration: 0.3), value: appState.currentScreen)
    }
}

struct DashboardView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            Text("Dashboard")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Text("Welcome to SmartBolt Dashboard")
                .font(.title3)
                .foregroundStyle(.secondary)
            
            Button("Sign Out") {
                appState.logout()
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
} 