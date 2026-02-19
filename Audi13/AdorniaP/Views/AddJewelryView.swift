import SwiftUI

struct AddJewelryView: View {
    let combination: Combination
    @ObservedObject var combinationStore: CombinationStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var selectedType: JewelryType = .ring
    
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
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("New Jewelry")
                                .font(.bauhausBold(24))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Text("Add an item to your combination")
                                .font(.bauhausRegular(14))
                                .foregroundColor(Color.theme.secondaryText)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Jewelry Name")
                                    .font(.bauhausBold(16))
                                    .foregroundColor(Color.theme.primaryText)
                                
                                TextField("Enter name (optional)", text: $name)
                                    .font(.bauhausRegular(16))
                                    .padding(16)
                                    .background(Color.theme.cardBackground)
                                    .cornerRadius(12)
                                    .shadow(color: Color.theme.cardShadow, radius: 4, x: 0, y: 2)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Jewelry Type")
                                    .font(.bauhausBold(16))
                                    .foregroundColor(Color.theme.primaryText)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                    ForEach(JewelryType.allCases, id: \.self) { type in
                                        JewelryTypeButton(
                                            type: type,
                                            isSelected: selectedType == type,
                                            action: {
                                                selectedType = type
                                            }
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        Button(action: saveJewelry) {
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
    
    private func saveJewelry() {
        let newJewelry = Jewelry(name: name, type: selectedType)
        combinationStore.addJewelryToCombination(newJewelry, to: combination)
        dismiss()
    }
}

struct JewelryTypeButton: View {
    let type: JewelryType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: type.iconName)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? Color.theme.buttonText : Color.theme.primaryBlue)
                
                Text(type.displayName)
                    .font(.bauhausRegular(12))
                    .foregroundColor(isSelected ? Color.theme.buttonText : Color.theme.primaryText)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(isSelected ? Color.theme.primaryBlue : Color.theme.cardBackground)
            .cornerRadius(12)
            .shadow(color: Color.theme.cardShadow, radius: isSelected ? 8 : 4, x: 0, y: isSelected ? 4 : 2)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
