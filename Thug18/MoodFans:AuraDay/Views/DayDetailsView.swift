import SwiftUI

struct DayDetailsView: View {
    let selectedDate: Date
    @Binding var isPresented: Bool
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var dataManager = MoodDataManager.shared
    @State private var showColorSelection = false
    @State private var showDeleteAlert = false
    @State private var animateContent = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return formatter
    }()
    
    var moodEntry: MoodEntry? {
        dataManager.getEntry(for: selectedDate)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.xl) {
                        headerView
                        
                        if let entry = moodEntry {
                            moodDetailsView(entry: entry)
                            
                            metadataView(entry: entry)
                            
                            actionButtonsView(entry: entry)
                        } else {
                            noMoodView
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.vertical, AppTheme.Spacing.lg)
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showColorSelection) {
            ColorSelectionView(selectedDate: selectedDate, isPresented: $showColorSelection)
        }
        .alert("Delete Entry", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                dataManager.deleteEntry(for: selectedDate)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this mood entry?")
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateContent = true
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            HStack {
                Button("Back") {
                    dismiss()
                }
                .font(AppTheme.Fonts.callout)
                .foregroundColor(AppTheme.Colors.secondaryText)
                
                Spacer()
                
                Text("Day Details")
                    .font(AppTheme.Fonts.navigationTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Spacer()
                
                Button("Back") {
                    dismiss()
                }
                .font(AppTheme.Fonts.callout)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .opacity(0)
                .disabled(true)
            }
            
            Text(dateFormatter.string(from: selectedDate))
                .font(AppTheme.Fonts.title3)
                .foregroundColor(AppTheme.Colors.accentYellow)
        }
        .opacity(animateContent ? 1.0 : 0.0)
        .offset(y: animateContent ? 0 : -20)
    }
    
    private func moodDetailsView(entry: MoodEntry) -> some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            ZStack {
                Circle()
                    .fill(entry.moodColor.color)
                    .frame(width: 120, height: 120)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 3)
                    )
                    .shadow(color: AppTheme.Shadow.heavy, radius: 15, x: 0, y: 8)
                
                if entry.isFavorite {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "star.fill")
                                .font(.system(size: 20))
                                .foregroundColor(AppTheme.Colors.accentYellow)
                                .background(
                                    Circle()
                                        .fill(Color.black.opacity(0.3))
                                        .frame(width: 32, height: 32)
                                )
                        }
                        Spacer()
                    }
                    .frame(width: 120, height: 120)
                }
            }
            .scaleEffect(animateContent ? 1.0 : 0.8)
            .opacity(animateContent ? 1.0 : 0.0)
            
            VStack(spacing: AppTheme.Spacing.md) {
                Text(entry.moodColor.displayName)
                    .font(AppTheme.Fonts.title2)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Text(entry.moodColor.emotion)
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            
            if !entry.note.isEmpty {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Note")
                        .font(AppTheme.Fonts.headline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                    
                    Text(entry.note)
                        .font(AppTheme.Fonts.body)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .padding(AppTheme.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                .fill(Color.white.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        )
                }
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
            }
        }
    }
    
    private func metadataView(entry: MoodEntry) -> some View {
        VStack(spacing: AppTheme.Spacing.md) {
            HStack {
                Text("Added:")
                    .font(AppTheme.Fonts.callout)
                    .foregroundColor(AppTheme.Colors.tertiaryText)
                
                Spacer()
                
                Text(timeFormatter.string(from: entry.createdAt))
                    .font(AppTheme.Fonts.callout)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
            
            if entry.updatedAt != entry.createdAt {
                HStack {
                    Text("Modified:")
                        .font(AppTheme.Fonts.callout)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                    
                    Spacer()
                    
                    Text(timeFormatter.string(from: entry.updatedAt))
                        .font(AppTheme.Fonts.callout)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .opacity(animateContent ? 1.0 : 0.0)
        .offset(y: animateContent ? 0 : 20)
    }
    
    private func actionButtonsView(entry: MoodEntry) -> some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Button(action: {
                dataManager.toggleFavorite(for: selectedDate)
            }) {
                HStack {
                    Image(systemName: entry.isFavorite ? "star.fill" : "star")
                        .font(.system(size: 18, weight: .medium))
                    
                    Text(entry.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                        .font(AppTheme.Fonts.buttonFont)
                }
                .foregroundColor(AppTheme.Colors.accentYellow)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(entry.isFavorite ? Color.yellow.opacity(0.4) : Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                        .stroke(AppTheme.Colors.accentYellow.opacity(0.5), lineWidth: 1)
                )
                .cornerRadius(AppTheme.CornerRadius.large)
            }
            
            Button(action: {
                showColorSelection = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 18, weight: .medium))
                    
                    Text("Edit")
                        .font(AppTheme.Fonts.buttonFont)
                }
                .foregroundColor(AppTheme.Colors.backgroundBlue)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(AppTheme.Colors.accentYellow)
                .cornerRadius(AppTheme.CornerRadius.large)
            }
            
            Button(action: {
                showDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 18, weight: .medium))
                    
                    Text("Delete Entry")
                        .font(AppTheme.Fonts.buttonFont)
                }
                .foregroundColor(AppTheme.Colors.error)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                        .stroke(AppTheme.Colors.error.opacity(0.5), lineWidth: 1)
                )
                .cornerRadius(AppTheme.CornerRadius.large)
            }
        }
        .opacity(animateContent ? 1.0 : 0.0)
        .offset(y: animateContent ? 0 : 20)
    }
    
    private var noMoodView: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppTheme.Colors.tertiaryText)
            
            VStack(spacing: AppTheme.Spacing.md) {
                Text("No mood recorded")
                    .font(AppTheme.Fonts.title3)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Text("Add a mood color for this day")
                    .font(AppTheme.Fonts.body)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                showColorSelection = true
            }) {
                Text("Add Mood")
                    .font(AppTheme.Fonts.buttonFont)
                    .foregroundColor(AppTheme.Colors.backgroundBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(AppTheme.Colors.accentYellow)
                    .cornerRadius(AppTheme.CornerRadius.large)
            }
        }
        .opacity(animateContent ? 1.0 : 0.0)
        .offset(y: animateContent ? 0 : 20)
    }
}

#Preview {
    DayDetailsView(selectedDate: Date(), isPresented: .constant(true))
}
