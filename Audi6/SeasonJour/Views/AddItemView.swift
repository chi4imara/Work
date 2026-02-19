import SwiftUI

struct AddItemView: View {
    @ObservedObject var viewModel: SeasonItemViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var itemName = ""
    @State private var selectedSeason = Season.spring
    @State private var comment = ""
    @State private var isFavorite = false
    
    var isFormValid: Bool {
        !itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
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
                            Text("Comment (Optional)")
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
                            Text("Add to Favorites")
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
                        
                        Button(action: saveItem) {
                            Text("Save Item")
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
            .navigationTitle("New Item")
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
    
    private func saveItem() {
        let newItem = SeasonItem(
            name: itemName.trimmingCharacters(in: .whitespacesAndNewlines),
            season: selectedSeason,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines),
            isFavorite: isFavorite
        )
        
        viewModel.addItem(newItem)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddItemView(viewModel: SeasonItemViewModel())
}
