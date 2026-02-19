import SwiftUI

struct FiltersView: View {
    @EnvironmentObject var viewModel: HabitsViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedTab: Int

    @State private var selectedCategories: Set<HabitCategory> = []
    @State private var timeFrom = ""
    @State private var timeTo = ""
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            AnimatedBubblesBackground()
            
            VStack {
                HStack {
                    Text("Filters")
                        .font(.ubuntu(size: 32, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        FilterSectionView(title: "Categories") {
                            VStack(spacing: 12) {
                                ForEach(HabitCategory.allCases, id: \.self) { category in
                                    CategoryCheckboxView(
                                        category: category,
                                        isSelected: selectedCategories.contains(category)
                                    ) { isSelected in
                                        if isSelected {
                                            selectedCategories.insert(category)
                                        } else {
                                            selectedCategories.remove(category)
                                        }
                                    }
                                }
                            }
                        }
                        
                        FilterSectionView(title: "Time Range") {
                            VStack(spacing: 16) {
                                HStack(spacing: 16) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("From")
                                            .font(.ubuntu(size: 14, weight: .medium))
                                            .foregroundColor(AppColors.primaryText)
                                        
                                        TextField("06:00", text: $timeFrom)
                                            .font(.ubuntu(size: 16))
                                            .foregroundColor(AppColors.primaryText)
                                            .padding(12)
                                            .background(Color.white)
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(AppColors.accentBlue.opacity(0.3), lineWidth: 1)
                                            )
                                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("To")
                                            .font(.ubuntu(size: 14, weight: .medium))
                                            .foregroundColor(AppColors.primaryText)
                                        
                                        TextField("22:00", text: $timeTo)
                                            .font(.ubuntu(size: 16))
                                            .foregroundColor(AppColors.primaryText)
                                            .padding(12)
                                            .background(Color.white)
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(AppColors.accentBlue.opacity(0.3), lineWidth: 1)
                                            )
                                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                    }
                                }
                                
                                Text("Enter time in HH:MM format (e.g., 06:00)")
                                    .font(.ubuntu(size: 12))
                                    .foregroundColor(AppColors.secondaryText)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        VStack(spacing: 12) {
                            Button(action: applyFilters) {
                                Text("Apply Filters")
                                    .font(.ubuntu(size: 16, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.accentGradient)
                                    .cornerRadius(25)
                                    .shadow(color: AppColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            
                            Button(action: resetFilters) {
                                Text("Reset")
                                    .font(.ubuntu(size: 16, weight: .medium))
                                    .foregroundColor(AppColors.secondaryText)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.white)
                                    .cornerRadius(25)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(AppColors.accentBlue.opacity(0.3), lineWidth: 1)
                                    )
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 20)
                }
            }
        }
        .accentColor(AppColors.accent)
        .onAppear {
            loadCurrentFilters()
        }
    }
    
    private func loadCurrentFilters() {
        selectedCategories = viewModel.filter.selectedCategories
        timeFrom = viewModel.filter.timeFrom
        timeTo = viewModel.filter.timeTo
    }
    
    private func applyFilters() {
        var newFilter = viewModel.filter
        newFilter.selectedCategories = selectedCategories
        newFilter.timeFrom = timeFrom.trimmingCharacters(in: .whitespacesAndNewlines)
        newFilter.timeTo = timeTo.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.applyFilter(newFilter)
        presentationMode.wrappedValue.dismiss()
        
        withAnimation {
            selectedTab = 0
        }
    }
    
    private func resetFilters() {
        selectedCategories.removeAll()
        timeFrom = ""
        timeTo = ""
        viewModel.resetFilters()
        presentationMode.wrappedValue.dismiss()
        
        withAnimation {
            selectedTab = 0
        }
    }
}

struct FilterSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.ubuntu(size: 20, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                content
                    .padding(20)
            }
            .cardStyle()
            .padding(.horizontal, 20)
        }
    }
}

struct CategoryCheckboxView: View {
    let category: HabitCategory
    let isSelected: Bool
    let onToggle: (Bool) -> Void
    
    var body: some View {
        Button(action: { onToggle(!isSelected) }) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(AppColors.accent, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.accent)
                            .frame(width: 16, height: 16)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                    }
                }
                
                Text(category.displayName)
                    .font(.ubuntu(size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
