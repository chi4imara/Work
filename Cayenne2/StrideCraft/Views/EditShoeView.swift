import SwiftUI

struct EditShoeView: View {
    @EnvironmentObject var viewModel: ShoesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let shoe: Shoe
    @State private var model: String
    @State private var selectedCategory: ShoeCategory
    @State private var selectedCondition: ShoeCondition
    @State private var selectedSeason: ShoeSeason
    @State private var purchaseDate: Date
    @State private var comment: String
    
    init(shoe: Shoe) {
        self.shoe = shoe
        self._model = State(initialValue: shoe.model)
        self._selectedCategory = State(initialValue: shoe.category)
        self._selectedCondition = State(initialValue: shoe.condition)
        self._selectedSeason = State(initialValue: shoe.season)
        self._purchaseDate = State(initialValue: shoe.purchaseDate)
        self._comment = State(initialValue: shoe.comment)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.primaryBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Model")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            TextField("Enter shoe model", text: $model)
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(ColorTheme.primaryText)
                                .padding(12)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            Picker("Category", selection: $selectedCategory) {
                                ForEach(ShoeCategory.allCases, id: \.self) { category in
                                    Text(category.displayName)
                                        .tag(category)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(ColorTheme.cardBackground)
                            .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Condition")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            Picker("Condition", selection: $selectedCondition) {
                                ForEach(ShoeCondition.allCases, id: \.self) { condition in
                                    Text(condition.displayName)
                                        .tag(condition)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(ColorTheme.cardBackground)
                            .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Season")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            Picker("Season", selection: $selectedSeason) {
                                ForEach(ShoeSeason.allCases, id: \.self) { season in
                                    Text(season.displayName)
                                        .tag(season)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(ColorTheme.cardBackground)
                            .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Purchase Date")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            DatePicker("", selection: $purchaseDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .padding(12)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            TextField("Add a comment (optional)", text: $comment, axis: .vertical)
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(ColorTheme.primaryText)
                                .padding(12)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(8)
                                .lineLimit(3...6)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Edit Pair")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(ColorTheme.secondaryText),
                
                trailing: Button("Save Changes") {
                    saveChanges()
                }
                .foregroundColor(ColorTheme.primaryButton)
                .disabled(model.isEmpty)
            )
        }
        .accentColor(ColorTheme.primaryButton)
    }
    
    private func saveChanges() {
        var updatedShoe = shoe
        updatedShoe.model = model
        updatedShoe.category = selectedCategory
        updatedShoe.condition = selectedCondition
        updatedShoe.season = selectedSeason
        updatedShoe.purchaseDate = purchaseDate
        updatedShoe.comment = comment
        
        viewModel.updateShoe(updatedShoe)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditShoeView(shoe: Shoe(
        model: "Nike Air Force 1",
        category: .sneakers,
        condition: .excellent,
        season: .allSeason,
        purchaseDate: Date(),
        comment: "Great for everyday wear"
    ))
    .environmentObject(ShoesViewModel())
}
