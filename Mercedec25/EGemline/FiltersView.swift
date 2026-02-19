import SwiftUI

struct FiltersView: View {
    @Binding var selectedCategory: JewelryCategory?
    @Binding var selectedStyle: JewelryStyle?
    @Binding var priceRange: ClosedRange<Double>
    
    @Environment(\.presentationMode) var presentationMode
    @State private var tempPriceRange: ClosedRange<Double>
    
    init(selectedCategory: Binding<JewelryCategory?>, selectedStyle: Binding<JewelryStyle?>, priceRange: Binding<ClosedRange<Double>>) {
        self._selectedCategory = selectedCategory
        self._selectedStyle = selectedStyle
        self._priceRange = priceRange
        self._tempPriceRange = State(initialValue: priceRange.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                GridPatternView()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        filterSection(title: "Category") {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(JewelryCategory.allCases, id: \.self) { category in
                                    FilterButton(
                                        title: category.rawValue,
                                        icon: category.icon,
                                        isSelected: selectedCategory == category
                                    ) {
                                        if selectedCategory == category {
                                            selectedCategory = nil
                                        } else {
                                            selectedCategory = category
                                        }
                                    }
                                }
                            }
                        }
                        
                        filterSection(title: "Style") {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(JewelryStyle.allCases, id: \.self) { style in
                                    FilterButton(
                                        title: style.rawValue,
                                        icon: "sparkles",
                                        isSelected: selectedStyle == style
                                    ) {
                                        if selectedStyle == style {
                                            selectedStyle = nil
                                        } else {
                                            selectedStyle = style
                                        }
                                    }
                                }
                            }
                        }
                        
                        filterSection(title: "Price Range") {
                            VStack(spacing: 16) {
                                HStack {
                                    Text("$\(Int(tempPriceRange.lowerBound))")
                                        .font(.playfairDisplay(16, weight: .semibold))
                                        .foregroundColor(ColorTheme.primaryText)
                                    
                                    Spacer()
                                    
                                    Text("$\(Int(tempPriceRange.upperBound))")
                                        .font(.playfairDisplay(16, weight: .semibold))
                                        .foregroundColor(ColorTheme.primaryText)
                                }
                                
                                RangeSlider(
                                    range: $tempPriceRange,
                                    bounds: 0...5000,
                                    step: 50
                                )
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Reset") {
                    selectedCategory = nil
                    selectedStyle = nil
                    tempPriceRange = 0...5000
                },
                trailing: Button("Apply") {
                    priceRange = tempPriceRange
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(ColorTheme.primaryBlue)
            )
        }
    }
    
    private func filterSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            content()
        }
    }
}

struct FilterButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? ColorTheme.whiteText : ColorTheme.primaryText)
                
                Text(title)
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(isSelected ? ColorTheme.whiteText : ColorTheme.primaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? ColorTheme.primaryBlue : ColorTheme.backgroundWhite)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 3)
            )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct RangeSlider: View {
    @Binding var range: ClosedRange<Double>
    let bounds: ClosedRange<Double>
    let step: Double
    
    var body: some View {
        GeometryReader { geometry in
            let sliderWidth = geometry.size.width
            let lowerPercent = (range.lowerBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
            let upperPercent = (range.upperBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(ColorTheme.lightGray)
                    .frame(height: 4)
                    .cornerRadius(2)
                
                Rectangle()
                    .fill(ColorTheme.primaryBlue)
                    .frame(width: sliderWidth * CGFloat(upperPercent - lowerPercent), height: 4)
                    .cornerRadius(2)
                    .offset(x: sliderWidth * CGFloat(lowerPercent))
                
                Circle()
                    .fill(ColorTheme.primaryYellow)
                    .frame(width: 20, height: 20)
                    .offset(x: sliderWidth * CGFloat(lowerPercent) - 10)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let percent = min(max(0, (value.location.x) / sliderWidth), CGFloat(upperPercent))
                                let newValue = bounds.lowerBound + Double(percent) * (bounds.upperBound - bounds.lowerBound)
                                let steppedValue = round(newValue / step) * step
                                range = steppedValue...range.upperBound
                            }
                    )
                
                Circle()
                    .fill(ColorTheme.primaryYellow)
                    .frame(width: 20, height: 20)
                    .offset(x: sliderWidth * CGFloat(upperPercent) - 10)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let percent = min(max(CGFloat(lowerPercent), (value.location.x) / sliderWidth), 1)
                                let newValue = bounds.lowerBound + Double(percent) * (bounds.upperBound - bounds.lowerBound)
                                let steppedValue = round(newValue / step) * step
                                range = range.lowerBound...steppedValue
                            }
                    )
            }
        }
        .frame(height: 20)
    }
}

#Preview {
    FiltersView(
        selectedCategory: .constant(.rings),
        selectedStyle: .constant(.classic),
        priceRange: .constant(500...2000)
    )
}
