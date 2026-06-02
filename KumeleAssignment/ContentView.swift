//
//  ContentView.swift
//  KumeleAssignment
//
//  Created by Ganesh Raju Galla on 02/06/26.
//

import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false

    var body: some View {
        Group {
            if isAuthenticated {
                HomeView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .opacity
                    ))
            } else {
                LoginView(isAuthenticated: $isAuthenticated)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: isAuthenticated)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
