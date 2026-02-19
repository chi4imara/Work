import SwiftUI

struct FiltersView: View {
    @ObservedObject var viewModel: MainScreenViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        FilterSection(title: "Massage Types") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(MassageType.allCases, id: \.self) { type in
                                    FilterToggleCard(
                                        title: type.rawValue,
                                        icon: type.icon,
                                        color: type.color,
                                        isSelected: viewModel.selectedMassageTypes.contains(type)
                                    ) {
                                        if viewModel.selectedMassageTypes.contains(type) {
                                            viewModel.selectedMassageTypes.remove(type)
                                        } else {
                                            viewModel.selectedMassageTypes.insert(type)
                                        }
                                    }
                                }
                            }
                        }
                        
                        FilterSection(title: "Session Duration") {
                            HStack(spacing: 12) {
                                ForEach(SessionDuration.allCases, id: \.self) { duration in
                                    FilterChip(
                                        title: duration.displayName,
                                        isSelected: viewModel.selectedDurations.contains(duration)
                                    ) {
                                        if viewModel.selectedDurations.contains(duration) {
                                            viewModel.selectedDurations.remove(duration)
                                        } else {
                                            viewModel.selectedDurations.insert(duration)
                                        }
                                    }
                                }
                                Spacer()
                            }
                        }
                        
                        FilterSection(title: "Max Price: $\(Int(viewModel.maxPrice))") {
                            VStack(spacing: 12) {
                                Slider(value: $viewModel.maxPrice, in: 50...300, step: 10)
                                    .accentColor(ColorTheme.primaryBlue)
                                
                                HStack {
                                    Text("$50")
                                        .font(.ubuntu(12, weight: .regular))
                                        .foregroundColor(ColorTheme.textSecondary)
                                    
                                    Spacer()
                                    
                                    Text("$300")
                                        .font(.ubuntu(12, weight: .regular))
                                        .foregroundColor(ColorTheme.textSecondary)
                                }
                            }
                        }
                        
                        FilterSection(title: "Minimum Rating") {
                            HStack(spacing: 8) {
                                ForEach(1...5, id: \.self) { rating in
                                    Button(action: {
                                        viewModel.minRating = Double(rating)
                                    }) {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(
                                                Double(rating) <= viewModel.minRating ? 
                                                ColorTheme.primaryYellow : 
                                                ColorTheme.textSecondary.opacity(0.3)
                                            )
                                    }
                                }
                                
                                Spacer()
                                
                                Text("\(Int(viewModel.minRating))+ stars")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(ColorTheme.textSecondary)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear All") {
                        viewModel.clearFilters()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.textSecondary)
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 12) {
                    Button(action: {
                        viewModel.applyFilters()
                        dismiss()
                    }) {
                        Text("Apply Filters (\(viewModel.filteredSessions.count))")
                            .font(.ubuntu(16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(ColorTheme.buttonGradient)
                            )
                            .shadow(color: ColorTheme.shadowColor, radius: 10, x: 0, y: 5)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                .background(
                    Rectangle()
                        .fill(ColorTheme.backgroundWhite.opacity(0.95))
                        .blur(radius: 10)
                        .ignoresSafeArea()
                )
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
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct FilterToggleCard: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .white : color)
                
                Text(title)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(isSelected ? .white : ColorTheme.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? color : ColorTheme.cardBackground)
                    .shadow(color: ColorTheme.shadowColor, radius: isSelected ? 8 : 4, x: 0, y: 2)
            )
        }
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(isSelected ? .white : ColorTheme.textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? ColorTheme.primaryBlue : ColorTheme.cardBackground)
                        .shadow(color: ColorTheme.shadowColor, radius: isSelected ? 5 : 2, x: 0, y: 2)
                )
        }
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

#Preview {
    FiltersView(viewModel: MainScreenViewModel())
}
