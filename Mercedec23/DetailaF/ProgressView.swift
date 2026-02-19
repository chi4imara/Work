import SwiftUI
import Charts

struct ProgressView: View {
    @EnvironmentObject private var accessoryViewModel: AccessoryViewModel
    @EnvironmentObject private var viewModel: ProgressViewModel
    @State private var selectedTab: ProgressTab = .achievements
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    tabSelector
                    
                    TabView(selection: $selectedTab) {
                        achievementsView
                            .tag(ProgressTab.achievements)
                        
                        analyticsView
                            .tag(ProgressTab.analytics)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(ProgressTab.allCases, id: \.self) { tab in
                Button(action: { selectedTab = tab }) {
                    Text(tab.rawValue)
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(selectedTab == tab ? AppColors.backgroundWhite : AppColors.textBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            selectedTab == tab ? AppColors.textBlue : Color.clear
                        )
                }
            }
        }
        .background(AppColors.backgroundWhite)
        .cornerRadius(12)
        .padding(.horizontal, AppConstants.cardPadding)
        .padding(.bottom, 16)
    }
    
    private var tryOnHistoryView: some View {
        ScrollView {
            VStack(spacing: 16) {
                if viewModel.tryOnSessions.isEmpty {
                    emptyTryOnState
                } else {
                    ForEach(viewModel.tryOnSessions) { session in
                        TryOnSessionCard(
                            session: session,
                            accessory: accessoryViewModel.accessory(byId: session.accessoryId)
                        )
                    }
                }
            }
            .padding(.horizontal, AppConstants.cardPadding)
        }
    }
    
    private var emptyTryOnState: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.circle")
                .font(.system(size: 60))
                .foregroundColor(AppColors.textBlue.opacity(0.6))
            
            Text("No try-on sessions yet")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.textBlue)
            
            Text("Start trying on accessories to see your history here")
                .font(.playfairDisplay(14, weight: .medium))
                .foregroundColor(AppColors.darkGray)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 60)
    }
    
    private var achievementsView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(viewModel.achievements) { achievement in
                    AchievementCard(achievement: achievement)
                }
            }
            .padding(.horizontal, AppConstants.cardPadding)
        }
    }
    
    private var analyticsView: some View {
        ScrollView {
            VStack(spacing: AppConstants.sectionSpacing) {
                stylePreferencesChart
                colorPreferencesChart
                stylistRecommendations
            }
            .padding(.horizontal, AppConstants.cardPadding)
        }
    }
    
    private var stylePreferencesChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Style Preferences")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.textBlue)
            
            if viewModel.stylePreferences.isEmpty {
                Text("No data available yet")
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(AppColors.darkGray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(viewModel.stylePreferences.sorted(by: { $0.value > $1.value })), id: \.key) { style, count in
                        HStack {
                            Text(style.rawValue)
                                .font(.playfairDisplay(14, weight: .medium))
                                .foregroundColor(AppColors.textBlue)
                            
                            Spacer()
                            
                            Text("\(count)")
                                .font(.playfairDisplay(14, weight: .semibold))
                                .foregroundColor(style.color)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(style.color.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding(AppConstants.cardPadding)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
    
    private var colorPreferencesChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Color Preferences")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.textBlue)
            
            if viewModel.colorPreferences.isEmpty {
                Text("No data available yet")
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(AppColors.darkGray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(Array(viewModel.colorPreferences.sorted(by: { $0.value > $1.value })), id: \.key) { color, count in
                        HStack {
                            Circle()
                                .fill(colorForName(color))
                                .frame(width: 20, height: 20)
                            
                            Text(color)
                                .font(.playfairDisplay(12, weight: .medium))
                                .foregroundColor(AppColors.textBlue)
                            
                            Spacer()
                            
                            Text("\(count)")
                                .font(.playfairDisplay(12, weight: .semibold))
                                .foregroundColor(AppColors.textBlue)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(AppColors.lightGray)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding(AppConstants.cardPadding)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
    
    private var stylistRecommendations: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Stylist Recommendations")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.textBlue)
            
            VStack(spacing: 12) {
                RecommendationCard(
                    icon: "sparkles",
                    title: "Try Gold Accessories",
                    description: "Based on your evening style preferences, gold jewelry would complement your looks perfectly.",
                    color: AppColors.primaryYellow
                )
                
                RecommendationCard(
                    icon: "handbag",
                    title: "Add a Statement Bag",
                    description: "Your collection could benefit from a bold, colorful handbag for casual outfits.",
                    color: AppColors.accentPink
                )
                
                RecommendationCard(
                    icon: "hat.cap",
                    title: "Summer Hat Collection",
                    description: "Consider adding wide-brim hats to your collection for the upcoming season.",
                    color: AppColors.accentGreen
                )
            }
        }
        .padding(AppConstants.cardPadding)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
    
    private func colorForName(_ name: String) -> Color {
        switch name.lowercased() {
        case "black": return .black
        case "white": return .white
        case "brown": return .brown
        case "gold": return .yellow
        case "silver": return .gray
        case "beige": return Color(red: 0.96, green: 0.96, blue: 0.86)
        case "pink": return .pink
        case "blue": return .blue
        default: return .gray
        }
    }
}

struct TryOnSessionCard: View {
    let session: TryOnSession
    let accessory: Accessory?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(accessory?.name ?? "Unknown item")
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(AppColors.textBlue)
                    
                    if let accessory = accessory {
                        Text(accessory.brand)
                            .font(.playfairDisplay(14, weight: .medium))
                            .foregroundColor(AppColors.darkGray)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= session.rating ? "star.fill" : "star")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.primaryYellow)
                        }
                    }
                    
                    Text(session.date, style: .date)
                        .font(.playfairDisplay(12, weight: .medium))
                        .foregroundColor(AppColors.darkGray)
                }
            }
            
            if let notes = session.notes, !notes.isEmpty {
                Text(notes)
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(AppColors.darkGray)
                    .padding(.top, 4)
            }
            
            HStack {
                Text(accessory?.category.rawValue ?? "—")
                    .font(.playfairDisplay(12, weight: .medium))
                    .foregroundColor(session.style.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(session.style.color.opacity(0.1))
                    .cornerRadius(8)
                
                Text(session.style.rawValue)
                    .font(.playfairDisplay(12, weight: .medium))
                    .foregroundColor(AppColors.textBlue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppColors.lightGray)
                    .cornerRadius(8)
                
                Spacer()
            }
        }
        .padding(AppConstants.cardPadding)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? AppColors.primaryYellow : AppColors.lightGray)
                    .frame(width: 50, height: 50)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 24))
                    .foregroundColor(achievement.isUnlocked ? AppColors.backgroundWhite : AppColors.darkGray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(AppColors.textBlue)
                
                Text(achievement.description)
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(AppColors.darkGray)
                
                if !achievement.isUnlocked {
                    SwiftUI.ProgressView(value: achievement.progress)
                        .tint(AppColors.primaryYellow)
                        .frame(height: 4)
                        .scaleEffect(y: 0.5)
                }
            }
            
            Spacer()
            
            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.accentGreen)
            } else {
                Text("\(Int(achievement.progress * 100))%")
                    .font(.playfairDisplay(12, weight: .semibold))
                    .foregroundColor(AppColors.textBlue)
            }
        }
        .padding(AppConstants.cardPadding)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
}

struct RecommendationCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(AppColors.textBlue)
                
                Text(description)
                    .font(.playfairDisplay(12, weight: .medium))
                    .foregroundColor(AppColors.darkGray)
                    .lineLimit(3)
            }
            
            Spacer()
        }
        .padding(12)
        .background(AppColors.backgroundWhite)
        .cornerRadius(12)
    }
}

enum ProgressTab: String, CaseIterable {
    case achievements = "Achievements"
    case analytics = "Analytics"
}

#Preview {
    ProgressView()
        .environmentObject(AccessoryViewModel())
        .environmentObject(ProgressViewModel())
}
