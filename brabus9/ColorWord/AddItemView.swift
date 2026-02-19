import SwiftUI

struct AddItemView: View {
    @ObservedObject var viewModel: CatalogViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var itemText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    private var canSave: Bool {
        !itemText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 30) {
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                        
                        Spacer()
                        
                        Text("New Item")
                            .font(.ubuntu(20, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button("Save") {
                            saveItem()
                        }
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(canSave ? AppColors.accent : AppColors.secondaryText.opacity(0.5))
                        .disabled(!canSave)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Enter your item")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        TextEditor(text: $itemText)
                            .font(.ubuntu(16, weight: .regular))
                            .foregroundColor(AppColors.primaryText)
                            .scrollContentBackground(.hidden)
                            .focused($isTextFieldFocused)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.cardBorder, lineWidth: 1)
                                    )
                            )
                            .frame(minHeight: 120)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                isTextFieldFocused = true
            }
        }
    }
    
    private func saveItem() {
        let trimmedText = itemText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedText.isEmpty {
            viewModel.addItem(trimmedText)
            dismiss()
        }
    }
}

#Preview {
    AddItemView(viewModel: CatalogViewModel())
}
