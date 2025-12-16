import SwiftUI

struct GratitudeEntryView: View {
    @ObservedObject var viewModel: GratitudeViewModel
    let date: Date
    @Environment(\.presentationMode) var presentationMode
    
    @State private var text: String = ""
    @State private var showingEmptyTextAlert = false
    @FocusState private var isTextFieldFocused: Bool
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    private var isEditing: Bool {
        viewModel.getEntry(for: date) != nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                GradientBackground()
                
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("Entry for \(dateFormatter.string(from: date))")
                            .font(.playfairDisplay(size: 20, weight: .bold))
                            .foregroundColor(.primaryPurple)
                        
                        if isEditing {
                            Text("Edit your gratitude")
                                .font(.playfairDisplay(size: 16))
                                .foregroundColor(.accentBlue)
                        }
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What are you grateful for today?")
                            .font(.playfairDisplay(size: 16, weight: .medium))
                            .foregroundColor(.darkGray)
                        
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                            
                            if text.isEmpty {
                                Text("Write one thing you're grateful for today...")
                                    .font(.playfairDisplay(size: 16))
                                    .foregroundColor(.lightGray)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                            }
                            
                            TextEditor(text: $text)
                                .font(.playfairDisplay(size: 16))
                                .foregroundColor(.darkGray)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 12)
                                .background(Color.clear)
                                .focused($isTextFieldFocused)
                                .scrollContentBackground(.hidden)
                        }
                        .frame(minHeight: 200)
                        
                        Text("One entry per day. Long text will be automatically shortened in lists.")
                            .font(.playfairDisplay(size: 14))
                            .foregroundColor(.accentBlue.opacity(0.8))
                            .padding(.horizontal, 4)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Button(action: saveEntry) {
                            HStack {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Save")
                                    .font(.playfairDisplay(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty 
                                ? AnyShapeStyle(Color.lightGray)
                                : AnyShapeStyle(Color.purpleGradient)
                            )
                            .cornerRadius(12)
                            .shadow(
                                color: text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty 
                                ? Color.clear 
                                : Color.primaryPurple.opacity(0.3), 
                                radius: 8, x: 0, y: 4
                            )
                        }
                        .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        
                        Button(action: cancel) {
                            Text("Cancel")
                                .font(.playfairDisplay(size: 16, weight: .medium))
                                .foregroundColor(.accentBlue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.accentBlue.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 20)
            }
            .navigationBarHidden(true)
            .onAppear {
                loadExistingEntry()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isTextFieldFocused = true
                }
            }
            .alert("Empty Entry", isPresented: $showingEmptyTextAlert) {
                Button("OK") { }
            } message: {
                Text("Please enter your gratitude text.")
            }
        }
    }
    
    private func loadExistingEntry() {
        if let existingEntry = viewModel.getEntry(for: date) {
            text = existingEntry.text
        }
    }
    
    private func saveEntry() {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedText.isEmpty else {
            showingEmptyTextAlert = true
            return
        }
        
        if let existingEntry = viewModel.getEntry(for: date) {
            viewModel.updateEntry(existingEntry, text: trimmedText)
        } else {
            viewModel.addEntry(text: trimmedText, for: date)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func cancel() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct GratitudeEntryView_Previews: PreviewProvider {
    static var previews: some View {
        GratitudeEntryView(viewModel: GratitudeViewModel(), date: Date())
    }
}
