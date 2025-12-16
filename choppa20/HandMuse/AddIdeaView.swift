import SwiftUI

struct AddIdeaView: View {
    @ObservedObject var viewModel: IdeasViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var selectedCraftType: CraftType = .knitting
    @State private var description = ""
    @State private var materialsText = ""
    @State private var stepsText = ""
    @State private var isCompleted = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            TextField("Large knit scarf", text: $title)
                                .font(.playfairDisplay(16))
                                .foregroundColor(Color.theme.primaryText)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.cardBackground)
                                        .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Craft Type")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Menu {
                                ForEach(CraftType.allCases, id: \.self) { craftType in
                                    Button(craftType.displayName) {
                                        selectedCraftType = craftType
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCraftType.displayName)
                                        .font(.playfairDisplay(16))
                                        .foregroundColor(Color.theme.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(Color.theme.secondaryText)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.cardBackground)
                                        .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            ZStack(alignment: .topLeading) {
                                if description.isEmpty {
                                    Text("Planning to knit a gift for a friend")
                                        .font(.playfairDisplay(16))
                                        .foregroundColor(Color.theme.secondaryText.opacity(0.5))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                }
                                
                                TextEditor(text: $description)
                                    .font(.playfairDisplay(16))
                                    .foregroundColor(Color.theme.primaryText)
                                    .frame(minHeight: 100)
                                    .scrollContentBackground(.hidden)
                                    .padding(8)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.theme.cardBackground)
                                    .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Materials")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            ZStack(alignment: .topLeading) {
                                if materialsText.isEmpty {
                                    Text("Yarn, needles #7, needle\nScissors, measuring tape")
                                        .font(.playfairDisplay(16))
                                        .foregroundColor(Color.theme.secondaryText.opacity(0.5))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                }
                                
                                TextEditor(text: $materialsText)
                                    .font(.playfairDisplay(16))
                                    .foregroundColor(Color.theme.primaryText)
                                    .frame(minHeight: 120)
                                    .scrollContentBackground(.hidden)
                                    .padding(8)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.theme.cardBackground)
                                    .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Steps")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            ZStack(alignment: .topLeading) {
                                if stepsText.isEmpty {
                                    Text("1. Start pattern\n2. Knit 30 cm\n3. Finish edge")
                                        .font(.playfairDisplay(16))
                                        .foregroundColor(Color.theme.secondaryText.opacity(0.5))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                }
                                
                                TextEditor(text: $stepsText)
                                    .font(.playfairDisplay(16))
                                    .foregroundColor(Color.theme.primaryText)
                                    .frame(minHeight: 150)
                                    .scrollContentBackground(.hidden)
                                    .padding(8)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.theme.cardBackground)
                                    .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                            )
                        }
                        
                        HStack {
                            Toggle("Completed", isOn: $isCompleted)
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                                .toggleStyle(SwitchToggleStyle(tint: Color.theme.primaryYellow))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 4)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("New Idea")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.secondaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveIdea()
                    }
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(Color.theme.primaryYellow)
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveIdea() {
        let materials = materialsText
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        let steps = stepsText
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { CraftStep(title: $0) }
        
        let idea = CraftIdea(
            title: title,
            craftType: selectedCraftType,
            description: description,
            materials: materials,
            steps: steps,
            isCompleted: isCompleted
        )
        
        viewModel.addIdea(idea)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddIdeaView(viewModel: IdeasViewModel())
}
