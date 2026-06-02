//
//  HomeView.swift
//  KumeleAssignment
//
//  Created by Ganesh Raju Galla on 02/06/26.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.ignoresSafeArea()
            tabContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, 83)
            KumeleTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
    }

    @ViewBuilder
    var tabContent: some View {
        switch selectedTab {
        case 0:  SwipeView()
        case 1:  PlaceholderView(icon: "newspaper.fill",       title: "Blog")
        case 2:  PlaceholderView(icon: "bag.fill",             title: "Shop")
        case 3:  PlaceholderView(icon: "square.grid.2x2.fill", title: "More")
        case 4:  PlaceholderView(icon: "person.fill",          title: "Profile")
        default: SwipeView()
        }
    }
}

// MARK: - Tab Bar

struct KumeleTabBar: View {
    @Binding var selectedTab: Int

    private let items: [(icon: String, label: String)] = [
        ("house.fill",            "Home"),
        ("person.2.fill",         "Blog"),
        ("bag.fill",              "Shop"),
        ("square.grid.2x2.fill",  "More"),
        ("person.fill",           "Profile"),
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(items.indices, id: \.self) { tabItem(index: $0) }
        }
        .padding(.top, 12)
        .padding(.bottom, 28)
        .background(Color(white: 0.055))
        .overlay(Rectangle().frame(height: 0.5).foregroundStyle(Color.white.opacity(0.08)),
                 alignment: .top)
    }

    func tabItem(index: Int) -> some View {
        let active = selectedTab == index
        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) { selectedTab = index }
        } label: {
            VStack(spacing: 5) {
                ZStack {
                    if active {
                        Circle()
                            .fill(Color(red: 0.22, green: 0.38, blue: 0.95))
                            .frame(width: 44, height: 44)
                    }
                    Image(systemName: items[index].icon)
                        .font(.system(size: active ? 20 : 18, weight: .medium))
                        .foregroundStyle(active ? .white : Color(white: 0.55))
                }
                .frame(width: 44, height: 44)
                Text(items[index].label)
                    .font(.system(size: 10, weight: active ? .semibold : .regular))
                    .foregroundStyle(active ? .white : Color(white: 0.55))
            }
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(.plain)
    }
}

// MARK: - Placeholder

struct PlaceholderView: View {
    let icon: String
    let title: String

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 48))
                    .foregroundStyle(Color.kumeleYellow)
                Text(title)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview { HomeView() }
