import SwiftUI

struct EditBagView: View {
    let bagId: UUID
    @ObservedObject var viewModel: BagViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var bagName: String = ""
    @State private var selectedScenario: BagScenario = .day
    @State private var comment: String = ""
    @State private var isFavorite: Bool = false
    
    private var bag: Bag? {
        viewModel.getBag(byId: bagId)
    }
    
    init(bagId: UUID, viewModel: BagViewModel) {
        self.bagId = bagId
        self.viewModel = viewModel
    }
    
    private var isFormValid: Bool {
        !bagName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        Group {
            if let bag = bag {
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
                                    
                                    Text("Edit Bag")
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
                                        Text("In Favorites")
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
                .onAppear {
                    bagName = bag.name
                    selectedScenario = bag.scenario
                    comment = bag.comment
                    isFavorite = bag.isFavorite
                }
            }
        }
    }
    
    private func saveBag() {
        guard let bag = bag else { return }
        
        let updatedBag = Bag(
            id: bag.id,
            name: bagName.trimmingCharacters(in: .whitespacesAndNewlines),
            scenario: selectedScenario,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines),
            isFavorite: isFavorite,
            createdAt: bag.createdAt
        )
        
        viewModel.updateBag(updatedBag)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let viewModel = BagViewModel()
    let sampleBag = Bag(
        name: "Black Leather Bag",
        scenario: .day,
        comment: "Perfect for daily use",
        isFavorite: true
    )
    viewModel.addBag(sampleBag)
    
    return EditBagView(bagId: sampleBag.id, viewModel: viewModel)
}
