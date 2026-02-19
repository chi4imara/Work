import SwiftUI

struct GiftIdeasView: View {
    let personId: UUID
    @StateObject private var dataManager = DataManager.shared
    @State private var showingAddIdea = false
    @Environment(\.presentationMode) var presentationMode
    
    private var currentPerson: Person? {
        dataManager.getPerson(by: personId)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
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
                    
                    Text(currentPerson?.name ?? "")
                        .font(.ubuntu(20, weight: .medium))
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
                
                if currentPerson?.ideas.isEmpty ?? true {
                    VStack(spacing: 30) {
                        Spacer()
                        
                        Image(systemName: "lightbulb")
                            .font(.system(size: 60))
                            .foregroundColor(.appTextSecondary)
                        
                        Text("No gift ideas yet. Add the first one.")
                            .font(.ubuntu(16))
                            .foregroundColor(.appTextSecondary)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            showingAddIdea = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add idea")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(.appTextPrimary)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.appAccent)
                            )
                        }
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(currentPerson?.ideas ?? []) { idea in
                                NavigationLink(destination: ViewIdeaView(ideaId: idea.id, personId: personId)) {
                                    IdeaCard(idea: idea)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            showingAddIdea = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add idea")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(.appTextPrimary)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.appAccent)
                            )
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 20)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingAddIdea) {
            AddIdeaView(personId: personId)
        }
    }
}

struct IdeaCard: View {
    let idea: GiftIdea
    
    var body: some View {
        HStack {
            Text(idea.text)
                .font(.ubuntu(16))
                .foregroundColor(.appTextPrimary)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.appTextSecondary)
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
    GiftIdeasView(personId: UUID())
}
