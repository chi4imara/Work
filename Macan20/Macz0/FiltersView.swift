import SwiftUI

struct FiltersView: View {
    @ObservedObject var viewModel: CosmeticViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedTab: Int
    
    @State private var selectedTypes: Set<ProductType>
    @State private var brandFilter: String
    @State private var colorFilter: String
    @State private var selectedLabels: Set<ProductLabel>
    
    init(viewModel: CosmeticViewModel, selectedTab: Binding<Int>) {
        self.viewModel = viewModel
        self._selectedTab = selectedTab
        _selectedTypes = State(initialValue: viewModel.currentFilter.selectedTypes)
        _brandFilter = State(initialValue: viewModel.currentFilter.brandFilter)
        _colorFilter = State(initialValue: viewModel.currentFilter.colorFilter)
        _selectedLabels = State(initialValue: viewModel.currentFilter.selectedLabels)
    }
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Filters")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorTheme.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Product Type")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(ProductType.allCases, id: \.self) { type in
                                    FilterToggleButton(
                                        title: type.displayName,
                                        isSelected: selectedTypes.contains(type)
                                    ) {
                                        if selectedTypes.contains(type) {
                                            selectedTypes.remove(type)
                                        } else {
                                            selectedTypes.insert(type)
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Brand")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            TextField("Enter brand name", text: $brandFilter)
                                .font(.ubuntu(16))
                                .foregroundColor(ColorTheme.white)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                                .accentColor(ColorTheme.lightBlue)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Color")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            TextField("Enter color description", text: $colorFilter)
                                .font(.ubuntu(16))
                                .foregroundColor(ColorTheme.white)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                                .accentColor(ColorTheme.lightBlue)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Labels")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            HStack(spacing: 16) {
                                ForEach([ProductLabel.favorite, ProductLabel.duplicate], id: \.self) { label in
                                    FilterToggleButton(
                                        title: "\(label.emoji) \(label.displayName)",
                                        isSelected: selectedLabels.contains(label)
                                    ) {
                                        if selectedLabels.contains(label) {
                                            selectedLabels.remove(label)
                                        } else {
                                            selectedLabels.insert(label)
                                        }
                                    }
                                }
                            }
                        }
                        
                        Button {
                            applyFilters()
                        } label: {
                            HStack {
                                Text("Apply")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(ColorTheme.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(ColorTheme.buttonGradient)
                            .cornerRadius(16)
                            .shadow(color: ColorTheme.lightBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        
                        
                        Button {
                            resetFilters()
                        } label: {
                            HStack {
                                Text("Reset")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(ColorTheme.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(ColorTheme.cardBackground)
                            .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
    }
    
    private func resetFilters() {
        selectedTypes.removeAll()
        brandFilter = ""
        colorFilter = ""
        selectedLabels.removeAll()
        
        var filter = FilterOptions()
        filter.reset()
        viewModel.applyFilter(filter)
        presentationMode.wrappedValue.dismiss()
        
        withAnimation {
            selectedTab = 0
        }
    }
    
    private func applyFilters() {
        var filter = FilterOptions()
        filter.selectedTypes = selectedTypes
        filter.brandFilter = brandFilter
        filter.colorFilter = colorFilter
        filter.selectedLabels = selectedLabels
        
        viewModel.applyFilter(filter)
        presentationMode.wrappedValue.dismiss()
        
        withAnimation {
            selectedTab = 0
        }
    }
}

struct FilterToggleButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(isSelected ? ColorTheme.white : ColorTheme.textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(isSelected ? ColorTheme.lightBlue : ColorTheme.cardBackground)
                .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
