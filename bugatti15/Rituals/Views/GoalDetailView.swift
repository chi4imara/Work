import SwiftUI

struct GoalDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var goal: Goal
    let onUpdate: (Goal) -> Void
    let onDelete: () -> Void
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    init(goal: Goal, onUpdate: @escaping (Goal) -> Void, onDelete: @escaping () -> Void) {
        self._goal = State(initialValue: goal)
        self.onUpdate = onUpdate
        self.onDelete = onDelete
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        GoalHeaderSection(goal: goal)
                        
                        GoalStatsSection(goal: goal)
                        
                        CompletionHistorySection(goal: goal)
                        
                        if let description = goal.description, !description.isEmpty {
                            DescriptionSection(description: description)
                        }
                        
                        ActionButtonsSection(
                            goal: goal,
                            onToggleCompletion: {
                                toggleCompletion()
                            },
                            onEdit: {
                                showingEditView = true
                            },
                            onDelete: {
                                showingDeleteAlert = true
                            }
                        )
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(goal.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEditView = true
                    }
                    .foregroundColor(AppColors.secondary)
                }
            }
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $showingEditView) {
            EditGoalView(goal: goal) { updatedGoal in
                goal = updatedGoal
                onUpdate(updatedGoal)
            }
        }
        .alert("Delete Goal", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this goal? This action cannot be undone.")
        }
    }
    
    private func toggleCompletion() {
        if goal.isCompleted {
            goal.markIncomplete()
        } else {
            goal.markCompleted()
        }
        onUpdate(goal)
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
}

struct GoalHeaderSection: View {
    let goal: Goal
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: goal.icon)
                    .font(.system(size: 40))
                    .foregroundColor(AppColors.secondary)
                    .frame(width: 60, height: 60)
                    .background(AppColors.secondary.opacity(0.2))
                    .cornerRadius(16)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.category.name)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                        .textCase(.uppercase)
                    
                    Text(goal.title)
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            
            HStack {
                FrequencyBadge(frequency: goal.frequency)
                
                Spacer()
                
                StatusBadge(isCompleted: goal.isCompleted)
            }
        }
        .padding(20)
        .background(AppGradients.primaryCard)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct GoalStatsSection: View {
    let goal: Goal
    
    var completionRate: Double {
        let totalDays = max(Calendar.current.dateComponents([.day], from: goal.createdDate, to: Date()).day ?? 0, 1)
        return Double(goal.completionDates.count) / Double(totalDays)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Statistics")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            HStack(spacing: 20) {
                StatCard(
                    title: "Current Streak",
                    value: "\(goal.streak)",
                    subtitle: "days",
                    icon: "flame.fill",
                    color: AppColors.warning
                )
                
                StatCard(
                    title: "Total Completed",
                    value: "\(goal.completionDates.count)",
                    subtitle: "times",
                    icon: "checkmark.circle.fill",
                    color: AppColors.success
                )
            }
            
            HStack(spacing: 20) {
                StatCard(
                    title: "Completion Rate",
                    value: "\(Int(completionRate * 100))%",
                    subtitle: "overall",
                    icon: "chart.line.uptrend.xyaxis",
                    color: AppColors.accent
                )
                
                StatCard(
                    title: "Days Active",
                    value: "\(max(Calendar.current.dateComponents([.day], from: goal.createdDate, to: Date()).day ?? 0, 1))",
                    subtitle: "total",
                    icon: "calendar",
                    color: AppColors.primary
                )
            }
        }
        .padding(20)
        .background(AppGradients.primaryCard)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            Text(value)
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.ubuntu(10, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                
                Text(subtitle)
                    .font(.ubuntu(8))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
}

struct CompletionHistorySection: View {
    let goal: Goal
    
    var recentCompletions: [Date] {
        goal.completionDates.suffix(7).reversed()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            if recentCompletions.isEmpty {
                Text("No completions yet")
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(recentCompletions, id: \.self) { date in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(AppColors.success)
                            
                            Text(date.formatted(date: .abbreviated, time: .shortened))
                                .font(.ubuntu(14))
                                .foregroundColor(AppColors.textPrimary)
                            
                            Spacer()
                            
                            Text(relativeDateString(for: date))
                                .font(.ubuntu(12))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .padding(20)
        .background(AppGradients.primaryCard)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func relativeDateString(for date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct DescriptionSection: View {
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Why this matters")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Text(description)
                .font(.ubuntu(16))
                .foregroundColor(AppColors.textSecondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(AppGradients.primaryCard)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct ActionButtonsSection: View {
    let goal: Goal
    let onToggleCompletion: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: onToggleCompletion) {
                HStack {
                    Image(systemName: goal.isCompleted ? "xmark.circle.fill" : "checkmark.circle.fill")
                        .font(.system(size: 20))
                    
                    Text(goal.isCompleted ? "Mark as Undone" : "Mark as Done")
                        .font(.ubuntu(18, weight: .medium))
                }
                .foregroundColor(goal.isCompleted ? AppColors.textPrimary : AppColors.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(goal.isCompleted ? AppColors.cardBackground : AppColors.success)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
                )
            }
            
            HStack(spacing: 12) {
                Button(action: onEdit) {
                    HStack {
                        Image(systemName: "pencil")
                            .font(.system(size: 16))
                        
                        Text("Edit")
                            .font(.ubuntu(16, weight: .medium))
                    }
                    .foregroundColor(AppColors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(AppColors.cardBackground)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
                    )
                }
                
                Button(action: onDelete) {
                    HStack {
                        Image(systemName: "trash")
                            .font(.system(size: 16))
                        
                        Text("Delete")
                            .font(.ubuntu(16, weight: .medium))
                    }
                    .foregroundColor(AppColors.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(12)
                }
            }
        }
    }
}

struct FrequencyBadge: View {
    let frequency: GoalFrequency
    
    var body: some View {
        Text(frequency.name)
            .font(.ubuntu(12, weight: .medium))
            .foregroundColor(AppColors.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(AppColors.secondary)
            .cornerRadius(12)
    }
}

struct StatusBadge: View {
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 12))
                .foregroundColor(isCompleted ? AppColors.success : AppColors.textSecondary)
            
            Text(isCompleted ? "Completed" : "Pending")
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(isCompleted ? AppColors.textPrimary : AppColors.textSecondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(isCompleted ? AppColors.success.opacity(0.2) : AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isCompleted ? AppColors.success.opacity(0.3) : AppColors.white.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    GoalDetailView(
        goal: Goal(title: "Morning walk", category: .body, frequency: .daily, description: "Take a refreshing morning walk to start the day"),
        onUpdate: { _ in },
        onDelete: { }
    )
}
