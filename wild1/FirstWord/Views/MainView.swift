import SwiftUI

struct MainView: View {
    @StateObject private var entryStore = EntryStore()
    @State private var showingAddEntry = false
    @State private var showingFilters = false
    @State private var selectedEntry: Entry?
    @State private var editingEntry: Entry?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HeaderView(
                    showingAddEntry: $showingAddEntry,
                    showingFilters: $showingFilters,
                    entryStore: entryStore
                )
                
                if entryStore.entries.isEmpty {
                    EmptyStateView(showingAddEntry: $showingAddEntry, entryStore: entryStore)
                } else if entryStore.filteredAndSortedEntries.isEmpty {
                    FilterEmptyStateView(entryStore: entryStore)
                } else {
                    EntryListView(
                        entries: entryStore.filteredAndSortedEntries,
                        selectedEntry: $selectedEntry,
                        editingEntry: $editingEntry,
                        entryStore: entryStore
                    )
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showingAddEntry) {
            AddEditEntryView(entryStore: entryStore)
        }
        .sheet(item: $editingEntry) { entry in
            AddEditEntryView(entryStore: entryStore, editingEntry: entry)
        }
        .sheet(item: $selectedEntry) { entry in
            EntryDetailView(entryId: entry.id, entryStore: entryStore)
        }
        .actionSheet(isPresented: $showingFilters) {
            FilterActionSheet(entryStore: entryStore)
        }
    }
}

struct HeaderView: View {
    @Binding var showingAddEntry: Bool
    @Binding var showingFilters: Bool
    let entryStore: EntryStore
    
    var body: some View {
        HStack {
            Text("First Phrase of the Day")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(Color.theme.textPrimary)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: { showingFilters = true }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.theme.textPrimary)
                        .frame(width: 40, height: 40)
                        .background(Color.theme.buttonSecondary)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
}

struct EntryListView: View {
    let entries: [Entry]
    @Binding var selectedEntry: Entry?
    @Binding var editingEntry: Entry?
    let entryStore: EntryStore
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(entries) { entry in
                    EntryCardView(entry: entry) {
                        selectedEntry = entry
                    }
                    .contextMenu {
                        Button(action: {
                            editingEntry = entry
                        }) {
                            Label("Edit", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive, action: {
                            entryStore.deleteEntry(entry)
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 200)
        }
        .padding(.bottom, -100)
    }
}

struct EntryCardView: View {
    let entry: Entry
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(entry.date.formattedShort())
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(Color.theme.textSecondary)
                    
                    Spacer()
                    
                    Text(entry.category.displayName)
                        .font(.ubuntu(10, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(entry.category.color)
                        .cornerRadius(8)
                }
                
                Text(entry.phrase)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(Color.theme.textPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                if let note = entry.note, !note.isEmpty {
                    Text(note)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(Color.theme.textSecondary)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color.theme.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.theme.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmptyStateView: View {
    @Binding var showingAddEntry: Bool
    let entryStore: EntryStore
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.textSecondary)
            
            VStack(spacing: 16) {
                Text("You haven't added your first phrase of the day yet")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(Color.theme.textPrimary)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 16) {
                    Button {
                        showingAddEntry = true
                    } label: {
                        Text("Add First Entry")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.theme.buttonPrimary)
                            .cornerRadius(25)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct FilterEmptyStateView: View {
    let entryStore: EntryStore
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.textSecondary)
            
            VStack(spacing: 16) {
                Text("No entries found for the selected conditions")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(Color.theme.textPrimary)
                    .multilineTextAlignment(.center)
                
                Button("Reset Filters") {
                    entryStore.resetFilters()
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 200, height: 50)
                .background(Color.theme.buttonPrimary)
                .cornerRadius(25)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

func FilterActionSheet(entryStore: EntryStore) -> ActionSheet {
    ActionSheet(
        title: Text("Filter & Sort"),
        buttons: [
            .default(Text("Filter: All")) { entryStore.filterPeriod = .all },
            .default(Text("Filter: Week")) { entryStore.filterPeriod = .week },
            .default(Text("Filter: Month")) { entryStore.filterPeriod = .month },
            .default(Text("Sort: Newest First")) { entryStore.sortOrder = .newest },
            .default(Text("Sort: Oldest First")) { entryStore.sortOrder = .oldest },
            .cancel()
        ]
    )
}

#Preview {
    MainView()
}
