//
//  SwipeView.swift
//  KumeleAssignment
//
//  Created by Ganesh Raju Galla on 02/06/26.
//

import SwiftUI

// MARK: - Model

struct EventCard: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let categoryIcon: String
    let price: String
    let timeRange: String
    let guests: String
    let location: String
    let startsIn: String
    let imageName: String?
    let accentColor: Color
}

private let sampleCards: [EventCard] = [
    EventCard(
        title: "Live show event updated",
        category: "Pet Love",
        categoryIcon: "pawprint.fill",
        price: "100.0", timeRange: "23:59–0:0", guests: "24 guests",
        location: "Indore, Madhya radesh, IN", startsIn: "7 hrs",
        imageName: nil, accentColor: .kumeleYellow
    ),
    EventCard(
        title: "www show event",
        category: "Pet Love",
        categoryIcon: "pawprint.fill",
        price: "100.0", timeRange: "23:59–0:0", guests: "24 guests",
        location: "Indore, Madhya radesh, IN", startsIn: "7 hrs",
        imageName: nil, accentColor: .kumeleYellow
    ),
    EventCard(
        title: "Sunset Music Festival",
        category: "Music",
        categoryIcon: "music.note",
        price: "250.0", timeRange: "18:00–22:0", guests: "120 guests",
        location: "Mumbai, Maharashtra, IN", startsIn: "3 hrs",
        imageName: nil, accentColor: .orange
    ),
    EventCard(
        title: "Morning Yoga Session",
        category: "Wellness",
        categoryIcon: "figure.yoga",
        price: "50.0", timeRange: "06:00–07:30", guests: "12 guests",
        location: "Mumbai, Maharashtra, IN", startsIn: "3 hrs",
        imageName: nil, accentColor: .purple
    ),
    EventCard(
        title: "Street Photography Walk",
        category: "Creative",
        categoryIcon: "camera.fill",
        price: "Free", timeRange: "10:00–13:00", guests: "8 guests",
        location: "Bangalore, Karnataka, IN", startsIn: "5 hrs",
        imageName: nil, accentColor: .blue
    ),
]

// MARK: - Swipe View

struct SwipeView: View {
    @State private var cards = sampleCards
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false

    private let swipeThreshold: CGFloat = 100
    private let maxVisible = 3

    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 0.10, green: 0.09, blue: 0.10).ignoresSafeArea()
            if cards.isEmpty { emptyState } else { cardStack }
        }
    }

    // MARK: - Card Stack

    private var cardStack: some View {
        GeometryReader { geo in
            let progress = min(abs(dragOffset) / geo.size.width, 1)
            let imgH = min(500, max(220, geo.size.height - 258))

            ZStack(alignment: .top) {
                ForEach(Array(cards.prefix(maxVisible).enumerated().reversed()), id: \.element.id) { index, card in
                    if index == 0 {
                        EventCardView(card: card, imageHeight: imgH)
                            .frame(width: geo.size.width - 32)
                            .offset(x: dragOffset)
                            .rotationEffect(topCardRotation(geo: geo), anchor: .bottom)
                            .zIndex(10)
                            .contentShape(Rectangle())
                            .gesture(dragGesture(geo: geo))
                            .animation(
                                isDragging
                                    ? .interactiveSpring(response: 0.3, dampingFraction: 0.8)
                                    : .spring(response: 0.42, dampingFraction: 0.76),
                                value: dragOffset
                            )
                    } else {
                        let bgProgress: CGFloat = index == 1 ? progress : 0
                        EventCardView(card: card, imageHeight: imgH)
                            .opacity(Double(bgProgress))
                            .frame(width: geo.size.width - 48)
                            .background(
                                RoundedRectangle(cornerRadius: index == 1 ? 26 : 34, style: .continuous)
                                    .fill(Color(white: index == 1 ? 0.65 : 0.28))
                                    .opacity(1 - Double(bgProgress))
                            )
                            .scaleEffect(bgScale(index: index, progress: progress), anchor: .top)
                            .offset(x: 0, y: bgOffsetY(index: index, progress: progress))
                            .zIndex(Double(10 - index))
                            .allowsHitTesting(false)
                            .animation(.spring(response: 0.42, dampingFraction: 0.76), value: dragOffset)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack {
            Spacer()
            Button {
                withAnimation(.spring(response: 0.5)) {
                    cards = sampleCards
                    dragOffset = 0
                }
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.kumeleYellow)
            }
            .buttonStyle(.plain)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Layout Helpers

    private func topCardRotation(geo: GeometryProxy) -> Angle {
        .degrees(Double(dragOffset / (geo.size.width * 0.8)) * 14.0)
    }

    private func bgOffsetY(index: Int, progress: CGFloat) -> CGFloat {
        let base: CGFloat = index == 1 ? 76 : 134
        return index == 1 ? base * (1 - progress) : base
    }

    private func bgScale(index: Int, progress: CGFloat) -> CGFloat {
        let min = 1 - CGFloat(index) * 0.06
        return index == 1 ? min + (1 - min) * progress : min
    }

    // MARK: - Drag Gesture

    private func dragGesture(geo: GeometryProxy) -> some Gesture {
        DragGesture(minimumDistance: 4)
            .onChanged { value in
                isDragging = true
                dragOffset = value.translation.width
            }
            .onEnded { value in
                isDragging = false
                let commit = abs(dragOffset) > swipeThreshold || abs(value.predictedEndTranslation.width) > 450
                if commit, !cards.isEmpty {
                    let dir: CGFloat = dragOffset < 0 ? -1 : 1
                    withAnimation(.spring(response: 0.34, dampingFraction: 0.68)) {
                        dragOffset = dir * (geo.size.width + 300)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.34) {
                        guard !cards.isEmpty else { return }
                        cards.removeFirst()
                        dragOffset = 0
                    }
                } else {
                    withAnimation(.spring(response: 0.40, dampingFraction: 0.72)) {
                        dragOffset = 0
                    }
                }
            }
    }
}

// MARK: - Event Card View

struct EventCardView: View {
    let card: EventCard
    var imageHeight: CGFloat = 300

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                cardImage
                categoryPill
            }
            .frame(maxWidth: .infinity)
            .frame(height: imageHeight)
            .clipped()
            infoSection
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.55), radius: 20, x: 0, y: 10)
    }

    @ViewBuilder
    private var cardImage: some View {
        if let name = card.imageName {
            Image(name)
                .resizable()
                .scaledToFill()
        } else {
            LinearGradient(
                colors: [card.accentColor, Color(white: 0.08)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    private var categoryPill: some View {
        HStack(spacing: 6) {
            Image(systemName: card.categoryIcon).font(.system(size: 11, weight: .bold))
            Text(card.category).font(.system(size: 13, weight: .semibold))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Capsule().fill(.black.opacity(0.75)))
        .padding(.top, 14)
        .padding(.trailing, 14)
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(card.title)
                .font(.system(size: 19, weight: .bold))
                .foregroundStyle(.white)

            HStack(spacing: 16) {
                Label(card.price,     systemImage: "dollarsign.circle.fill").foregroundStyle(card.accentColor)
                Label(card.timeRange, systemImage: "clock.fill").foregroundStyle(.white)
                Label(card.guests,    systemImage: "person.2.fill").foregroundStyle(.white)
            }
            .font(.system(size: 13, weight: .semibold))
            .lineLimit(1)

            HStack(spacing: 4) {
                Text("Location:").foregroundStyle(.white)
                Text(card.location).foregroundStyle(card.accentColor)
            }
            .font(.system(size: 14))

            HStack(spacing: 4) {
                Text("Starts in").foregroundStyle(.white)
                Label(card.startsIn, systemImage: "clock").foregroundStyle(card.accentColor)
            }
            .font(.system(size: 14))
        }
        .padding(.horizontal, 18)
        .padding(.top, 18)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black)
        .overlay(alignment: .bottomTrailing) {
            Button {} label: {
                Image(systemName: "checkmark")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(Circle().fill(Color(white: 0.36)))
            }
            .padding(.bottom, 18)
            .padding(.trailing, 16)
        }
    }
}

// MARK: - Theme

extension Color {
    static let kumeleYellow = Color(red: 0.97, green: 0.80, blue: 0.08)
    static let kumeleCorals = Color(red: 0.97, green: 0.45, blue: 0.28)
}

#Preview { SwipeView() }
