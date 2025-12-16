import SwiftUI

struct EditEntryView: View {
    @StateObject private var diaryManager = DiaryManager.shared
    @State private var editedText: String
    @State private var showingSaveConfirmation = false
    
    let entry: DiaryEntry
    let onSave: () -> Void
    let onCancel: () -> Void
    
    private var hasChanges: Bool {
        editedText.trimmingCharacters(in: .whitespacesAndNewlines) != entry.text &&
        !editedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var isValidText: Bool {
        let trimmed = editedText.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed.count <= 200
    }
    
    init(entry: DiaryEntry, onSave: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.entry = entry
        self.onSave = onSave
        self.onCancel = onCancel
        self._editedText = State(initialValue: entry.text)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(AppTheme.Colors.orb1)
                        .frame(width: 40 + CGFloat(index * 15))
                        .position(orbPosition(for: index, in: geometry))
                        .animation(
                            Animation.easeInOut(duration: 5 + Double(index))
                                .repeatForever(autoreverses: true),
                            value: UUID()
                        )
                }
                
                VStack(spacing: 0) {
                    headerView
                    
                    ScrollView {
                        VStack(spacing: AppTheme.Spacing.xl) {
                            entryInfoView
                            
                            editFormView
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, AppTheme.Spacing.lg)
                        .padding(.top, AppTheme.Spacing.lg)
                    }
                }
            }
        }
        .overlay(
            Group {
                if showingSaveConfirmation {
                    saveConfirmationOverlay
                }
            }
        )
    }
        
    private var headerView: some View {
        HStack {
            Button(action: onCancel) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                    Text("Back")
                        .font(AppTheme.Typography.callout)
                }
                .foregroundColor(AppTheme.Colors.primaryText)
            }
            
            Spacer()
            
            Text("Editing")
                .font(AppTheme.Typography.headline)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            Spacer()
            
            Button(action: saveChanges) {
                HStack(spacing: 4) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 16, weight: .medium))
                    Text("Save")
                        .font(AppTheme.Typography.callout)
                }
                .foregroundColor(hasChanges && isValidText ? AppTheme.Colors.primaryText : AppTheme.Colors.tertiaryText)
            }
            .disabled(!hasChanges || !isValidText)
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.vertical, AppTheme.Spacing.md)
        .background(AppTheme.Colors.cardBackground.opacity(0.8))
    }
        
    private var entryInfoView: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack {
                Text("Date: \(entry.formattedDate)")
                    .font(AppTheme.Typography.callout)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                
                Spacer()
            }
            
            if entry.isEdited {
                HStack {
                    Text("Previously edited")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(AppTheme.Colors.accent)
                    
                    Spacer()
                }
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.md)
    }
        
    private var editFormView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            VStack(alignment: .trailing, spacing: AppTheme.Spacing.sm) {
                TextEditor(text: $editedText)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .frame(minHeight: 200)
                    .padding(AppTheme.Spacing.md)
                    .background(AppTheme.Colors.cardBackground)
                    .cornerRadius(AppTheme.CornerRadius.md)
                
                HStack {
                    Spacer()
                    Text("\(editedText.count)/200")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(editedText.count > 200 ? AppTheme.Colors.error : AppTheme.Colors.tertiaryText)
                }
            }
            
            if !editedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && editedText.count > 200 {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(AppTheme.Colors.error)
                    Text("Text is too long. Maximum 200 characters.")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(AppTheme.Colors.error)
                    Spacer()
                }
            }
            
            if editedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(AppTheme.Colors.warning)
                    Text("Entry cannot be empty.")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(AppTheme.Colors.warning)
                    Spacer()
                }
            }
        }
    }
        
    private var saveConfirmationOverlay: some View {
        VStack {
            Spacer()
            
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(AppTheme.Colors.success)
                Text("Changes saved")
                    .font(AppTheme.Typography.callout)
                    .foregroundColor(AppTheme.Colors.primaryText)
            }
            .padding()
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.md)
            .padding(.bottom, 100)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
        
    private func saveChanges() {
        guard hasChanges && isValidText else { return }
        
        let trimmedText = editedText.trimmingCharacters(in: .whitespacesAndNewlines)
        diaryManager.updateEntry(entry, with: trimmedText)
        
        withAnimation(.easeInOut(duration: 0.5)) {
            showingSaveConfirmation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showingSaveConfirmation = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onSave()
            }
        }
    }
    
    private func orbPosition(for index: Int, in geometry: GeometryProxy) -> CGPoint {
        let width = geometry.size.width
        let height = geometry.size.height
        
        let positions: [CGPoint] = [
            CGPoint(x: width * 0.15, y: height * 0.25),
            CGPoint(x: width * 0.85, y: height * 0.4),
            CGPoint(x: width * 0.3, y: height * 0.8)
        ]
        
        return positions[index % positions.count]
    }
}

#Preview {
    EditEntryView(
        entry: DiaryEntry(text: "Sample diary entry text for preview"),
        onSave: {},
        onCancel: {}
    )
}
