import SwiftUI

struct HistoryFilterView: View {
    @ObservedObject var viewModel: IdeasViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDateRange: DateRange = .all
    @State private var selectedEventTypes: Set<HistoryEventType> = Set(HistoryEventType.allCases)
    @State private var customStartDate = Date()
    @State private var customEndDate = Date()
    @State private var showingDatePicker = false
    @State private var datePickerType: DatePickerType = .start
    
    enum DateRange: String, CaseIterable {
        case all = "All Time"
        case today = "Today"
        case week = "This Week"
        case month = "This Month"
        case custom = "Custom Range"
    }
    
    enum DatePickerType {
        case start, end
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                
                HStack {
                    Button("Reset") {
                        resetFilters()
                    }
                    .foregroundColor(AppColors.textSecondary)
                    
                    Spacer()
                    
                    Text("Filter History")
                        .font(.theme.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button("Apply") {
                        applyFilters()
                    }
                    .font(.theme.buttonMedium)
                    .foregroundColor(AppColors.primaryOrange)
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Date Range")
                                .font(.theme.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            VStack(spacing: 8) {
                                ForEach(DateRange.allCases, id: \.self) { range in
                                    Button(action: {
                                        selectedDateRange = range
                                    }) {
                                        HStack {
                                            Text(range.rawValue)
                                                .font(.theme.body)
                                                .foregroundColor(AppColors.textPrimary)
                                            
                                            Spacer()
                                            
                                            if selectedDateRange == range {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(AppColors.primaryOrange)
                                            } else {
                                                Image(systemName: "circle")
                                                    .foregroundColor(AppColors.textSecondary)
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(selectedDateRange == range ?
                                                      AppColors.primaryOrange.opacity(0.1) :
                                                        AppColors.cardBackground.opacity(0.5))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(selectedDateRange == range ?
                                                                AppColors.primaryOrange.opacity(0.3) :
                                                                    AppColors.cardBorder.opacity(0.5),
                                                                lineWidth: 1)
                                                )
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            
                            if selectedDateRange == .custom {
                                VStack(spacing: 12) {
                                    Button(action: {
                                        datePickerType = .start
                                        showingDatePicker = true
                                    }) {
                                        HStack {
                                            Text("Start Date")
                                                .font(.theme.body)
                                                .foregroundColor(AppColors.textPrimary)
                                            
                                            Spacer()
                                            
                                            Text(DateFormatter.shortDate.string(from: customStartDate))
                                                .font(.theme.body)
                                                .foregroundColor(AppColors.textSecondary)
                                            
                                            Image(systemName: "calendar")
                                                .font(.caption)
                                                .foregroundColor(AppColors.textSecondary)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(AppColors.cardBackground)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(AppColors.cardBorder, lineWidth: 1)
                                        )
                                    }
                                    
                                    Button(action: {
                                        datePickerType = .end
                                        showingDatePicker = true
                                    }) {
                                        HStack {
                                            Text("End Date")
                                                .font(.theme.body)
                                                .foregroundColor(AppColors.textPrimary)
                                            
                                            Spacer()
                                            
                                            Text(DateFormatter.shortDate.string(from: customEndDate))
                                                .font(.theme.body)
                                                .foregroundColor(AppColors.textSecondary)
                                            
                                            Image(systemName: "calendar")
                                                .font(.caption)
                                                .foregroundColor(AppColors.textSecondary)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(AppColors.cardBackground)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(AppColors.cardBorder, lineWidth: 1)
                                        )
                                    }
                                }
                                .padding(.top, 8)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Event Types")
                                .font(.theme.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            VStack(spacing: 8) {
                                ForEach(HistoryEventType.allCases, id: \.self) { eventType in
                                    Button(action: {
                                        if selectedEventTypes.contains(eventType) {
                                            selectedEventTypes.remove(eventType)
                                        } else {
                                            selectedEventTypes.insert(eventType)
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: eventType.icon)
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(eventType.color)
                                                .frame(width: 20)
                                            
                                            Text(eventType.displayName)
                                                .font(.theme.body)
                                                .foregroundColor(AppColors.textPrimary)
                                            
                                            Spacer()
                                            
                                            if selectedEventTypes.contains(eventType) {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(AppColors.primaryOrange)
                                            } else {
                                                Image(systemName: "circle")
                                                    .foregroundColor(AppColors.textSecondary)
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(selectedEventTypes.contains(eventType) ?
                                                      AppColors.primaryOrange.opacity(0.1) :
                                                        AppColors.cardBackground.opacity(0.5))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(selectedEventTypes.contains(eventType) ?
                                                                AppColors.primaryOrange.opacity(0.3) :
                                                                    AppColors.cardBorder.opacity(0.5),
                                                                lineWidth: 1)
                                                )
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(
                selectedDate: datePickerType == .start ? $customStartDate : $customEndDate
            )
        }
        .onAppear {
            loadCurrentFilters()
        }
    }
    
    private func resetFilters() {
        selectedDateRange = .all
        selectedEventTypes = Set(HistoryEventType.allCases)
        customStartDate = Date()
        customEndDate = Date()
    }
    
    private func applyFilters() {
        switch selectedDateRange {
        case .all:
            break
        case .today:
            let today = Calendar.current.startOfDay(for: Date())
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
            break
        case .week:
            let weekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
            break
        case .month:
            let monthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
            break
        case .custom:
            break
        }
        
        dismiss()
    }
    
    private func loadCurrentFilters() {
    }
}


#Preview {
    HistoryFilterView(viewModel: IdeasViewModel())
}
