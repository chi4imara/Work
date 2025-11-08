import SwiftUI

struct AddCategoryView: View {
    @ObservedObject var viewModel: PlacesViewModel
    @State private var newCategoryName: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category Name")
                            .font(FontManager.subheadline)
                            .foregroundColor(ColorTheme.primaryText)
                        
                        TextField("Enter category name", text: $newCategoryName)
                            .font(FontManager.body)
                            .padding(16)
                            .background(ColorTheme.backgroundWhite)
                            .cornerRadius(12)
                            .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 2, x: 0, y: 1)
                            .onChange(of: newCategoryName) { newValue in
                                print("Category name changed to: '\(newValue)'")
                            }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("Add Category")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    newCategoryName = ""
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Add") {
                    let trimmedName = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
                    print("Add button tapped. Text: '\(newCategoryName)', Trimmed: '\(trimmedName)'")
                    if !trimmedName.isEmpty {
                        print("Adding category: \(trimmedName)")
                        viewModel.addCategory(trimmedName)
                        newCategoryName = ""
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        print("Category name is empty, not adding")
                    }
                }
                .disabled(newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .foregroundColor(newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? ColorTheme.secondaryText : ColorTheme.primaryBlue)
            )
        }
        .onAppear {
            print("AddCategoryView appeared")
        }
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView(viewModel: PlacesViewModel())
    }
}
