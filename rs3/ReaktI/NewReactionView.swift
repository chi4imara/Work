import SwiftUI

struct NewReactionView: View {
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
    }
    
    private var headerView: some View {
        HStack {
            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            .font(.ibmPlexMono(16, weight: .medium))
            .foregroundColor(AppColors.textSecondary)
            
            Spacer()
            
            Text("New Reaction")
                .font(.ibmPlexMono(20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Button("Save") {
                let newReaction = formViewModel.createReaction()
                reactionsViewModel.addReaction(newReaction)
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

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.ibmPlexMono(16, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
            
            TextField(placeholder, text: $text)
                .font(.ibmPlexMono(14, weight: .regular))
                .foregroundColor(AppColors.textPrimary)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.textSecondary.opacity(0.2), lineWidth: 1)
                        )
                )
        }
    }
}

struct TypeSelectionCard: View {
    let type: ReactionType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: type.iconName)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? .white : typeColor)
                
                Text(type.rawValue)
                    .font(.ibmPlexMono(14, weight: .semibold))
                    .foregroundColor(isSelected ? .white : AppColors.textPrimary)
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? typeColor : Color.white.opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? typeColor : AppColors.textSecondary.opacity(0.2), lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
    
    private var typeColor: Color {
        switch type {
        case .movie: return AppColors.primaryBlue
        case .food: return AppColors.accentOrange
        case .place: return AppColors.accentGreen
        case .person: return AppColors.accentPurple
        case .other: return AppColors.primaryYellow
        }
    }
}
