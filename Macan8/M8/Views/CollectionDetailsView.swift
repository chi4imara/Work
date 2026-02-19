import SwiftUI

struct CollectionDetailsView: View {
    let collection: NailCollection
    @ObservedObject var viewModel: NailIdeasViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingAddIdeas = false
    @State private var showingDeleteAlert = false
    
    private var ideasInCollection: [NailIdea] {
        viewModel.getIdeasInCollection(collection)
    }
    
    private var availableIdeas: [NailIdea] {
        viewModel.ideas.filter { idea in
            !collection.ideaIds.contains(idea.id)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if ideasInCollection.isEmpty {
                        emptyStateView
                        
                        Spacer()
                    } else {
                        ideasListView
                    }
                }
            }
            .navigationTitle("Collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { showingAddIdeas = true }) {
                            Label("Add Ideas", systemImage: "plus")
                        }
                        
                        Button(role: .destructive, action: { showingDeleteAlert = true }) {
                            Label("Delete Collection", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(AppColors.primaryText)
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $showingAddIdeas) {
            AddIdeasToCollectionView(
                collection: collection,
                availableIdeas: availableIdeas,
                viewModel: viewModel
            )
        }
        .alert("Delete Collection", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteCollection(collection)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this collection? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            Text(collection.name)
                .font(FontManager.playfairDisplay(size: 24, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 20) {
                VStack(spacing: 4) {
                    Text("\(ideasInCollection.count)")
                        .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                        .foregroundColor(AppColors.accentYellow)
                    Text("Ideas")
                        .font(FontManager.playfairDisplay(size: 14))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text(DateFormatter.shortDate.string(from: collection.dateCreated))
                        .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                    Text("Created")
                        .font(FontManager.playfairDisplay(size: 14))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 8) {
                Text("No ideas in this collection")
                    .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add some nail art ideas to organize them by theme")
                    .font(FontManager.playfairDisplay(size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            if !availableIdeas.isEmpty {
                Button(action: { showingAddIdeas = true }) {
                    Text("Add Ideas")
                        .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.primaryBlue)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(AppColors.accentYellow)
                        .cornerRadius(20)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var ideasListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if !availableIdeas.isEmpty {
                    Button(action: { showingAddIdeas = true }) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 20))
                            Text("Add More Ideas")
                                .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                        }
                        .foregroundColor(AppColors.accentYellow)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.accentYellow.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
                
                ForEach(ideasInCollection) { idea in
                    CollectionIdeaCardView(idea: idea, collection: collection, viewModel: viewModel)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
}

struct CollectionIdeaCardView: View {
    let idea: NailIdea
    let collection: NailCollection
    let viewModel: NailIdeasViewModel
    @State private var showingDetails = false
    
    var body: some View {
        HStack {
            Button(action: { showingDetails = true }) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(idea.name)
                            .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.leading)
                        
                        Text(idea.mainColor)
                            .font(FontManager.playfairDisplay(size: 14))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: idea.status.icon)
                                .font(.system(size: 12))
                            Text(idea.status.rawValue)
                                .font(FontManager.playfairDisplay(size: 12, weight: .medium))
                        }
                        .foregroundColor(AppColors.accentYellow)
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            
            Button(action: {
                viewModel.removeIdeaFromCollection(ideaId: idea.id, collectionId: collection.id)
            }) {
                Image(systemName: "minus.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.red)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
        .sheet(isPresented: $showingDetails) {
            IdeaDetailsView(idea: idea, viewModel: viewModel)
        }
    }
}

struct AddIdeasToCollectionView: View {
    let collection: NailCollection
    let availableIdeas: [NailIdea]
    @ObservedObject var viewModel: NailIdeasViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedIdeas: Set<UUID> = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()
                
                if availableIdeas.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(AppColors.accentYellow)
                        
                        Text("All ideas are already in collections")
                            .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.center)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(availableIdeas) { idea in
                                Button(action: {
                                    if selectedIdeas.contains(idea.id) {
                                        selectedIdeas.remove(idea.id)
                                    } else {
                                        selectedIdeas.insert(idea.id)
                                    }
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(idea.name)
                                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                                .foregroundColor(AppColors.primaryText)
                                                .multilineTextAlignment(.leading)
                                            
                                            Text(idea.mainColor)
                                                .font(FontManager.playfairDisplay(size: 14))
                                                .foregroundColor(AppColors.secondaryText)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: selectedIdeas.contains(idea.id) ? "checkmark.circle.fill" : "circle")
                                            .font(.system(size: 20))
                                            .foregroundColor(selectedIdeas.contains(idea.id) ? AppColors.accentYellow : AppColors.secondaryText)
                                    }
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedIdeas.contains(idea.id) ? AppColors.accentYellow.opacity(0.1) : AppColors.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(selectedIdeas.contains(idea.id) ? AppColors.accentYellow : AppColors.cardBorder, lineWidth: 1)
                                            )
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
            .navigationTitle("Add Ideas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add (\(selectedIdeas.count))") {
                        addSelectedIdeas()
                    }
                    .foregroundColor(selectedIdeas.isEmpty ? AppColors.secondaryText : AppColors.accentYellow)
                    .disabled(selectedIdeas.isEmpty)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func addSelectedIdeas() {
        for ideaId in selectedIdeas {
            viewModel.addIdeaToCollection(ideaId: ideaId, collectionId: collection.id)
        }
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    CollectionDetailsView(
        collection: NailCollection(name: "Spring 2025"),
        viewModel: NailIdeasViewModel()
    )
}
