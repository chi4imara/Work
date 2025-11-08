import SwiftUI

struct FiltersView: View {
    @ObservedObject var viewModel: CollectionViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGradient
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Spacer()
                        Spacer()
                        Spacer()
                        
                        Text("Filters & Sort")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.trailing, 5)
                        
                        Spacer()
                        Spacer()
                        
                        Button("Done") {
                            isPresented = false
                        }
                        .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Sort By")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                VStack(spacing: 8) {
                                    ForEach(CollectionViewModel.SortOption.allCases, id: \.self) { option in
                                        Button(action: {
                                            viewModel.sortOption = option
                                        }) {
                                            HStack {
                                                Text(option.rawValue)
                                                    .font(.body)
                                                    .foregroundColor(.white)
                                                
                                                Spacer()
                                                
                                                if viewModel.sortOption == option {
                                                    Image(systemName: "checkmark")
                                                        .foregroundColor(.accentGreen)
                                                }
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.white.opacity(viewModel.sortOption == option ? 0.3 : 0.1))
                                            )
                                        }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Category")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        CategoryChip(title: "All", isSelected: viewModel.selectedCategory == "All") {
                                            viewModel.selectedCategory = "All"
                                        }
                                        
                                        ForEach(viewModel.categories, id: \.self) { category in
                                            CategoryChip(title: category, isSelected: viewModel.selectedCategory == category) {
                                                viewModel.selectedCategory = category
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Quick Filters")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                VStack(spacing: 12) {
                                    FilterToggle(title: "Only with Value", isOn: $viewModel.showOnlyWithValue)
                                    FilterToggle(title: "Duplicates Only", isOn: $viewModel.showDuplicatesOnly)
                                    FilterToggle(title: "For Trade Only", isOn: $viewModel.showForTradeOnly)
                                    FilterToggle(title: "Needs Verification", isOn: $viewModel.showNeedsVerification)
                                }
                            }
                            
                            Button(action: resetFilters) {
                                Text("Reset All Filters")
                                    .font(.headline)
                                    .foregroundColor(.primaryBlue)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.white)
                                    )
                            }
                            .padding(.top, 20)
                        }
                        .padding(20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func resetFilters() {
        viewModel.searchText = ""
        viewModel.selectedCategory = "All"
        viewModel.sortOption = .dateAdded
        viewModel.showOnlyWithValue = false
        viewModel.showDuplicatesOnly = false
        viewModel.showForTradeOnly = false
        viewModel.showNeedsVerification = false
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .primaryBlue : .white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? Color.white : Color.white.opacity(0.2))
                )
        }
    }
}

struct FilterToggle: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.white)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .accentGreen))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
}

#Preview {
    FiltersView(viewModel: CollectionViewModel(), isPresented: .constant(true))
}
