import SwiftUI

struct ExtraView: View {
    @ObservedObject var catalogViewModel: CatalogViewModel
    @State private var showStats = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 30) {
                HStack {
                    Text("Extra")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 20) {
                        StatsCard(catalogViewModel: catalogViewModel)
                        
                        VStack(spacing: 12) {
                            Text("Quick Actions")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 12) {
                                QuickActionCard(
                                    icon: "plus.circle.fill",
                                    title: "Add Item",
                                    color: AppColors.accent
                                ) {
                                }
                                
                                QuickActionCard(
                                    icon: "shuffle.circle.fill",
                                    title: "Random",
                                    color: AppColors.softPink
                                ) {
                                }
                            }
                        }
                        
                        InspirationCard()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                
                Spacer()
            }
        }
    }
}

struct StatsCard: View {
    @ObservedObject var catalogViewModel: CatalogViewModel
    
    private var totalItems: Int {
        catalogViewModel.items.count
    }
    
    private var recentItems: Int {
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return catalogViewModel.items.filter { $0.dateCreated >= oneWeekAgo }.count
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Your Collection")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 20) {
                StatItem(
                    number: "\(totalItems)",
                    label: "Total Items",
                    color: AppColors.accent
                )
                
                StatItem(
                    number: "\(recentItems)",
                    label: "This Week",
                    color: AppColors.lightGreen
                )
                
                StatItem(
                    number: totalItems > 0 ? "✓" : "○",
                    label: "Started",
                    color: AppColors.lavender
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct StatItem: View {
    let number: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(number)
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(color)
            
            Text(label)
                .font(.ubuntu(12, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

struct QuickActionCard: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct InspirationCard: View {
    private let inspirations = [
        "Collect moments, not things",
        "Your taste is uniquely yours",
        "Small details make big memories",
        "Beauty is in the eye of the beholder"
    ]
    
    @State private var currentInspiration = 0
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "quote.bubble")
                .font(.system(size: 32))
                .foregroundColor(AppColors.accent)
            
            Text(inspirations[currentInspiration])
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
                .italic()
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
        .onTapGesture {
            withAnimation(.easeInOut) {
                currentInspiration = (currentInspiration + 1) % inspirations.count
            }
        }
        .onAppear {
            startInspirationTimer()
        }
    }
    
    private func startInspirationTimer() {
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            withAnimation(.easeInOut) {
                currentInspiration = (currentInspiration + 1) % inspirations.count
            }
        }
    }
}

#Preview {
    ExtraView(catalogViewModel: CatalogViewModel())
}
