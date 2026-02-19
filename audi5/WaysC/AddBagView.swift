import SwiftUI

struct AddBagView: View {
    @ObservedObject var viewModel: BagViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var bagName = ""
    @State private var selectedScenario: BagScenario = .day
    @State private var comment = ""
    @State private var isFavorite = false
    
    private var isFormValid: Bool {
        !bagName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        HStack {
                            Button("Cancel") {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .font(.bellGothicRegular(size: 16))
                            .foregroundColor(Color.theme.textGray)
                            
                            Spacer()
                            
                            Text("New Bag")
                                .font(.bellGothicBold(size: 20))
                                .foregroundColor(Color.theme.textWhite)
                            
                            Spacer()
                            
                            Button("Save") {
                                saveBag()
                            }
                            .font(.bellGothicBold(size: 16))
                            .foregroundColor(isFormValid ? Color.theme.accentYellow : Color.theme.textGray)
                            .disabled(!isFormValid)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Bag Name")
                                    .font(.bellGothicBold(size: 16))
                                    .foregroundColor(Color.theme.textWhite)
                                
                                TextField("Enter bag name", text: $bagName)
                                    .font(.bellGothicRegular(size: 16))
                                    .foregroundColor(Color.theme.textWhite)
                                    .padding()
                                    .background(Color.theme.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.theme.cardBorder, lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Usage Scenario")
                                    .font(.bellGothicBold(size: 16))
                                    .foregroundColor(Color.theme.textWhite)
                                
                                HStack(spacing: 12) {
                                    ForEach(BagScenario.allCases) { scenario in
                                        ScenarioButton(
                                            scenario: scenario,
                                            isSelected: selectedScenario == scenario,
                                            action: {
                                                selectedScenario = scenario
                                            }
                                        )
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Comment")
                                    .font(.bellGothicBold(size: 16))
                                    .foregroundColor(Color.theme.textWhite)
                                
                                TextField("Add notes about this bag", text: $comment, axis: .vertical)
                                    .font(.bellGothicRegular(size: 16))
                                    .foregroundColor(Color.theme.textWhite)
                                    .padding()
                                    .background(Color.theme.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.theme.cardBorder, lineWidth: 1)
                                    )
                                    .frame(minHeight: 80)
                            }
                            
                            HStack {
                                Text("Add to Favorites")
                                    .font(.bellGothicBold(size: 16))
                                    .foregroundColor(Color.theme.textWhite)
                                
                                Spacer()
                                
                                Toggle("", isOn: $isFavorite)
                                    .toggleStyle(CustomToggleStyle())
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 50)
                    }
                }
            }
        }
    }
    
    private func saveBag() {
        let newBag = Bag(
            name: bagName.trimmingCharacters(in: .whitespacesAndNewlines),
            scenario: selectedScenario,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines),
            isFavorite: isFavorite
        )
        
        viewModel.addBag(newBag)
        presentationMode.wrappedValue.dismiss()
    }
}

struct ScenarioButton: View {
    let scenario: BagScenario
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: scenario.icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? Color.theme.darkBlue : Color.theme.textGray)
                
                Text(scenario.displayName)
                    .font(.bellGothicRegular(size: 12))
                    .foregroundColor(isSelected ? Color.theme.darkBlue : Color.theme.textGray)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.theme.accentYellow : Color.theme.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.theme.accentYellow : Color.theme.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? Color.theme.accentYellow : Color.theme.cardBackground)
                .frame(width: 50, height: 30)
                .overlay(
                    Circle()
                        .fill(configuration.isOn ? Color.theme.darkBlue : Color.theme.textGray)
                        .frame(width: 26, height: 26)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AddBagView(viewModel: BagViewModel())
}
