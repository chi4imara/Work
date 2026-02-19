import SwiftUI

struct WearingView: View {
    @ObservedObject var viewModel: WatchViewModel
    @State private var selectedWatch: Watch?
    @State private var showingWatchDetails = false
    @State private var expandedWatchId: UUID?
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Wearing")
                    .font(.playfairDisplay(size: 32, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                
                if viewModel.getAllWearingDays().isEmpty {
                    VStack(spacing: 30) {
                        Image(systemName: "chart.bar.xaxis")
                            .font(.system(size: 80, weight: .thin))
                            .foregroundColor(ColorManager.secondaryText)
                        
                        Text("No wearing information.")
                            .font(.playfairDisplay(size: 18, weight: .medium))
                            .foregroundColor(ColorManager.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.getWatchesWithWearingDays(), id: \.watch.id) { watchData in
                                WearingStatsCard(
                                    watch: watchData.watch,
                                    wearingCount: watchData.count,
                                    isExpanded: expandedWatchId == watchData.watch.id,
                                    onToggleExpand: {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            if expandedWatchId == watchData.watch.id {
                                                expandedWatchId = nil
                                            } else {
                                                expandedWatchId = watchData.watch.id
                                            }
                                        }
                                    },
                                    onOpenWatch: {
                                        selectedWatch = watchData.watch
                                        showingWatchDetails = true
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(item: $selectedWatch) { watch in
            WatchDetailsView(
                watch: watch,
                viewModel: viewModel,
                isPresented: $showingWatchDetails
            )
        }
    }
}

struct WearingStatsCard: View {
    let watch: Watch
    let wearingCount: Int
    let isExpanded: Bool
    let onToggleExpand: () -> Void
    let onOpenWatch: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button(action: onToggleExpand) {
                HStack(spacing: 16) {
                    Image(systemName: "applewatch")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(ColorManager.lightBlue)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(ColorManager.lightBlue.opacity(0.2))
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(watch.name)
                            .font(.playfairDisplay(size: 16, weight: .semibold))
                            .foregroundColor(ColorManager.primaryText)
                            .lineLimit(1)
                        
                        Text("\(wearingCount) wearing day\(wearingCount == 1 ? "" : "s")")
                            .font(.playfairDisplay(size: 14, weight: .regular))
                            .foregroundColor(ColorManager.secondaryText)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(ColorManager.lightBlue)
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()
                        .background(ColorManager.lightBlue.opacity(0.3))
                    
                    Text("Wearing History")
                        .font(.playfairDisplay(size: 14, weight: .semibold))
                        .foregroundColor(ColorManager.accentText)
                    
                    LazyVStack(spacing: 8) {
                        ForEach(watch.wearingDays.sorted(by: { $0.date > $1.date })) { wearingDay in
                            WearingDateRow(
                                wearingDay: wearingDay,
                                onOpen: onOpenWatch
                            )
                        }
                    }
                    
                    Button(action: onOpenWatch) {
                        HStack {
                            Text("Open Watch Details")
                                .font(.playfairDisplay(size: 14, weight: .semibold))
                                .foregroundColor(ColorManager.white)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(ColorManager.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .background(
                            LinearGradient(
                                colors: [ColorManager.lightBlue, ColorManager.orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(18)
                    }
                }
            }
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct WearingDateRow: View {
    let wearingDay: WearingDay
    let onOpen: () -> Void
    
    var body: some View {
        Button(action: onOpen) {
            HStack {
                Image(systemName: "calendar")
                    .font(.system(size: 12))
                    .foregroundColor(ColorManager.lightBlue)
                
                Text(formatDate(wearingDay.date))
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                Text("Open")
                    .font(.playfairDisplay(size: 12, weight: .medium))
                    .foregroundColor(ColorManager.lightBlue)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(ColorManager.lightBlue.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    WearingView(viewModel: WatchViewModel())
}
