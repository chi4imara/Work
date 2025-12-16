import SwiftUI

struct RepotJournalView: View {
    @EnvironmentObject private var viewModel: RepotJournalViewModel
    @State private var showingAddView = false
    @State private var showingFilterView = false
    @State private var showingSortMenu = false
    @State private var selectedRecord: RepotRecord?
    @State private var editingRecord: RepotRecord?
    @State private var showingEditView = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                searchBarView
                
                if viewModel.isFilterActive {
                    filterInfoView
                }
                
                if viewModel.filteredRecords.isEmpty {
                    emptyStateView
                } else {
                    recordsListView
                }
            }
        }
        .sheet(isPresented: $showingAddView) {
            RepotFormView(viewModel: viewModel, editingRecord: nil)
        }
        .sheet(isPresented: $showingFilterView) {
            FilterView(journalViewModel: viewModel)
        }
        .sheet(item: $selectedRecord) { record in
            RepotDetailsView(record: record, journalViewModel: viewModel)
        }
        .sheet(item: $editingRecord) { record in
                RepotFormView(viewModel: viewModel, editingRecord: record)
        }
        .confirmationDialog("Sort Options", isPresented: $showingSortMenu) {
            ForEach(SortOption.allCases, id: \.self) { option in
                Button(option.displayName) {
                    viewModel.selectedSort = option
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Repot Journal")
                .font(AppFonts.largeTitle(.bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: { showingAddView = true }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(AppColors.accentYellow)
                        .frame(width: 44, height: 44)
                        .background(AppColors.cardBackground)
                        .clipShape(Circle())
                        .shadow(color: AppColors.primaryBlue.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                
                Button(action: { showingSortMenu = true }) {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .foregroundColor(AppColors.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(AppColors.cardBackground)
                        .clipShape(Circle())
                        .shadow(color: AppColors.primaryBlue.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                .contextMenu {
                    Button("Filter...") {
                        showingFilterView = true
                    }
                    Button("Sort") {
                        showingSortMenu = true
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchBarView: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.textTertiary)
                
                TextField("Search by plant or note", text: $viewModel.searchText)
                    .font(AppFonts.body(.regular))
                    .foregroundColor(AppColors.textPrimary)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.textTertiary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
    
    private var filterInfoView: some View {
        HStack {
            Text(viewModel.filterDescription)
                .font(AppFonts.caption(.medium))
                .foregroundColor(AppColors.textSecondary)
            
            Spacer()
            
            Button("Reset") {
                viewModel.clearFilters()
            }
            .font(AppFonts.caption(.semiBold))
            .foregroundColor(AppColors.primaryBlue)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(AppColors.accentYellow.opacity(0.1))
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "leaf.circle")
                .font(.system(size: 80))
                .foregroundColor(AppColors.textTertiary)
            
            VStack(spacing: 12) {
                Text(viewModel.records.isEmpty ? "No repotting records yet" : "No records found")
                    .font(AppFonts.title2(.semiBold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(viewModel.records.isEmpty ? 
                     "Start tracking your plant repotting journey" : 
                     "Try adjusting your search or filter")
                    .font(AppFonts.body(.regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 12) {
                Button(action: { showingAddView = true }) {
                    Text(viewModel.records.isEmpty ? "Add First Record" : "Add Record")
                        .font(AppFonts.headline(.semiBold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppColors.primaryBlue)
                        .cornerRadius(25)
                }
                
                if !viewModel.records.isEmpty {
                    Button("Reset Filter/Search") {
                        viewModel.clearFilters()
                    }
                    .font(AppFonts.subheadline(.medium))
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var recordsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredRecords) { record in
                    RepotRecordCard(
                        record: record,
                        isHighlighted: record.id == viewModel.highlightedRecordId,
                        onTap: { selectedRecord = record },
                        onEdit: { 
                            editingRecord = record
                            showingEditView = true
                        },
                        onDelete: { viewModel.deleteRecord(record) }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }
}

struct RepotRecordCard: View {
    let record: RepotRecord
    let isHighlighted: Bool
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            swipeBackground
            
            HStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text(DateFormatter.dayMonth.string(from: record.repotDate))
                        .font(AppFonts.caption(.semiBold))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text(DateFormatter.year.string(from: record.repotDate))
                        .font(AppFonts.caption2(.regular))
                        .foregroundColor(AppColors.textTertiary)
                }
                .frame(width: 50)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(record.plantName)
                        .font(AppFonts.headline(.semiBold))
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    if !record.shortDescription.isEmpty {
                        Text(record.shortDescription)
                            .font(AppFonts.subheadline(.regular))
                            .foregroundColor(AppColors.textSecondary)
                            .lineLimit(1)
                    }
                    
                    if let note = record.careNote, !note.isEmpty {
                        Text(note)
                            .font(AppFonts.caption(.regular))
                            .foregroundColor(AppColors.textTertiary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.textTertiary)
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isHighlighted ? AppColors.primaryBlue : Color.clear, lineWidth: 2)
            )
            .offset(x: dragOffset.width, y: 0)
            .onTapGesture { onTap() }
            .highPriorityGesture(
                DragGesture(minimumDistance: 20)
                    .onChanged { value in
                        let limited = max(min(value.translation.width, 160), -160)
                        dragOffset = CGSize(width: limited, height: 0)
                    }
                    .onEnded { value in
                        withAnimation(.spring()) { dragOffset = .zero }
                        if value.translation.width > 100 {
                            onEdit()
                        } else if value.translation.width < -100 {
                            showingDeleteAlert = true
                        }
                    }
            )
        }
        .alert("Delete Record", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Delete record from \(DateFormatter.medium.string(from: record.repotDate))?")
        }
    }

    private var swipeBackground: some View {
        let progress = min(max(abs(dragOffset.width) / 100, 0), 1)
        return ZStack {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                    Text("Edit")
                        .font(AppFonts.subheadline(.semiBold))
                        .foregroundColor(.white)
                }
                .opacity(dragOffset.width > 0 ? progress : 0)
                .padding(.leading, 16)
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .background(AppColors.primaryBlue.opacity(dragOffset.width > 0 ? 0.6 : 0))
            
            HStack {
                Spacer()
                HStack(spacing: 8) {
                    Text("Delete")
                        .font(AppFonts.subheadline(.semiBold))
                        .foregroundColor(.white)
                    Image(systemName: "trash.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .opacity(dragOffset.width < 0 ? progress : 0)
                .padding(.trailing, 16)
            }
            .frame(maxHeight: .infinity)
            .background(AppColors.error.opacity(dragOffset.width < 0 ? 0.6 : 0))
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

extension DateFormatter {
    static let dayMonth: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        return formatter
    }()
    
    static let year: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    static let medium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

#Preview {
    RepotJournalView()
}
