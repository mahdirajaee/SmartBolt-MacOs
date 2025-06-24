import SwiftUI

struct SplashView: View {
    @EnvironmentObject var appState: AppState
    @State private var logoScale: CGFloat = 0.3
    @State private var logoOpacity: Double = 0
    @State private var logoRotation: Double = 0
    @State private var titleOffset: CGSize = CGSize(width: 0, height: 30)
    @State private var titleOpacity: Double = 0
    @State private var subtitleOffset: CGSize = CGSize(width: 0, height: 20)
    @State private var subtitleOpacity: Double = 0
    @State private var showLoadingText: Bool = false
    @State private var progress: Double = 0
    @State private var glowIntensity: Double = 0
    
    var body: some View {
        ZStack {
            BrandColors.Background.gradient
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Spacer()
                
                VStack(spacing: 32) {
                    logoSection
                    brandingSection
                }
                
                loadingSection
                
                Spacer()
            }
        }
        .onAppear {
            startAnimationSequence()
        }
    }
    
    private var logoSection: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            BrandColors.smartBlue.opacity(glowIntensity * 0.3),
                            BrandColors.techGreen.opacity(glowIntensity * 0.2),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 80
                    )
                )
                .frame(width: 160, height: 160)
                .blur(radius: 15)
                .animation(
                    Animation.easeInOut(duration: 2)
                        .repeatForever(autoreverses: true),
                    value: glowIntensity
                )
            
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            BrandColors.smartBlue.opacity(0.3),
                            BrandColors.techGreen.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
                .frame(width: 120, height: 120)
                .rotationEffect(.degrees(logoRotation))
            
            Image(systemName: "bolt.circle.fill")
                .font(.system(size: 60, weight: .medium))
                .foregroundStyle(
                    LinearGradient(
                        colors: [BrandColors.smartBlue, BrandColors.techGreen],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                .shadow(color: BrandColors.smartBlue.opacity(0.3), radius: 10, x: 0, y: 5)
        }
    }
    
    private var brandingSection: some View {
        VStack(spacing: 12) {
            Text("SmartBolt")
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [BrandColors.Text.primary, BrandColors.Text.primary.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .offset(titleOffset)
                .opacity(titleOpacity)
            
            Text("Next-Generation IoT Management")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(BrandColors.Text.secondary)
                .offset(subtitleOffset)
                .opacity(subtitleOpacity)
        }
    }
    
    private var loadingSection: some View {
        VStack(spacing: 20) {
            if showLoadingText {
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(BrandColors.smartBlue)
                            .scaleEffect(0.9)
                        
                        Text("Initializing secure connection...")
                            .font(.subheadline)
                            .foregroundStyle(BrandColors.Text.secondary)
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    
                    ProgressView(value: progress, total: 1.0)
                        .progressViewStyle(ModernProgressStyle())
                        .frame(width: 200)
                        .transition(.opacity.combined(with: .scale))
                }
            }
        }
    }
    
    private func startAnimationSequence() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
            logoRotation = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            glowIntensity = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                titleOffset = .zero
                titleOpacity = 1.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                subtitleOffset = .zero
                subtitleOpacity = 1.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showLoadingText = true
            }
            
            animateProgress()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            appState.navigateToLogin()
        }
    }
    
    private func animateProgress() {
        let steps = [0.2, 0.4, 0.7, 0.9, 1.0]
        let durations = [0.3, 0.4, 0.5, 0.3, 0.2]
        
        for (index, step) in steps.enumerated() {
            let delay = durations.prefix(index).reduce(0, +)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: durations[index])) {
                    progress = step
                }
            }
        }
    }
}

struct ModernProgressStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(BrandColors.Surface.card)
                    .frame(height: 6)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [BrandColors.smartBlue, BrandColors.techGreen],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(
                        width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0),
                        height: 6
                    )
                    .animation(.easeInOut, value: configuration.fractionCompleted)
            }
        }
    }
} 