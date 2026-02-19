import SwiftUI

struct AddFragranceView: View {
    @ObservedObject var fragranceViewModel: FragranceViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var notesText = ""
    @State private var selectedSeason = Season.spring
    @State private var selectedFormat = FragranceFormat.day
    @State private var description = ""
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !notesText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        FormField(title: "Fragrance Name") {
                            CustomTextField(
                                placeholder: "Enter fragrance name",
                                text: $name
                            )
                        }
                        
                        FormField(title: "Notes") {
                            CustomTextField(
                                placeholder: "Enter notes separated by commas",
                                text: $notesText
                            )
                        }
                        
                        FormField(title: "Season") {
                            SeasonPicker(selectedSeason: $selectedSeason)
                        }
                        
                        FormField(title: "Format") {
                            FormatPicker(selectedFormat: $selectedFormat)
                        }
                        
                        FormField(title: "Notes (Optional)") {
                            CustomTextEditor(
                                placeholder: "Add your personal notes...",
                                text: $description
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("New Fragrance")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.primaryWhite),
                
                trailing: Button("Save") {
                    saveFragrance()
                }
                .foregroundColor(isFormValid ? AppColors.primaryWhite : AppColors.buttonDisabled)
                .disabled(!isFormValid)
            )
            .preferredColorScheme(.dark)
        }
    }
    
    private func saveFragrance() {
        let notes = notesText.components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        let fragrance = Fragrance(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes,
            season: selectedSeason,
            format: selectedFormat,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        fragranceViewModel.addFragrance(fragrance)
        presentationMode.wrappedValue.dismiss()
    }
}

struct FormField<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.lumierepolis(16, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .font(.lumierepolis(16))
            .foregroundColor(AppColors.primaryText)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            .cornerRadius(12)
    }
}

struct CustomTextEditor: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .font(.lumierepolis(16))
                .foregroundColor(AppColors.primaryText)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .frame(minHeight: 100)
            
            if text.isEmpty {
                Text(placeholder)
                    .font(.lumierepolis(16))
                    .foregroundColor(AppColors.placeholderText)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 8)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(AppColors.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

struct SeasonPicker: View {
    @Binding var selectedSeason: Season
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(Season.allCases, id: \.self) { season in
                Button(action: { selectedSeason = season }) {
                    Text(season.displayName)
                        .font(.lumierepolis(14, weight: .bold))
                        .foregroundColor(selectedSeason == season ? AppColors.primaryWhite : AppColors.secondaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedSeason == season ? AppColors.buttonPrimary : AppColors.buttonSecondary)
                        .cornerRadius(20)
                }
            }
        }
    }
}

struct FormatPicker: View {
    @Binding var selectedFormat: FragranceFormat
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(FragranceFormat.allCases, id: \.self) { format in
                Button(action: { selectedFormat = format }) {
                    Text(format.displayName)
                        .font(.lumierepolis(14, weight: .bold))
                        .foregroundColor(selectedFormat == format ? AppColors.primaryWhite : AppColors.secondaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedFormat == format ? AppColors.buttonPrimary : AppColors.buttonSecondary)
                        .cornerRadius(20)
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    AddFragranceView(fragranceViewModel: FragranceViewModel())
}
