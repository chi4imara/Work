import SwiftUI

struct HomeView: View {
    @StateObject private var diaryManager = DiaryManager.shared
    @State private var entryText = ""
    @State private var showingDeleteAlert = false
    @State private var showingSaveConfirmation = false
    @State private var showingMenu = false
    
    let onNavigateToTips: () -> Void
    let onNavigateToRandom: () -> Void
    let onNavigateToArchive: () -> Void
    let onNavigateToEdit: (DiaryEntry) -> Void
    
    @Binding var selectedTab: Int
    
    private var todayEntry: DiaryEntry? {
        diaryManager.getTodayEntry()
    }
    
    private var hasEntries: Bool {
        diaryManager.hasEntries
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                ForEach(0..<5, id: \.self) { index in
                    Circle()
                        .fill(orbColor(for: index))
                        .frame(width: orbSize(for: index))
                        .position(orbPosition(for: index, in: geometry))
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 4...6))
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.5),
                            value: UUID()
                        )
                }
                
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.xl) {
                        headerView
                        
                        if let entry = todayEntry {
                            todayEntryView(entry)
                        } else if hasEntries {
                            questionAndInputView
                        } else {
                            emptyStateView
                        }
                        
                        if todayEntry == nil {
                            tipView
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.top, AppTheme.Spacing.lg)
                }
            }
        }
        .alert("Delete Today's Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let entry = todayEntry {
                    diaryManager.deleteEntry(entry)
                }
            }
        } message: {
            Text("Are you sure you want to delete today's memory?")
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
        VStack(spacing: AppTheme.Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Memory Helper")
                        .font(AppTheme.Typography.largeTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)
                    
                    Text("One day — one memory")
                        .font(AppTheme.Typography.callout)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
                
                Spacer()
                
                Button(action: { showingMenu.toggle() }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .frame(width: 44, height: 44)
                        .background(AppTheme.Colors.cardBackground)
                        .cornerRadius(AppTheme.CornerRadius.md)
                }
                .actionSheet(isPresented: $showingMenu) {
                    ActionSheet(
                        title: Text("Menu"),
                        buttons: [
                            .default(Text("Archive")) { withAnimation { selectedTab = 1 } },
                            .default(Text("Writing Tips")) { withAnimation { selectedTab = 3 } },
                            .default(Text("Random Memory")) { withAnimation { selectedTab = 2 } },
                            .cancel()
                        ]
                    )
                }
            }
        }
    }
        
    private var questionAndInputView: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            VStack(spacing: AppTheme.Spacing.md) {
                Text("What will you remember today?")
                    .font(AppTheme.Typography.title2)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("You can write one sentence. The essence matters, not the length.")
                    .font(AppTheme.Typography.callout)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, AppTheme.Spacing.xl)
            
            VStack(spacing: AppTheme.Spacing.lg) {
                VStack(alignment: .trailing, spacing: AppTheme.Spacing.sm) {
                    TextEditor(text: $entryText)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .frame(minHeight: 120)
                        .padding(AppTheme.Spacing.md)
                        .background(AppTheme.Colors.cardBackground)
                        .cornerRadius(AppTheme.CornerRadius.md)
                        .overlay(
                            Group {
                                if entryText.isEmpty {
                                    VStack {
                                        HStack {
                                            Text("Write a moment, thought, feeling...")
                                                .font(AppTheme.Typography.body)
                                                .foregroundColor(AppTheme.Colors.tertiaryText)
                                                .padding(.top, AppTheme.Spacing.md + 8)
                                                .padding(.leading, AppTheme.Spacing.md + 4)
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        )
                    
                    Text("\(entryText.count)/200")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(entryText.count > 200 ? AppTheme.Colors.error : AppTheme.Colors.tertiaryText)
                }
                
                Button(action: saveEntry) {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                        Text("Save")
                    }
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.md)
                    .background(entryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || entryText.count > 200 ? 
                               AppTheme.Colors.tertiaryText : AppTheme.Colors.primaryPurple)
                    .cornerRadius(AppTheme.CornerRadius.md)
                }
                .disabled(entryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || entryText.count > 200)
            }
        }
    }
        
    private func todayEntryView(_ entry: DiaryEntry) -> some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Text("Today's Memory")
                .font(AppTheme.Typography.title2)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text(entry.text)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .lineSpacing(2)
                
                HStack {
                    Text("Added: \(entry.formattedDate), \(entry.formattedTime)")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                    
                    if entry.isEdited {
                        Text("• Edited")
                            .font(AppTheme.Typography.caption1)
                            .foregroundColor(AppTheme.Colors.accent)
                    }
                    
                    Spacer()
                }
                
                HStack(spacing: AppTheme.Spacing.md) {
                    Button(action: { onNavigateToEdit(entry) }) {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Edit")
                        }
                        .font(AppTheme.Typography.callout)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .background(AppTheme.Colors.primaryPurple)
                        .cornerRadius(AppTheme.CornerRadius.sm)
                    }
                    
                    Button(action: { showingDeleteAlert = true }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete")
                        }
                        .font(AppTheme.Typography.callout)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .background(AppTheme.Colors.error)
                        .cornerRadius(AppTheme.CornerRadius.sm)
                    }
                    
                    Spacer()
                }
            }
            .padding(AppTheme.Spacing.lg)
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.lg)
        }
        .padding(.top, AppTheme.Spacing.xl)
    }
    
    
    private var emptyStateView: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            Image(systemName: "captions.bubble.fill")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppTheme.Colors.primaryText)
            
            VStack(spacing: AppTheme.Spacing.md) {
                Text("Every day — a new memory. Start with today's.")
                    .font(AppTheme.Typography.title3)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .multilineTextAlignment(.center)
            }
            
            questionAndInputView
        }
        .padding(.top, AppTheme.Spacing.xxl)
    }
        
    private var tipView: some View {
        Text("Don't try to write perfectly. The main thing is that it's yours.")
            .font(AppTheme.Typography.footnote)
            .foregroundColor(AppTheme.Colors.tertiaryText)
            .multilineTextAlignment(.center)
            .padding(.horizontal, AppTheme.Spacing.xl)
    }
        
    private var saveConfirmationOverlay: some View {
        VStack {
            Spacer()
            
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(AppTheme.Colors.success)
                Text("Remembered")
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
        
    private func saveEntry() {
        let trimmedText = entryText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty && trimmedText.count <= 200 else { return }
        
        diaryManager.addEntry(trimmedText)
        entryText = ""
        
        withAnimation(.easeInOut(duration: 0.5)) {
            showingSaveConfirmation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showingSaveConfirmation = false
            }
        }
    }
    
    private func orbColor(for index: Int) -> Color {
        switch index % 3 {
        case 0: return AppTheme.Colors.orb1
        case 1: return AppTheme.Colors.orb2
        default: return AppTheme.Colors.orb3
        }
    }
    
    private func orbSize(for index: Int) -> CGFloat {
        let sizes: [CGFloat] = [50, 30, 70, 25, 60]
        return sizes[index % sizes.count]
    }
    
    private func orbPosition(for index: Int, in geometry: GeometryProxy) -> CGPoint {
        let width = geometry.size.width
        let height = geometry.size.height
        
        let positions: [CGPoint] = [
            CGPoint(x: width * 0.1, y: height * 0.2),
            CGPoint(x: width * 0.9, y: height * 0.3),
            CGPoint(x: width * 0.2, y: height * 0.8),
            CGPoint(x: width * 0.8, y: height * 0.9),
            CGPoint(x: width * 0.5, y: height * 0.1)
        ]
        
        return positions[index % positions.count]
    }
}


