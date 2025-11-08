import SwiftUI

struct EditEntryView: View {
    let entry: EmotionEntry
    @ObservedObject var dataManager: EmotionDataManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDate: Date
    @State private var selectedEmotion: EmotionType
    @State private var reason: String
    @State private var showDatePicker = false
    @State private var emotionError = ""
    @State private var reasonError = ""
    
    init(entry: EmotionEntry, dataManager: EmotionDataManager) {
        self.entry = entry
        self.dataManager = dataManager
        self._selectedDate = State(initialValue: entry.date)
        self._selectedEmotion = State(initialValue: entry.emotion)
        self._reason = State(initialValue: entry.reason)
    }
    
    private var isFormValid: Bool {
        !reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        Text("Cancel")
                            .font(.poppinsMedium(size: 16))
                            .foregroundColor(AppColors.primaryText)
                    }
                    
                    Spacer()
                    
                    Text("Edit Entry")
                        .font(.poppinsBold(size: 20))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: saveChanges) {
                        Text("Save")
                            .font(.poppinsSemiBold(size: 16))
                            .foregroundColor(isFormValid ? AppColors.primaryText : .gray)
                    }
                    .disabled(!isFormValid)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
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
                                    Text("Describe the reason for your mood")
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
    }
    
    private func saveChanges() {
        let trimmedReason = reason.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedReason.isEmpty else {
            reasonError = "Please provide a reason"
            return
        }
        
        var updatedEntry = entry
        updatedEntry.date = selectedDate
        updatedEntry.emotion = selectedEmotion
        updatedEntry.reason = trimmedReason
        
        dataManager.updateEntry(updatedEntry)
        dismiss()
    }
}

#Preview {
    EditEntryView(
        entry: EmotionEntry(emotion: .joy, reason: "Had a great day"),
        dataManager: EmotionDataManager()
    )
}
