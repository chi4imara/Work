import SwiftUI

struct ReactionDetailView: View {
    let reaction: Reaction
    @EnvironmentObject var reactionsViewModel: ReactionsViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    contentView
                    
                    actionButtons
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditView) {
            EditReactionView(reaction: reaction)
                .environmentObject(reactionsViewModel)
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Delete Reaction"),
                message: Text("Are you sure you want to delete this reaction? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    reactionsViewModel.deleteReaction(reaction)
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Text("Reaction Details")
                .font(.ibmPlexMono(20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Color.clear
                .frame(width: 20, height: 20)
        }
        .padding(.vertical, 10)
    }
    
    private var contentView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 20) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(typeColor.opacity(0.1))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: reaction.type.iconName)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(typeColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(reaction.object)
                            .font(.ibmPlexMono(20, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                            .multilineTextAlignment(.leading)
                        
                        Text(reaction.type.rawValue)
                            .font(.ibmPlexMono(14, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                }
                
                Divider()
                    .background(AppColors.textSecondary.opacity(0.2))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Reaction")
                        .font(.ibmPlexMono(14, weight: .semibold))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text(reaction.reaction)
                        .font(.ibmPlexMono(18, weight: .semibold))
                        .foregroundColor(AppColors.primaryBlue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if !reaction.comment.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Comment")
                            .font(.ibmPlexMono(14, weight: .semibold))
                            .foregroundColor(AppColors.textSecondary)
                        
                        Text(reaction.comment)
                            .font(.ibmPlexMono(14, weight: .regular))
                            .foregroundColor(AppColors.textPrimary)
                            .lineSpacing(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Divider()
                    .background(AppColors.textSecondary.opacity(0.2))
                
                VStack(spacing: 8) {
                    HStack {
                        Text("Created")
                            .font(.ibmPlexMono(12, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                        
                        Spacer()
                        
                        Text(formatDate(reaction.createdAt))
                            .font(.ibmPlexMono(12, weight: .medium))
                            .foregroundColor(AppColors.textPrimary)
                    }
                    
                    if reaction.updatedAt != reaction.createdAt {
                        HStack {
                            Text("Updated")
                                .font(.ibmPlexMono(12, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                            
                            Spacer()
                            
                            Text(formatDate(reaction.updatedAt))
                                .font(.ibmPlexMono(12, weight: .medium))
                                .foregroundColor(AppColors.textPrimary)
                        }
                    }
                }
            }
            .padding(24)
            .background(AppColors.cardGradient)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            Button(action: { showingEditView = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Edit Reaction")
                        .font(.ibmPlexMono(16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.buttonGradient)
                .cornerRadius(25)
                .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Delete Reaction")
                        .font(.ibmPlexMono(16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    LinearGradient(
                        colors: [Color.red, Color.red.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(25)
                .shadow(color: Color.red.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
    }
    
    private var typeColor: Color {
        switch reaction.type {
        case .movie: return AppColors.primaryBlue
        case .food: return AppColors.accentOrange
        case .place: return AppColors.accentGreen
        case .person: return AppColors.accentPurple
        case .other: return AppColors.primaryYellow
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
