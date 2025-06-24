import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var rememberMe: Bool = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Image(systemName: "bolt.circle.fill")
                        .font(.system(size: 64, weight: .regular))
                        .foregroundStyle(.blue)
                    
                    Text("SmartBolt")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text("Sign in to continue")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom, 16)
                
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        TextField("Enter your email address", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .focused($focusedField, equals: .email)
                            .onSubmit {
                                focusedField = .password
                            }
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        SecureField("Enter your password", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .focused($focusedField, equals: .password)
                            .onSubmit {
                                handleLogin()
                            }
                    }
                    
                    HStack {
                        Toggle("Remember me", isOn: $rememberMe)
                            .toggleStyle(.checkbox)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Button("Forgot Password?") {
                            // Handle forgot password
                        }
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                    }
                }
                
                VStack(spacing: 12) {
                    Button(action: handleLogin) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .scaleEffect(0.8)
                                Text("Signing In...")
                            } else {
                                Text("Sign In")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isLoading || email.isEmpty || password.isEmpty)
                    .keyboardShortcut(.return, modifiers: [])
                    
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Button("Sign Up") {
                            // Handle sign up
                        }
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                    }
                }
            }
            .frame(maxWidth: 320)
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
        .alert("Authentication Failed", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                focusedField = .email
            }
        }
    }
    
    private func handleLogin() {
        guard !email.isEmpty && !password.isEmpty else { return }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            
            if validateCredentials() {
                appState.navigateToDashboard()
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