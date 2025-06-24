import SwiftUI

enum AppScreen {
    case splash
    case login
    case dashboard
}

enum DashboardSection: String, CaseIterable {
    case overview = "Overview"
    case pipelines = "Pipelines"
    case statistics = "Statistics"
    
    var icon: String {
        switch self {
        case .overview: return "square.grid.2x2"
        case .pipelines: return "cylinder.split.1x2"
        case .statistics: return "chart.bar.fill"
        }
    }
}

class AppState: ObservableObject {
    @Published var currentScreen: AppScreen = .splash
    @Published var isAuthenticated: Bool = false
    @Published var selectedDashboardSection: DashboardSection = .overview
    
    func navigateToLogin() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentScreen = .login
        }
    }
    
    func navigateToDashboard() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentScreen = .dashboard
            isAuthenticated = true
        }
    }
    
    func logout() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isAuthenticated = false
            currentScreen = .login
        }
    }
    
    func selectDashboardSection(_ section: DashboardSection) {
        selectedDashboardSection = section
    }
} 