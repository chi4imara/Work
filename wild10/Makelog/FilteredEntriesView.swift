import SwiftUI

struct FilteredEntriesView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: WeatherEntriesViewModel
    let category: WeatherCategory
    @State private var showingDeleteAlert = false
    @State private var entryToDelete: WeatherEntry?
    
    @Binding var selectedTab: Int
    
    var filteredEntries: [WeatherEntry] {
        return viewModel.entries.filter { $0.category.id == category.id }
            .sorted { $0.date > $1.date }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                if filteredEntries.isEmpty {
                    emptyStateView
                } else {
                    entriesListView
                }
            }
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.large)
        .preferredColorScheme(.dark)
        .sheet(isPresented: $viewModel.isShowingCreateEntry) {
            CreateEntryView(
                viewModel: CreateEntryViewModel(
                    weatherEntriesViewModel: viewModel,
                    editingEntry: viewModel.editingEntry
                )
            )
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let entry = entryToDelete {
                    viewModel.deleteEntry(entry)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this entry? This action cannot be undone.")
        }
    }
    
    private var entriesListView: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: AppSpacing.md) {
                    ForEach(filteredEntries) { entry in
                        NavigationLink(destination: EntryDetailView(entry: entry, viewModel: viewModel)) {
                            EntryCardView(entry: entry)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contextMenu {
                            Button(action: { viewModel.startEditingEntry(entry) }) {
                                Label("Edit", systemImage: "pencil")
                            }
                            
                            Button(role: .destructive, action: {
                                entryToDelete = entry
                                showingDeleteAlert = true
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive, action: {
                                entryToDelete = entry
                                showingDeleteAlert = true
                            }) {
                                Image(systemName: "trash")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button(action: { viewModel.startEditingEntry(entry) }) {
                                Image(systemName: "pencil")
                            }
                            .tint(AppColors.accentGreen)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.bottom, AppSpacing.xl)
            }
            
            HStack {
                Spacer()
                Text("\(filteredEntries.count) \(filteredEntries.count == 1 ? "entry" : "entries")")
                    .font(AppFonts.footnote)
                    .foregroundColor(AppColors.textSecondary)
                Spacer()
            }
            .padding(.vertical, AppSpacing.sm)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            )
            .padding(.horizontal, AppSpacing.md)
            .padding(.bottom, AppSpacing.sm)
        }
        .padding(.bottom, 100)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            
            Image(systemName: categoryIcon)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            
            VStack(spacing: AppSpacing.sm) {
                Text("No \(category.name.lowercased()) entries yet")
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Create your first entry for this category")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { 
                withAnimation {
                    dismiss()
                    selectedTab = 3
                }
            }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Add Entry")
                        .font(AppFonts.headline)
                }
                .foregroundColor(AppColors.buttonText)
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)
                .background(
                    RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                        .fill(AppColors.buttonBackground)
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.xl)
    }
    
    private var categoryIcon: String {
        switch category.name.lowercased() {
        case "sunny", "sun":
            return "sun.max.fill"
        case "rainy", "rain":
            return "cloud.rain.fill"
        case "cloudy", "cloud":
            return "cloud.fill"
        case "snowy", "snow":
            return "cloud.snow.fill"
        case "stormy", "storm":
            return "cloud.bolt.fill"
        case "windy", "wind":
            return "wind"
        default:
            return "cloud"
        }
    }
}

