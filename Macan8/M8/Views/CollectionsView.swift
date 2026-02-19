import SwiftUI

struct CollectionsView: View {
    @ObservedObject var viewModel: NailIdeasViewModel
    @State private var showingNewCollection = false
    @State private var newCollectionName = ""
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.collections.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    collectionsListView
                }
            }
        }
        .alert("New Collection", isPresented: $showingNewCollection) {
            TextField("Collection name", text: $newCollectionName)
            Button("Cancel", role: .cancel) {
                newCollectionName = ""
            }
            Button("Create") {
                createNewCollection()
            }
            .disabled(newCollectionName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        } message: {
            Text("Enter a name for your new collection")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Collections")
                .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: { showingNewCollection = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.accentYellow)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "folder")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 8) {
                Text("No collections yet")
                    .font(FontManager.playfairDisplay(size: 24, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Create collections to organize your nail art ideas by season, event, or theme")
                    .font(FontManager.playfairDisplay(size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingNewCollection = true }) {
                Text("Create Collection")
                    .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.primaryBlue)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppColors.accentYellow)
                    .cornerRadius(20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var collectionsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.collections) { collection in
                    CollectionCardView(collection: collection, viewModel: viewModel)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
    
    private func createNewCollection() {
        let trimmedName = newCollectionName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty {
            let newCollection = NailCollection(name: trimmedName)
            viewModel.addCollection(newCollection)
            newCollectionName = ""
        }
    }
}

struct CollectionCardView: View {
    let collection: NailCollection
    let viewModel: NailIdeasViewModel
    @State private var showingDetails = false
    
    private var ideasCount: Int {
        viewModel.getIdeasInCollection(collection).count
    }
    
    var body: some View {
        Button(action: { showingDetails = true }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(collection.name)
                            .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.leading)
                        
                        Text("\(ideasCount) idea\(ideasCount == 1 ? "" : "s")")
                            .font(FontManager.playfairDisplay(size: 14))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Image(systemName: "folder.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppColors.accentYellow)
                        
                        Text(DateFormatter.shortDate.string(from: collection.dateCreated))
                            .font(FontManager.playfairDisplay(size: 12))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                
                HStack {
                    if ideasCount > 0 {
                        let previewIdeas = viewModel.getIdeasInCollection(collection).prefix(3)
                        HStack(spacing: 4) {
                            ForEach(Array(previewIdeas), id: \.id) { idea in
                                Text(idea.name)
                                    .font(FontManager.playfairDisplay(size: 12))
                                    .foregroundColor(AppColors.secondaryText)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(AppColors.accentYellow.opacity(0.2))
                                    )
                            }
                            if ideasCount > 3 {
                                Text("+\(ideasCount - 3)")
                                    .font(FontManager.playfairDisplay(size: 12))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            )
        }
        .sheet(isPresented: $showingDetails) {
            CollectionDetailsView(collection: collection, viewModel: viewModel)
        }
    }
}

#Preview {
    CollectionsView(viewModel: NailIdeasViewModel())
}
