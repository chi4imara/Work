import SwiftUI

struct AddOutfitView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: DataManager
    
    @State private var name = ""
    @State private var description = ""
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Outfit Name *")
                                .font(.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter outfit name", text: $name)
                                .customTextField()
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description (Optional)")
                                .font(.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter description", text: $description, axis: .vertical)
                                .lineLimit(3...6)
                                .customTextField()
                        }
                        
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(AppColors.accentYellow)
                                Text("Tip")
                                    .font(.playfairDisplay(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.primaryText)
                                Spacer()
                            }
                            
                            Text("After creating this outfit, you can link accessories to it from the Accessories tab.")
                                .font(.playfairDisplay(size: 14, weight: .regular))
                                .foregroundColor(AppColors.secondaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .glassCard()
                        
                        Spacer(minLength: 200)
                    }
                    .padding()
                }
            }
            .navigationTitle("New Outfit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveOutfit()
                    }
                    .foregroundColor(isFormValid ? AppColors.accentYellow : AppColors.secondaryText)
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private func saveOutfit() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let newOutfit = Outfit(name: trimmedName, description: trimmedDescription)
        dataManager.addOutfit(newOutfit)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddOutfitView()
        .environmentObject(DataManager.shared)
}
