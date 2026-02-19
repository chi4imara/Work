import SwiftUI

struct AddBreakfastView: View {
    @EnvironmentObject var viewModel: BreakfastViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedTab: Int
    
    @State private var name: String = ""
    @State private var selectedCategory: BreakfastCategory = .weekday
    @State private var dishes: String = ""
    @State private var drink: String = ""
    @State private var atmosphereDescription: String = ""
    @State private var showingCategoryPicker = false
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
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
        .sheet(isPresented: $showingCategoryPicker) {
            CategoryPickerView(selectedCategory: $selectedCategory)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Add Breakfast")
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
            Button(action: saveBreakfast) {
                Text("Save")
                    .font(.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.backgroundWhite)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        isFormValid ?
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
                        color: isFormValid ? AppColors.primaryYellow.opacity(0.4) : Color.clear,
                        radius: isFormValid ? 10 : 0,
                        x: 0,
                        y: isFormValid ? 5 : 0
                    )
            }
            .disabled(!isFormValid)
        }
    }
    
    private func saveBreakfast() {
        let newBreakfast = Breakfast(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            dishes: dishes.trimmingCharacters(in: .whitespacesAndNewlines),
            drink: drink.trimmingCharacters(in: .whitespacesAndNewlines),
            atmosphereDescription: atmosphereDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addBreakfast(newBreakfast)
        presentationMode.wrappedValue.dismiss()
        
        withAnimation {
            selectedTab = 0
            
            name = ""
            selectedCategory = .weekday
            dishes = ""
            drink = ""
            atmosphereDescription = ""
            showingCategoryPicker = false
        }
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var isMultiline: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(size: 16, weight: .medium))
                .foregroundColor(AppColors.primaryBlue)
            
            if isMultiline {
                TextField(placeholder, text: $text, axis: .vertical)
                    .font(.playfairDisplay(size: 16))
                    .lineLimit(3...6)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(AppColors.backgroundWhite.opacity(0.9))
                    .cornerRadius(15)
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
            } else {
                TextField(placeholder, text: $text)
                    .font(.playfairDisplay(size: 16))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(AppColors.backgroundWhite.opacity(0.9))
                    .cornerRadius(15)
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
            }
        }
    }
}

struct CategoryPickerView: View {
    @Binding var selectedCategory: BreakfastCategory
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 20) {
                    Text("Select Category")
                        .font(.playfairDisplay(size: 24, weight: .bold))
                        .foregroundColor(AppColors.primaryBlue)
                        .padding(.top, 20)
                    
                    VStack(spacing: 12) {
                        ForEach(BreakfastCategory.allCases, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    Text(category.displayName)
                                        .font(.playfairDisplay(size: 18))
                                        .foregroundColor(AppColors.primaryBlue)
                                    
                                    Spacer()
                                    
                                    if selectedCategory == category {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(AppColors.primaryYellow)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(AppColors.backgroundWhite.opacity(0.9))
                                        .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryYellow)
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                }
            }
        }
    }
}
