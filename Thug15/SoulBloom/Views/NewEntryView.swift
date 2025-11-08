import SwiftUI

struct NewEntryView: View {
    @ObservedObject var viewModel: GratitudeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let selectedDate: Date
    let isEditing: Bool
    
    @State private var firstGratitude = ""
    @State private var secondGratitude = ""
    @State private var thirdGratitude = ""
    @State private var showingAlert = false
    
    private var isFormValid: Bool {
        !firstGratitude.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !secondGratitude.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !thirdGratitude.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: selectedDate)
    }
    
    init(viewModel: GratitudeViewModel, selectedDate: Date, existingEntry: GratitudeEntry? = nil) {
        self.viewModel = viewModel
        self.selectedDate = selectedDate
        self.isEditing = existingEntry != nil
        
        if let entry = existingEntry {
            _firstGratitude = State(initialValue: entry.firstGratitude)
            _secondGratitude = State(initialValue: entry.secondGratitude)
            _thirdGratitude = State(initialValue: entry.thirdGratitude)
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            GridPatternView()
                .opacity(0.1)
            
            VStack {
                headerView
                    .padding(.bottom, -8)
                
                ScrollView {
                    VStack(spacing: 20) {
                        dateView
                            .padding(.horizontal, 15)
                            .padding(.top, 8)
                        
                        Divider()
                            .frame(maxWidth: .infinity)
                            .overlay {
                                Color.white
                            }
                        
                        inputFieldsView
                        
                        Spacer(minLength: 50)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Incomplete Entry", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text("Please fill in all three gratitude fields before saving.")
        }
    }
    
    private var headerView: some View {
        VStack {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                        .font(FontManager.callout)
                        .foregroundColor(ColorTheme.primaryText)
                        .padding(.vertical, 6)
                }
                
                Spacer()
                
                Text(isEditing ? "Edit Entry" : "New Entry")
                    .font(FontManager.headline)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Button {
                    saveEntry()
                } label: {
                    Text("Save")
                        .font(FontManager.body)
                        .foregroundColor(isFormValid ? ColorTheme.buttonText : ColorTheme.secondaryText)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isFormValid ? ColorTheme.buttonBackground : ColorTheme.cardBackground)
                        )
                }
                .disabled(!isFormValid)
            }
            .padding(.horizontal, 15)
            .padding(.top, 10)
            .padding(.bottom, 5)
            
            Divider()
                .frame(maxWidth: .infinity)
                .overlay {
                    Color.white
                }
        }
    }
    
    private var dateView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Date")
                .font(FontManager.body)
                .foregroundColor(ColorTheme.primaryText)
            
            HStack {
                Text(dateString)
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.primaryText)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ColorTheme.cardBackground)
                    )
                
                Spacer()
            }
        }
    }
    
    private var inputFieldsView: some View {
        VStack(spacing: 15) {
            GratitudeInputField(
                title: "First Gratitude",
                text: $firstGratitude,
                placeholder: "What are you grateful for today?"
            )
            .padding(.horizontal, 15)
            
            Divider()
                .frame(maxWidth: .infinity)
                .overlay {
                    Color.white
                }
            
            GratitudeInputField(
                title: "Second Gratitude",
                text: $secondGratitude,
                placeholder: "Another thing you appreciate..."
            )
            .padding(.horizontal, 15)
            
            Divider()
                .frame(maxWidth: .infinity)
                .overlay {
                    Color.white
                }
            
            GratitudeInputField(
                title: "Third Gratitude",
                text: $thirdGratitude,
                placeholder: "One more blessing in your life..."
            )
            .padding(.horizontal, 15)
        }
    }
    
    private func saveEntry() {
        guard isFormValid else {
            showingAlert = true
            return
        }
        
        let entry = GratitudeEntry(
            date: selectedDate,
            firstGratitude: firstGratitude.trimmingCharacters(in: .whitespacesAndNewlines),
            secondGratitude: secondGratitude.trimmingCharacters(in: .whitespacesAndNewlines),
            thirdGratitude: thirdGratitude.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.saveEntry(entry)
        presentationMode.wrappedValue.dismiss()
    }
}

struct GratitudeInputField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(FontManager.body)
                .foregroundColor(ColorTheme.primaryText)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTheme.cardBackground)
                    .frame(minHeight: 80)
                
                if text.isEmpty {
                    Text(placeholder)
                        .font(FontManager.callout)
                        .foregroundColor(ColorTheme.secondaryText.opacity(0.6))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                }
                
                TextEditor(text: $text)
                    .font(FontManager.callout)
                    .foregroundColor(ColorTheme.primaryText)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
            }
        }
    }
}

#Preview {
    NavigationView {
        NewEntryView(viewModel: GratitudeViewModel(), selectedDate: Date())
    }
}
