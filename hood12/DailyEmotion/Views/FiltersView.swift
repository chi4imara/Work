import SwiftUI

struct FiltersView: View {
    @ObservedObject var dataManager: EmotionDataManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var dateFrom: Date?
    @State private var dateTo: Date?
    @State private var selectedEmotions: Set<EmotionType> = []
    @State private var showDateFromPicker = false
    @State private var showDateToPicker = false
    @State private var dateError = ""
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                            .frame(width: 40, height: 40)
                            .background(AppColors.cardBackground)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("Archive Filters")
                        .font(.poppinsBold(size: 20))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color.clear)
                            .frame(width: 40, height: 40)
                    }
                    .disabled(true)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 30) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Date Range")
                                .font(.poppinsSemiBold(size: 18))
                                .foregroundColor(AppColors.primaryText)
                            
                            VStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("From")
                                        .font(.poppinsMedium(size: 14))
                                        .foregroundColor(AppColors.secondaryText)
                                    
                                    Button(action: { showDateFromPicker = true }) {
                                        HStack {
                                            Image(systemName: "calendar")
                                                .foregroundColor(AppColors.accentYellow)
                                            
                                            Text(dateFrom != nil ? DateFormatter.displayFormatter.string(from: dateFrom!) : "Select start date")
                                                .font(.poppinsMedium(size: 16))
                                                .foregroundColor(dateFrom != nil ? AppColors.primaryText : AppColors.placeholderText)
                                            
                                            Spacer()
                                            
                                            if dateFrom != nil {
                                                Button(action: { dateFrom = nil; validateDates() }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(AppColors.primaryText.opacity(0.6))
                                                }
                                            }
                                        }
                                        .padding(16)
                                        .background(AppColors.cardBackground)
                                        .cornerRadius(12)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("To")
                                        .font(.poppinsMedium(size: 14))
                                        .foregroundColor(AppColors.secondaryText)
                                    
                                    Button(action: { showDateToPicker = true }) {
                                        HStack {
                                            Image(systemName: "calendar")
                                                .foregroundColor(AppColors.accentYellow)
                                            
                                            Text(dateTo != nil ? DateFormatter.displayFormatter.string(from: dateTo!) : "Select end date")
                                                .font(.poppinsMedium(size: 16))
                                                .foregroundColor(dateTo != nil ? AppColors.primaryText : AppColors.placeholderText)
                                            
                                            Spacer()
                                            
                                            if dateTo != nil {
                                                Button(action: { dateTo = nil; validateDates() }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(AppColors.primaryText.opacity(0.6))
                                                }
                                            }
                                        }
                                        .padding(16)
                                        .background(AppColors.cardBackground)
                                        .cornerRadius(12)
                                    }
                                }
                            }
                            
                            if !dateError.isEmpty {
                                Text(dateError)
                                    .font(.poppinsRegular(size: 14))
                                    .foregroundColor(AppColors.errorRed)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Filter by Emotions")
                                .font(.poppinsSemiBold(size: 18))
                                .foregroundColor(AppColors.primaryText)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(EmotionType.allCases, id: \.self) { emotion in
                                    EmotionFilterButton(
                                        emotion: emotion,
                                        isSelected: selectedEmotions.contains(emotion)
                                    ) {
                                        if selectedEmotions.contains(emotion) {
                                            selectedEmotions.remove(emotion)
                                        } else {
                                            selectedEmotions.insert(emotion)
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(spacing: 16) {
                            Button(action: applyFilters) {
                                Text("Apply Filters")
                                    .font(.poppinsSemiBold(size: 18))
                                    .foregroundColor(AppColors.primaryBlue)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(AppColors.accentYellow)
                                    .cornerRadius(28)
                            }
                            
                            Button(action: resetFilters) {
                                Text("Reset Filters")
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
        .sheet(isPresented: $showDateFromPicker) {
            DatePickerSheet(selectedDate: Binding(
                get: { dateFrom ?? Date() },
                set: { dateFrom = $0; validateDates() }
            ))
        }
        .sheet(isPresented: $showDateToPicker) {
            DatePickerSheet(selectedDate: Binding(
                get: { dateTo ?? Date() },
                set: { dateTo = $0; validateDates() }
            ))
        }
    }
    
    private func validateDates() {
        dateError = ""
        
        if let from = dateFrom, let to = dateTo {
            if to < from {
                dateError = "End date cannot be earlier than start date"
            }
        }
    }
    
    private func applyFilters() {
        guard dateError.isEmpty else { return }
        
        dataManager.applyFilters(
            dateFrom: dateFrom,
            dateTo: dateTo,
            emotions: selectedEmotions,
            useArchived: true
        )
        
        dismiss()
    }
    
    private func resetFilters() {
        dateFrom = nil
        dateTo = nil
        selectedEmotions.removeAll()
        dateError = ""
        
        dataManager.clearFilters(useArchived: true)
        dismiss()
    }
}

struct EmotionFilterButton: View {
    let emotion: EmotionType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.accentYellow : AppColors.primaryText.opacity(0.6))
                
                Image(systemName: emotion.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Text(emotion.title)
                    .font(.poppinsRegular(size: 12))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            .padding(16)
            .background(isSelected ? AppColors.accentYellow.opacity(0.2) : AppColors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 13)
                    .stroke(isSelected ? AppColors.accentYellow : Color.clear, lineWidth: 1)
            )
        }
    }
}

#Preview {
    FiltersView(dataManager: EmotionDataManager())
}
