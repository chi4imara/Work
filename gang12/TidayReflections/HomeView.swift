import SwiftUI

struct HomeView: View {
    @ObservedObject var momentsViewModel: DailyMomentsViewModel
    @StateObject private var profileViewModel = ProfileViewModel()
    @State private var showingMenu = false
    @State private var selectedModal: ModalType?
    
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            AppGradients.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    headerView
                    
                    questionSection
                    
                    if let todaysMoment = momentsViewModel.todaysMoment {
                        savedMomentView(todaysMoment)
                    } else {
                        emptyStateView
                    }
                    
                    additionalContentSection
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
        .sheet(item: $selectedModal) { modal in
            switch modal {
            case .createMoment:
                CreateMomentView(momentsViewModel: momentsViewModel)
            case .editMoment(let id):
                if let moment = momentsViewModel.moments.first(where: { $0.id == id }) {
                    EditMomentView(moment: moment, momentsViewModel: momentsViewModel)
                } else {
                    EmptyView()
                }
            default:
                EmptyView()
            }
        }
        .actionSheet(isPresented: $showingMenu) {
            ActionSheet(
                title: Text("Menu"),
                buttons: [
                    .default(Text("History")) {
                        withAnimation {
                            selectedTab = .history
                        }
                    },
                    .default(Text("My Notes")) {
                        withAnimation {
                            selectedTab = .notes
                        }
                    },
                    .default(Text("Statistics")) {
                        withAnimation {
                            selectedTab = .statistics
                        }
                    },
                    .cancel()
                ]
            )
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Daily Reflections")
                .font(.builderSans(size: 24, weight: .bold))
                .foregroundColor(.primaryText)
            
            Spacer()
            
            Button(action: { showingMenu = true }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primaryText)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.8))
                    )
            }
        }
    }
    
    private var questionSection: some View {
        VStack(spacing: 12) {
            Text("What was the most alive moment today?")
                .font(.builderSans(size: 20, weight: .semibold))
                .foregroundColor(.primaryText)
                .multilineTextAlignment(.center)
            
            Text("Write briefly — what you felt most strongly.")
                .font(.builderSans(size: 14, weight: .regular))
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.center)
        }
    }
    
    private func savedMomentView(_ moment: DailyMoment) -> some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Text(moment.text)
                    .font(.builderSans(size: 16, weight: .regular))
                    .foregroundColor(.primaryText)
                    .lineSpacing(4)
                
                HStack {
                    Text("Answer recorded today at \(moment.timeString)")
                        .font(.builderSans(size: 12, weight: .medium))
                        .foregroundColor(.secondaryText)
                    
                    Spacer()
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppGradients.cardGradient)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            
            if momentsViewModel.canEditToday() {
                Button(action: { 
                    if let moment = momentsViewModel.todaysMoment {
                        selectedModal = .editMoment(moment.id)
                    }
                }) {
                    Text("Edit")
                        .font(.builderSans(size: 16, weight: .semibold))
                        .foregroundColor(.primaryText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.primaryText, lineWidth: 2)
                        )
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            VStack(spacing: 20) {
                Image(systemName: "leaf")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(.softGreen)
                
                VStack(spacing: 8) {
                    Text("Every day consists of moments.")
                        .font(.builderSans(size: 18, weight: .medium))
                        .foregroundColor(.primaryText)
                        .multilineTextAlignment(.center)
                    
                    Text("Write one — the most alive.")
                        .font(.builderSans(size: 16, weight: .regular))
                        .foregroundColor(.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            
            Button(action: { selectedModal = .createMoment }) {
                Text("Start First Day")
                    .font(.builderSans(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppGradients.buttonGradient)
                    )
                    .shadow(color: Color.accentYellow.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .onAppear {
            profileViewModel.updateStatistics(moments: momentsViewModel.moments)
        }
    }
    
    private var additionalContentSection: some View {
        VStack(spacing: 24) {
            dailyQuoteSection
            
            quickStatsSection
        }
    }
    
    private var dailyQuoteSection: some View {
        VStack(spacing: 16) {
            Text("Daily Inspiration")
                .font(.builderSans(size: 18, weight: .semibold))
                .foregroundColor(.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                Text("\"\(profileViewModel.dailyQuote.text)\"")
                    .font(.builderSans(size: 16, weight: .medium))
                    .foregroundColor(.primaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                
                if let author = profileViewModel.dailyQuote.author {
                    Text("— \(author)")
                        .font(.builderSans(size: 14, weight: .regular))
                        .foregroundColor(.secondaryText)
                        .multilineTextAlignment(.center)
                }
                
                Text("Quote updates every morning.")
                    .font(.builderSans(size: 12, weight: .medium))
                    .foregroundColor(.secondaryText.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppGradients.cardGradient)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var quickStatsSection: some View {
        VStack(spacing: 16) {
            Text("Your Progress")
                .font(.builderSans(size: 18, weight: .semibold))
                .foregroundColor(.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Days",
                    value: "\(profileViewModel.statistics.totalDaysWithEntries)",
                    icon: "calendar",
                    color: .softGreen
                )
                
                StatCard(
                    title: "Streak",
                    value: "\(profileViewModel.statistics.currentStreak)",
                    icon: "flame",
                    color: .lightOrange
                )
                
                StatCard(
                    title: "Avg Time",
                    value: profileViewModel.statistics.averageEntryTime,
                    icon: "clock",
                    color: .lavender
                )
            }
        }
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            Text("Quick Actions")
                .font(.builderSans(size: 18, weight: .semibold))
                .foregroundColor(.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 12) {
                Button(action: {
                    withAnimation {
                        selectedTab = .history
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "clock")
                            .font(.system(size: 16, weight: .medium))
                        Text("History")
                            .font(.builderSans(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.primaryText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.9))
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    )
                }
                
                Button(action: {
                    withAnimation {
                        selectedTab = .notes
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "note.text")
                            .font(.system(size: 16, weight: .medium))
                        Text("Notes")
                            .font(.builderSans(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.primaryText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.9))
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    )
                }
                
                Button(action: {
                    withAnimation {
                        selectedTab = .statistics
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chart.bar")
                            .font(.system(size: 16, weight: .medium))
                        Text("Stats")
                            .font(.builderSans(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.primaryText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.9))
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    )
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.builderSans(size: 16, weight: .bold))
                .foregroundColor(.primaryText)
            
            Text(title)
                .font(.builderSans(size: 12, weight: .medium))
                .foregroundColor(.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppGradients.cardGradient)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

