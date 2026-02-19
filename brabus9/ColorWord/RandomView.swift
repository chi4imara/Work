import SwiftUI

struct RandomView: View {
    @ObservedObject var viewModel: CatalogViewModel
    @State private var currentRandomItem: CatalogItem?
    @State private var animateContent = false
    @State private var viewCount: Int = 0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Random")
                            .font(.ubuntu(32, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        if !viewModel.items.isEmpty {
                            Text("\(viewModel.items.count) items in catalog")
                                .font(.ubuntu(12, weight: .regular))
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        if !viewModel.items.isEmpty {
                            RandomStatsBadge(viewCount: viewCount)
                        }
                        
                        if !viewModel.items.isEmpty {
                            Button(action: {
                                showAnotherItem()
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(AppColors.buttonBackground)
                                        .frame(width: 44, height: 44)
                                    
                                    Image(systemName: "shuffle")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(AppColors.buttonText)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.items.isEmpty {
                    RandomEmptyStateView()
                    
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            RandomContentView(
                                currentItem: currentRandomItem,
                                animateContent: animateContent
                            )
                            
                            if let item = currentRandomItem {
                                RandomItemDetailsCard(item: item)
                            }
                            
                            RandomStatsCard(
                                totalItems: viewModel.items.count,
                                viewCount: viewCount
                            )
                            
                            RandomTipsCard()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .onAppear {
            if currentRandomItem == nil {
                showAnotherItem()
            }
        }
    }
    
    private func showAnotherItem() {
        withAnimation(.easeInOut(duration: 0.3)) {
            animateContent = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            currentRandomItem = viewModel.getRandomItem()
            viewCount += 1
            
            withAnimation(.easeInOut(duration: 0.3)) {
                animateContent = true
            }
        }
    }
}

struct RandomStatsBadge: View {
    let viewCount: Int
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "eye.fill")
                .font(.system(size: 12))
                .foregroundColor(AppColors.accent)
            
            Text("\(viewCount)")
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(AppColors.accent)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(AppColors.accent.opacity(0.2))
        )
    }
}

struct RandomEmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "shuffle.circle")
                .font(.system(size: 60))
                .foregroundColor(AppColors.accent)
            
            Text("Add at least one item to see a random one.")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct RandomContentView: View {
    let currentItem: CatalogItem?
    let animateContent: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            if let item = currentItem {
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        AppColors.accent.opacity(0.3),
                                        AppColors.accent.opacity(0.1),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 60
                                )
                            )
                            .frame(width: 120, height: 120)
                            .scaleEffect(animateContent ? 1.0 : 0.8)
                            .opacity(animateContent ? 1.0 : 0.0)
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 50))
                            .foregroundColor(AppColors.accent)
                            .scaleEffect(animateContent ? 1.0 : 0.8)
                            .opacity(animateContent ? 1.0 : 0.0)
                    }
                    
                    VStack(spacing: 16) {
                        Text(item.text)
                            .font(.ubuntu(24, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.center)
                            .lineSpacing(8)
                            .padding(28)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                AppColors.cardBackground,
                                                AppColors.cardBackground.opacity(0.7)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        AppColors.accent.opacity(0.4),
                                                        AppColors.cardBorder
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1.5
                                            )
                                    )
                            )
                            .scaleEffect(animateContent ? 1.0 : 0.9)
                            .opacity(animateContent ? 1.0 : 0.0)
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: animateContent)
    }
}

struct RandomItemDetailsCard: View {
    let item: CatalogItem
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.accent)
                
                Text("Item Details")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Created")
                            .font(.ubuntu(12, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                        
                        HStack(spacing: 6) {
                            Image(systemName: "calendar")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.accent)
                            
                            Text(item.dateCreated, style: .date)
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Time")
                            .font(.ubuntu(12, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                        
                        HStack(spacing: 6) {
                            Image(systemName: "clock")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.accent)
                            
                            Text(item.dateCreated, style: .time)
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                        }
                    }
                }
                
                Divider()
                    .background(AppColors.cardBorder)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Characters")
                            .font(.ubuntu(12, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text("\(item.text.count)")
                            .font(.ubuntu(16, weight: .bold))
                            .foregroundColor(AppColors.accent)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Words")
                            .font(.ubuntu(12, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text("\(item.text.split(separator: " ").count)")
                            .font(.ubuntu(16, weight: .bold))
                            .foregroundColor(AppColors.accent)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct RandomStatsCard: View {
    let totalItems: Int
    let viewCount: Int
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.accent)
                
                Text("Statistics")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("\(totalItems)")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.accent)
                    
                    Text("Total Items")
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: 50)
                    .background(AppColors.cardBorder)
                
                VStack(spacing: 8) {
                    Text("\(viewCount)")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.lightGreen)
                    
                    Text("Views")
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct RandomTipsCard: View {
    @State private var currentTip = 0
    
    private let tips = [
        "Each random view helps you rediscover your collection",
        "Your catalog grows with every item you save",
        "No two random views are the same",
        "Take time to appreciate each discovery",
        "Random moments can spark new memories"
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.accent)
                
                Text("Tip")
                    .font(.ubuntu(14, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            Text(tips[currentTip])
                .font(.ubuntu(13, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(AppColors.cardBackground.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(AppColors.cardBorder.opacity(0.5), lineWidth: 1)
                )
        )
        .onAppear {
            currentTip = Int.random(in: 0..<tips.count)
        }
    }
}

#Preview {
    RandomView(viewModel: CatalogViewModel())
}
