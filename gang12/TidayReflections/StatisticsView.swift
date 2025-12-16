import SwiftUI

struct StatisticsView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var momentsViewModel: DailyMomentsViewModel
    @State private var selectedModal: ModalType?
    
    var body: some View {
        ZStack {
            AppGradients.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    headerView
                    
                    statisticsSection
                    
                    quoteSection
                    
                    actionButton
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .onAppear {
            profileViewModel.updateStatistics(moments: momentsViewModel.moments)
        }
        .sheet(item: $selectedModal) { modal in
            switch modal {
            case .createMoment:
                CreateMomentView(momentsViewModel: momentsViewModel)
            default:
                EmptyView()
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Statistics")
                    .font(.builderSans(size: 24, weight: .bold))
                    .foregroundColor(.primaryText)
                
                Text("Your reflection journey")
                    .font(.builderSans(size: 16, weight: .medium))
                    .foregroundColor(.secondaryText)
            }
            
            Spacer()
        }
    }
    
    private var statisticsSection: some View {
        VStack(spacing: 16) {
            Text("Your Progress")
                .font(.builderSans(size: 18, weight: .semibold))
                .foregroundColor(.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                StatisticRow(
                    title: "Total days with entries",
                    value: "\(profileViewModel.statistics.totalDaysWithEntries)"
                )
                
                StatisticRow(
                    title: "Last moment",
                    value: lastMomentText
                )
                
                StatisticRow(
                    title: "Days in a row with answer",
                    value: "\(profileViewModel.statistics.currentStreak)"
                )
                
                StatisticRow(
                    title: "Average entry time",
                    value: profileViewModel.statistics.averageEntryTime
                )
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppGradients.cardGradient)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var quoteSection: some View {
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
                    .padding(.top, 8)
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
    
    private var actionButton: some View {
        VStack(spacing: 16) {
            if momentsViewModel.todaysMoment == nil {
                Button(action: { selectedModal = .createMoment }) {
                    Text("Add moment today")
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
            } else {
                VStack(spacing: 8) {
                    Text("You've already captured today's moment!")
                        .font(.builderSans(size: 16, weight: .medium))
                        .foregroundColor(.primaryText)
                        .multilineTextAlignment(.center)
                    
                    Text("Come back tomorrow for a new reflection.")
                        .font(.builderSans(size: 14, weight: .regular))
                        .foregroundColor(.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.softGreen.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.softGreen, lineWidth: 1)
                        )
                )
            }
        }
    }
    
    private var lastMomentText: String {
        guard let lastDate = profileViewModel.statistics.lastMomentDate else {
            return "No entries yet"
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: lastDate)
    }
}

struct StatisticRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.builderSans(size: 14, weight: .regular))
                .foregroundColor(.secondaryText)
            
            Spacer()
            
            Text(value)
                .font(.builderSans(size: 16, weight: .semibold))
                .foregroundColor(.primaryText)
        }
    }
}

#Preview {
    StatisticsView(
        profileViewModel: ProfileViewModel(),
        momentsViewModel: DailyMomentsViewModel()
    )
}
