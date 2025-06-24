import SwiftUI

struct RootView: View {
    @StateObject private var appState = AppState()
    
    var body: some View {
        ZStack {
            switch appState.currentScreen {
            case .splash:
                SplashView()
                    .environmentObject(appState)
                    .transition(.asymmetric(
                        insertion: .opacity,
                        removal: .opacity.combined(with: .scale(scale: 0.95))
                    ))
                
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
        .frame(minWidth: 900, minHeight: 650)
        .frame(idealWidth: 1200, idealHeight: 800)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: appState.currentScreen)
        .preferredColorScheme(nil)
    }
}

struct DashboardView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingSidebar = true
    
    var body: some View {
        NavigationSplitView(sidebar: {
            sidebar
        }, detail: {
            mainContent
        })
        .navigationSplitViewStyle(.balanced)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BrandColors.Background.primary)
    }
    
    private var sidebar: some View {
        VStack(spacing: 0) {
            sidebarHeader
            
            List {
                NavigationLink("Dashboard", value: "dashboard")
                NavigationLink("Devices", value: "devices")
                NavigationLink("Analytics", value: "analytics")
                NavigationLink("Settings", value: "settings")
            }
            .listStyle(.sidebar)
            
            Spacer()
            
            sidebarFooter
        }
        .frame(minWidth: 200)
        .background(BrandColors.Surface.elevated)
    }
    
    private var sidebarHeader: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "bolt.circle.fill")
                    .font(.title2)
                    .foregroundStyle(BrandColors.smartBlue)
                
                Text("SmartBolt")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(BrandColors.Text.primary)
                
                Spacer()
            }
            
            Divider()
        }
        .padding()
    }
    
    private var sidebarFooter: some View {
        VStack(spacing: 8) {
            Divider()
            
            Button(action: { appState.logout() }) {
                HStack {
                    Image(systemName: "arrow.right.square")
                    Text("Sign Out")
                    Spacer()
                }
            }
            .buttonStyle(.plain)
            .foregroundStyle(BrandColors.Text.secondary)
            .padding()
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome back!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(BrandColors.Text.primary)
                    
                    Text("Manage your IoT devices with confidence")
                        .font(.title3)
                        .foregroundStyle(BrandColors.Text.secondary)
                }
                
                Spacer()
                
                Button("Add Device") {
                    // Handle add device
                }
                .buttonStyle(.borderedProminent)
                .tint(BrandColors.smartBlue)
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 20) {
                DashboardCard(
                    title: "Connected Devices",
                    value: "12",
                    icon: "antenna.radiowaves.left.and.right",
                    color: BrandColors.techGreen
                )
                
                DashboardCard(
                    title: "Active Alerts",
                    value: "3",
                    icon: "exclamationmark.triangle",
                    color: BrandColors.energyOrange
                )
                
                DashboardCard(
                    title: "System Status",
                    value: "Online",
                    icon: "checkmark.circle",
                    color: BrandColors.smartBlue
                )
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BrandColors.Background.primary)
    }
}

struct DashboardCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(BrandColors.Text.primary)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(BrandColors.Text.secondary)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BrandColors.Surface.card)
        .cornerRadius(16)
        .shadow(color: BrandColors.deepSpace.opacity(0.1), radius: 8, x: 0, y: 4)
    }
} 