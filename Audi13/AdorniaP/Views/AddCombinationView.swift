import SwiftUI

struct AddCombinationView: View {
    @ObservedObject var combinationStore: CombinationStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var description = ""
    
    var isEditing: Bool
    var combinationToEdit: Combination?
    
    init(combinationStore: CombinationStore, combinationToEdit: Combination? = nil) {
        self.combinationStore = combinationStore
        self.combinationToEdit = combinationToEdit
        self.isEditing = combinationToEdit != nil
        
        if let combination = combinationToEdit {
            _name = State(initialValue: combination.name)
            _description = State(initialValue: combination.description)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.theme.backgroundGradientStart, Color.theme.backgroundGradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                AnimatedBackground()
                
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text(isEditing ? "Edit Combination" : "New Combination")
                            .font(.bauhausBold(24))
                            .foregroundColor(Color.theme.primaryText)
                        
                        Text("Create your perfect jewelry set")
                            .font(.bauhausRegular(14))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Combination Name")
                                .font(.bauhausBold(16))
                                .foregroundColor(Color.theme.primaryText)
                            
                            TextField("Enter name (optional)", text: $name)
                                .font(.bauhausRegular(16))
                                .padding(16)
                                .background(Color.theme.cardBackground)
                                .cornerRadius(12)
                                .shadow(color: Color.theme.cardShadow, radius: 4, x: 0, y: 2)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.bauhausBold(16))
                                .foregroundColor(Color.theme.primaryText)
                            
                            VStack {
                                TextField("For what occasions? (optional)", text: $description, axis: .vertical)
                                    .font(.bauhausRegular(16))
                                    .lineLimit(3...6)
                                    .padding(16)
                                    .background(Color.theme.cardBackground)
                                    .cornerRadius(12)
                                    .shadow(color: Color.theme.cardShadow, radius: 4, x: 0, y: 2)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Quick suggestions:")
                                .font(.bauhausRegular(14))
                                .foregroundColor(Color.theme.secondaryText)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                ForEach(CombinationCategory.allCases, id: \.self) { category in
                                    Button(action: {
                                        if description.isEmpty {
                                            description = category.rawValue
                                        } else {
                                            description += ", " + category.rawValue.lowercased()
                                        }
                                    }) {
                                        Text(category.rawValue)
                                            .font(.bauhausRegular(12))
                                            .foregroundColor(Color.theme.primaryBlue)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .frame(maxWidth: .infinity)
                                            .background(Color.theme.primaryBlue.opacity(0.1))
                                            .cornerRadius(16)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Button(action: saveCombination) {
                        Text("Save")
                            .font(.bauhausBold(18))
                            .foregroundColor(Color.theme.buttonText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.theme.buttonBackground)
                            .cornerRadius(25)
                            .shadow(color: Color.theme.cardShadow, radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.bauhausRegular(16))
                    .foregroundColor(Color.theme.primaryBlue)
                }
            }
        }
    }
    
    private func saveCombination() {
        if isEditing, var combination = combinationToEdit {
            combination.name = name
            combination.description = description
            combinationStore.updateCombination(combination)
        } else {
            let newCombination = Combination(name: name, description: description)
            combinationStore.addCombination(newCombination)
        }
        dismiss()
    }
}
