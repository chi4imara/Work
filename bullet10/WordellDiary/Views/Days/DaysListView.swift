import SwiftUI
import Combine

struct DaysListView: View {
    @ObservedObject var viewModel: DiaryViewModel
    @Binding var showingNewEntry: Bool
    @State private var showingFilters = false
    @State private var showingEntryDetail: DiaryEntry?
    @State private var showingEditEntry: DiaryEntry?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("My Days")
                    .font(AppFonts.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primaryBlue)
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button(action: { showingFilters = true }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.system(size: 22))
                            .foregroundColor(AppColors.primaryBlue)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 20)
            
            if viewModel.filteredEntries.isEmpty {
                EmptyStateView(showingNewEntry: $showingNewEntry)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.filteredEntries) { entry in
                            DiaryEntryCard(
                                entry: entry,
                                onTap: { showingEntryDetail = entry },
                                onEdit: { 
                                    showingEditEntry = entry
                                },
                                onDelete: { viewModel.deleteEntry(entry) }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100) 
                }
            }
        }
        .sheet(item: $showingEditEntry) { entry in
            NewEntryView(viewModel: viewModel, selectedTab: .constant(.days), editingEntry: entry)
                .onDisappear {
                    viewModel.objectWillChange.send()
                }
        }
        .sheet(isPresented: $showingFilters) {
            FilterView(viewModel: viewModel)
        }
        .sheet(item: $showingEntryDetail) { entry in
            EntryDetailView(entryId: entry.id, viewModel: viewModel)
        }
    }
}

struct DiaryEntryCard: View {
    let entry: DiaryEntry
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack {
                    Image(systemName: entry.mood.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                        .frame(width: 40, height: 40)
                        .background {
                            Circle()
                                .fill(AppColors.accentYellow.opacity(0.2))
                        }
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(entry.date, style: .date)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.darkGray.opacity(0.7))
                    
                    Text(entry.previewTitle)
                        .font(AppFonts.headline)
                        .fontWeight(.medium)
                        .foregroundColor(AppColors.primaryBlue)
                        .lineLimit(1)
                    
                    Text(entry.previewText)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.darkGray)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.darkGray.opacity(0.5))
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: AppColors.darkGray.opacity(0.1), radius: 8, x: 0, y: 4)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .offset(x: dragOffset.width, y: 0)
        .background {
            HStack {
                if dragOffset.width > 50 {
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(AppColors.accentGreen)
                            .clipShape(Circle())
                    }
                    .padding(.leading, 20)
                }
                
                Spacer()
                
                if dragOffset.width < -50 {
                    Button(action: { showingDeleteConfirmation = true }) {
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(AppColors.warningRed)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 20)
                }
            }
        }
        .highPriorityGesture(
            DragGesture(minimumDistance: 20)
                .onChanged { value in
                    dragOffset = value.translation
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        if value.translation.width > 100 {
                            onEdit()
                        } else if value.translation.width < -100 {
                            showingDeleteConfirmation = true
                        }
                        dragOffset = .zero
                    }
                }
        )
        .alert("Delete Entry", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this entry? This action cannot be undone.")
        }
    }
}

struct EmptyStateView: View {
    @Binding var showingNewEntry: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.lightPurple.opacity(0.3))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "pencil.and.outline")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppColors.primaryBlue)
            }
            
            VStack(spacing: 16) {
                Text("No entries yet")
                    .font(AppFonts.headline)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.primaryBlue)
                
                Text("Start with your first entry — describe today's moment with words.")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.darkGray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: { showingNewEntry = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("New Entry")
                }
                .font(AppFonts.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .background {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                colors: [AppColors.primaryBlue, AppColors.accentYellow],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    DaysListView(viewModel: DiaryViewModel(), showingNewEntry: .constant(false))
        .background(AppColors.mainBackgroundGradient)
}
