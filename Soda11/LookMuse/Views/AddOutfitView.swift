import SwiftUI

struct AddOutfitView: View {
    @ObservedObject var viewModel: OutfitViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDate = Date()
    @State private var description = ""
    @State private var location = ""
    @State private var weather = ""
    @State private var comment = ""
    @State private var showingDatePicker = false
    
    private var isFormValid: Bool {
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    VStack(spacing: 20) {
                        dateField
                        
                        CustomTextField(
                            title: "Outfit Description",
                            text: $description,
                            placeholder: "e.g., Denim jacket, white t-shirt, sneakers"
                        )
                        
                        CustomTextField(
                            title: "Location",
                            text: $location,
                            placeholder: "e.g., Park walk, Office, Beach"
                        )
                        
                        CustomTextField(
                            title: "Weather",
                            text: $weather,
                            placeholder: "e.g., +16°C, sunny"
                        )
                        
                        CustomTextEditor(
                            title: "Comment (Optional)",
                            text: $comment,
                            placeholder: "How did you feel? Any notes about the outfit?"
                        )
                    }
                    
                    saveButton
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerSheet(selectedDate: $selectedDate)
        }
    }
    
    private var headerView: some View {
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .font(.ubuntu(16, weight: .regular))
            .foregroundColor(Color.theme.primaryText)
            
            Spacer()
            
            Text("Add Outfit")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Spacer()
            
            Button("Save") {
                saveOutfit()
            }
            .font(.ubuntu(16, weight: .medium))
            .foregroundColor(isFormValid ? Color.theme.primaryYellow : Color.theme.secondaryText)
            .disabled(!isFormValid)
        }
        .padding(.top, 20)
        .padding(.bottom, 20)
    }
    
    private var dateField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Date")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(Color.theme.primaryText)
            
            Button(action: {
                showingDatePicker = true
            }) {
                HStack {
                    Text(formatDate(selectedDate))
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(Color.theme.darkText)
                    
                    Spacer()
                    
                    Image(systemName: "calendar")
                        .font(.system(size: 16))
                        .foregroundColor(Color.theme.accentText)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.theme.cardBackground)
                        .shadow(color: Color.theme.lightShadowColor, radius: 4, x: 0, y: 2)
                )
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: saveOutfit) {
            Text("Save Outfit")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(Color.theme.buttonText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(isFormValid ? Color.theme.buttonBackground : Color.gray.opacity(0.5))
                        .shadow(color: Color.theme.shadowColor, radius: isFormValid ? 8 : 0, x: 0, y: 4)
                )
        }
        .disabled(!isFormValid)
        .padding(.top, 20)
    }
    
    private func saveOutfit() {
        let outfit = OutfitModel(
            date: selectedDate,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            location: location.trimmingCharacters(in: .whitespacesAndNewlines),
            weather: weather.trimmingCharacters(in: .whitespacesAndNewlines),
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addOutfit(outfit)
        dismiss()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(Color.theme.primaryText)
            
            TextField(placeholder, text: $text)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(Color.theme.darkText)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.theme.cardBackground)
                        .shadow(color: Color.theme.lightShadowColor, radius: 4, x: 0, y: 2)
                )
        }
    }
}

struct CustomTextEditor: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(Color.theme.primaryText)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.cardBackground)
                    .shadow(color: Color.theme.lightShadowColor, radius: 4, x: 0, y: 2)
                    .frame(minHeight: 100)
                
                if text.isEmpty {
                    Text(placeholder)
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(Color.gray.opacity(0.6))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .allowsHitTesting(false)
                }
                
                TextEditor(text: $text)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(Color.theme.darkText)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .frame(minHeight: 100)
            }
        }
    }
}

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .padding()
                    
                    Spacer()
                }
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.primaryYellow)
                    .fontWeight(.medium)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    AddOutfitView(viewModel: OutfitViewModel())
}
