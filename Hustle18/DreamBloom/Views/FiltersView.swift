import SwiftUI

struct FiltersView: View {
    @ObservedObject var dreamStore: DreamStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var tempSelectedTags: Set<String>
    @State private var tempSearchText: String
    @State private var tempSortOrder: DreamStore.SortOrder
    
    init(dreamStore: DreamStore) {
        self.dreamStore = dreamStore
        self._tempSelectedTags = State(initialValue: dreamStore.selectedTags)
        self._tempSearchText = State(initialValue: dreamStore.searchText)
        self._tempSortOrder = State(initialValue: dreamStore.sortOrder)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Search")
                                .font(.dreamHeadline)
                                .foregroundColor(.dreamWhite)
                            
                            TextField("Search in descriptions...", text: $tempSearchText)
                                .font(.dreamBody)
                                .padding(12)
                                .background(Color.cardBackground)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.dreamWhite.opacity(0.2), lineWidth: 1)
                                )
                                .foregroundColor(.dreamWhite)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Filter by Tags")
                                .font(.dreamHeadline)
                                .foregroundColor(.dreamWhite)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(dreamStore.allTags, id: \.id) { tag in
                                    FilterTagView(
                                        tag: tag.name,
                                        isSelected: tempSelectedTags.contains(tag.name)
                                    ) {
                                        if tempSelectedTags.contains(tag.name) {
                                            tempSelectedTags.remove(tag.name)
                                        } else {
                                            tempSelectedTags.insert(tag.name)
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Sort Order")
                                .font(.dreamHeadline)
                                .foregroundColor(.dreamWhite)
                            
                            VStack(spacing: 8) {
                                ForEach(DreamStore.SortOrder.allCases, id: \.self) { sortOption in
                                    SortOptionView(
                                        title: sortOption.rawValue,
                                        isSelected: tempSortOrder == sortOption
                                    ) {
                                        tempSortOrder = sortOption
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        tempSelectedTags.removeAll()
                        tempSearchText = ""
                        tempSortOrder = .newestFirst
                    }
                    .foregroundColor(.dreamYellow)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        dreamStore.selectedTags = tempSelectedTags
                        dreamStore.searchText = tempSearchText
                        dreamStore.sortOrder = tempSortOrder
                        dreamStore.applyFilters()
                        dismiss()
                    }
                    .foregroundColor(.dreamYellow)
                    .fontWeight(.semibold)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct FilterTagView: View {
    let tag: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .dreamYellow : .dreamWhite.opacity(0.6))
                
                Text(tag.capitalized)
                    .font(.dreamBody)
                    .foregroundColor(.dreamWhite)
                
                Spacer()
            }
            .padding(12)
            .background(isSelected ? Color.dreamYellow.opacity(0.2) : Color.cardBackground)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.dreamYellow : Color.dreamWhite.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct SortOptionView: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(isSelected ? .dreamYellow : .dreamWhite.opacity(0.6))
                
                Text(title)
                    .font(.dreamBody)
                    .foregroundColor(.dreamWhite)
                
                Spacer()
            }
            .padding(12)
            .background(isSelected ? Color.dreamYellow.opacity(0.2) : Color.cardBackground)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.dreamYellow : Color.dreamWhite.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

#Preview {
    FiltersView(dreamStore: DreamStore())
}
