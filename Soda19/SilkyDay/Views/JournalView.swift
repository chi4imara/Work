import SwiftUI

struct EntryID: Identifiable {
    let id: UUID
}

struct AddEntryID: Identifiable {
    let id = UUID()
}

struct JournalView: View {
    @StateObject private var viewModel = CareJournalViewModel()
    @State private var addEntryID: AddEntryID?
    @State private var selectedEntryId: UUID?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                filterView
                
                if viewModel.filteredEntries.isEmpty {
                    emptyStateView
                } else {
                    entriesListView
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .sheet(item: $addEntryID) { _ in
            AddEntryView(viewModel: viewModel)
        }
        .sheet(item: Binding(
            get: { selectedEntryId.map { EntryID(id: $0) } },
            set: { selectedEntryId = $0?.id }
        )) { entryID in
            if let entry = viewModel.getEntry(by: entryID.id) {
                EntryDetailView(entryId: entryID.id, viewModel: viewModel)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Hair Care Journal")
                .font(AppFonts.title1)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: {
                addEntryID = AddEntryID()
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.yellow)
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 16)
    }
    
    private var filterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(CareJournalViewModel.FilterType.allCases, id: \.self) { filter in
                    FilterButton(
                        title: filter.displayName,
                        isSelected: viewModel.selectedFilter == filter
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.selectedFilter = filter
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
        .padding(.horizontal, -20)
    }
    
    private var entriesListView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredEntries) { entry in
                    CareEntryCard(
                        entry: entry,
                        isFrequentlyUsed: viewModel.frequentlyUsedProducts.contains(entry.name)
                    ) {
                        selectedEntryId = entry.id
                    }
                    .onLongPressGesture {
                        showDeleteAlert(for: entry)
                    }
                }
            }
            .padding(.bottom, 200)
        }
        .padding(.bottom, -100)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(AppColors.primaryText.opacity(0.5))
            
            Text("Journal is empty")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
            
            Text("Add your first entry to start tracking your hair care routine.")
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                addEntryID = AddEntryID()
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Entry")
                }
                .font(AppFonts.button)
                .foregroundColor(AppColors.accentText)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(AppColors.yellow)
                .cornerRadius(25)
            }
            .padding(.top, 10)
            
            Spacer()
        }
    }
    
    private func showDeleteAlert(for entry: CareEntry) {
        let alert = UIAlertController(
            title: "Delete Entry",
            message: "Are you sure you want to delete this entry?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            withAnimation {
                viewModel.deleteEntry(entry)
            }
        })
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(alert, animated: true)
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.callout)
                .foregroundColor(isSelected ? AppColors.accentText : AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? AppColors.yellow : AppColors.cardBackground)
                )
        }
    }
}

struct CareEntryCard: View {
    let entry: CareEntry
    let isFrequentlyUsed: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: entry.type.icon)
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.yellow)
                    .frame(width: 40, height: 40)
                    .background(AppColors.yellow.opacity(0.2))
                    .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(entry.name)
                            .font(AppFonts.bodyBold)
                            .foregroundColor(AppColors.primaryText)
                        
                        if isFrequentlyUsed {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.yellow)
                        }
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text(entry.type.displayName)
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text("•")
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text(entry.date, style: .date)
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    if !entry.comment.isEmpty {
                        Text(entry.comment)
                            .font(AppFonts.footnote)
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.yellow.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    JournalView()
}
