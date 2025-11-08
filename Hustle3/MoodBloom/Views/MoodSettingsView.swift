import SwiftUI

struct MoodSettingsView: View {
    @ObservedObject var settings: AppSettings
    @Environment(\.dismiss) private var dismiss
    
    @State private var tempUseExtendedMoods: Bool
    @State private var tempCommentLimit: CommentLimit
    @State private var hasChanges = false
    @State private var showingDiscardAlert = false
    
    init(settings: AppSettings) {
        self.settings = settings
        self._tempUseExtendedMoods = State(initialValue: settings.useExtendedMoods)
        self._tempCommentLimit = State(initialValue: settings.commentLimit)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        moodSetSection
                        
                        commentLimitSection
                        
                        previewSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Mood Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        if hasChanges {
                            showingDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    }
                    .foregroundColor(Color.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSettings()
                    }
                    .foregroundColor(Color.primaryBlue)
                    .fontWeight(.semibold)
                    .disabled(!hasChanges)
                }
            }
        }
        .alert("Discard Changes?", isPresented: $showingDiscardAlert) {
            Button("Discard", role: .destructive) {
                dismiss()
            }
            Button("Keep Editing", role: .cancel) { }
        } message: {
            Text("You have unsaved changes. Are you sure you want to discard them?")
        }
        .onChange(of: tempUseExtendedMoods) { _ in
            checkForChanges()
        }
        .onChange(of: tempCommentLimit) { _ in
            checkForChanges()
        }
    }
    
    private var moodSetSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mood Set")
                .font(FontManager.headline)
                .foregroundColor(Color.textPrimary)
            
            VStack(spacing: 12) {
                moodSetOption(
                    title: "Basic Moods",
                    description: "5 essential emotions",
                    isSelected: !tempUseExtendedMoods
                ) {
                    tempUseExtendedMoods = false
                }
                
                moodSetOption(
                    title: "Extended Moods",
                    description: "More detailed emotional range",
                    isSelected: tempUseExtendedMoods
                ) {
                    tempUseExtendedMoods = true
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundWhite)
                .shadow(color: Color.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var commentLimitSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Comment Length")
                .font(FontManager.headline)
                .foregroundColor(Color.textPrimary)
            
            Text("Choose the maximum length for your daily notes")
                .font(FontManager.body)
                .foregroundColor(Color.textSecondary)
            
            VStack(spacing: 12) {
                ForEach(CommentLimit.allCases, id: \.self) { limit in
                    commentLimitOption(
                        limit: limit,
                        isSelected: tempCommentLimit == limit
                    ) {
                        tempCommentLimit = limit
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundWhite)
                .shadow(color: Color.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Preview")
                .font(FontManager.headline)
                .foregroundColor(Color.textPrimary)
            
            HStack(spacing: 12) {
                ForEach(MoodType.allCases, id: \.self) { mood in
                    VStack(spacing: 4) {
                        Text(tempUseExtendedMoods ? mood.extendedEmoji : mood.emoji)
                            .font(.system(size: 24))
                        
                        Text(mood.description)
                            .font(FontManager.small)
                            .foregroundColor(Color.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Comment limit: \(tempCommentLimit.rawValue) characters")
                    .font(FontManager.body)
                    .foregroundColor(Color.textSecondary)
                
                Text(String(repeating: "A", count: min(tempCommentLimit.rawValue, 50)) + (tempCommentLimit.rawValue > 50 ? "..." : ""))
                    .font(FontManager.caption)
                    .foregroundColor(Color.textSecondary.opacity(0.7))
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.backgroundGray)
                    )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundWhite)
                .shadow(color: Color.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private func moodSetOption(title: String, description: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(FontManager.subheadline)
                        .foregroundColor(Color.textPrimary)
                    
                    Text(description)
                        .font(FontManager.body)
                        .foregroundColor(Color.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? Color.primaryBlue : Color.textSecondary.opacity(0.5))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.lightBlue.opacity(0.1) : Color.backgroundGray.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.primaryBlue.opacity(0.3) : Color.clear, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func commentLimitOption(limit: CommentLimit, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(limit.description)
                    .font(FontManager.body)
                    .foregroundColor(Color.textPrimary)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? Color.primaryBlue : Color.textSecondary.opacity(0.5))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.lightBlue.opacity(0.1) : Color.backgroundGray.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.primaryBlue.opacity(0.3) : Color.clear, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func checkForChanges() {
        hasChanges = tempUseExtendedMoods != settings.useExtendedMoods ||
                    tempCommentLimit != settings.commentLimit
    }
    
    private func saveSettings() {
        settings.useExtendedMoods = tempUseExtendedMoods
        settings.commentLimit = tempCommentLimit
        hasChanges = false
        dismiss()
    }
}

#Preview {
    MoodSettingsView(settings: AppSettings())
}
