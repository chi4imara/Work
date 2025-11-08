import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: DiaryViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedMoods: Set<Mood>
    @State private var selectedTimeFilter: TimeFilter
    
    init(viewModel: DiaryViewModel) {
        self.viewModel = viewModel
        self._selectedMoods = State(initialValue: viewModel.selectedMoodFilters)
        self._selectedTimeFilter = State(initialValue: viewModel.timeFilter)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.mainBackgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Filter by Mood")
                            .font(AppFonts.headline)
                            .fontWeight(.medium)
                            .foregroundColor(AppColors.primaryBlue)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                            ForEach(Mood.allCases, id: \.self) { mood in
                                MoodFilterButton(
                                    mood: mood,
                                    isSelected: selectedMoods.contains(mood),
                                    action: {
                                        if selectedMoods.contains(mood) {
                                            selectedMoods.remove(mood)
                                        } else {
                                            selectedMoods.insert(mood)
                                        }
                                    }
                                )
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Time Period")
                            .font(AppFonts.headline)
                            .fontWeight(.medium)
                            .foregroundColor(AppColors.primaryBlue)
                        
                        VStack(spacing: 12) {
                            ForEach(TimeFilter.allCases, id: \.self) { filter in
                                TimeFilterButton(
                                    filter: filter,
                                    isSelected: selectedTimeFilter == filter,
                                    action: { selectedTimeFilter = filter }
                                )
                            }
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Button {
                            viewModel.setMoodFilters(selectedMoods)
                            viewModel.setTimeFilter(selectedTimeFilter)
                            dismiss()
                        } label: {
                            Text("Apply Filters")
                                .font(AppFonts.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            LinearGradient(
                                                colors: [AppColors.primaryBlue, AppColors.accentYellow],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                }
                        }
                        
                        Button("Clear All") {
                            selectedMoods.removeAll()
                            selectedTimeFilter = .all
                        }
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.darkGray)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
    }
}

struct MoodFilterButton: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: mood.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .white : AppColors.primaryBlue)
                    .frame(width: 50, height: 50)
                    .background {
                        Circle()
                            .fill(isSelected ? AppColors.primaryBlue : AppColors.lightPurple.opacity(0.3))
                            .overlay {
                                if isSelected {
                                    Circle()
                                        .stroke(AppColors.accentYellow, lineWidth: 2)
                                }
                            }
                    }
                
                Text(mood.displayName)
                    .font(AppFonts.caption)
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.darkGray)
                    .fontWeight(isSelected ? .medium : .regular)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
    }
}

struct TimeFilterButton: View {
    let filter: TimeFilter
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(filter.rawValue)
                    .font(AppFonts.body)
                    .foregroundColor(isSelected ? .white : AppColors.darkGray)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? AnyShapeStyle(AppColors.primaryBlue) : AnyShapeStyle(AppColors.cardGradient))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? AnyShapeStyle(AppColors.accentYellow) : AnyShapeStyle(AppColors.lightPurple), lineWidth: 1)
                    }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FilterView(viewModel: DiaryViewModel())
}
