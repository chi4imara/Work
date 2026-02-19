import SwiftUI

struct TodayView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingAddItem = false
    @State private var showingAddOutfit = false
    @State private var celebrationAnimation = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    HeaderView()
                    
                    DailyProgressCard()
                    
                    WardrobeSection()
                    
                    OutfitsSection()
                    
                    DailyChallengeCard()
                    
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .sheet(isPresented: $showingAddItem) {
            AddWardrobeItemView()
                .environmentObject(appState)
        }
        .sheet(isPresented: $showingAddOutfit) {
            AddOutfitView()
                .environmentObject(appState)
        }
        .overlay(
            celebrationAnimation ? CelebrationView() : nil
        )
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(appState.greetingForTimeOfDay())
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("What outfit today?")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Circle()
                    .fill(AppColors.yellow)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppColors.accentText)
                    )
            }
        }
    }
    
    @ViewBuilder
    private func DailyProgressCard() -> some View {
        VStack(spacing: 16) {
            HStack {
                Text("Today's Progress")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                if let progress = appState.todaysProgress {
                    Text(progress.progressDescription)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.yellow)
                }
            }
            
            if let progress = appState.todaysProgress {
                ProgressRingView(progress: progress.totalProgress)
            }
        }
        .padding(20)
        .cardStyle()
    }
    
    @ViewBuilder
    private func WardrobeSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Wardrobe")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button(action: { showingAddItem = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.yellow)
                }
            }
            
            if appState.wardrobeItems.isEmpty {
                EmptyStateView(
                    icon: "tshirt",
                    title: "No Items Yet",
                    description: "Start with one item - it's already a step to the perfect look",
                    actionTitle: "Add First Item",
                    action: { showingAddItem = true }
                )
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    ForEach(appState.wardrobeItems.prefix(4)) { item in
                        WardrobeItemCard(itemId: item.id)
                    }
                    
                    if appState.wardrobeItems.count > 4 {
                        Button(action: { appState.selectedTab = .wardrobe }) {
                            VStack {
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 24))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text("View All")
                                    .font(.ubuntu(12, weight: .medium))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            .frame(height: 100)
                            .frame(maxWidth: .infinity)
                            .cardStyle()
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func OutfitsSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Created Outfits")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button(action: { showingAddOutfit = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.yellow)
                }
            }
            
            if appState.outfits.isEmpty {
                EmptyStateView(
                    icon: "person",
                    title: "No Outfits Yet",
                    description: "Create your first outfit combination",
                    actionTitle: "Create Outfit",
                    action: { showingAddOutfit = true }
                )
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(appState.outfits) { outfit in
                            OutfitCard(outfitId: outfit.id) {
                                withAnimation(.spring()) {
                                    if let o = appState.outfit(byId: outfit.id) {
                                        appState.markOutfitAsWorn(o)
                                    }
                                    showCelebration()
                                }
                            }
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, -20)
            }
        }
    }
    
    @ViewBuilder
    private func DailyChallengeCard() -> some View {
        if let challenge = appState.todaysChallenge {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: challenge.type.icon)
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.yellow)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Mini-Challenge")
                            .font(.ubuntu(16, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text(challenge.title)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                    
                    if challenge.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppColors.green)
                    }
                }
                
                Text(challenge.description)
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(nil)
                
                if !challenge.isCompleted {
                    Button("I Did It!") {
                        withAnimation(.spring()) {
                            appState.completeChallenge(challenge.id)
                            showCelebration()
                        }
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
            }
            .padding(20)
            .cardStyle()
        }
    }
    
    private func showCelebration() {
        withAnimation(.easeInOut(duration: 0.5)) {
            celebrationAnimation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.5)) {
                celebrationAnimation = false
            }
        }
    }
}

struct ProgressRingView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColors.primaryText.opacity(0.2), lineWidth: 8)
                .frame(width: 80, height: 80)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    LinearGradient(
                        colors: [AppColors.yellow, AppColors.pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 80, height: 80)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1), value: progress)
            
            Text("\(Int(progress * 100))%")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(AppColors.primaryText)
        }
    }
}

struct WardrobeItemCard: View {
    let itemId: UUID
    @EnvironmentObject var appState: AppState
    
    private var item: WardrobeItem? {
        appState.wardrobeItem(byId: itemId)
    }
    
    var body: some View {
        Group {
            if let item = item {
                VStack(spacing: 8) {
                    Image(systemName: item.category.icon)
                        .font(.system(size: 32))
                        .foregroundColor(AppColors.yellow)
                        .frame(height: 50)
                    
                    Text(item.name)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
                .padding(12)
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .cardStyle()
            }
        }
    }
}

struct OutfitCard: View {
    let outfitId: UUID
    let onWear: () -> Void
    @EnvironmentObject var appState: AppState
    
    private var outfit: Outfit? {
        appState.outfit(byId: outfitId)
    }
    
    var body: some View {
        Group {
            if let outfit = outfit {
                VStack(spacing: 12) {
                    HStack(spacing: 4) {
                        ForEach(outfit.items.prefix(3)) { item in
                            Image(systemName: item.category.icon)
                                .font(.system(size: 16))
                                .foregroundColor(AppColors.yellow)
                        }
                    }
                    .frame(height: 40)
                    
                    Text(outfit.name)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    
                    Button {
                        onWear()
                    } label: {
                        Text("Wear Today")
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(AppColors.accentText)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(AppColors.yellow)
                            .cornerRadius(12)
                    }
                }
                .padding(16)
                .frame(width: 140)
                .cardStyle()
            }
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let description: String
    let actionTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(description)
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(actionTitle, action: action)
                .buttonStyle(SecondaryButtonStyle())
        }
        .padding(32)
        .cardStyle()
    }
}

struct CelebrationView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "star.fill")
                    .font(.system(size: 60))
                    .foregroundColor(AppColors.yellow)
                    .scaleEffect(animate ? 1.2 : 0.8)
                    .rotationEffect(.degrees(animate ? 360 : 0))
                
                Text("You're Super Stylish!")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .opacity(animate ? 1 : 0)
            }
            .padding(40)
            .cardStyle()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                animate = true
            }
        }
    }
}

#Preview {
    TodayView()
        .environmentObject(AppState())
}
