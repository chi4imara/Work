import SwiftUI

struct AddItemView: View {
    @EnvironmentObject var bagViewModel: BagViewModel
    @Environment(\.dismiss) private var dismiss
    
    let bag: Bag
    @State private var itemName = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Item Name")
                            .font(.bellGothic(size: 16, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        TextField("Enter item name", text: $itemName)
                            .font(.bellGothic(size: 16))
                            .padding()
                            .background(AppColors.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                            )
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("New Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveItem()
                    }
                    .foregroundColor(AppColors.yellow)
                    .font(.bellGothic(size: 16, weight: .bold))
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func saveItem() {
        let newItem = Item(name: itemName)
        bagViewModel.addItem(newItem, to: bag)
        dismiss()
    }
}

#Preview {
    AddItemView(bag: Bag(name: "Test Bag"))
        .environmentObject(BagViewModel())
}
