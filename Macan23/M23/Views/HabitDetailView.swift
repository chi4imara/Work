import SwiftUI

struct HabitDetailView: View {
    @EnvironmentObject var viewModel: HabitsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let habit: Habit
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            AnimatedBubblesBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(habit.name)
                            .font(.ubuntu(size: 28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(nil)
                        
                        HStack {
                            CategoryBadge(category: habit.category)
                            
                            Spacer()
                            
                            if !habit.time.isEmpty {
                                HStack {
                                    Image(systemName: "clock")
                                        .font(.system(size: 14))
                                        .foregroundColor(AppColors.accent)
                                    
                                    Text(habit.time)
                                        .font(.ubuntu(size: 16, weight: .medium))
                                        .foregroundColor(AppColors.primaryText)
                                }
                            }
                        }
                    }
                    .padding(20)
                    .cardStyle()
                    
                    if !habit.description.isEmpty || !habit.comment.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            if !habit.description.isEmpty {
                                DetailSection(
                                    title: "Description",
                                    content: habit.description,
                                    icon: "text.alignleft"
                                )
                            }
                            
                            if !habit.comment.isEmpty {
                                if !habit.description.isEmpty {
                                    Divider()
                                        .background(AppColors.secondaryText.opacity(0.3))
                                }
                                
                                DetailSection(
                                    title: "Comment",
                                    content: habit.comment,
                                    icon: "bubble.left"
                                )
                            }
                        }
                        .padding(20)
                        .cardStyle()
                    }
                    
                    VStack(spacing: 12) {
                        Button(action: { showingEditView = true }) {
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16))
                                Text("Edit")
                                    .font(.ubuntu(size: 16, weight: .medium))
                            }
                            .foregroundColor(AppColors.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppColors.accentGradient)
                            .cornerRadius(25)
                            .shadow(color: AppColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        
                        Button(action: { showingDeleteAlert = true }) {
                            HStack {
                                Image(systemName: "trash")
                                    .font(.system(size: 16))
                                Text("Delete")
                                    .font(.ubuntu(size: 16, weight: .medium))
                            }
                            .foregroundColor(AppColors.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    colors: [AppColors.error, AppColors.error.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                        }
                    }
                    Spacer(minLength: 100)
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Habit Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            EditHabitView(habit: habit)
                .environmentObject(viewModel)
        }
        .alert("Delete Habit", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteHabit(habit)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this habit? This action cannot be undone.")
        }
    }
}

struct DetailSection: View {
    let title: String
    let content: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.accent)
                
                Text(title)
                    .font(.ubuntu(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
            }
            
            Text(content)
                .font(.ubuntu(size: 15))
                .foregroundColor(AppColors.secondaryText)
                .lineLimit(nil)
        }
    }
}

struct CategoryBadge: View {
    let category: HabitCategory
    
    var body: some View {
        Text(category.displayName)
            .font(.ubuntu(size: 14, weight: .medium))
            .foregroundColor(AppColors.primaryText)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(AppColors.accent.opacity(0.2))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.accent.opacity(0.5), lineWidth: 1)
            )
    }
}
