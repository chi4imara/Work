import SwiftUI

struct AddFragranceView: View {
    @ObservedObject var viewModel: FragranceViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var brand = ""
    @State private var type: FragranceType = .daytime
    @State private var season: Season = .spring
    @State private var mainNotes = ""
    @State private var atmosphere = ""
    @State private var comment = ""
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        formFields
                    }
                    .padding(20)
                    .padding(.bottom, 50)
                }
            }
            .navigationTitle("New Fragrance")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveFragrance()
                }
                .disabled(!isFormValid)
                .foregroundColor(isFormValid ? AppColors.accentYellow : AppColors.tertiaryText)
            )
            .preferredColorScheme(.dark)
        }
    }
    
    private var formFields: some View {
        VStack(spacing: 16) {
            FormField(
                title: "Fragrance Name *",
                text: $name,
                placeholder: "e.g., Replica Lazy Sunday Morning"
            )
            
            FormField(
                title: "Brand",
                text: $brand,
                placeholder: "e.g., Maison Margiela"
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Type")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Picker("Type", selection: $type) {
                    ForEach(FragranceType.allCases, id: \.self) { type in
                        Text(type.displayName)
                            .tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Season")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach(Season.allCases, id: \.self) { seasonOption in
                        Button(action: { season = seasonOption }) {
                            HStack {
                                Image(systemName: seasonOption.icon)
                                Text(seasonOption.displayName)
                                    .font(.ubuntu(14, weight: .medium))
                            }
                            .foregroundColor(season == seasonOption ? AppColors.buttonText : AppColors.primaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(season == seasonOption ? AppColors.accentYellow : AppColors.cardBackground)
                            .cornerRadius(8)
                        }
                    }
                }
            }
            
            FormField(
                title: "Main Notes",
                text: $mainNotes,
                placeholder: "e.g., bergamot, sandalwood, powdery rose",
                isMultiline: true
            )
            
            FormField(
                title: "Atmosphere",
                text: $atmosphere,
                placeholder: "e.g., calm, cozy, with vanilla notes"
            )
            
            FormField(
                title: "Comment",
                text: $comment,
                placeholder: "e.g., Perfect for office or walks",
                isMultiline: true
            )
        }
    }
    
    private func saveFragrance() {
        let newFragrance = Fragrance(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            brand: brand.trimmingCharacters(in: .whitespacesAndNewlines),
            type: type,
            season: season,
            mainNotes: mainNotes.trimmingCharacters(in: .whitespacesAndNewlines),
            atmosphere: atmosphere.trimmingCharacters(in: .whitespacesAndNewlines),
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addFragrance(newFragrance)
        presentationMode.wrappedValue.dismiss()
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var isMultiline: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            if isMultiline {
                TextEditor(text: $text)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.primaryText)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 80)
                    .padding(12)
                    .background(AppColors.cardBackground)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColors.borderPrimary, lineWidth: 1)
                    )
                    .overlay(
                        Group {
                            if text.isEmpty {
                                HStack {
                                    VStack {
                                        Text(placeholder)
                                            .font(.ubuntu(16))
                                            .foregroundColor(AppColors.tertiaryText)
                                            .padding(.top, 20)
                                            .padding(.leading, 16)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }
                        }
                    )
            } else {
                TextField(placeholder, text: $text)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.primaryText)
                    .padding(12)
                    .background(AppColors.cardBackground)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColors.borderPrimary, lineWidth: 1)
                    )
            }
        }
    }
}

#Preview {
    AddFragranceView(viewModel: FragranceViewModel())
}
