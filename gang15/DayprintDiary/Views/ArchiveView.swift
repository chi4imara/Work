import SwiftUI

struct DatePickerItem: Identifiable {
    let id = UUID()
}

struct ArchiveView: View {
    @StateObject private var diaryManager = DiaryManager.shared
    @State private var searchText = ""
    @State private var datePickerItem: DatePickerItem?
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var isDateFilterActive = false
    @State private var showingClearAllAlert = false
    @State private var entryToDelete: DiaryEntry?
    
    let onNavigateToEdit: (DiaryEntry) -> Void
    let onDismiss: () -> Void
    
    private var filteredEntries: [DiaryEntry] {
        var entries = diaryManager.sortedEntries
        
        if !searchText.isEmpty {
            entries = entries.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
        }
        
        if isDateFilterActive {
            entries = entries.filter { entry in
                guard let entryDate = DateManager.shared.dateFromString(entry.date) else { return false }
                return entryDate >= Calendar.current.startOfDay(for: startDate) &&
                       entryDate <= Calendar.current.startOfDay(for: endDate)
            }
        }
        
        return entries
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(AppTheme.Colors.orb1)
                        .frame(width: 30 + CGFloat(index * 8))
                        .position(orbPosition(for: index, in: geometry))
                        .animation(
                            Animation.easeInOut(duration: 5 + Double(index))
                                .repeatForever(autoreverses: true),
                            value: UUID()
                        )
                }
                
                VStack(spacing: 0) {
                    headerView
                    
                    if diaryManager.hasEntries {
                        archiveContentView
                    } else {
                        emptyStateView
                    }
                }
            }
        }
        .sheet(item: $datePickerItem) { _ in
            datePickerSheet
        }
        .alert("Delete Entry", isPresented: .constant(entryToDelete != nil)) {
            Button("Cancel", role: .cancel) {
                entryToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let entry = entryToDelete {
                    diaryManager.deleteEntry(entry)
                    entryToDelete = nil
                }
            }
        } message: {
            Text("Are you sure you want to delete this memory?")
        }
        .alert("Clear All Entries", isPresented: $showingClearAllAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete All", role: .destructive) {
                diaryManager.deleteAllEntries()
            }
        } message: {
            Text("Are you sure you want to delete all memories? This action cannot be undone.")
        }
    }
        
    private var headerView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            HStack {
                Text("Memory Archive")
                    .font(AppTheme.Typography.largeTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Spacer()
                
                if diaryManager.hasEntries {
                    Button(action: { showingClearAllAlert = true }) {
                        Image(systemName: "trash")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(AppTheme.Colors.error)
                    }
                } else {
                    Button(action: {}) {
                        Image(systemName: "trash")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color.clear)
                    }
                    .disabled(true)
                }
            }
            
            if diaryManager.hasEntries {
                searchAndFiltersView
            }
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.vertical, AppTheme.Spacing.md)
    }
        
    private var searchAndFiltersView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            HStack(spacing: AppTheme.Spacing.md) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                    
                    TextField("Find entry by word...", text: $searchText)
                        .font(AppTheme.Typography.callout)
                        .foregroundColor(AppTheme.Colors.primaryText)
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.vertical, AppTheme.Spacing.sm)
                .background(AppTheme.Colors.cardBackground)
                .cornerRadius(AppTheme.CornerRadius.sm)
                
                Button(action: { datePickerItem = DatePickerItem() }) {
                    HStack {
                        Image(systemName: "calendar")
                        Text("Period")
                    }
                    .font(AppTheme.Typography.callout)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.vertical, AppTheme.Spacing.sm)
                    .background(isDateFilterActive ? AppTheme.Colors.accent : AppTheme.Colors.cardBackground)
                    .cornerRadius(AppTheme.CornerRadius.sm)
                }
            }
            
            if isDateFilterActive {
                HStack {
                    Text("Filtered: \(DateFormatter.shortDate.string(from: startDate)) - \(DateFormatter.shortDate.string(from: endDate))")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                    
                    Spacer()
                    
                    Button("Clear") {
                        isDateFilterActive = false
                    }
                    .font(AppTheme.Typography.caption1)
                    .foregroundColor(AppTheme.Colors.accent)
                }
            }
        }
    }
        
    private var archiveContentView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Total memories: \(filteredEntries.count)")
                    .font(AppTheme.Typography.callout)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                
                Spacer()
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.sm)
            
            if filteredEntries.isEmpty {
                noResultsView
                
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: AppTheme.Spacing.md) {
                        ForEach(filteredEntries) { entry in
                            entryCardView(entry)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.bottom, 100)
                }
            }
        }
    }
        
    private func entryCardView(_ entry: DiaryEntry) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text(entry.text)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
                .lineLimit(3)
                .lineSpacing(2)
            
            HStack {
                Text(entry.formattedDate)
                    .font(AppTheme.Typography.caption1)
                    .foregroundColor(AppTheme.Colors.tertiaryText)
                
                if entry.isEdited {
                    Text("• Edited")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(AppTheme.Colors.accent)
                }
                
                Spacer()
            }
            
            HStack(spacing: AppTheme.Spacing.md) {
                Button(action: { onNavigateToEdit(entry) }) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Edit")
                    }
                    .font(AppTheme.Typography.callout)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .padding(.vertical, AppTheme.Spacing.xs)
                    .padding(.horizontal, AppTheme.Spacing.sm)
                    .background(AppTheme.Colors.primaryPurple)
                    .cornerRadius(AppTheme.CornerRadius.sm)
                }
                
                Button(action: { entryToDelete = entry }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete")
                    }
                    .font(AppTheme.Typography.callout)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .padding(.vertical, AppTheme.Spacing.xs)
                    .padding(.horizontal, AppTheme.Spacing.sm)
                    .background(AppTheme.Colors.error)
                    .cornerRadius(AppTheme.CornerRadius.sm)
                }
                
                Spacer()
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.lg)
    }
        
    private var noResultsView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(AppTheme.Colors.secondaryText)
            
            Text("No memories found")
                .font(AppTheme.Typography.title3)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            Text("Try adjusting your search or date filter")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.top, AppTheme.Spacing.xxl)
    }
        
    private var emptyStateView: some View {
        VStack {
            Spacer()
            
            VStack(spacing: AppTheme.Spacing.xl) {
                Image(systemName: "book")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                VStack(spacing: AppTheme.Spacing.md) {
                    Text("No entries yet.")
                        .font(AppTheme.Typography.title2)
                        .foregroundColor(AppTheme.Colors.primaryText)
                    
                    Text("Every day — a new memory.")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
                
                Button(action: onDismiss) {
                    Text("Create Entry")
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.md)
                        .background(AppTheme.Colors.primaryPurple)
                        .cornerRadius(AppTheme.CornerRadius.md)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            
            Spacer()
        }
    }
        
    private var datePickerSheet: some View {
        NavigationView {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: AppTheme.Spacing.lg) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                    
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                    
                    Spacer()
                }
                .padding(AppTheme.Spacing.lg)
            }
            .navigationTitle("Filter by Period")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    datePickerItem = nil
                },
                trailing: Button("Apply") {
                    isDateFilterActive = true
                    datePickerItem = nil
                }
            )
            .preferredColorScheme(.dark)
        }
    }
        
    private func orbPosition(for index: Int, in geometry: GeometryProxy) -> CGPoint {
        let width = geometry.size.width
        let height = geometry.size.height
        
        let positions: [CGPoint] = [
            CGPoint(x: width * 0.1, y: height * 0.3),
            CGPoint(x: width * 0.9, y: height * 0.2),
            CGPoint(x: width * 0.2, y: height * 0.8),
            CGPoint(x: width * 0.8, y: height * 0.9)
        ]
        
        return positions[index % positions.count]
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

#Preview {
    ArchiveView(
        onNavigateToEdit: { _ in },
        onDismiss: {}
    )
}
