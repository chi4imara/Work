import SwiftUI

struct AddFragranceView: View {
    @ObservedObject var viewModel: FragranceViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var notes: String = ""
    @State private var selectedSeason: Season?
    @State private var occasions: String = ""
    @State private var personalNotes: String = ""
    @State private var showingSeasonsSheet = false
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        FormFieldView(
                            title: "Fragrance Name",
                            text: $name,
                            placeholder: "Enter fragrance name",
                            isRequired: true
                        )
                        
                        FormFieldView(
                            title: "Notes",
                            text: $notes,
                            placeholder: "vanilla, bergamot, musk...",
                            isMultiline: true
                        )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Season")
                                .font(.bauhausMedium(16))
                                .foregroundColor(.appPrimaryBlue)
                            
                            Button(action: {
                                showingSeasonsSheet = true
                            }) {
                                HStack {
                                    Text(selectedSeason?.displayName ?? "Select season")
                                        .font(.bauhausLight(16))
                                        .foregroundColor(selectedSeason != nil ? .appPrimaryBlue : .appTextGray)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.appTextGray)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .shadow(color: Color.appPrimaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        FormFieldView(
                            title: "Occasions",
                            text: $occasions,
                            placeholder: "office, evening, date...",
                            isMultiline: true
                        )
                        
                        FormFieldView(
                            title: "Personal Notes",
                            text: $personalNotes,
                            placeholder: "Your thoughts about this fragrance...",
                            isMultiline: true,
                            isOptional: true
                        )
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("New Fragrance")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.bauhausLight(16))
                    .foregroundColor(.appTextGray)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveFragrance()
                    }
                    .font(.bauhausMedium(16))
                    .foregroundColor(isFormValid ? .appPrimaryYellow : .appTextGray)
                    .disabled(!isFormValid)
                }
            }
        }
        .actionSheet(isPresented: $showingSeasonsSheet) {
            ActionSheet(
                title: Text("Select Season"),
                buttons: Season.allCases.map { season in
                    .default(Text(season.displayName)) {
                        selectedSeason = season
                    }
                } + [.cancel()]
            )
        }
    }
    
    private func saveFragrance() {
        let fragrance = Fragrance(
            name: name.trimmingCharacters(in: .whitespaces),
            notes: notes.trimmingCharacters(in: .whitespaces),
            season: selectedSeason,
            occasions: occasions.trimmingCharacters(in: .whitespaces),
            personalNotes: personalNotes.trimmingCharacters(in: .whitespaces)
        )
        
        viewModel.addFragrance(fragrance)
        presentationMode.wrappedValue.dismiss()
    }
}

struct FormFieldView: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var isMultiline: Bool = false
    var isRequired: Bool = false
    var isOptional: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.bauhausMedium(16))
                    .foregroundColor(.appPrimaryBlue)
                
                if isRequired {
                    Text("*")
                        .font(.bauhausMedium(16))
                        .foregroundColor(.red)
                } else if isOptional {
                    Text("(optional)")
                        .font(.bauhausLight(12))
                        .foregroundColor(.appTextGray)
                }
                
                Spacer()
            }
            
            if isMultiline {
                TextEditor(text: $text)
                    .font(.bauhausLight(16))
                    .frame(minHeight: 80)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: Color.appPrimaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.appLightBlue, lineWidth: 1)
                    )
            } else {
                TextField(placeholder, text: $text)
                    .font(.bauhausLight(16))
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: Color.appPrimaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.appLightBlue, lineWidth: 1)
                    )
            }
        }
    }
}

#Preview {
    AddFragranceView(viewModel: FragranceViewModel())
}
