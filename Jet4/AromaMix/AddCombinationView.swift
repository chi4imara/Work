import SwiftUI

struct AddCombinationView: View {
    @ObservedObject var viewModel: ScentCombinationsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var selectedCategory: ScentCategory = .warm
    @State private var perfumeAroma: String = ""
    @State private var candleAroma: String = ""
    @State private var comment: String = ""
    @State private var selectedRating: Rating = .good
    
    var existingCombination: ScentCombination?
    
    init(viewModel: ScentCombinationsViewModel, existingCombination: ScentCombination? = nil) {
        self.viewModel = viewModel
        self.existingCombination = existingCombination
        
        if let combination = existingCombination {
            _name = State(initialValue: combination.name)
            _selectedCategory = State(initialValue: combination.category)
            _perfumeAroma = State(initialValue: combination.perfumeAroma)
            _candleAroma = State(initialValue: combination.candleAroma)
            _comment = State(initialValue: combination.comment)
            _selectedRating = State(initialValue: combination.rating)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            FormField(title: "Name", text: $name, placeholder: "Vanilla & Sandalwood")
                            
                            CategoryPickerField(selectedCategory: $selectedCategory)
                            
                            FormField(title: "Perfume Aroma", text: $perfumeAroma, placeholder: "YSL Black Opium")
                            
                            FormField(title: "Candle Aroma", text: $candleAroma, placeholder: "Diptyque Vanille")
                            
                            CommentField(comment: $comment)
                            
                            RatingPickerField(selectedRating: $selectedRating)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        Button(action: saveCombination) {
                            Text("Save")
                                .font(AppFonts.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    canSave ? AnyShapeStyle(AppColors.buttonGradient) : AnyShapeStyle(Color.gray.opacity(0.5))
                                )
                                .cornerRadius(25)
                                .shadow(
                                    color: canSave ? AppColors.purpleGradientStart.opacity(0.3) : Color.clear,
                                    radius: 8, x: 0, y: 4
                                )
                        }
                        .disabled(!canSave)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle(existingCombination == nil ? "New Combination" : "Edit Combination")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.blueText)
            )
        }
    }
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !perfumeAroma.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !candleAroma.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveCombination() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPerfume = perfumeAroma.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCandle = candleAroma.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedComment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let existing = existingCombination {
            var updatedCombination = existing
            updatedCombination.name = trimmedName
            updatedCombination.category = selectedCategory
            updatedCombination.perfumeAroma = trimmedPerfume
            updatedCombination.candleAroma = trimmedCandle
            updatedCombination.comment = trimmedComment
            updatedCombination.rating = selectedRating
            
            viewModel.updateCombination(updatedCombination)
        } else {
            let newCombination = ScentCombination(
                name: trimmedName,
                category: selectedCategory,
                perfumeAroma: trimmedPerfume,
                candleAroma: trimmedCandle,
                comment: trimmedComment,
                rating: selectedRating
            )
            
            viewModel.addCombination(newCombination)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.darkGray)
            
            TextField(placeholder, text: $text)
                .font(AppFonts.body)
                .foregroundColor(AppColors.darkGray)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.8))
                .cornerRadius(12)
        }
    }
}

struct CategoryPickerField: View {
    @Binding var selectedCategory: ScentCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Category")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.darkGray)
            
            Menu {
                ForEach(ScentCategory.allCases, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        HStack {
                            Text(category.displayName)
                            if selectedCategory == category {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selectedCategory.displayName)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.darkGray)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.darkGray.opacity(0.6))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.8))
                .cornerRadius(12)
            }
        }
    }
}

struct CommentField: View {
    @Binding var comment: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Comment")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.darkGray)
            
            TextField("Warm and cozy combination for autumn...", text: $comment, axis: .vertical)
                .font(AppFonts.body)
                .foregroundColor(AppColors.darkGray)
                .lineLimit(3...6)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.8))
                .cornerRadius(12)
        }
    }
}

struct RatingPickerField: View {
    @Binding var selectedRating: Rating
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Rating")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.darkGray)
            
            HStack(spacing: 12) {
                ForEach(Rating.allCases, id: \.self) { rating in
                    Button(action: {
                        selectedRating = rating
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: rating.icon)
                                .font(.system(size: 16))
                            
                            Text(rating.displayName)
                                .font(AppFonts.callout)
                        }
                        .foregroundColor(selectedRating == rating ? .white : AppColors.darkGray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            selectedRating == rating ? 
                            AppColors.purpleGradientStart : 
                            Color.white.opacity(0.8)
                        )
                        .cornerRadius(20)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AddCombinationView(viewModel: ScentCombinationsViewModel())
}
