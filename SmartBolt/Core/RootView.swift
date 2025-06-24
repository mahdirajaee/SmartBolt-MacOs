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