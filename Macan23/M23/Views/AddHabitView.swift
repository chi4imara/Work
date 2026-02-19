import SwiftUI

struct AddHabitView: View {
    @EnvironmentObject var viewModel: HabitsViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedTab: Int

    @State private var name = ""
    @State private var selectedCategory = HabitCategory.morning
    @State private var time = ""
    @State private var description = ""
    @State private var comment = ""
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            AnimatedBubblesBackground()
            
            VStack {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("Cancel")
                            .font(.ubuntu(size: 16))
                            .foregroundColor(.clear)
                    }
                    .opacity(0)
                    .disabled(true)
                    
                    Spacer()
                    
                    Text("Add Habit")
                        .font(.ubuntu(size: 32, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Text("Cancel")
                        .font(.ubuntu(size: 16))
                        .foregroundColor(.clear)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            FormFieldView(
                                title: "Name",
                                text: $name,
                                placeholder: "e.g., Evening Candle",
                                isRequired: true
                            )
                            
                            CategoryPickerView(selectedCategory: $selectedCategory)
                            
                            FormFieldView(
                                title: "Time",
                                text: $time,
                                placeholder: "e.g., 20:30"
                            )
                            
                            FormFieldView(
                                title: "Description",
                                text: $description,
                                placeholder: "Light a candle at the table after dinner",
                                isMultiline: true
                            )
                            
                            FormFieldView(
                                title: "Comment",
                                text: $comment,
                                placeholder: "Use vanilla scent",
                                isMultiline: true
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        
                        Button(action: saveHabit) {
                            Text("Save")
                                .font(.ubuntu(size: 18, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(isFormValid ? AnyShapeStyle(AppColors.accentGradient) : AnyShapeStyle(AppColors.accentGradient.opacity(0.5)))
                                .cornerRadius(25)
                                .shadow(color: AppColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .disabled(!isFormValid)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
    }
    
    private func saveHabit() {
        let newHabit = Habit(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            time: time.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addHabit(newHabit)
        presentationMode.wrappedValue.dismiss()
        
        withAnimation {
            selectedTab = 0
            
            name = ""
            selectedCategory = HabitCategory.morning
            time = ""
            description = ""
            comment = ""
        }
    }
}

struct FormFieldView: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var isRequired: Bool = false
    var isMultiline: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.ubuntu(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                if isRequired {
                    Text("*")
                        .foregroundColor(AppColors.error)
                }
                
                Spacer()
            }
            
            if isMultiline {
                TextEditor(text: $text)
                    .font(.ubuntu(size: 16))
                    .foregroundColor(AppColors.primaryText)
                    .frame(minHeight: 80)
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColors.accentBlue.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            } else {
                TextField(placeholder, text: $text)
                    .font(.ubuntu(size: 16))
                    .foregroundColor(AppColors.primaryText)
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColors.accentBlue.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            }
        }
    }
}

struct CategoryPickerView: View {
    @Binding var selectedCategory: HabitCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Category")
                .font(.ubuntu(size: 16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            Menu {
                ForEach(HabitCategory.allCases, id: \.self) { category in
                    Button(category.displayName) {
                        selectedCategory = category
                    }
                }
            } label: {
                HStack {
                    Text(selectedCategory.displayName)
                        .font(.ubuntu(size: 16))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(AppColors.accentBlue.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            }
        }
    }
}
