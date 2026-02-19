import SwiftUI

struct AddPracticeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: DataManager
    
    @State private var name = ""
    @State private var selectedType = PracticeType.movement
    @State private var duration = 5
    @State private var note = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
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
                                Button(action: {
                                    if duration > 1 {
                                        duration -= 1
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(ColorTheme.accentColor)
                                }
                                
                                Spacer()
                                
                                Text("\(duration) min")
                                    .font(.playfair(20, weight: .medium))
                                    .foregroundColor(ColorTheme.textColor)
                                
                                Spacer()
                                
                                Button(action: {
                                    if duration < 60 {
                                        duration += 1
                                    }
                                }) {
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
            .navigationTitle("New Practice")
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
                    .disabled(name.isEmpty)
                }
            }
        }
        .alert("Practice Added", isPresented: $showingAlert) {
            Button("OK") {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Your new practice has been added successfully!")
        }
    }
    
    private func savePractice() {
        let newPractice = Practice(
            name: name,
            type: selectedType,
            duration: duration,
            note: note
        )
        
        dataManager.addPractice(newPractice)
        showingAlert = true
    }
}

struct TypeSelectionCard: View {
    let type: PracticeType
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                Image(systemName: type.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : ColorTheme.accentColor)
                
                Text(type.rawValue)
                    .font(.playfair(14, weight: .medium))
                    .foregroundColor(isSelected ? .white : ColorTheme.textColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(
                isSelected ? ColorTheme.accentColor : ColorTheme.cardBackground
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? ColorTheme.accentColor : ColorTheme.secondaryColor.opacity(0.3),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AddPracticeView()
        .environmentObject(DataManager.shared)
}
