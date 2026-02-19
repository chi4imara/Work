import SwiftUI

struct FiltersView: View {
    @ObservedObject var viewModel: AccessoryViewModel
    @Environment(\.dismiss) private var dismiss
    
    let colors = ["Black", "White", "Brown", "Gold", "Silver", "Beige", "Pink", "Blue"]
    let brands = ["Chanel", "Gucci", "Prada", "Hermès", "Tiffany & Co", "Cartier", "Louis Vuitton"]
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: AppConstants.sectionSpacing) {
                        styleSection
                        categorySection
                        brandSection
                        colorSection
                        priceSection
                    }
                    .padding(.horizontal, AppConstants.cardPadding)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear All") {
                        viewModel.clearFilters()
                    }
                    .foregroundColor(AppColors.accentPink)
                    .font(.playfairDisplay(16, weight: .medium))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        viewModel.applyFilters()
                        dismiss()
                    }
                    .foregroundColor(AppColors.textBlue)
                    .font(.playfairDisplay(16, weight: .semibold))
                }
            }
        }
    }
    
    private var styleSection: some View {
        FilterSection(title: "Style") {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(AccessoryStyle.allCases, id: \.self) { style in
                    FilterChip(
                        title: style.rawValue,
                        isSelected: viewModel.selectedStyle == style,
                        color: style.color
                    ) {
                        viewModel.selectedStyle = viewModel.selectedStyle == style ? nil : style
                    }
                }
            }
        }
    }
    
    private var categorySection: some View {
        FilterSection(title: "Category") {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(AccessoryCategory.allCases, id: \.self) { category in
                    FilterChip(
                        title: category.rawValue,
                        isSelected: viewModel.selectedCategory == category,
                        icon: category.icon
                    ) {
                        viewModel.selectedCategory = viewModel.selectedCategory == category ? nil : category
                    }
                }
            }
        }
    }
    
    private var brandSection: some View {
        FilterSection(title: "Brand") {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(brands, id: \.self) { brand in
                    FilterChip(
                        title: brand,
                        isSelected: viewModel.selectedBrand == brand
                    ) {
                        viewModel.selectedBrand = viewModel.selectedBrand == brand ? nil : brand
                    }
                }
            }
        }
    }
    
    private var colorSection: some View {
        FilterSection(title: "Color") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                ForEach(colors, id: \.self) { color in
                    ColorFilterChip(
                        color: color,
                        isSelected: viewModel.selectedColor == color
                    ) {
                        viewModel.selectedColor = viewModel.selectedColor == color ? nil : color
                    }
                }
            }
        }
    }
    
    private var priceSection: some View {
        FilterSection(title: "Price Range: $\(Int(viewModel.priceRange.lowerBound)) - $\(Int(viewModel.priceRange.upperBound))") {
            VStack(spacing: 16) {
                RangeSlider(
                    range: $viewModel.priceRange,
                    bounds: 0...5000,
                    step: 50
                )
                
                HStack {
                    Text("$0")
                        .font(.playfairDisplay(12, weight: .medium))
                        .foregroundColor(AppColors.darkGray)
                    
                    Spacer()
                    
                    Text("$5000")
                        .font(.playfairDisplay(12, weight: .medium))
                        .foregroundColor(AppColors.darkGray)
                }
            }
        }
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
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.textBlue)
            
            content
        }
        .padding(AppConstants.cardPadding)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let color: Color?
    let icon: String?
    let action: () -> Void
    
    init(title: String, isSelected: Bool, color: Color? = nil, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.color = color
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16))
                }
                
                Text(title)
                    .font(.playfairDisplay(14, weight: .medium))
            }
            .foregroundColor(isSelected ? AppColors.backgroundWhite : (color ?? AppColors.textBlue))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(
                isSelected ? (color ?? AppColors.textBlue) : AppColors.backgroundWhite
            )
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(color ?? AppColors.textBlue, lineWidth: isSelected ? 0 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ColorFilterChip: View {
    let color: String
    let isSelected: Bool
    let action: () -> Void
    
    var colorValue: Color {
        switch color.lowercased() {
        case "black": return .black
        case "white": return .white
        case "brown": return .brown
        case "gold": return .yellow
        case "silver": return .gray
        case "beige": return Color(red: 0.96, green: 0.96, blue: 0.86)
        case "pink": return .pink
        case "blue": return .blue
        default: return .gray
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Circle()
                    .fill(colorValue)
                    .frame(width: 30, height: 30)
                    .overlay(
                        Circle()
                            .stroke(AppColors.textBlue, lineWidth: isSelected ? 3 : 1)
                    )
                
                Text(color)
                    .font(.playfairDisplay(10, weight: .medium))
                    .foregroundColor(AppColors.textBlue)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RangeSlider: View {
    @Binding var range: ClosedRange<Double>
    let bounds: ClosedRange<Double>
    let step: Double
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(AppColors.lightGray)
                    .frame(height: 6)
                    .cornerRadius(3)
                
                Rectangle()
                    .fill(AppColors.primaryYellow)
                    .frame(width: sliderWidth, height: 6)
                    .cornerRadius(3)
                    .offset(x: sliderOffset)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        updateRange(with: value)
                    }
            )
        }
    }
    
    private var sliderWidth: CGFloat {
        let totalWidth = UIScreen.main.bounds.width - 64
        let rangeWidth = range.upperBound - range.lowerBound
        let boundsWidth = bounds.upperBound - bounds.lowerBound
        return totalWidth * CGFloat(rangeWidth / boundsWidth)
    }
    
    private var sliderOffset: CGFloat {
        let totalWidth = UIScreen.main.bounds.width - 64
        let boundsWidth = bounds.upperBound - bounds.lowerBound
        let offsetRatio = (range.lowerBound - bounds.lowerBound) / boundsWidth
        return totalWidth * CGFloat(offsetRatio)
    }
    
    private func updateRange(with value: DragGesture.Value) {
        let totalWidth = UIScreen.main.bounds.width - 64
        let boundsWidth = bounds.upperBound - bounds.lowerBound
        let ratio = Double(value.location.x / totalWidth)
        let newValue = bounds.lowerBound + (ratio * boundsWidth)
        
        let steppedValue = round(newValue / step) * step
        let clampedValue = max(bounds.lowerBound, min(bounds.upperBound, steppedValue))
        
        let currentRange = range.upperBound - range.lowerBound
        range = clampedValue...(clampedValue + currentRange)
    }
}

#Preview {
    FiltersView(viewModel: AccessoryViewModel())
}
