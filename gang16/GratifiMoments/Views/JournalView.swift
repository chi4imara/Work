import SwiftUI

struct JournalView: View {
    @ObservedObject var viewModel: GratitudeViewModel
    @State private var showingClearAlert = false
    @State private var showingDatePicker = false
    @State private var selectedEntry: GratitudeEntry?
    @State private var entryToDelete: GratitudeEntry?
    @State private var showingDeleteAlert = false
    
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.entriesCount == 0 {
                    emptyStateView
                } else {
                    contentView
                }
            }
        }
        .sheet(item: $selectedEntry) { entry in
            EditGratitudeView(viewModel: viewModel, entry: entry)
        }
        .alert("Clear Journal", isPresented: $showingClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete All", role: .destructive) {
                viewModel.deleteAllEntries()
            }
        } message: {
            Text("Are you sure you want to delete all gratitude entries? This action cannot be undone.")
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let entry = entryToDelete {
                    viewModel.deleteEntry(entry)
                    entryToDelete = nil
                }
            }
        } message: {
            Text("Are you sure you want to delete this gratitude entry?")
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Gratitude Journal")
                    .font(.builderSans(.bold, size: 24))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                if viewModel.entriesCount > 0 {
                    Button(action: {
                        showingClearAlert = true
                    }) {
                        Image(systemName: "trash")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(AppColors.accentOrange)
                    }
                }
            }
            .padding(.bottom, 4)

            if viewModel.entriesCount > 0 {
                searchAndFiltersView
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var searchAndFiltersView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.textLight)
                
                TextField("Search gratitudes...", text: $viewModel.searchText)
                    .font(.builderSans(.regular, size: 16))
                    .foregroundColor(AppColors.textPrimary)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.clearSearch()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.textLight)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardGradient)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.textLight.opacity(0.3), lineWidth: 1)
                    }
            )
            
            HStack {
                Text("Total gratitudes: \(viewModel.entriesCount)")
                    .font(.builderSans(.medium, size: 14))
                    .foregroundColor(AppColors.textSecondary)
                
                Spacer()
            }
        }
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.getFilteredEntries()) { entry in
                    JournalEntryCard(
                        entry: entry,
                        onEdit: {
                            selectedEntry = entry
                        },
                        onDelete: {
                            entryToDelete = entry
                            showingDeleteAlert = true
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100) 
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "book")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryBlue)
            
            VStack(spacing: 16) {
                Text("Journal is Empty")
                    .font(.builderSans(.bold, size: 24))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Your journal is empty. Every day you can say 'thank you'.")
                    .font(.builderSans(.regular, size: 16))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
            
            Button(action: {
                withAnimation {
                    selectedTab = 0
                }
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 18))
                    Text("Add Gratitude")
                        .font(.builderSans(.semiBold, size: 18))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.primaryBlue)
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct JournalEntryCard: View {
    let entry: GratitudeEntry
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(entry.text)
                .font(.builderSans(.regular, size: 16))
                .foregroundColor(AppColors.textPrimary)
                .lineSpacing(3)
                .lineLimit(3)
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.displayDate)
                        .font(.builderSans(.medium, size: 14))
                        .foregroundColor(AppColors.textSecondary)
                    
                    if entry.edited {
                        Text("Edited")
                            .font(.builderSans(.medium, size: 10))
                            .foregroundColor(AppColors.primaryYellow)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(AppColors.primaryYellow.opacity(0.2))
                            )
                    }
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.primaryBlue)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(AppColors.primaryBlue.opacity(0.1))
                            )
                    }
                    
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.accentOrange)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(AppColors.accentOrange.opacity(0.1))
                            )
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.textLight.opacity(0.1), radius: 6, x: 0, y: 3)
        )
    }
}
