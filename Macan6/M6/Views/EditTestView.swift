import SwiftUI

struct EditTestView: View {
    let originalTest: TestModel
    @ObservedObject var viewModel: TestsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var test: TestModel
    
    init(test: TestModel, viewModel: TestsViewModel) {
        self.originalTest = test
        self.viewModel = viewModel
        self._test = State(initialValue: test)
    }
    
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
            .navigationTitle("Edit Test")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save Changes") {
                    viewModel.updateTest(test)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(test.productName.isEmpty)
            )
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    EditTestView(
        test: TestModel(
            productName: "Hydra Cream",
            brand: "Laneige",
            category: .skincare,
            skinType: .dry,
            effect: "Excellent moisturizing, absorbs quickly.",
            rating: 5,
            status: .recommend,
            comment: "Perfect for winter."
        ),
        viewModel: TestsViewModel()
    )
}
