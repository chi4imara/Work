import SwiftUI

struct EditItemView: View {
    let itemId: UUID
    @ObservedObject var viewModel: SeasonItemViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var itemName: String = ""
    @State private var selectedSeason: Season = .spring
    @State private var comment: String = ""
    @State private var isFavorite: Bool = false
    
    var item: SeasonItem? {
        viewModel.getItem(byId: itemId)
    }
    
    init(itemId: UUID, viewModel: SeasonItemViewModel) {
        self.itemId = itemId
        self.viewModel = viewModel
    }
    
    var isFormValid: Bool {
        !itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        Group {
            if let item = item {
                editItemContent(item: item)
            } else {
                Text("Item not found")
                    .font(FontManager.bauhausMedium(18))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .onAppear {
            if let item = item {
                itemName = item.name
                selectedSeason = item.season
                comment = item.comment
                isFavorite = item.isFavorite
            }
        }
    }
    
    @ViewBuilder
    private func editItemContent(item: SeasonItem) -> some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Item Name")
                                .font(FontManager.bauhausMedium(16))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter item name", text: $itemName)
                                .font(FontManager.bauhausLight(16))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.lightGray, lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Season")
                                .font(FontManager.bauhausMedium(16))
                                .foregroundColor(AppColors.primaryText)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(Season.allCases) { season in
                                    Button(action: {
                                        selectedSeason = season
                                    }) {
                                        HStack {
                                            Image(systemName: season.icon)
                                            Text(season.displayName)
                                                .font(FontManager.bauhausLight(16))
                                        }
                                        .foregroundColor(selectedSeason == season ? AppColors.contrastText : AppColors.primaryBlue)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(selectedSeason == season ? AppColors.primaryBlue : Color.white)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(AppColors.primaryBlue, lineWidth: 1)
                                        )
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment")
                                .font(FontManager.bauhausMedium(16))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Add a note about this item", text: $comment, axis: .vertical)
                                .font(FontManager.bauhausLight(16))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.lightGray, lineWidth: 1)
                                )
                                .lineLimit(3...6)
                        }
                        
                        HStack {
                            Text("In Favorites")
                                .font(FontManager.bauhausMedium(16))
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            Toggle("", isOn: $isFavorite)
                                .tint(AppColors.primaryYellow)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(AppColors.lightGray, lineWidth: 1)
                        )
                        
                        Spacer(minLength: 20)
                        
                        Button(action: saveChanges) {
                            Text("Save Changes")
                                .font(FontManager.bauhausMedium(18))
                                .foregroundColor(isFormValid ? AppColors.contrastText : AppColors.secondaryText)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isFormValid ? AppColors.primaryBlue : AppColors.lightGray)
                                .cornerRadius(12)
                        }
                        .disabled(!isFormValid)
                    }
                    .padding()
                }
            }
            .navigationTitle("Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
    }
    
    private func saveChanges() {
        guard var updatedItem = item else { return }
        updatedItem.name = itemName.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedItem.season = selectedSeason
        updatedItem.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedItem.isFavorite = isFavorite
        
        viewModel.updateItem(updatedItem)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let viewModel = SeasonItemViewModel()
    let testItem = SeasonItem(name: "Light Trench Coat", season: .spring, comment: "Perfect for cool spring days", isFavorite: true)
    viewModel.addItem(testItem)
    return EditItemView(
        itemId: testItem.id,
        viewModel: viewModel
    )
}
