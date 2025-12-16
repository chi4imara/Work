import SwiftUI

struct CreateNoteView: View {
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var content = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.playfairDisplay(16, weight: .semibold))
                            .foregroundColor(Color.theme.primaryText)
                        
                        TextField("Ideas for winter projects", text: $title)
                            .font(.playfairDisplay(18))
                            .foregroundColor(Color.theme.primaryText)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.theme.cardBackground)
                                    .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Content")
                            .font(.playfairDisplay(16, weight: .semibold))
                            .foregroundColor(Color.theme.primaryText)
                        
                        ZStack(alignment: .topLeading) {
                            if content.isEmpty {
                                Text("Knit mittens with pattern, try new embroidery technique...")
                                    .font(.playfairDisplay(16))
                                    .foregroundColor(Color.theme.secondaryText.opacity(0.5))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                            }
                            
                            TextEditor(text: $content)
                                .font(.playfairDisplay(16))
                                .foregroundColor(Color.theme.primaryText)
                                .frame(minHeight: 200)
                                .scrollContentBackground(.hidden)
                                .padding(8)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.theme.cardBackground)
                                .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                        )
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("New Note")
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
                        saveNote()
                    }
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(Color.theme.primaryYellow)
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveNote() {
        let note = Note(title: title, content: content)
        viewModel.addNote(note)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    CreateNoteView(viewModel: NotesViewModel())
}
