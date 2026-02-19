import SwiftUI

struct AddTestView: View {
    @ObservedObject var viewModel: TestsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var test = TestModel()
    @State private var showingDatePicker = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 20) {
                        FormField(
                            title: "Product Name",
                            text: $test.productName,
                            placeholder: "Enter product name"
                        )
                        
                        FormField(
                            title: "Brand",
                            text: $test.brand,
                            placeholder: "Enter brand name"
                        )
                        
                        FormPicker(
                            title: "Category",
                            selection: $test.category,
                            options: Category.allCases,
                            displayName: { $0.displayName }
                        )
                        
                        FormPicker(
                            title: "Skin/Hair Type",
                            selection: $test.skinType,
                            options: SkinType.allCases,
                            displayName: { $0.displayName }
                        )
                        
                        FormDatePicker(
                            title: "Test Date",
                            date: $test.testDate
                        )
                        
                        FormTextEditor(
                            title: "Effect/Result",
                            text: $test.effect,
                            placeholder: "Describe the effect or result..."
                        )
                        
                        FormRating(
                            title: "Rating",
                            rating: $test.rating
                        )
                        
                        FormPicker(
                            title: "Status",
                            selection: $test.status,
                            options: TestStatus.allCases,
                            displayName: { $0.displayName }
                        )
                        
                        FormTextEditor(
                            title: "Comment (Optional)",
                            text: $test.comment,
                            placeholder: "Add any additional comments..."
                        )
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("New Test")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    viewModel.addTest(test)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(test.productName.isEmpty)
            )
        }
        .preferredColorScheme(.dark)
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            TextField(placeholder, text: $text)
                .font(.playfairDisplay(16))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
        }
    }
}

struct FormTextEditor: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.playfairDisplay(16))
                        .foregroundColor(AppColors.secondaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                }
                
                TextEditor(text: $text)
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.primaryText)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(minHeight: 80)
                    .background(Color.clear)
            }
            .background(AppColors.cardBackground)
            .cornerRadius(12)
        }
    }
}

struct FormPicker<T: Hashable>: View {
    let title: String
    @Binding var selection: T
    let options: [T]
    let displayName: (T) -> String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(displayName(option))
                        .font(.playfairDisplay(16))
                        .tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
        }
    }
}

struct FormDatePicker: View {
    let title: String
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
        }
    }
}

struct FormRating: View {
    let title: String
    @Binding var rating: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { star in
                    Button(action: { rating = star }) {
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .font(.system(size: 24))
                            .foregroundColor(AppColors.yellow)
                    }
                }
                
                Spacer()
                
                Text("\(rating) star\(rating == 1 ? "" : "s")")
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
        }
    }
}

#Preview {
    AddTestView(viewModel: TestsViewModel())
}
