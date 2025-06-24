import SwiftUI

enum AppScreen {
    case splash
    case login
    case dashboard
}

class AppState: ObservableObject {
    @Published var currentScreen: AppScreen = .splash
    @Published var isAuthenticated: Bool = false
    
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
} 