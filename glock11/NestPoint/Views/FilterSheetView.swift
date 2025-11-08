import SwiftUI

struct FilterSheetView: View {
    @ObservedObject var viewModel: PlacesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Category")
                            .font(FontManager.headline)
                            .foregroundColor(ColorTheme.primaryText)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                FilterChip(
                                    title: "All",
                                    isSelected: viewModel.selectedCategory == "All"
                                ) {
                                    viewModel.selectedCategory = "All"
                                    viewModel.updateFilteredPlaces()
                                }
                                
                                ForEach(viewModel.categoryNames, id: \.self) { category in
                                    FilterChip(
                                        title: category,
                                        isSelected: viewModel.selectedCategory == category
                                    ) {
                                        viewModel.selectedCategory = category
                                        viewModel.updateFilteredPlaces()
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.horizontal, -20)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Show Only Favorites")
                            .font(FontManager.headline)
                            .foregroundColor(ColorTheme.primaryText)
                        
                            HStack {
                                Toggle("", isOn: $viewModel.showOnlyFavorites)
                                    .toggleStyle(SwitchToggleStyle(tint: ColorTheme.primaryBlue))
                                    .onChange(of: viewModel.showOnlyFavorites) { _ in
                                        viewModel.updateFilteredPlaces()
                                    }
                                
                                Spacer()
                                
                                Text("Show only favorite places")
                                    .font(FontManager.body)
                                    .foregroundColor(ColorTheme.secondaryText)
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(ColorTheme.backgroundWhite)
                            .cornerRadius(12)
                            .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 2, x: 0, y: 1)
                        
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Reset") {
                    viewModel.resetFilters()
                },
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
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
                .font(FontManager.subheadline)
                .foregroundColor(isSelected ? .white : ColorTheme.primaryBlue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? ColorTheme.primaryBlue : ColorTheme.lightBlue.opacity(0.3))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FilterSheetView_Previews: PreviewProvider {
    static var previews: some View {
        FilterSheetView(viewModel: PlacesViewModel())
    }
}
