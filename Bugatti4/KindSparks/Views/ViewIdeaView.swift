import SwiftUI

struct ViewIdeaView: View {
    let ideaId: UUID
    let personId: UUID
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var dataManager = DataManager.shared
    @State private var editedText: String = ""
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.ubuntu(16))
                        .foregroundColor(.appTextSecondary)
                    }
                    
                    Spacer()
                    
                    Text("Gift idea")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(.appTextPrimary)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.ubuntu(16))
                    .opacity(0)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Edit idea")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(.appTextSecondary)
                            
                            TextField("Enter your gift idea", text: $editedText, axis: .vertical)
                                .font(.ubuntu(16))
                                .foregroundColor(.appTextPrimary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.appCard)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.appAccent.opacity(0.3), lineWidth: 1)
                                )
                                .lineLimit(5...10)
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 16) {
                            Button(action: {
                                if !editedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                                   var currentIdea = dataManager.getIdea(ideaId: ideaId) {
                                    currentIdea.text = editedText.trimmingCharacters(in: .whitespacesAndNewlines)
                                    dataManager.updateIdea(currentIdea, for: personId)
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }) {
                                Text("Save changes")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.appTextPrimary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.appAccent)
                                    )
                            }
                            .disabled(editedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                Text("Delete")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.appTextPrimary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.appDelete)
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if let idea = dataManager.getIdea(ideaId: ideaId) {
                editedText = idea.text
            }
        }
        .alert("Delete Idea", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let ideaToDelete = dataManager.getIdea(ideaId: ideaId) {
                    dataManager.deleteIdea(ideaToDelete, from: personId)
                }
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this gift idea?")
        }
    }
}

#Preview {
    ViewIdeaView(ideaId: UUID(), personId: UUID())
}
