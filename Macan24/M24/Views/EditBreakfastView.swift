import SwiftUI

struct EditBreakfastView: View {
    @EnvironmentObject var viewModel: BreakfastViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let breakfast: Breakfast
    
    @State private var name: String = ""
    @State private var selectedCategory: BreakfastCategory = .weekday
    @State private var dishes: String = ""
    @State private var drink: String = ""
    @State private var atmosphereDescription: String = ""
    @State private var showingCategoryPicker = false
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var hasChanges: Bool {
        name != breakfast.name ||
        selectedCategory != breakfast.category ||
        dishes != breakfast.dishes ||
        drink != breakfast.drink ||
        atmosphereDescription != breakfast.atmosphereDescription
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        VStack(spacing: 20) {
                            CustomTextField(
                                title: "Name *",
                                text: $name,
                                placeholder: "Scandinavian breakfast"
                            )
                            
                            categorySelector
                            
                            CustomTextField(
                                title: "Dishes",
                                text: $dishes,
                                placeholder: "Avocado toast, poached eggs",
                                isMultiline: true
                            )
                            
                            CustomTextField(
                                title: "Drink",
                                text: $drink,
                                placeholder: "Fresh orange juice"
                            )
                            
                            CustomTextField(
                                title: "Atmosphere Description",
                                text: $atmosphereDescription,
                                placeholder: "White tablecloth, fresh flowers, morning light from the window",
                                isMultiline: true
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        actionButtons
                            .padding(.horizontal, 20)
                            .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingCategoryPicker) {
            CategoryPickerView(selectedCategory: $selectedCategory)
        }
        .onAppear {
            loadBreakfastData()
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.textGray)
                    .padding(12)
                    .background(AppColors.backgroundWhite.opacity(0.9))
                    .clipShape(Circle())
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            
            Spacer()
            
            Text("Edit Breakfast")
                .font(.playfairDisplay(size: 28, weight: .bold))
                .foregroundColor(AppColors.primaryBlue)
            
            Spacer()
            
            Color.clear
                .frame(width: 42, height: 42)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var categorySelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Category")
                .font(.playfairDisplay(size: 16, weight: .medium))
                .foregroundColor(AppColors.primaryBlue)
            
            Button(action: {
                showingCategoryPicker = true
            }) {
                HStack {
                    Text(selectedCategory.displayName)
                        .font(.playfairDisplay(size: 16))
                        .foregroundColor(AppColors.textGray)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.textGray.opacity(0.6))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(AppColors.backgroundWhite.opacity(0.9))
                .cornerRadius(15)
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            Button(action: saveChanges) {
                Text("Save Changes")
                    .font(.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.backgroundWhite)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        (isFormValid && hasChanges) ?
                        LinearGradient(
                            colors: [AppColors.primaryYellow, AppColors.accentOrange],
                            startPoint: .leading,
                            endPoint: .trailing
                        ) :
                        LinearGradient(
                            colors: [AppColors.textGray.opacity(0.3), AppColors.textGray.opacity(0.3)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
                    .shadow(
                        color: (isFormValid && hasChanges) ? AppColors.primaryYellow.opacity(0.4) : Color.clear,
                        radius: (isFormValid && hasChanges) ? 10 : 0,
                        x: 0,
                        y: (isFormValid && hasChanges) ? 5 : 0
                    )
            }
            .disabled(!isFormValid || !hasChanges)
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
                    .font(.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(AppColors.textGray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppColors.backgroundWhite.opacity(0.9))
                    .cornerRadius(20)
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
            }
        }
    }
    
    private func loadBreakfastData() {
        name = breakfast.name
        selectedCategory = breakfast.category
        dishes = breakfast.dishes
        drink = breakfast.drink
        atmosphereDescription = breakfast.atmosphereDescription
    }
    
    private func saveChanges() {
        var updatedBreakfast = breakfast
        updatedBreakfast.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedBreakfast.category = selectedCategory
        updatedBreakfast.dishes = dishes.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedBreakfast.drink = drink.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedBreakfast.atmosphereDescription = atmosphereDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateBreakfast(updatedBreakfast)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let sampleBreakfast = Breakfast(
        name: "French Morning Set",
        category: .weekend,
        dishes: "Croissant, jam, omelet",
        drink: "Cappuccino",
        atmosphereDescription: "White dishes, sunny window, fresh flowers"
    )
    
    return EditBreakfastView(breakfast: sampleBreakfast)
        .environmentObject(BreakfastViewModel())
}
