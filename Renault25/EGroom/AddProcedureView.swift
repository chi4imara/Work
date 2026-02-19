import SwiftUI

struct AddProcedureView: View {
    @EnvironmentObject var viewModel: GroomingViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var selectedCategory: Procedure.ProcedureCategory = .skincare
    @State private var frequency: String = ""
    @State private var notes: String = ""
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(FontManager.playfairDisplay(.medium, size: 16))
                    .foregroundColor(.primaryWhite.opacity(0.8))
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Text("New Procedure")
                            .font(FontManager.playfairDisplay(.bold, size: 16))
                            .foregroundColor(.primaryWhite)
                        
                        Text("Add a new routine to your day")
                            .font(FontManager.playfairDisplay(.regular, size: 12))
                            .foregroundColor(.primaryWhite.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        saveProcedure()
                    }
                    .font(FontManager.playfairDisplay(.semibold, size: 16))
                    .foregroundColor(canSave ? .primaryOrange : .primaryWhite.opacity(0.3))
                    .disabled(!canSave)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        FormField(
                            title: "Name",
                            placeholder: "Enter procedure name",
                            text: $name
                        )
                        
                        CategorySelector(selectedCategory: $selectedCategory)
                        
                        FormField(
                            title: "Frequency",
                            placeholder: "e.g., Daily, Weekly, Every 2 days",
                            text: $frequency
                        )
                        
                        NotesField(notes: $notes)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveProcedure() {
        let procedure = Procedure(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            frequency: frequency.isEmpty ? "Daily" : frequency,
            notes: notes
        )
        
        viewModel.addProcedure(procedure)
        presentationMode.wrappedValue.dismiss()
    }
}

struct FormField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(FontManager.playfairDisplay(.semibold, size: 16))
                .foregroundColor(.primaryWhite)
            
            TextField(placeholder, text: $text)
                .font(FontManager.playfairDisplay(.regular, size: 16))
                .foregroundColor(.primaryWhite)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.cardGradient)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.primaryWhite.opacity(0.2), lineWidth: 1)
                        )
                )
        }
    }
}

struct CategorySelector: View {
    @Binding var selectedCategory: Procedure.ProcedureCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Category")
                .font(FontManager.playfairDisplay(.semibold, size: 16))
                .foregroundColor(.primaryWhite)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(Procedure.ProcedureCategory.allCases, id: \.self) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
        }
    }
}

struct CategoryButton: View {
    let category: Procedure.ProcedureCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? .primaryWhite : .primaryWhite.opacity(0.6))
                
                Text(category.rawValue)
                    .font(FontManager.playfairDisplay(.medium, size: 14))
                    .foregroundColor(isSelected ? .primaryWhite : .primaryWhite.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AnyShapeStyle(Color.primaryOrange) : AnyShapeStyle(Color.cardGradient))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? AnyShapeStyle(Color.primaryOrange) : AnyShapeStyle(Color.primaryWhite.opacity(0.2)), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct NotesField: View {
    @Binding var notes: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes (Optional)")
                .font(FontManager.playfairDisplay(.semibold, size: 16))
                .foregroundColor(.primaryWhite)
            
            TextField("Add any additional notes...", text: $notes, axis: .vertical)
                .font(FontManager.playfairDisplay(.regular, size: 16))
                .foregroundColor(.primaryWhite)
                .lineLimit(3...6)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.cardGradient)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.primaryWhite.opacity(0.2), lineWidth: 1)
                        )
                )
        }
    }
}

struct AddProcedureView_Previews: PreviewProvider {
    static var previews: some View {
        AddProcedureView()
            .environmentObject(GroomingViewModel())
    }
}
