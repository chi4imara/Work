import SwiftUI

struct DreamListView: View {
    @StateObject private var viewModel = DreamListViewModel()
    @State private var selectedDream: Dream?
    
    @Binding var showingAddDream: Bool
    @Binding var dreamToEdit: Dream?
    @Binding var showingFilters: Bool
    @Binding var showingSortOptions: Bool
    @Binding var isNewDream: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.filteredDreams.isEmpty {
                emptyStateView
            } else {
                dreamsList
            }
        }
        .sheet(isPresented: $showingAddDream) {
            AddEditDreamView(dream: dreamToEdit) { dream in
                print("AddEditDreamView completion called with dream: \(dream.title)")
                print("dreamToEdit at completion: \(dreamToEdit?.title ?? "nil")")
                print("isNewDream: \(isNewDream)")
                
                if !isNewDream && dreamToEdit != nil {
                    DataManager.shared.updateDream(dream)
                    print("Updated existing dream")
                } else {
                    DataManager.shared.addDream(dream)
                    print("Added new dream")
                }
                
                dreamToEdit = nil
                isNewDream = true
                showingAddDream = false
                
                DispatchQueue.main.async {
                    viewModel.applyFiltersAndSort()
                }
            }
        }
        .sheet(item: $selectedDream) { dream in
            DreamDetailView(dream: dream)
        }
        .sheet(isPresented: $showingFilters) {
            FiltersView(viewModel: viewModel)
        }
        .confirmationDialog("Sort Dreams", isPresented: $showingSortOptions) {
            ForEach(DreamListViewModel.SortOption.allCases, id: \.self) { option in
                Button(option.displayName) {
                    viewModel.sortOption = option
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                dreamToEdit = nil
                showingAddDream = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                    Text("New Dream")
                        .font(AppFonts.medium(16))
                }
                .foregroundColor(AppColors.backgroundBlue)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.yellow)
                )
            }
            
            Spacer()
            
            Menu {
                Button(action: { showingFilters = true }) {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                }
                
                Button(action: { showingSortOptions = true }) {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .padding(8)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var dreamsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredDreams) { dream in
                    DreamCard(dream: dream) {
                        selectedDream = dream
                    } onEdit: {
                        print("DreamCard onEdit called for dream: \(dream.title)")
                        isNewDream = false
                        dreamToEdit = dream
                        print("dreamToEdit set to: \(dreamToEdit?.title ?? "nil")")
                        showingAddDream = true
                        print("showingAddDream set to: \(showingAddDream)")
                    } onDelete: {
                        viewModel.deleteDream(dream)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .padding(.top, 10)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "moon.stars")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 12) {
                Text(viewModel.isFilterActive ? "No dreams found" : "You haven't added any dreams yet")
                    .font(AppFonts.medium(18))
                    .foregroundColor(AppColors.primaryText)
                
                Text(viewModel.isFilterActive ? "Try adjusting your filters" : "Start by adding your first prophetic dream")
                    .font(AppFonts.regular(14))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                if viewModel.isFilterActive {
                    viewModel.resetFilters()
                } else {
                    dreamToEdit = nil
                    showingAddDream = true
                }
            }) {
                Text(viewModel.isFilterActive ? "Reset Filters" : "Add First Dream")
                    .font(AppFonts.semiBold(16))
                    .foregroundColor(AppColors.backgroundBlue)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.yellow)
                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
}

struct DreamCard: View {
    let dream: Dream
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            if offset.width < 0 {
                HStack {
                    Spacer()
                    Button(action: {
                    }) {
                        VStack {
                            Image(systemName: "trash")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                            Text("Delete")
                                .font(AppFonts.callout)
                                .foregroundColor(.white)
                        }
                        .frame(width: 80)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red)
                .cornerRadius(12)
            }
            
            if offset.width > 0 {
                HStack {
                    Button(action: onEdit) {
                        VStack {
                            Image(systemName: "pencil")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                            Text("Edit")
                                .font(AppFonts.callout)
                                .foregroundColor(.white)
                        }
                        .frame(width: 80)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue)
                .cornerRadius(12)
            }
            
            HStack(spacing: 16) {
                Circle()
                    .fill(dream.status.color)
                    .frame(width: 12, height: 12)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(dream.title)
                            .font(AppFonts.semiBold(16))
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text(formatDate(dream.dreamDate))
                            .font(AppFonts.regular(12))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Text(dream.expectedEvent)
                        .font(AppFonts.regular(14))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(2)
                    
                    HStack {
                        Text("Check by: \(formatDate(dream.checkDeadline))")
                            .font(AppFonts.regular(12))
                            .foregroundColor(AppColors.yellow)
                        
                        Spacer()
                        
                        if !dream.tags.isEmpty {
                            HStack(spacing: 4) {
                                ForEach(dream.tags.prefix(2), id: \.self) { tag in
                                    Text(tag)
                                        .font(AppFonts.regular(10))
                                        .foregroundColor(AppColors.backgroundBlue)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(AppColors.yellow.opacity(0.8))
                                        )
                                }
                                
                                if dream.tags.count > 2 {
                                    Text("+\(dream.tags.count - 2)")
                                        .font(AppFonts.regular(10))
                                        .foregroundColor(AppColors.secondaryText)
                                }
                            }
                        }
                    }
                    
                    HStack {
                        Text(dream.status.displayName)
                            .font(AppFonts.medium(12))
                            .foregroundColor(dream.status.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(dream.status.color.opacity(0.2))
                            )
                        
                        Spacer()
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
            )
            .offset(x: offset.width, y: 0)
            .highPriorityGesture(
                DragGesture(minimumDistance: 20)
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            if value.translation.width > 100 {
                                onEdit()
                            } else if value.translation.width < -100 {
                                showingDeleteAlert = true
                            }
                            offset = .zero
                        }
                    }
            )
            .onTapGesture {
                onTap()
            }
        }
        .alert("Delete Dream", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this dream? This action cannot be undone.")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

