import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var rememberMe: Bool = false
    @State private var showPassword: Bool = false
    @FocusState private var focusedField: Field?
    
    @State private var cardOffset: CGSize = CGSize(width: 0, height: 50)
    @State private var cardOpacity: Double = 0
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        ZStack {
            BrandColors.Background.gradient
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 32) {
                        headerSection
                        
                        loginCard
                            .offset(cardOffset)
                            .opacity(cardOpacity)
                    }
                    .frame(maxWidth: 400)
                    .frame(width: min(400, geometry.size.width - 80))
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .alert("Authentication Failed", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                cardOffset = .zero
                cardOpacity = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                focusedField = .email
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            Image("PolitectoLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 280, height: 190)
                .shadow(color: BrandColors.smartBlue.opacity(0.2), radius: 8, x: 0, y: 4)
            
            VStack(spacing: 8) {
                HStack(spacing: 12) {
                    Image(systemName: "bolt.circle.fill")
                        .font(.title2)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [BrandColors.smartBlue, BrandColors.techGreen],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("SmartBolt")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(BrandColors.Text.primary)
                }
                
                Text("Politecnico di Torino")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(BrandColors.Text.secondary)
                
                Text("Secure IoT Management Platform")
                    .font(.caption)
                    .foregroundStyle(BrandColors.Text.tertiary)
            }
        }
    }
    
    private var loginCard: some View {
        VStack(spacing: 24) {
            VStack(spacing: 20) {
                FloatingTextField(
                    text: $email,
                    placeholder: "Email Address",
                    icon: "envelope",
                    isSecure: false
                )
                .focused($focusedField, equals: .email)
                .onSubmit { focusedField = .password }
                .disableAutocorrection(true)
                
                FloatingTextField(
                    text: $password,
                    placeholder: "Password",
                    icon: "lock",
                    isSecure: !showPassword,
                    trailingAction: {
                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundStyle(BrandColors.Text.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                )
                .focused($focusedField, equals: .password)
                .onSubmit { handleLogin() }
                
                HStack {
                    Toggle("Remember me", isOn: $rememberMe)
                        .toggleStyle(ModernCheckboxStyle())
                    
                    Spacer()
                    
                    Button("Forgot Password?") {
                        // Handle forgot password
                    }
                    .font(.subheadline)
                    .foregroundStyle(BrandColors.smartBlue)
                    .buttonStyle(.plain)
                }
            }
            
            VStack(spacing: 16) {
                Button(action: handleLogin) {
                    HStack(spacing: 12) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .scaleEffect(0.9)
                                .tint(.white)
                            Text("Signing In...")
                        } else {
                            Text("Sign In")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        LinearGradient(
                            colors: [BrandColors.smartBlue, BrandColors.techGreen],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
                .buttonStyle(PressableButtonStyle())
                .disabled(isLoading || email.isEmpty || password.isEmpty)
                .opacity((isLoading || email.isEmpty || password.isEmpty) ? 0.6 : 1.0)
                .keyboardShortcut(.return, modifiers: [])
                
                HStack(spacing: 6) {
                    Text("Don't have an account?")
                        .font(.subheadline)
                        .foregroundStyle(BrandColors.Text.secondary)
                    
                    Button("Sign Up") {
                        // Handle sign up
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(BrandColors.smartBlue)
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(BrandColors.Surface.glass)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(BrandColors.Border.primary, lineWidth: 1)
                        .blur(radius: 0.5)
                )
        )
        .shadow(color: BrandColors.deepSpace.opacity(0.1), radius: 20, x: 0, y: 10)
    }
    
    private func handleLogin() {
        guard !email.isEmpty && !password.isEmpty else { return }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            
            if validateCredentials() {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    appState.navigateToDashboard()
                }
            } else {
                errorMessage = "Please check your email and password and try again."
                showError = true
            }
        }
    }
    
    private func validateCredentials() -> Bool {
        return !email.isEmpty && !password.isEmpty
    }
}

struct FloatingTextField<TrailingContent: View>: View {
    @Binding var text: String
    let placeholder: String
    let icon: String
    let isSecure: Bool
    @ViewBuilder let trailingAction: () -> TrailingContent
    
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    init(
        text: Binding<String>,
        placeholder: String,
        icon: String,
        isSecure: Bool = false,
        @ViewBuilder trailingAction: @escaping () -> TrailingContent = { EmptyView() }
    ) {
        self._text = text
        self.placeholder = placeholder
        self.icon = icon
        self.isSecure = isSecure
        self.trailingAction = trailingAction
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !text.isEmpty || isFocused {
                Text(placeholder)
                    .font(.caption)
                    .foregroundStyle(isFocused ? BrandColors.smartBlue : BrandColors.Text.secondary)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundStyle(isFocused ? BrandColors.smartBlue : BrandColors.Text.secondary)
                    .frame(width: 16)
                
                Group {
                    if isSecure {
                        SecureField(text.isEmpty && !isFocused ? placeholder : "", text: $text)
                    } else {
                        TextField(text.isEmpty && !isFocused ? placeholder : "", text: $text)
                    }
                }
                .textFieldStyle(.plain)
                .focused($isFocused)
                .onChange(of: isFocused) { _, newValue in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isEditing = newValue
                    }
                }
                
                trailingAction()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(BrandColors.Surface.card)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isFocused ? BrandColors.smartBlue : BrandColors.Border.primary,
                        lineWidth: isFocused ? 2 : 1
                    )
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

struct ModernCheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 4)
                .fill(configuration.isOn ? BrandColors.smartBlue : BrandColors.Surface.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(
                            configuration.isOn ? BrandColors.smartBlue : BrandColors.Border.primary,
                            lineWidth: configuration.isOn ? 2 : 1
                        )
                )
                .overlay(
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                        .opacity(configuration.isOn ? 1 : 0)
                        .scaleEffect(configuration.isOn ? 1 : 0.5)
                )
                .frame(width: 16, height: 16)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isOn)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            
            configuration.label
                .font(.subheadline)
                .foregroundStyle(BrandColors.Text.secondary)
        }
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
} 