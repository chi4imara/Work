import SwiftUI

struct EditReactionView: View {
    let reaction: Reaction
    @EnvironmentObject var reactionsViewModel: ReactionsViewModel
    @StateObject private var formViewModel = ReactionFormViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        formView
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            formViewModel.populate(with: reaction)
        }
    }
    
    private var headerView: some View {
        HStack {
            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            .font(.ibmPlexMono(16, weight: .medium))
            .foregroundColor(AppColors.textSecondary)
            
            Spacer()
            
            Text("Edit Reaction")
                .font(.ibmPlexMono(18, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Button("Save Changes") {
                var updatedReaction = reaction
                formViewModel.updateReaction(&updatedReaction)
                reactionsViewModel.updateReaction(updatedReaction)
                presentationMode.wrappedValue.dismiss()
            }
            .font(.ibmPlexMono(16, weight: .semibold))
            .foregroundColor(formViewModel.isValid ? AppColors.primaryBlue : AppColors.textSecondary)
            .disabled(!formViewModel.isValid)
        }
        .padding(.vertical, 20)
    }
    
    private var formView: some View {
        VStack(spacing: 20) {
            FormField(
                title: "Object",
                text: $formViewModel.object,
                placeholder: "What are you reacting to?"
            )
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Type")
                    .font(.ibmPlexMono(16, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach(ReactionType.allCases, id: \.id) { type in
                        TypeSelectionCard(
                            type: type,
                            isSelected: formViewModel.selectedType == type,
                            action: { formViewModel.selectedType = type }
                        )
                    }
                }
            }
            
            FormField(
                title: "Reaction",
                text: $formViewModel.reaction,
                placeholder: "Your quick reaction (1-2 words)"
            )
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Comment (Optional)")
                    .font(.ibmPlexMono(16, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                TextEditor(text: $formViewModel.comment)
                    .font(.ibmPlexMono(14, weight: .regular))
                    .foregroundColor(AppColors.textPrimary)
                    .padding(16)
                    .frame(minHeight: 100)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.textSecondary.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .overlay(
                        VStack {
                            HStack {
                                Text(formViewModel.comment.isEmpty ? "Add any additional thoughts..." : "")
                                    .font(.ibmPlexMono(14, weight: .regular))
                                    .foregroundColor(AppColors.textSecondary.opacity(0.6))
                                    .padding(.leading, 20)
                                    .padding(.top, 24)
                                Spacer()
                            }
                            Spacer()
                        }
                        .allowsHitTesting(false)
                    )
            }
        }
    }
}
