import SwiftUI

struct EditSneakerView: View {
    @Environment(\.dismiss) var dismiss
    
    let originalSneaker: Sneaker
    let onSave: (Sneaker) -> Void
    
    @State private var model: String
    @State private var purchaseDate: Date
    @State private var selectedCondition: SneakerCondition
    @State private var comment: String
    
    init(sneaker: Sneaker, onSave: @escaping (Sneaker) -> Void) {
        self.originalSneaker = sneaker
        self.onSave = onSave
        
        self._model = State(initialValue: sneaker.model)
        self._purchaseDate = State(initialValue: sneaker.purchaseDate)
        self._selectedCondition = State(initialValue: sneaker.condition)
        self._comment = State(initialValue: sneaker.comment)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        HStack {
                            Button("Cancel") {
                                dismiss()
                            }
                            .font(.ubuntu(16))
                            .foregroundColor(ColorManager.lightBlue)
                            
                            Spacer()
                            
                            Text("Edit Pair")
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Spacer()
                            
                            Button("Save") {
                                saveChanges()
                            }
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorManager.orange)
                            .disabled(model.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Model")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                TextField("Enter sneaker model", text: $model)
                                    .font(.ubuntu(16))
                                    .padding(16)
                                    .background(ColorManager.cardBackground)
                                    .cornerRadius(12)
                                    .foregroundColor(ColorManager.primaryText)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Purchase Date")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                DatePicker("", selection: $purchaseDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .padding(16)
                                    .background(ColorManager.cardBackground)
                                    .cornerRadius(12)
                                    .accentColor(ColorManager.lightBlue)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Condition")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                Menu {
                                    ForEach(SneakerCondition.allCases, id: \.self) { condition in
                                        Button(condition.rawValue) {
                                            selectedCondition = condition
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedCondition.rawValue)
                                            .font(.ubuntu(16))
                                            .foregroundColor(ColorManager.primaryText)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14))
                                            .foregroundColor(ColorManager.secondaryText)
                                    }
                                    .padding(16)
                                    .background(ColorManager.cardBackground)
                                    .cornerRadius(12)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Comment")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                TextField("Optional comment", text: $comment, axis: .vertical)
                                    .font(.ubuntu(16))
                                    .lineLimit(3...6)
                                    .padding(16)
                                    .background(ColorManager.cardBackground)
                                    .cornerRadius(12)
                                    .foregroundColor(ColorManager.primaryText)
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        Spacer()
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func saveChanges() {
        let trimmedModel = model.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedModel.isEmpty else { return }
        
        var updatedSneaker = originalSneaker
        updatedSneaker.model = trimmedModel
        updatedSneaker.purchaseDate = purchaseDate
        updatedSneaker.condition = selectedCondition
        updatedSneaker.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        onSave(updatedSneaker)
        dismiss()
    }
}

#Preview {
    EditSneakerView(
        sneaker: Sneaker(
            model: "Nike Air Max 270",
            purchaseDate: Date(),
            condition: .new,
            comment: "Great for running"
        )
    ) { _ in
        print("Saved")
    }
}
