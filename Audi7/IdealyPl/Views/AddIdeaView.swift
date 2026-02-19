import SwiftUI

struct AddIdeaView: View {
    @ObservedObject var viewModel: IdeasViewModel
    @Binding var selectedTab: Int
    @State private var ideaText: String = ""
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("New Idea")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button("Save") {
                        if !ideaText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            withAnimation {
                                viewModel.addIdea(text: ideaText)
                                selectedTab = 0
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ideaText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
                                     AppColors.secondaryText : AppColors.accentYellow)
                    .disabled(ideaText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $ideaText)
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.primaryText)
                        .background(Color.clear)
                        .focused($isTextFieldFocused)
                        .scrollContentBackground(.hidden)
                    
                    if ideaText.isEmpty {
                        Text("Write anything")
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.secondaryText)
                            .padding(.leading, 5)
                            .padding(.top, 8)
                            .allowsHitTesting(false)
                    }
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
                .padding(.bottom, 120)
            }
        }
        .onAppear {
            isTextFieldFocused = true
        }
    }
}
