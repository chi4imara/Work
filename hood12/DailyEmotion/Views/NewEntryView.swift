import SwiftUI

struct NewEntryView: View {
    @ObservedObject var dataManager: EmotionDataManager
    @State private var selectedDate = Date()
    @State private var selectedEmotion: EmotionType?
    @State private var reason = ""
    @State private var showDatePicker = false
    @State private var showSuccessAlert = false
    @State private var showMenuSheet = false
    @State private var emotionError = ""
    @State private var reasonError = ""
    @State private var showArchiveAlert = false
    @State private var entryToArchive: EmotionEntry?
    
    let onNavigateToArchive: (() -> Void)?
    
    init(dataManager: EmotionDataManager, onNavigateToArchive: (() -> Void)? = nil) {
        self.dataManager = dataManager
        self.onNavigateToArchive = onNavigateToArchive
    }
    
    private var isFormValid: Bool {
        selectedEmotion != nil && !reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("New Emotion Entry")
                        .font(.poppinsBold(size: 24))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: { showMenuSheet = true }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                            .frame(width: 40, height: 40)
                            .background(AppColors.cardBackground)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 30) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Date")
                                .font(.poppinsSemiBold(size: 18))
                                .foregroundColor(AppColors.primaryText)
                            
                            Button(action: { showDatePicker = true }) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(AppColors.accentYellow)
                                    
                                    Text(DateFormatter.displayFormatter.string(from: selectedDate))
                                        .font(.poppinsMedium(size: 16))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(AppColors.primaryText.opacity(0.6))
                                }
                                .padding(16)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Choose Your Mood")
                                .font(.poppinsSemiBold(size: 18))
                                .foregroundColor(AppColors.primaryText)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                                ForEach(EmotionType.allCases, id: \.self) { emotion in
                                    EmotionButton(
                                        emotion: emotion,
                                        isSelected: selectedEmotion == emotion
                                    ) {
                                        selectedEmotion = emotion
                                        emotionError = ""
                                    }
                                }
                            }
                            
                            if !emotionError.isEmpty {
                                Text(emotionError)
                                    .font(.poppinsRegular(size: 14))
                                    .foregroundColor(AppColors.errorRed)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Describe the Reason")
                                .font(.poppinsSemiBold(size: 18))
                                .foregroundColor(AppColors.primaryText)
                            
                            ZStack(alignment: .topLeading) {
                                if reason.isEmpty {
                                    Text("Describe the reason for your mood (e.g., had a good rest, passed an exam, tired after training)")
                                        .font(.poppinsRegular(size: 16))
                                        .foregroundColor(AppColors.placeholderText)
                                        .padding(.top, 16)
                                        .padding(.leading, 16)
                                }
                                
                                TextEditor(text: $reason)
                                    .font(.poppinsRegular(size: 16))
                                    .foregroundColor(AppColors.primaryText)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.clear)
                                    .frame(minHeight: 120)
                                    .padding(16)
                                    .onChange(of: reason) { _ in
                                        reasonError = ""
                                        if reason.count > 150 {
                                            reason = String(reason.prefix(150))
                                        }
                                    }
                            }
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                            
                            HStack {
                                if !reasonError.isEmpty {
                                    Text(reasonError)
                                        .font(.poppinsRegular(size: 14))
                                        .foregroundColor(AppColors.errorRed)
                                }
                                
                                Spacer()
                                
                                Text("\(reason.count)/150")
                                    .font(.poppinsRegular(size: 12))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                        }
                        
                        if !dataManager.entries.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Recent Entries")
                                    .font(.poppinsSemiBold(size: 18))
                                    .foregroundColor(AppColors.primaryText)
                                
                                ForEach(dataManager.entries.prefix(3)) { entry in
                                    RecentEntryCard(entry: entry) {
                                        entryToArchive = entry
                                        showArchiveAlert = true
                                    }
                                }
                                
                                if dataManager.entries.count > 3 {
                                    Button(action: {
                                        onNavigateToArchive?()
                                    }) {
                                        Text("View All Entries")
                                            .font(.poppinsMedium(size: 14))
                                            .foregroundColor(AppColors.accentYellow)
                                    }
                                }
                            }
                        }
                        
                        VStack(spacing: 16) {
                            Button(action: saveEntry) {
                                Text("Save Entry")
                                    .font(.poppinsSemiBold(size: 18))
                                    .foregroundColor(isFormValid ? AppColors.primaryBlue : AppColors.primaryText.opacity(0.5))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(isFormValid ? AppColors.accentYellow : AppColors.cardBackground)
                                    .cornerRadius(28)
                            }
                            .disabled(!isFormValid)
                            
                            Button(action: {
                                onNavigateToArchive?()
                            }) {
                                Text("Go to Archive")
                                    .font(.poppinsMedium(size: 16))
                                    .foregroundColor(AppColors.primaryText)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(24)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(selectedDate: $selectedDate)
        }
        .actionSheet(isPresented: $showMenuSheet) {
            ActionSheet(
                title: Text("Menu"),
                buttons: [
                    .destructive(Text("Clear Form")) {
                        clearForm()
                    },
                    .cancel()
                ]
            )
        }
        .alert("Emotion Saved", isPresented: $showSuccessAlert) {
            Button("OK") { }
        } message: {
            Text("Your emotion entry has been saved successfully.")
        }
        .alert("Archive Entry", isPresented: $showArchiveAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Archive", role: .destructive) {
                if let entry = entryToArchive {
                    dataManager.archiveEntry(entry)
                    entryToArchive = nil
                }
            }
        } message: {
            Text("This will move the entry to the archive. You can restore it later from the archive.")
        }
    }
    
    private func saveEntry() {
        guard let emotion = selectedEmotion else {
            emotionError = "Please select a mood"
            return
        }
        
        let trimmedReason = reason.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedReason.isEmpty else {
            reasonError = "Please provide a reason"
            return
        }
        
        let entry = EmotionEntry(date: selectedDate, emotion: emotion, reason: trimmedReason)
        dataManager.addEntry(entry)
        
        showSuccessAlert = true
        clearForm()
    }
    
    private func clearForm() {
        selectedDate = Date()
        selectedEmotion = nil
        reason = ""
        emotionError = ""
        reasonError = ""
    }
}

struct EmotionButton: View {
    let emotion: EmotionType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: emotion.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.primaryText)
                
                Text(emotion.title)
                    .font(.poppinsRegular(size: 14))
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.primaryText)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(isSelected ? AppColors.accentYellow : AppColors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? AppColors.accentYellow : Color.clear, lineWidth: 2)
            )
        }
    }
}

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button("Done") {
                        dismiss()
                    }
                    .opacity(0)
                    .disabled(true)
                    
                    Spacer()
                    
                    Text("Select Date")
                        .font(.poppinsBold(size: 20))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .font(.poppinsMedium(size: 16))
                    .foregroundColor(AppColors.primaryText)
                }
                
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .colorInvert()
                
                Spacer()
            }
            .padding()
        }
    }
}

extension DateFormatter {
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

struct RecentEntryCard: View {
    let entry: EmotionEntry
    let onArchive: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: entry.emotion.icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(AppColors.accentYellow)
                .frame(width: 32, height: 32)
                .background(AppColors.accentYellow.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(DateFormatter.displayFormatter.string(from: entry.date))
                    .font(.poppinsMedium(size: 14))
                    .foregroundColor(AppColors.primaryText)
                
                Text(entry.emotion.title)
                    .font(.poppinsRegular(size: 12))
                    .foregroundColor(AppColors.accentYellow)
                
                Text(entry.reason)
                    .font(.poppinsRegular(size: 12))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            
            Spacer()
            
            Button(action: onArchive) {
                Image(systemName: "archivebox")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryText.opacity(0.6))
            }
        }
        .padding(12)
        .background(AppColors.cardBackground)
        .cornerRadius(8)
    }
}

#Preview {
    NewEntryView(dataManager: EmotionDataManager())
}
