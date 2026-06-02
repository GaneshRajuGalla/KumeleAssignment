//
//  PasskeyAuthManager.swift
//  KumeleAssignment
//
//  Created by Ganesh Raju Galla on 02/06/26.
//

import Foundation
import AuthenticationServices
import UIKit

@Observable
class PasskeyAuthManager: NSObject {
    var isAuthenticated = false
    var errorMessage: String?
    var isLoading = false

    private let relyingPartyID = "kumele.com"

    // MARK: - Sign In

    func signIn() {
        isLoading = true
        errorMessage = nil
        let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(
            relyingPartyIdentifier: relyingPartyID
        )
        let request = provider.createCredentialAssertionRequest(challenge: makeChallenge())
        performRequests([request])
    }

    // MARK: - Register

    func registerPasskey(username: String) {
        guard !username.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter a username to create a passkey."
            return
        }
        isLoading = true
        errorMessage = nil
        let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(
            relyingPartyIdentifier: relyingPartyID
        )
        let request = provider.createCredentialRegistrationRequest(
            challenge: makeChallenge(),
            name: username,
            userID: withUnsafeBytes(of: UUID().uuid) { Data($0) }  // opaque 16-byte ID
        )
        performRequests([request])
    }

    // MARK: - Private

    private func performRequests(_ requests: [ASAuthorizationRequest]) {
        let controller = ASAuthorizationController(authorizationRequests: requests)
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    private func makeChallenge() -> Data {
        var bytes = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        return Data(bytes)
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension PasskeyAuthManager: ASAuthorizationControllerDelegate {

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        isLoading = false
        isAuthenticated = true
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        isLoading = false
        guard let authError = error as? ASAuthorizationError else {
            errorMessage = error.localizedDescription
            return
        }
        switch authError.code {
        case .canceled:
            break
        case .notHandled:
            errorMessage = "No passkey found for this device. Tap \"Create Account with Passkey\" to register first."
        case .failed:
            errorMessage = "Passkey unavailable. Add the Associated Domains entitlement (webcredentials:kumele.com) in Xcode and serve the AASA file at kumele.com. Use Demo Mode to continue."
        case .invalidResponse:
            errorMessage = "Invalid passkey response. Please try again."
        case .notInteractive:
            errorMessage = "Passkey authentication requires user interaction."
        default:
            errorMessage = "Passkey error (\(authError.code.rawValue)): \(authError.localizedDescription)"
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension PasskeyAuthManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        if let w = scenes.flatMap(\.windows).first(where: \.isKeyWindow) { return w }
        if let w = scenes.flatMap(\.windows).first { return w }
        guard let scene = scenes.first else { fatalError("No UIWindowScene available.") }
        return ASPresentationAnchor(windowScene: scene)
    }
}
