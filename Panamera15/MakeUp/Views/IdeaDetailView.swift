import SwiftUI
import StoreKit

struct IdeaDetailView: View {
    @EnvironmentObject var makeupStore: MakeupStore
    @Environment(\.dismiss) private var dismiss
    
    let ideaId: UUID
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var idea: MakeupIdea? {
        makeupStore.ideas.first { $0.id == ideaId }
    }
    
    var body: some View {
        Group {
            if let idea = idea {
                ideaDetailContent(idea: idea)
            } else {
                Text("Idea not found")
                    .foregroundColor(AppColors.white)
            }
        }
    }
    
    private func ideaDetailContent(idea: MakeupIdea) -> some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if let image = idea.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                            .clipped()
                            .cornerRadius(20)
                    }
                    
                    HStack(alignment: .top) {
                        Text(idea.title)
                            .font(.bauhausBold(28))
                            .foregroundColor(AppColors.white)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        Button(action: { makeupStore.toggleFavorite(idea) }) {
                            Image(systemName: idea.isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 24))
                                .foregroundColor(idea.isFavorite ? AppColors.purple : AppColors.white)
                        }
                    }
                    
                    if !idea.tags.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tags")
                                .font(.bauhausMedium(18))
                                .foregroundColor(AppColors.white)
                            
                            ScrollView(.horizontal, showsIndicators: true) {
                                HStack {
                                    ForEach(idea.tags, id: \.self) { tag in
                                        Button(action: {
                                            makeupStore.filterByTag(tag)
                                            dismiss()
                                        }) {
                                            Text(tag)
                                                .font(.bauhausLight(14))
                                                .foregroundColor(AppColors.purple)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .fill(AppColors.white.opacity(0.9))
                                                )
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            .padding(.horizontal, -20)
                        }
                    }
                    
                    if !idea.description.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Description")
                                .font(.bauhausMedium(18))
                                .foregroundColor(AppColors.white)
                            
                            Text(idea.description)
                                .font(.bauhausLight(16))
                                .foregroundColor(AppColors.white.opacity(0.9))
                                .lineSpacing(4)
                        }
                    }
                    
                    actionButtons(idea: idea)
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.bauhausMedium(16))
                    .foregroundColor(AppColors.white)
                }
            }
        }
        .toolbarBackground(Color.clear, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(isPresented: $showingEditView) {
            NewIdeaView(ideaToEditId: ideaId)
        }
        .alert("Delete Idea", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let ideaToDelete = makeupStore.ideas.first(where: { $0.id == ideaId }) {
                    makeupStore.deleteIdea(ideaToDelete)
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this makeup idea? This action cannot be undone.")
        }
    }
    
    private func actionButtons(idea: MakeupIdea) -> some View {
        VStack(spacing: 16) {
            Button(action: { showingEditView = true }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit")
                }
                .font(.bauhausMedium(16))
                .foregroundColor(AppColors.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AppColors.buttonGradient)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete")
                }
                .font(.bauhausMedium(16))
                .foregroundColor(AppColors.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [Color.red.opacity(0.8), Color.red],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
        .padding(.top, 20)
    }
}

struct IdeaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IdeaDetailView(ideaId: MakeupIdea.sampleData[0].id)
                .environmentObject(MakeupStore())
        }
    }
}
