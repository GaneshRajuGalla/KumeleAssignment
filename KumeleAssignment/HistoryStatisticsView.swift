//
//  HistoryStatisticsView.swift
//  KumeleAssignment
//
//  Created by Ganesh Raju Galla on 02/06/26.
//

import SwiftUI
import Charts

// MARK: - Models

struct FMonthBar: Identifiable {
    let id = UUID()
    let month: String
    let value: Double
}

struct FPieSlice: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
    let color: Color
}

private let barData: [FMonthBar] = [
    .init(month: "Mar", value: 127.72),
    .init(month: "Apr", value:  83.19),
    .init(month: "May", value: 134.75),
    .init(month: "Jun", value: 114.83),
    .init(month: "Jul", value:  48.04),
    .init(month: "Aug", value: 144.12),
    .init(month: "Sep", value:  80.85),
    .init(month: "Oct", value: 140.61),
    .init(month: "Nov", value:  92.57),
]

private let pieData: [FPieSlice] = [
    .init(label: "Gold",   value: 12, color: Color(red: 0.871, green: 0.718, blue: 0.059)),
    .init(label: "Silver", value:  8, color: Color(red: 0.678, green: 0.663, blue: 0.592)),
    .init(label: "Bronze", value:  4, color: Color(red: 0.804, green: 0.498, blue: 0.196)),
]

private let medalRows: [(name: String, pill: Color, achieved: String)] = [
    ("Gold",   Color(red: 0.871, green: 0.718, blue: 0.059), "Achieved 22 medals"),
    ("Silver", Color(red: 0.769, green: 0.769, blue: 0.769), "Achieved 1 medal"),
    ("Bronze", Color(red: 0.804, green: 0.498, blue: 0.196), "Achieved 1 medal"),
]

// MARK: - View

struct HistoryStatisticsView: View {

    @State private var barsVisible     = false
    @State private var pieVisible      = false
    @State private var medalPop: String? = nil
    @State private var medalAngle: Double = -12
    @State private var activeSidebarIcon = 5
    @State private var selectedYear    = 2022

    private let years = [2020, 2021, 2022, 2023]
    @Namespace private var pillNS

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(red: 0.941, green: 0.941, blue: 0.941).ignoresSafeArea()

                VStack(spacing: 0) {
                    topBar
                    HStack(spacing: 0) {
                        sidebar
                        contentArea(geo: geo)
                    }
                }

                if let medal = medalPop {
                    medalInfoPopup(name: medal)
                }
            }
        }
        .preferredColorScheme(.light)
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.3)) { pieVisible = true }
            withAnimation(.spring(response: 1.1, dampingFraction: 0.75).delay(0.5)) { barsVisible = true }
            withAnimation(.easeInOut(duration: 0.55).repeatForever(autoreverses: true)) { medalAngle = 12 }
        }
    }

    // MARK: Sidebar

    private var sidebar: some View {
        let icons = ["icon_home", "icon_bookshelf", "icon_basket",
                     "icon_account1", "icon_account2", "icon_events",
                     "icon_account3", "icon_buy"]

        return ZStack(alignment: .leading) {
            Color.white
                .overlay(
                    Rectangle().frame(width: 0.5)
                        .foregroundStyle(Color(red: 0.812, green: 0.812, blue: 0.812)),
                    alignment: .trailing
                )

            VStack(spacing: 0) {
                ForEach(icons.indices, id: \.self) { i in
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            activeSidebarIcon = i
                        }
                    } label: {
                        Image(icons[i])
                            .resizable().scaledToFit()
                            .frame(width: 24, height: 24)
                            .opacity(activeSidebarIcon == i ? 1.0 : 0.55)
                    }
                    .buttonStyle(.plain)
                    .frame(width: 70, height: 54)
                    .overlay(alignment: .leading) {
                        if activeSidebarIcon == i {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color(red: 0, green: 0.302, blue: 1.0))
                                .frame(width: 4, height: 50)
                                .matchedGeometryEffect(id: "pill", in: pillNS)
                        }
                    }
                }
                Spacer()
            }
            .padding(.top, 12)
        }
        .frame(width: 70)
    }

    // MARK: Top Bar

    private var topBar: some View {
        ZStack {
            Color.white
            HStack {
                Image("kumele_logo_bar")
                    .resizable().scaledToFit()
                    .frame(height: 28)
                    .padding(.leading, 20)
                Spacer()
                Image("user_avatar")
                    .resizable().scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding(.trailing, 20)
            }
        }
        .frame(height: 70)
        .overlay(
            Rectangle().frame(height: 0.5)
                .foregroundStyle(Color(red: 0.878, green: 0.878, blue: 0.878)),
            alignment: .bottom
        )
    }

    // MARK: Content Area

    private func contentArea(geo: GeometryProxy) -> some View {
        whiteCard
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private var whiteCard: some View {
        VStack(spacing: 0) {
            HStack {
                Text("History & Statistics")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.black)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)

            Rectangle()
                .fill(Color(red: 0.918, green: 0.918, blue: 0.918))
                .frame(height: 1)

            HStack(alignment: .top, spacing: 0) {
                leftPanel
                    .frame(maxWidth: .infinity)
                    .padding(.leading, 25)
                    .padding(.top, 25)
                    .padding(.bottom, 25)

                rightPanel
                    .frame(maxWidth: .infinity)
                    .padding(.top, 25)
                    .padding(.trailing, 25)
                    .padding(.bottom, 25)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    // MARK: Left Panel

    private var leftPanel: some View {
        VStack(alignment: .leading, spacing: 32) {
            HStack(spacing: 10) {
                Text("Reward Rings")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(.black)

                Image("medal_frame")
                    .resizable().scaledToFit()
                    .frame(width: 44, height: 44)
                    .rotationEffect(.degrees(medalAngle))
            }

            HStack(alignment: .top, spacing: 49) {
                Chart(pieData) { slice in
                    SectorMark(
                        angle: .value("Value", slice.value),
                        innerRadius: .ratio(0)
                    )
                    .foregroundStyle(slice.color)
                }
                .frame(width: 188, height: 188)
                .scaleEffect(pieVisible ? 1 : 0.05)
                .animation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.3), value: pieVisible)

                VStack(alignment: .leading, spacing: 22) {
                    ForEach(medalRows, id: \.name) { row in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 11) {
                                RoundedRectangle(cornerRadius: 13)
                                    .fill(row.pill)
                                    .frame(width: 27, height: 27)
                                Text(row.name)
                                    .font(.system(size: 20, weight: .regular))
                                    .foregroundStyle(.black)
                                Button {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                        medalPop = row.name
                                    }
                                } label: {
                                    Image("icon_info")
                                        .resizable().scaledToFit()
                                        .frame(width: 15, height: 15)
                                }
                                .buttonStyle(.plain)
                            }
                            Text(row.achieved)
                                .font(.system(size: 16))
                                .foregroundStyle(Color(red: 0.149, green: 0.149, blue: 0.149))
                                .padding(.leading, 38)
                        }
                    }
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: Right Panel

    private var rightPanel: some View {
        VStack(alignment: .leading, spacing: 19) {
            HStack(alignment: .center) {
                Text("Money Earned")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.black)
                Text("$905")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.black)
                Spacer()
                Menu {
                    ForEach(years, id: \.self) { year in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) { selectedYear = year }
                        } label: {
                            HStack {
                                Text(String(year))
                                if year == selectedYear {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 5) {
                        Text(String(selectedYear))
                            .font(.system(size: 15))
                            .foregroundStyle(.black)
                        Image(systemName: "checkmark")
                            .font(.caption.bold())
                            .foregroundStyle(Color(white: 0.35))
                    }
                    .padding(.horizontal, 11).padding(.vertical, 7)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(white: 0.78), lineWidth: 1)
                    )
                }
                .menuStyle(.borderlessButton)
            }

            barChart
            Spacer()
        }
    }

    // MARK: Bar Chart

    private var barChart: some View {
        Chart(barData) { bar in
            BarMark(
                x: .value("Month", bar.month),
                y: .value("Value", barsVisible ? bar.value : 0)
            )
            .foregroundStyle(bar.month == "Jun"
                ? Color(red: 0.871, green: 0.718, blue: 0.059)
                : Color(red: 0, green: 0.302, blue: 1.0))
            .cornerRadius(7, style: .continuous)
            .annotation(position: .top, alignment: .center, spacing: 0) {
                barAnnotation(for: bar.month)
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { _ in
                AxisValueLabel()
                    .font(.system(size: 12))
                    .foregroundStyle(Color.black)
            }
        }
        .chartYAxis(.hidden)
        .allowsHitTesting(false)
        .frame(maxWidth: .infinity)
        .frame(height: 260)
        .animation(.spring(response: 1.1, dampingFraction: 0.75).delay(0.5), value: barsVisible)
    }

    @ViewBuilder
    private func barAnnotation(for month: String) -> some View {
        if month == "Jun" {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("90's Hip-Hop")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.primary)
                    HStack(spacing: 4) {
                        Text("$100")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(.secondary)
                        Image("icon_party")
                            .resizable().scaledToFit()
                            .frame(width: 12, height: 12)
                        Text("House Party")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 2)

                Circle()
                    .fill(Color.secondary.opacity(0.4))
                    .frame(width: 4, height: 4)
                    .padding(.top, 4)
            }
        }
    }

    // MARK: Medal Info Popup

    private func medalInfoPopup(name: String) -> some View {
        let row = medalRows.first { $0.name == name }!
        let info: String = {
            switch name {
            case "Gold":   return "Top-tier achievement — less than 5% of users reach Gold."
            case "Silver": return "Consistent achiever across 3+ months of events."
            default:       return "First milestone — attend your first paid event."
            }
        }()

        return ZStack {
            Color.black.opacity(0.30).ignoresSafeArea()
                .onTapGesture { withAnimation(.spring()) { medalPop = nil } }

            VStack(spacing: 18) {
                HStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(row.pill)
                        .frame(width: 30, height: 30)
                    Text("\(name) Medal")
                        .font(.headline)
                    Spacer()
                    Button { withAnimation(.spring()) { medalPop = nil } } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color(white: 0.65))
                    }
                    .buttonStyle(.plain)
                }
                Text(row.achieved)
                    .font(.subheadline.bold())
                    .foregroundStyle(row.pill)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(info)
                    .font(.subheadline)
                    .foregroundStyle(Color(white: 0.42))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineSpacing(3)
                Button { withAnimation(.spring()) { medalPop = nil } } label: {
                    Text("Got it")
                        .font(.subheadline.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(row.pill)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }
            .padding(22)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.14), radius: 24)
            .frame(maxWidth: 340)
            .padding(.horizontal, 28)
            .transition(.scale(scale: 0.88).combined(with: .opacity))
        }
    }
}

#Preview("iPad 11-inch") {
    HistoryStatisticsView()
        .frame(width: 1194, height: 834)
}
