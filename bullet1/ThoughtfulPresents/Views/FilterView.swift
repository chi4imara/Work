import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: GiftIdeaViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var tempFilter: GiftFilter
    @State private var minPrice = ""
    @State private var maxPrice = ""
    
    init(viewModel: GiftIdeaViewModel) {
        self.viewModel = viewModel
        self._tempFilter = State(initialValue: viewModel.currentFilter)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.theme.backgroundGradientStart, Color.theme.backgroundGradientEnd]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        FilterSection(title: "Status") {
                            VStack(spacing: 12) {
                                ForEach(GiftStatus.allCases, id: \.self) { status in
                                    FilterCheckbox(
                                        title: status.displayName,
                                        icon: status.iconName,
                                        isSelected: tempFilter.selectedStatuses.contains(status)
                                    ) {
                                        if tempFilter.selectedStatuses.contains(status) {
                                            tempFilter.selectedStatuses.remove(status)
                                        } else {
                                            tempFilter.selectedStatuses.insert(status)
                                        }
                                    }
                                }
                            }
                        }
                        
                        FilterSection(title: "Occasion") {
                            VStack(spacing: 12) {
                                FilterCheckbox(
                                    title: "Any Occasion",
                                    icon: "star",
                                    isSelected: tempFilter.selectedOccasion == nil
                                ) {
                                    tempFilter.selectedOccasion = nil
                                }
                                
                                ForEach(GiftOccasion.allCases, id: \.self) { occasion in
                                    FilterCheckbox(
                                        title: occasion.displayName,
                                        icon: "calendar",
                                        isSelected: tempFilter.selectedOccasion == occasion
                                    ) {
                                        tempFilter.selectedOccasion = tempFilter.selectedOccasion == occasion ? nil : occasion
                                    }
                                }
                            }
                        }
                        
                        FilterSection(title: "Price Range") {
                            VStack(spacing: 16) {
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("From")
                                            .font(.theme.caption)
                                            .foregroundColor(Color.theme.secondaryText)
                                        TextField("0.00", text: $minPrice)
                                            .keyboardType(.decimalPad)
                                            .padding()
                                            .background(Color.theme.cardBackground)
                                            .cornerRadius(8)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("To")
                                            .font(.theme.caption)
                                            .foregroundColor(Color.theme.secondaryText)
                                        TextField("999.99", text: $maxPrice)
                                            .keyboardType(.decimalPad)
                                            .padding()
                                            .background(Color.theme.cardBackground)
                                            .cornerRadius(8)
                                    }
                                }
                                
                                Button("Clear Price Range") {
                                    minPrice = ""
                                    maxPrice = ""
                                    tempFilter.priceRange = nil
                                }
                                .font(.theme.caption)
                                .foregroundColor(Color.theme.primaryBlue)
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, 50)
                }
                
                VStack {
                    Spacer()
                    VStack(spacing: 12) {
                        Button {
                            applyFilter()
                        } label: {
                            Text("Apply Filter")
                                .font(.theme.buttonLarge)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.theme.primaryBlue)
                                .cornerRadius(25)
                        }
                        
                        Button {
                            resetFilter()
                        } label: {
                            Text("Reset Filter")
                                .font(.theme.buttonMedium)
                                .foregroundColor(Color.theme.primaryBlue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(Color.theme.cardBackground)
                                .cornerRadius(22)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
            }
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.primaryBlue)
                }
            }
        }
        .onAppear {
            loadCurrentFilter()
        }
    }
    
    private func loadCurrentFilter() {
        tempFilter = viewModel.currentFilter
        
        if let priceRange = tempFilter.priceRange {
            minPrice = String(priceRange.lowerBound)
            maxPrice = String(priceRange.upperBound)
        }
    }
    
    private func applyFilter() {
        let minPriceValue = Double(minPrice) ?? 0
        let maxPriceValue = Double(maxPrice) ?? Double.greatestFiniteMagnitude
        
        if !minPrice.isEmpty || !maxPrice.isEmpty {
            tempFilter.priceRange = minPriceValue...maxPriceValue
        } else {
            tempFilter.priceRange = nil
        }
        
        viewModel.applyFilter(tempFilter)
        dismiss()
    }
    
    private func resetFilter() {
        tempFilter.reset()
        minPrice = ""
        maxPrice = ""
        viewModel.resetFilter()
        dismiss()
    }
}

struct FilterSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.theme.title3)
                .foregroundColor(Color.theme.primaryText)
            
            content
        }
        .padding(20)
        .background(Color.theme.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.theme.cardShadow, radius: 4, x: 0, y: 2)
    }
}

struct FilterCheckbox: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(Color.theme.primaryBlue)
                    .frame(width: 24)
                
                Text(title)
                    .font(.theme.body)
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? Color.theme.primaryBlue : Color.theme.secondaryText)
            }
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    FilterView(viewModel: GiftIdeaViewModel())
}
