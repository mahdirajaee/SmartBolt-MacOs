import SwiftUI

struct SplashView: View {
    @EnvironmentObject var appState: AppState
    @State private var isAnimating = false
    @State private var showLoadingText = false
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 24) {
                Image(systemName: "bolt.circle.fill")
                    .font(.system(size: 80, weight: .regular))
                    .foregroundStyle(.blue)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(
                        Animation.linear(duration: 2)
                            .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
                
                VStack(spacing: 8) {
                    Text("SmartBolt")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .opacity(logoOpacity)
                    
                    Text("IoT Device Management")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                        .opacity(logoOpacity)
                }
            }
            
            if showLoadingText {
                HStack(spacing: 12) {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(0.8)
                    
                    Text("Initializing...")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showLoadingText = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                appState.navigateToLogin()
            }
        }
    }
} 