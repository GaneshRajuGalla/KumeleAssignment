//
//  LoginView.swift
//  KumeleAssignment
//
//  Created by Ganesh Raju Galla on 02/06/26.
//

import SwiftUI

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    @State private var authManager       = PasskeyAuthManager()
    @State private var showError         = false
    @State private var username          = ""
    @State private var showRegisterSheet = false

    var body: some View {
        ZStack {
            background
            VStack(spacing: 0) {
                Spacer()
                logo
                Spacer()
                buttons
                demoLink.padding(.bottom, 48)
            }
            .padding(.horizontal, 28)
            if authManager.isLoading { loadingOverlay }
        }
        .onChange(of: authManager.isAuthenticated) {
            if authManager.isAuthenticated { isAuthenticated = true }
        }
        .onChange(of: authManager.errorMessage) {
            showError = authManager.errorMessage != nil
        }
        .alert("Authentication", isPresented: $showError) {
            Button("OK") { authManager.errorMessage = nil }
        } message: {
            Text(authManager.errorMessage ?? "")
        }
    }

    // MARK: - Background

    private var background: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            LinearGradient(
                colors: [Color.kumeleYellow.opacity(0.25), Color.kumeleCorals.opacity(0.15), Color.clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
    }

    // MARK: - Logo

    private var logo: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [Color.kumeleYellow, Color.kumeleCorals],
                                        startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 90, height: 90)
                    .shadow(color: Color.kumeleYellow.opacity(0.5), radius: 20, y: 8)
                Image(systemName: "person.2.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.white)
            }
            VStack(spacing: 6) {
                Text("kumele")
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                Text("Connect through hobbies")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
    }

    // MARK: - Buttons

    private var buttons: some View {
        VStack(spacing: 14) {
            Button(action: { authManager.signIn() }) {
                HStack(spacing: 12) {
                    Image(systemName: "person.badge.key.fill").font(.body.bold())
                    Text("Sign in with Passkey").font(.body.bold())
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(LinearGradient(colors: [Color.kumeleYellow, Color.kumeleCorals],
                                           startPoint: .leading, endPoint: .trailing))
                .foregroundStyle(.black)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.kumeleYellow.opacity(0.4), radius: 12, y: 4)
            }

            Button(action: { showRegisterSheet = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.circle.fill")
                    Text("Create Account with Passkey").font(.body.weight(.medium))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.white.opacity(0.07))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.15), lineWidth: 1))
            }
            .sheet(isPresented: $showRegisterSheet) { registerSheet }
        }
        .padding(.bottom, 20)
    }

    // MARK: - Register Sheet

    private var registerSheet: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                Image(systemName: "person.badge.key.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(Color.kumeleYellow)
                VStack(spacing: 8) {
                    Text("Create Passkey Account").font(.title3.bold())
                    Text("Enter a username to link to your passkey")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                TextField("Username (e.g. ganesh@kumele.com)", text: $username)
                    .textContentType(.username)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                Button {
                    showRegisterSheet = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        authManager.registerPasskey(username: username)
                    }
                } label: {
                    Text("Create Passkey")
                        .font(.body.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.kumeleYellow)
                        .foregroundStyle(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(username.trimmingCharacters(in: .whitespaces).isEmpty)
                .padding(.horizontal)
                Spacer()
            }
            .navigationTitle("Register")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showRegisterSheet = false }
                }
            }
        }
        .presentationDetents([.medium])
    }

    // MARK: - Misc

    private var demoLink: some View {
        Button("Skip → Demo Mode") {
            withAnimation(.easeInOut(duration: 0.4)) { isAuthenticated = true }
        }
        .font(.footnote.weight(.medium))
        .foregroundStyle(.white.opacity(0.45))
        .padding(.top, 4)
    }

    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            VStack(spacing: 16) {
                ProgressView().tint(Color.kumeleYellow).scaleEffect(1.4)
                Text("Authenticating…")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(32)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

#Preview { LoginView(isAuthenticated: .constant(false)) }
