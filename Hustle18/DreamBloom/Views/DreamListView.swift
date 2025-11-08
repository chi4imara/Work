import SwiftUI

struct DreamListView: View {
    @ObservedObject var dreamStore: DreamStore
    @State private var showingFilters = false
    @State private var showingAddDream = false
    @State private var dreamToEdit: Dream?
    @State private var dreamToDelete: Dream?
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("My Dreams")
                        .font(.dreamTitle)
                        .foregroundColor(.dreamWhite)
                    
                    Spacer()
                    
                    Button(action: { showingFilters = true }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title2)
                            .foregroundColor(.dreamYellow)
                    }
                    
                    Button(action: { showingAddDream = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.dreamYellow)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                if dreamStore.filteredDreams.isEmpty {
                    EmptyStateView(
                        hasAnyDreams: !dreamStore.dreams.isEmpty,
                        onAddDream: { showingAddDream = true },
                        onResetFilters: { dreamStore.resetFilters() }
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(dreamStore.filteredDreams) { dream in
                                NavigationLink(destination: DreamDetailView(dreamStore: dreamStore, dreamId: dream.id)) {
                                    DreamCardView(dream: dream)
                                }
                                .buttonStyle(PlainButtonStyle())
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button("Delete") {
                                            dreamToDelete = dream
                                            showingDeleteAlert = true
                                        }
                                        .tint(.red)
                                    }
                                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                        Button("Edit") {
                                            dreamToEdit = dream
                                        }
                                        .tint(.dreamYellow)
                                    }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
        }
        .sheet(isPresented: $showingFilters) {
            FiltersView(dreamStore: dreamStore)
        }
        .sheet(isPresented: $showingAddDream) {
            AddEditDreamView(dreamStore: dreamStore)
        }
        .sheet(item: $dreamToEdit) { dream in
            AddEditDreamView(dreamStore: dreamStore, dreamToEdit: dream)
        }
        .alert("Delete Dream", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let dream = dreamToDelete {
                    dreamStore.deleteDream(dream)
                }
            }
        } message: {
            Text("Are you sure you want to delete this dream? This action cannot be undone.")
        }
    }
}

struct DreamCardView: View {
    let dream: Dream
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(dream.date, style: .date)
                    .font(.dreamSubheadline)
                    .foregroundColor(.dreamWhite)
                
                Spacer()
                
                if dream.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundColor(.dreamYellow)
                        .font(.caption)
                }
            }
            
            Text(dream.description)
                .font(.dreamBody)
                .foregroundColor(.dreamWhite.opacity(0.9))
                .lineLimit(3)
                .multilineTextAlignment(.leading)
            
            if !dream.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(dream.tags, id: \.self) { tag in
                            TagBadgeView(tag: tag)
                        }
                    }
                    .padding(.horizontal, 15)
                }
                .padding(.horizontal, -15)
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.dreamWhite.opacity(0.1), lineWidth: 1)
        )
    }
}

struct TagBadgeView: View {
    let tag: String
    
    var body: some View {
        Text(tag)
            .font(.dreamCaption)
            .foregroundColor(.black)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.tagColor(for: tag))
            .cornerRadius(12)
    }
}

struct EmptyStateView: View {
    let hasAnyDreams: Bool
    let onAddDream: () -> Void
    let onResetFilters: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "moon.stars")
                .font(.system(size: 60))
                .foregroundColor(.dreamYellow.opacity(0.6))
            
            if hasAnyDreams {
                Text("No dreams match your filters")
                    .font(.dreamHeadline)
                    .foregroundColor(.dreamWhite)
                
                Text("Try adjusting your search criteria")
                    .font(.dreamBody)
                    .foregroundColor(.dreamWhite.opacity(0.7))
                    .multilineTextAlignment(.center)
                
                Button("Reset Filters") {
                    onResetFilters()
                }
                .font(.dreamSubheadline)
                .foregroundColor(.black)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.dreamYellow)
                .cornerRadius(8)
            } else {
                Text("You haven't added any dreams yet")
                    .font(.dreamHeadline)
                    .foregroundColor(.dreamWhite)
                    .multilineTextAlignment(.center)
                
                Text("Start capturing your dreams and discover patterns in your sleep")
                    .font(.dreamBody)
                    .foregroundColor(.dreamWhite.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Button("Add Your First Dream") {
                    onAddDream()
                }
                .font(.dreamSubheadline)
                .foregroundColor(.black)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.dreamYellow)
                .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    DreamListView(dreamStore: DreamStore())
}
