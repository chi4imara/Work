import SwiftUI

struct AddPhraseView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var phraseText = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let onPhraseAdded: (String) -> Void
    
    var body: some View {
        BackgroundContainer {
            VStack(spacing: 0) {
                headerSection
                
                ScrollView {
                    VStack(spacing: 32) {
                        instructionsSection
                        
                        textInputSection
                        
                        examplesSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
                
                bottomButtonSection
            }
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK") { }
        }
    }
    
    private var headerSection: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(ColorTheme.lightBlue.opacity(0.2))
                    )
            }
            
            Spacer()
            
            Text("Add New Phrase")
                .font(.ubuntu(20, weight: .medium))
                .foregroundColor(ColorTheme.textPrimary)
            
            Spacer()
            
            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    private var instructionsSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorTheme.primaryBlue)
            
            VStack(spacing: 8) {
                Text("Create Your Own Phrase")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Add a personal relaxing phrase that helps you unwind and let go of the day.")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .padding(.vertical, 20)
    }
    
    private var textInputSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Phrase")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(ColorTheme.textPrimary)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.backgroundWhite)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(ColorTheme.primaryBlue.opacity(0.3), lineWidth: 1)
                    )
                
                if phraseText.isEmpty {
                    Text("Write your calming phrase here...")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(ColorTheme.textLight)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                }
                
                TextEditor(text: $phraseText)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.textPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.clear)
            }
            .frame(minHeight: 120)
            
            HStack {
                Text("\(phraseText.count) characters")
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(ColorTheme.textLight)
                
                Spacer()
                
                if phraseText.count > 200 {
                    Text("Maximum 200 characters")
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(ColorTheme.warmOrange)
                }
            }
        }
    }
    
    private var examplesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Examples")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(ColorTheme.textPrimary)
            
            VStack(spacing: 12) {
                examplePhrase("Today I did my best. Tomorrow is a fresh start.")
                examplePhrase("I release all worries and embrace peace.")
                examplePhrase("My mind is calm, my heart is light.")
                examplePhrase("Everything that matters is already done.")
            }
        }
    }
    
    private func examplePhrase(_ text: String) -> some View {
        Button(action: {
            phraseText = text
        }) {
            HStack {
                Text(text)
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(2)
                
                Spacer()
                
                Image(systemName: "arrow.up.left")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTheme.lightBlue.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorTheme.primaryBlue.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var bottomButtonSection: some View {
        Button(action: {
            addPhrase()
        }) {
            Text("Add Phrase")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(ColorTheme.backgroundWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            phraseText.isEmpty || phraseText.count > 200 ?
                            LinearGradient(
                                colors: [ColorTheme.textLight, ColorTheme.textLight],
                                startPoint: .leading,
                                endPoint: .trailing
                            ) :
                            LinearGradient(
                                colors: [ColorTheme.primaryBlue, ColorTheme.accentPurple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .shadow(
                    color: phraseText.isEmpty || phraseText.count > 200 ? Color.clear : ColorTheme.primaryBlue.opacity(0.3),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        }
        .disabled(phraseText.isEmpty || phraseText.count > 200)
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }
    
    private func addPhrase() {
        let trimmedText = phraseText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedText.isEmpty else {
            showAlert("Please enter a phrase")
            return
        }
        
        guard trimmedText.count <= 200 else {
            showAlert("Phrase must be 200 characters or less")
            return
        }
        
        onPhraseAdded(trimmedText)
        dismiss()
    }
    
    private func showAlert(_ message: String) {
        alertMessage = message
        showingAlert = true
    }
}

#Preview {
    AddPhraseView(onPhraseAdded: { _ in })
}
