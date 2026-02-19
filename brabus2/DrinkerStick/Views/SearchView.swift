import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: DrinkViewModel
    @State private var showingFilters = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Text("Search")
                        .font(.playfair(32, weight: .bold))
                        .foregroundColor(Color.black)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(ColorTheme.textTertiary)
                    
                    TextField("Search drinks...", text: $viewModel.searchText)
                        .onChange(of: viewModel.searchText) { _ in
                            viewModel.applyFilters()
                        }
                }
                .padding()
                .background(ColorTheme.cardBackground)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                
                HStack {
                    Button(action: {
                        showingFilters = true
                    }) {
                        HStack {
                            Image(systemName: "slider.horizontal.3")
                            Text("Filters")
                        }
                        .font(.playfair(16, weight: .medium))
                        .foregroundColor(ColorTheme.primaryYellow)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(ColorTheme.cardBackground)
                        .cornerRadius(20)
                    }
                    
                    if hasActiveFilters {
                        Button(action: {
                            viewModel.clearFilters()
                        }) {
                            Text("Clear")
                                .font(.playfair(14, weight: .medium))
                                .foregroundColor(ColorTheme.primaryPink)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                if viewModel.filteredDrinks.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(ColorTheme.textTertiary.opacity(0.6))
                        
                        Text("No results")
                            .font(.playfair(20, weight: .medium))
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.filteredDrinks) { drink in
                                NavigationLink(destination: DrinkDetailView(drinkId: drink.id, viewModel: viewModel)) {
                                    DrinkCardView(drink: drink)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .padding(.top, 10)
        }
        .sheet(isPresented: $showingFilters) {
            FilterView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.applyFilters()
        }
    }
    
    private var hasActiveFilters: Bool {
        viewModel.selectedType != nil ||
        !viewModel.selectedCountry.isEmpty ||
        viewModel.strengthRange != 0...100
    }
}

struct FilterView: View {
    @ObservedObject var viewModel: DrinkViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var tempSelectedType: DrinkType? = nil
    @State private var tempSelectedCountry: String = ""
    @State private var tempStrengthRange: ClosedRange<Double> = 0...100
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Type")
                                .font(.playfair(18, weight: .semibold))
                                .foregroundColor(ColorTheme.textPrimary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    FilterChip(
                                        title: "All",
                                        isSelected: tempSelectedType == nil
                                    ) {
                                        tempSelectedType = nil
                                    }
                                    
                                    ForEach(DrinkType.allCases, id: \.self) { type in
                                        FilterChip(
                                            title: type.displayName,
                                            isSelected: tempSelectedType == type
                                        ) {
                                            tempSelectedType = type
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            .padding(.horizontal, -20)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Country")
                                .font(.playfair(18, weight: .semibold))
                                .foregroundColor(ColorTheme.textPrimary)
                            
                            TextField("Enter country name", text: $tempSelectedCountry)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Strength Range")
                                .font(.playfair(18, weight: .semibold))
                                .foregroundColor(ColorTheme.textPrimary)
                            
                            VStack(spacing: 8) {
                                HStack {
                                    Text(String(format: "%.0f%%", tempStrengthRange.lowerBound))
                                        .font(.playfair(14, weight: .medium))
                                        .foregroundColor(ColorTheme.textSecondary)
                                    
                                    Spacer()
                                    
                                    Text(String(format: "%.0f%%", tempStrengthRange.upperBound))
                                        .font(.playfair(14, weight: .medium))
                                        .foregroundColor(ColorTheme.textSecondary)
                                }
                                
                                RangeSlider(range: $tempStrengthRange, bounds: 0...100)
                            }
                        }
                        
                        Button(action: applyFilters) {
                            Text("Apply Filters")
                                .font(.playfair(18, weight: .semibold))
                                .foregroundColor(ColorTheme.buttonText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(ColorTheme.buttonBackground)
                                .cornerRadius(12)
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryYellow)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear All") {
                        clearAllFilters()
                    }
                    .foregroundColor(ColorTheme.primaryPink)
                }
            }
        }
        .onAppear {
            loadCurrentFilters()
        }
    }
    
    private func loadCurrentFilters() {
        tempSelectedType = viewModel.selectedType
        tempSelectedCountry = viewModel.selectedCountry
        tempStrengthRange = viewModel.strengthRange
    }
    
    private func applyFilters() {
        viewModel.selectedType = tempSelectedType
        viewModel.selectedCountry = tempSelectedCountry
        viewModel.strengthRange = tempStrengthRange
        viewModel.applyFilters()
        dismiss()
    }
    
    private func clearAllFilters() {
        tempSelectedType = nil
        tempSelectedCountry = ""
        tempStrengthRange = 0...100
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.playfair(14, weight: .medium))
                .foregroundColor(isSelected ? ColorTheme.buttonText : ColorTheme.textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ? ColorTheme.primaryPink : ColorTheme.cardBackground
                )
                .cornerRadius(20)
        }
    }
}

struct RangeSlider: View {
    @Binding var range: ClosedRange<Double>
    let bounds: ClosedRange<Double>
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(ColorTheme.divider)
                    .frame(height: 4)
                    .cornerRadius(2)
                
                Rectangle()
                    .fill(ColorTheme.primaryPink)
                    .frame(width: activeTrackWidth(in: geometry), height: 4)
                    .cornerRadius(2)
                    .offset(x: lowerThumbOffset(in: geometry))
                
                Circle()
                    .fill(ColorTheme.primaryPink)
                    .frame(width: 20, height: 20)
                    .offset(x: lowerThumbOffset(in: geometry))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                updateLowerBound(with: value, in: geometry)
                            }
                    )
                
                Circle()
                    .fill(ColorTheme.primaryPink)
                    .frame(width: 20, height: 20)
                    .offset(x: upperThumbOffset(in: geometry))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                updateUpperBound(with: value, in: geometry)
                            }
                    )
            }
        }
        .frame(height: 20)
    }
    
    private func lowerThumbOffset(in geometry: GeometryProxy) -> CGFloat {
        let percentage = (range.lowerBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
        return percentage * (geometry.size.width - 20)
    }
    
    private func upperThumbOffset(in geometry: GeometryProxy) -> CGFloat {
        let percentage = (range.upperBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
        return percentage * (geometry.size.width - 20)
    }
    
    private func activeTrackWidth(in geometry: GeometryProxy) -> CGFloat {
        let lowerPercentage = (range.lowerBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
        let upperPercentage = (range.upperBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
        return (upperPercentage - lowerPercentage) * (geometry.size.width - 20)
    }
    
    private func updateLowerBound(with value: DragGesture.Value, in geometry: GeometryProxy) {
        let percentage = max(0, min(1, value.location.x / (geometry.size.width - 20)))
        let newValue = bounds.lowerBound + percentage * (bounds.upperBound - bounds.lowerBound)
        range = min(newValue, range.upperBound - 1)...range.upperBound
    }
    
    private func updateUpperBound(with value: DragGesture.Value, in geometry: GeometryProxy) {
        let percentage = max(0, min(1, value.location.x / (geometry.size.width - 20)))
        let newValue = bounds.lowerBound + percentage * (bounds.upperBound - bounds.lowerBound)
        range = range.lowerBound...max(newValue, range.lowerBound + 1)
    }
}

#Preview {
    SearchView(viewModel: DrinkViewModel())
}
