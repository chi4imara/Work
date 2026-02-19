import SwiftUI

struct AllIdeasView: View {
    @StateObject private var dataManager = DataManager.shared
    
    var allIdeas: [GiftIdea] {
        return dataManager.getAllIdeas().sorted { $0.createdAt > $1.createdAt }
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("All Ideas")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(.appTextPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if allIdeas.isEmpty {
                    VStack(spacing: 30) {
                        Spacer()
                        
                        Image(systemName: "lightbulb")
                            .font(.system(size: 60))
                            .foregroundColor(.appTextSecondary)
                        
                        Text("All gift ideas will appear here.")
                            .font(.ubuntu(16))
                            .foregroundColor(.appTextSecondary)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(allIdeas) { idea in
                                NavigationLink(destination: ViewIdeaView(ideaId: idea.id, personId: idea.personId)) {
                                    AllIdeaCard(
                                        idea: idea,
                                        personName: dataManager.getPersonName(for: idea.personId)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
    }
}

struct AllIdeaCard: View {
    let idea: GiftIdea
    let personName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(idea.text)
                .font(.ubuntu(16))
                .foregroundColor(.appTextPrimary)
                .multilineTextAlignment(.leading)
            
            HStack {
                Text("for \(personName)")
                    .font(.ubuntu(12))
                    .foregroundColor(.appTextSecondary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.appTextSecondary)
                    .font(.system(size: 12))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appCard)
        )
    }
}

#Preview {
    AllIdeasView()
}
