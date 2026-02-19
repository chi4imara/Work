import SwiftUI

struct AddEditBagView: View {
    @EnvironmentObject var bagViewModel: BagViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var bagName = ""
    @State private var selectedType: BagType = .bag
    @State private var bagDescription = ""
    
    let editingBag: Bag?
    
    init(editingBag: Bag? = nil) {
        self.editingBag = editingBag
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bag Name")
                                .font(.bellGothic(size: 16, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter bag name", text: $bagName)
                                .font(.bellGothic(size: 16))
                                .padding()
                                .background(AppColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                                .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Type")
                                .font(.bellGothic(size: 16, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Picker("Bag Type", selection: $selectedType) {
                                ForEach(BagType.allCases, id: \.self) { type in
                                    Text(type.displayName)
                                        .tag(type)
                                }
                            }
                            .pickerStyle(.segmented)
                            .tint(AppColors.yellow)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description (Days/Scenarios)")
                                .font(.bellGothic(size: 16, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("e.g., work days, meetings, travel", text: $bagDescription, axis: .vertical)
                                .font(.bellGothic(size: 16))
                                .lineLimit(3...6)
                                .padding()
                                .background(AppColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                                .cornerRadius(8)
                        }
                        
                        Spacer().frame(height: 20)
                    }
                    .padding()
                }
            }
            .navigationTitle(editingBag == nil ? "New Bag" : "Edit Bag")
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
                        saveBag()
                    }
                    .foregroundColor(AppColors.yellow)
                    .font(.bellGothic(size: 16, weight: .bold))
                }
            }
            .preferredColorScheme(.dark)
        }
        .onAppear {
            if let bag = editingBag {
                bagName = bag.name
                selectedType = bag.type
                bagDescription = bag.description
            }
        }
    }
    
    private func saveBag() {
        if let editingBag = editingBag {
            var updatedBag = editingBag
            updatedBag.name = bagName
            updatedBag.type = selectedType
            updatedBag.description = bagDescription
            bagViewModel.updateBag(updatedBag)
        } else {
            let newBag = Bag(name: bagName, type: selectedType, description: bagDescription)
            bagViewModel.addBag(newBag)
        }
        dismiss()
    }
}

#Preview {
    AddEditBagView()
        .environmentObject(BagViewModel())
}
