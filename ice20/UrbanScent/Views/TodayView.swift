import SwiftUI

struct TodayView: View {
    @ObservedObject var viewModel: ScentViewModel
    @State private var scent = ""
    @State private var location = ""
    @State private var selectedEmotion: Emotion = .calm
    @State private var comment = ""
    @State private var showingEmotionPicker = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                inputFormSection
                
                if !viewModel.entries.isEmpty {
                    recentEntriesSection
                }
                
                if viewModel.entries.isEmpty {
                    emptyStateSection
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .padding(.bottom, 80)
        }
        .onAppear {
            loadTodayEntry()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Today's Scent")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(.appTextPrimary)
            
            Text("What does your city smell like?")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(.appTextSecondary)
            
            Text(Date().formatted(date: .abbreviated, time: .omitted))
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(.appTextTertiary)
        }
    }
    
    private var inputFormSection: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Main scent of the day")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.appTextPrimary)
                
                TextField("Breathe deeply... what does today smell like?", text: $scent)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(.appTextPrimary)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.appCardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.appCardBorder, lineWidth: 1)
                            )
                    )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Where did you feel this?")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.appTextPrimary)
                
                TextField("Park near home, Metro station, Bridge over river...", text: $location)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(.appTextPrimary)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.appCardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.appCardBorder, lineWidth: 1)
                            )
                    )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("What feeling did the scent leave?")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.appTextPrimary)
                
                Button(action: { showingEmotionPicker.toggle() }) {
                    HStack {
                        Image(systemName: selectedEmotion.icon)
                            .foregroundColor(.appPrimaryYellow)
                        
                        Text(selectedEmotion.rawValue)
                            .font(.ubuntu(16, weight: .regular))
                            .foregroundColor(.appTextPrimary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .foregroundColor(.appTextTertiary)
                            .rotationEffect(.degrees(showingEmotionPicker ? 180 : 0))
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.appCardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.appCardBorder, lineWidth: 1)
                            )
                    )
                }
                
                if showingEmotionPicker {
                    VStack(spacing: 8) {
                        ForEach(Emotion.allCases, id: \.self) { emotion in
                            Button(action: {
                                selectedEmotion = emotion
                                showingEmotionPicker = false
                            }) {
                                HStack {
                                    Image(systemName: emotion.icon)
                                        .foregroundColor(.appPrimaryYellow)
                                    
                                    Text(emotion.rawValue)
                                        .font(.ubuntu(16, weight: .regular))
                                        .foregroundColor(.appTextPrimary)
                                    
                                    Spacer()
                                    
                                    if selectedEmotion == emotion {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.appPrimaryYellow)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(selectedEmotion == emotion ? Color.appPrimaryYellow.opacity(0.1) : Color.appCardBackground)
                                )
                            }
                        }
                    }
                    .padding(.top, 8)
                }
            }
            
            CustomButton(
                title: viewModel.todayEntry != nil ? "Update Entry" : "Save Entry",
                action: saveEntry,
                isEnabled: !scent.isEmpty && !location.isEmpty
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.appCardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.appCardBorder, lineWidth: 1)
                )
        )
    }
    
    private var recentEntriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Entries")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(.appTextPrimary)
            
            LazyVStack(spacing: 12) {
                ForEach(viewModel.getRecentEntries()) { entry in
                    ScentEntryCard(entry: entry)
                    
                }
            }
        }
    }
    
    private var emptyStateSection: some View {
        VStack(spacing: 20) {
            Image(systemName: "wind")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.appTextTertiary)
            
            Text("It's empty here for now. Make your first entry about the street scent today.")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(.appTextSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(40)
    }
    
    private func loadTodayEntry() {
        if let todayEntry = viewModel.todayEntry {
            scent = todayEntry.scent
            location = todayEntry.location
            selectedEmotion = todayEntry.emotion
            comment = todayEntry.comment ?? ""
        }
    }
    
    private func saveEntry() {
        viewModel.addEntry(
            scent: scent,
            location: location,
            emotion: selectedEmotion,
            comment: comment.isEmpty ? nil : comment
        )
        
        HapticManager.shared.success()
        
        withAnimation(.easeInOut(duration: 0.5)) {
        }
    }
}

struct ScentEntryCard: View {
    let entry: ScentEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(.appTextTertiary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: entry.emotion.icon)
                        .foregroundColor(.appPrimaryYellow)
                    
                    Text(entry.emotion.rawValue)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(.appTextSecondary)
                }
            }
            
            Text(entry.scent)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.appTextPrimary)
                .multilineTextAlignment(.leading)
            
            Text(entry.location)
                .font(.ubuntu(14, weight: .regular))
                .foregroundColor(.appTextSecondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.appCardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.appCardBorder, lineWidth: 1)
                )
        )
    }
}

#Preview {
    ZStack {
        AnimatedBackground()
        TodayView(viewModel: ScentViewModel())
    }
}
