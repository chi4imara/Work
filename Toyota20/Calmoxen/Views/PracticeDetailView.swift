import SwiftUI

struct PracticeDetailView: View {
    let practiceId: UUID
    @ObservedObject var practiceViewModel: PracticeViewModel
    var onDismiss: (() -> Void)?
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var showingCompletionAlert = false
    
    private var practice: Practice? {
        practiceViewModel.practice(byId: practiceId)
    }
    
    private var practiceHistory: [HistoryEntry] {
        practiceViewModel.history.filter { $0.practiceId == practiceId }
            .sorted { $0.completedAt > $1.completedAt }
    }
    
    private var currentStreak: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let practiceDays = Set(practiceHistory.map { calendar.startOfDay(for: $0.completedAt) })
        
        var streak = 0
        var checkDate = today
        
        while practiceDays.contains(checkDate) {
            streak += 1
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
        }
        
        return streak
    }
    
    private func dismiss() {
        onDismiss?()
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                if let practice = practice {
                    ScrollView {
                        VStack(spacing: 25) {
                            headerSection(practice: practice)
                            
                            statsSection
                            
                            historySection
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                    .navigationTitle(practice.name)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close") { dismiss() }
                                .foregroundColor(AppColors.primaryNavy)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                Button("Edit") { showingEditView = true }
                                Button("Delete", role: .destructive) { showingDeleteAlert = true }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .foregroundColor(AppColors.primaryOrange)
                            }
                        }
                    }
                } else {
                    practiceNotFoundView
                }
            }
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingEditView) {
            if let practice = practice {
                AddPracticeView(practiceViewModel: practiceViewModel, practiceToEdit: practice)
            }
        }
        .alert("Delete Practice", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                practiceViewModel.deletePractice(byId: practiceId)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this practice? This action cannot be undone.")
        }
        .alert("Practice Completed!", isPresented: $showingCompletionAlert) {
            Button("OK") { }
        } message: {
            Text("Great job! Practice completed successfully.")
        }
    }
    
    private var practiceNotFoundView: some View {
        VStack(spacing: 24) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 60))
                .foregroundColor(AppColors.mediumGray)
            Text("Practice not found")
                .font(.cardTitle)
                .foregroundColor(AppColors.primaryNavy)
            Text("It may have been deleted.")
                .font(.bodyText)
                .foregroundColor(AppColors.secondaryText)
            Button("Close") { dismiss() }
                .font(.buttonText)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(AppColors.primaryOrange)
                .cornerRadius(20)
        }
        .padding(.horizontal, 20)
    }
    
    private func headerSection(practice: Practice) -> some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                Image(systemName: practice.type.icon)
                    .font(.system(size: 50))
                    .foregroundColor(AppColors.primaryOrange)
                    .frame(width: 80, height: 80)
                    .background(AppColors.primaryOrange.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(practice.type.rawValue)
                            .font(.cardTitle)
                            .foregroundColor(AppColors.primaryNavy)
                        
                        if practice.isFavorite {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 16))
                                .foregroundColor(AppColors.primaryOrange)
                        }
                    }
                    
                    Text("\(practice.duration) minutes")
                        .font(.bodyText)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text(practice.frequency.rawValue)
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
            }
            
            if !practice.comment.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes")
                        .font(.cardTitle)
                        .foregroundColor(AppColors.primaryNavy)
                    
                    Text(practice.comment)
                        .font(.bodyText)
                        .foregroundColor(AppColors.secondaryText)
                        .padding(16)
                        .background(AppColors.cardGradient)
                        .cornerRadius(12)
                }
            }
            
            Button(action: {
                practiceViewModel.completePractice(practice)
                showingCompletionAlert = true
            }) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                    Text("I Did It")
                        .font(.buttonText)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [AppColors.primaryOrange, AppColors.lightBlue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
                .shadow(color: AppColors.primaryOrange.opacity(0.3), radius: 10, x: 0, y: 5)
            }
        }
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Statistics")
                .font(.screenTitle)
                .foregroundColor(AppColors.primaryNavy)
            
            VStack(spacing: 12) {
                StatCardView(
                    title: "Total Sessions",
                    value: "\(practiceHistory.count)",
                    icon: "chart.bar.fill",
                    color: AppColors.lightBlue
                )
                
                StatCardView(
                    title: "Current Streak",
                    value: "\(currentStreak)",
                    subtitle: "days",
                    icon: "flame.fill",
                    color: AppColors.primaryOrange
                )
                
                let totalMinutes = practiceHistory.reduce(0) { $0 + $1.duration }
                StatCardView(
                    title: "Total Time",
                    value: "\(totalMinutes)",
                    subtitle: "minutes",
                    icon: "clock.fill",
                    color: AppColors.softGreen
                )
            }
        }
    }
    
    private var historySection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recent Sessions")
                .font(.screenTitle)
                .foregroundColor(AppColors.primaryNavy)
            
            if practiceHistory.isEmpty {
                VStack(spacing: 15) {
                    Image(systemName: "clock.badge.questionmark")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.mediumGray)
                    
                    Text("No sessions yet")
                        .font(.bodyText)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text("Complete your first session to start tracking progress")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .padding(30)
                .background(AppColors.cardGradient)
                .cornerRadius(16)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(practiceHistory.prefix(10)) { entry in
                        HistoryEntryRow(entry: entry)
                    }
                }
            }
        }
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    var subtitle: String = ""
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
                
                HStack(alignment: .bottom, spacing: 4) {
                    Text(value)
                        .font(.playfairBold(size: 24))
                        .foregroundColor(AppColors.primaryNavy)
                    
                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.smallCaption)
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primaryNavy.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct HistoryEntryRow: View {
    let entry: HistoryEntry
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: entry.completedAt)
    }
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(AppColors.softGreen)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(formattedDate)
                    .font(.bodyText)
                    .foregroundColor(AppColors.primaryNavy)
                
                Text("\(entry.duration) minutes")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
                
                if !entry.note.isEmpty {
                    Text(entry.note)
                        .font(.smallCaption)
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(2)
                }
            }
            
            Spacer()
        }
        .padding(12)
        .background(AppColors.cardGradient)
        .cornerRadius(12)
    }
}

struct PracticeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeDetailView(
            practiceId: Practice.samplePractices[0].id,
            practiceViewModel: PracticeViewModel()
        )
    }
}
