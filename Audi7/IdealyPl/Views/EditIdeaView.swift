import SwiftUI

struct EditIdeaView: View {
    let idea: Idea
    @ObservedObject var viewModel: IdeasViewModel
    @State private var ideaText: String = ""
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                GradientBackground()
                
                VStack(spacing: 0) {
                    HStack {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Text("Edit Idea")
                            .font(.ubuntu(20, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button("Save") {
                            if !ideaText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                viewModel.updateIdea(idea, with: ideaText)
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(ideaText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 
                                       AppColors.secondaryText : AppColors.accentYellow)
                        .disabled(ideaText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        TextEditor(text: $ideaText)
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.primaryText)
                            .background(Color.clear)
                            .focused($isTextFieldFocused)
                            .scrollContentBackground(.hidden)
                    }
                    .padding(20)
                    .background(AppColors.cardBackground)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.primaryText.opacity(0.1), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            ideaText = idea.text
            isTextFieldFocused = true
        }
    }
}
