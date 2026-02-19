import SwiftUI

struct FilterView: View {
    @ObservedObject var bagViewModel: BagViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var tempFilter: BagFilter
    
    init(bagViewModel: BagViewModel) {
        self.bagViewModel = bagViewModel
        self._tempFilter = State(initialValue: bagViewModel.currentFilter)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.theme.gradientStart, Color.theme.gradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        filterSection(
                            title: "Categories",
                            items: BagCategory.allCases.map { $0.rawValue },
                            selectedItems: Binding(
                                get: { Set(tempFilter.categories.map { $0.rawValue }) },
                                set: { newValue in
                                    tempFilter.categories = Set(newValue.compactMap { BagCategory(rawValue: $0) })
                                }
                            )
                        )
                        
                        filterSection(
                            title: "Sizes",
                            items: BagSize.allCases.map { $0.rawValue },
                            selectedItems: Binding(
                                get: { Set(tempFilter.sizes.map { $0.rawValue }) },
                                set: { newValue in
                                    tempFilter.sizes = Set(newValue.compactMap { BagSize(rawValue: $0) })
                                }
                            )
                        )
                        
                        filterSection(
                            title: "Styles",
                            items: BagStyle.allCases.map { $0.rawValue },
                            selectedItems: Binding(
                                get: { Set(tempFilter.styles.map { $0.rawValue }) },
                                set: { newValue in
                                    tempFilter.styles = Set(newValue.compactMap { BagStyle(rawValue: $0) })
                                }
                            )
                        )
                        
                        filterSection(
                            title: "Brands",
                            items: bagViewModel.availableBrands,
                            selectedItems: Binding(
                                get: { tempFilter.brands },
                                set: { tempFilter.brands = $0 }
                            )
                        )
                        
                        filterSection(
                            title: "Colors",
                            items: bagViewModel.availableColors,
                            selectedItems: Binding(
                                get: { tempFilter.colors },
                                set: { tempFilter.colors = $0 }
                            )
                        )
                        
                        priceRangeSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 16)
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
                    .foregroundColor(Color.theme.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        bagViewModel.currentFilter = tempFilter
                        bagViewModel.filterBags()
                        dismiss()
                    }
                    .foregroundColor(Color.theme.accentYellow)
                    .fontWeight(.semibold)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func filterSection(title: String, items: [String], selectedItems: Binding<Set<String>>) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                ForEach(items, id: \.self) { item in
                    FilterChip(
                        title: item,
                        isSelected: selectedItems.wrappedValue.contains(item)
                    ) {
                        if selectedItems.wrappedValue.contains(item) {
                            selectedItems.wrappedValue.remove(item)
                        } else {
                            selectedItems.wrappedValue.insert(item)
                        }
                    }
                }
            }
        }
    }
    
    private var priceRangeSection: some View {
        let options: [(ClosedRange<Double>, String)] = [
            (0.0...100.0, "$0-100"),
            (100.0...200.0, "$100-200"),
            (200.0...300.0, "$200-300"),
            (300.0...500.0, "$300-500")
        ]
        return VStack(alignment: .leading, spacing: 12) {
            Text("Price Range")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            VStack(spacing: 8) {
                HStack {
                    Text("$\(Int(tempFilter.priceRange.lowerBound))")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                    
                    Text("$\(Int(tempFilter.priceRange.upperBound))")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(Color.theme.primaryText)
                }
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {
                    ForEach(Array(options.enumerated()), id: \.offset) { index, _ in
                        PriceRangeChipView(
                            range: options[index].0,
                            title: options[index].1,
                            selectedRange: Binding(
                                get: { tempFilter.priceRange },
                                set: { newValue in
                                    var updated = tempFilter
                                    updated.priceRange = newValue
                                    tempFilter = updated
                                }
                            )
                        )
                    }
                }
            }
        }
    }
}

private struct PriceRangeChipView: View {
    let range: ClosedRange<Double>
    let title: String
    @Binding var selectedRange: ClosedRange<Double>
    
    var body: some View {
        FilterChip(
            title: title,
            isSelected: selectedRange.lowerBound == range.lowerBound && selectedRange.upperBound == range.upperBound
        ) {
            selectedRange = range
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(isSelected ? Color.theme.primaryText : Color.theme.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.theme.accentYellow : Color.theme.cardBackground)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.theme.accentYellow : Color.theme.cardBorder, lineWidth: 1)
                )
        }
    }
}

#Preview {
    FilterView(bagViewModel: BagViewModel())
}
