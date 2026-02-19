import SwiftUI

struct CategoryReactionsView: View {
    let category: ReactionType
    let reactions: [Reaction]
    @EnvironmentObject var reactionsViewModel: ReactionsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if reactions.isEmpty {
                        emptyStateView
                    } else {
                        reactionsList
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            Button("Close") {
                presentationMode.wrappedValue.dismiss()
            }
            .font(.ibmPlexMono(16, weight: .medium))
            .foregroundColor(AppColors.textSecondary)
            
            Spacer()
            
            VStack(spacing: 4) {
                Text(category.rawValue)
                    .font(.ibmPlexMono(20, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("\(reactions.count) reactions")
                    .font(.ibmPlexMono(14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Color.clear
                .frame(width: 50, height: 20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(typeColor.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: category.iconName)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(typeColor.opacity(0.6))
            }
            
            VStack(spacing: 12) {
                Text("No reactions yet")
                    .font(.ibmPlexMono(20, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("You haven't added any \(category.rawValue.lowercased()) reactions yet.")
                    .font(.ibmPlexMono(14, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var reactionsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(reactions) { reaction in
                    NavigationLink(destination: ReactionDetailView(reaction: reaction).environmentObject(reactionsViewModel)) {
                        ReactionCard(reaction: reaction)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }
    
    private var typeColor: Color {
        switch category {
        case .movie: return AppColors.primaryBlue
        case .food: return AppColors.accentOrange
        case .place: return AppColors.accentGreen
        case .person: return AppColors.accentPurple
        case .other: return AppColors.primaryYellow
        }
    }
}
