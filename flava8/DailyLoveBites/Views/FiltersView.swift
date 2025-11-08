import SwiftUI

struct FiltersView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var tempTimeFilter: TimeFilter?
    @State private var tempDifficultyFilter: Recipe.Difficulty?
    @State private var tempServingsFilter: ServingsFilter?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        filterSection(
                            title: "Cooking Time",
                            icon: "clock"
                        ) {
                            VStack(spacing: 8) {
                                ForEach(TimeFilter.allCases, id: \.self) { filter in
                                    FilterOption(
                                        title: filter.displayName,
                                        isSelected: tempTimeFilter == filter
                                    ) {
                                        tempTimeFilter = tempTimeFilter == filter ? nil : filter
                                    }
                                }
                            }
                        }
                        
                        filterSection(
                            title: "Difficulty",
                            icon: "chart.bar"
                        ) {
                            VStack(spacing: 8) {
                                ForEach(Recipe.Difficulty.allCases, id: \.self) { difficulty in
                                    FilterOption(
                                        title: "\(difficulty.emoji) \(difficulty.localizedString)",
                                        isSelected: tempDifficultyFilter == difficulty
                                    ) {
                                        tempDifficultyFilter = tempDifficultyFilter == difficulty ? nil : difficulty
                                    }
                                }
                            }
                        }
                        
                        filterSection(
                            title: "Servings",
                            icon: "person.2"
                        ) {
                            VStack(spacing: 8) {
                                ForEach(ServingsFilter.allCases, id: \.self) { filter in
                                    FilterOption(
                                        title: filter.displayName,
                                        isSelected: tempServingsFilter == filter
                                    ) {
                                        tempServingsFilter = tempServingsFilter == filter ? nil : filter
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: HStack {
                    Button("Reset") {
                        resetFilters()
                    }
                    .foregroundColor(.errorRed)
                    
                    Button("Apply") {
                        applyFilters()
                    }
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                }
            )
            .preferredColorScheme(.dark)
            .onAppear {
                loadCurrentFilters()
            }
        }
    }
    
    private func filterSection<Content: View>(
        title: String,
        icon: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.primaryPurple)
                
                Text(title)
                    .font(AppFonts.titleSmall)
                    .foregroundColor(.white)
            }
            
            content()
        }
        .padding(20)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
    
    private func loadCurrentFilters() {
        tempTimeFilter = viewModel.selectedTimeFilter
        tempDifficultyFilter = viewModel.selectedDifficultyFilter
        tempServingsFilter = viewModel.selectedServingsFilter
    }
    
    private func applyFilters() {
        viewModel.selectedTimeFilter = tempTimeFilter
        viewModel.selectedDifficultyFilter = tempDifficultyFilter
        viewModel.selectedServingsFilter = tempServingsFilter
        presentationMode.wrappedValue.dismiss()
    }
    
    private func resetFilters() {
        tempTimeFilter = nil
        tempDifficultyFilter = nil
        tempServingsFilter = nil
    }
}

struct FilterOption: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(title)
                    .font(AppFonts.bodyMedium)
                    .foregroundColor(isSelected ? .white : .darkText)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                isSelected ? Color.primaryPurple : Color.white.opacity(0.9)
            )
            .cornerRadius(10)
        }
    }
}
