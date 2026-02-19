import SwiftUI

struct IdeasView: View {
    @EnvironmentObject var makeupStore: MakeupStore
    @State private var showingNewIdea = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchBar
                
                if makeupStore.filteredIdeas.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    ideasList
                }
            }
        }
        .sheet(isPresented: $showingNewIdea) {
            NewIdeaView()
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Makeup Ideas")
                    .font(.bauhausBold(28))
                    .foregroundColor(AppColors.white)
                
                if let selectedTag = makeupStore.selectedTag {
                    Text("Filtered by: \(selectedTag)")
                        .font(.bauhausLight(14))
                        .foregroundColor(AppColors.white.opacity(0.8))
                }
            }
            
            Spacer()
            
            Button(action: { showingNewIdea = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(AppColors.white)
                    .frame(width: 44, height: 44)
                    .background(AppColors.buttonGradient)
                    .clipShape(Circle())
                    .shadow(color: AppColors.purple.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.mediumGray)
            
            TextField("Search ideas or tags...", text: $makeupStore.searchText)
                .font(.bauhausLight(16))
                .foregroundColor(AppColors.darkGray)
            
            if !makeupStore.searchText.isEmpty || makeupStore.selectedTag != nil {
                Button(action: makeupStore.clearSearch) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.mediumGray)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(AppColors.white.opacity(0.9))
        )
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "lightbulb")
                .font(.system(size: 60))
                .foregroundColor(AppColors.white.opacity(0.6))
            
            Text(makeupStore.ideas.isEmpty ?
                 "No makeup ideas yet. Add your first one to get started." :
                    "No ideas match your search.")
            .font(.bauhausMedium(18))
            .foregroundColor(AppColors.white)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
            
            if makeupStore.ideas.isEmpty {
                Button(action: { showingNewIdea = true }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Idea")
                    }
                    .font(.bauhausMedium(16))
                    .foregroundColor(AppColors.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppColors.buttonGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var ideasList: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(makeupStore.filteredIdeas) { idea in
                    NavigationLink(destination: IdeaDetailView(ideaId: idea.id)) {
                        IdeaCard(idea: idea)
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

struct IdeaCard: View {
    let idea: MakeupIdea
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let image = idea.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .clipped()
                    .cornerRadius(12)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.mediumGray.opacity(0.3))
                    .frame(height: 120)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 30))
                            .foregroundColor(AppColors.mediumGray)
                    )
            }
            
            Text(idea.title)
                .font(.bauhausMedium(16))
                .foregroundColor(AppColors.darkGray)
                .lineLimit(2)
            
            if !idea.displayTags.isEmpty {
                HStack {
                    ForEach(idea.displayTags, id: \.self) { tag in
                        Text(tag)
                            .font(.bauhausLight(12))
                            .foregroundColor(AppColors.purple)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.purple.opacity(0.1))
                            )
                    }
                    Spacer()
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.darkGray.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

struct IdeasView_Previews: PreviewProvider {
    static var previews: some View {
        IdeasView()
            .environmentObject(MakeupStore())
    }
}
