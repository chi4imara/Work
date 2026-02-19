import SwiftUI

struct EditPracticeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: DataManager
    let practiceId: UUID
    
    @State private var name: String = ""
    @State private var selectedType: PracticeType = .movement
    @State private var duration: Int = 5
    @State private var note: String = ""
    @State private var showingAlert = false
    @State private var didLoad = false
    
    private var practice: Practice? {
        dataManager.practices.first { $0.id == practiceId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                if practice == nil && didLoad {
                    VStack(spacing: 20) {
                        Text("Practice not found")
                            .font(.playfair(16))
                            .foregroundColor(ColorTheme.secondaryColor)
                        Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(ColorTheme.accentColor)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Practice Name")
                                    .font(.playfair(18, weight: .medium))
                                    .foregroundColor(ColorTheme.textColor)
                                TextField("Enter practice name", text: $name)
                                    .font(.playfair(16))
                                    .padding(16)
                                    .background(ColorTheme.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(ColorTheme.secondaryColor.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Type")
                                    .font(.playfair(18, weight: .medium))
                                    .foregroundColor(ColorTheme.textColor)
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                    ForEach(PracticeType.allCases, id: \.self) { type in
                                        TypeSelectionCard(
                                            type: type,
                                            isSelected: selectedType == type
                                        ) {
                                            selectedType = type
                                        }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Duration (minutes)")
                                    .font(.playfair(18, weight: .medium))
                                    .foregroundColor(ColorTheme.textColor)
                                HStack {
                                    Button(action: { if duration > 1 { duration -= 1 } }) {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(ColorTheme.accentColor)
                                    }
                                    Spacer()
                                    Text("\(duration) min")
                                        .font(.playfair(20, weight: .medium))
                                        .foregroundColor(ColorTheme.textColor)
                                    Spacer()
                                    Button(action: { if duration < 60 { duration += 1 } }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(ColorTheme.accentColor)
                                    }
                                }
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("How this helps your body (optional)")
                                    .font(.playfair(18, weight: .medium))
                                    .foregroundColor(ColorTheme.textColor)
                                TextField("Add a note about benefits", text: $note, axis: .vertical)
                                    .font(.playfair(16))
                                    .padding(16)
                                    .background(ColorTheme.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(ColorTheme.secondaryColor.opacity(0.3), lineWidth: 1)
                                    )
                                    .lineLimit(3...6)
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
            .navigationTitle("Edit Practice")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(ColorTheme.textColor)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        savePractice()
                    }
                    .foregroundColor(ColorTheme.accentColor)
                    .disabled(name.isEmpty || practice == nil)
                }
            }
        }
        .onAppear {
            if let p = practice {
                name = p.name
                selectedType = p.type
                duration = p.duration
                note = p.note
            }
            didLoad = true
        }
        .alert("Practice Updated", isPresented: $showingAlert) {
            Button("OK") {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Your practice has been updated successfully!")
        }
    }
    
    private func savePractice() {
        if let index = dataManager.practices.firstIndex(where: { $0.id == practiceId }) {
            var updatedPractice = dataManager.practices[index]
            updatedPractice.name = name
            updatedPractice.type = selectedType
            updatedPractice.duration = duration
            updatedPractice.note = note
            dataManager.practices[index] = updatedPractice
            dataManager.saveDataIfNeeded()
            showingAlert = true
        }
    }
}

#Preview {
    EditPracticeView(practiceId: UUID())
        .environmentObject(DataManager.shared)
}
