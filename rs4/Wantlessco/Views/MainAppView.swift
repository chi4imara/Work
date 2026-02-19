import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var wishViewModel: WishViewModel
    @State private var selectedTab: NavigationTab = .home
    @State private var showSidebar = false
    @State private var selectedEntryId: UUID?
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .home:
                    HomeView(viewModel: wishViewModel)
                        .onReceive(NotificationCenter.default.publisher(for: .entrySelected)) { notification in
                            if let entryId = notification.object as? UUID {
                                selectedEntryId = entryId
                            }
                        }
                case .categories:
                    CategoriesView()
                        .environmentObject(wishViewModel)
                case .statistics:
                    StatisticsView(viewModel: wishViewModel)
                case .settings:
                    SettingsView()
                case .about:
                    CalendarView()
                        .environmentObject(wishViewModel)
                }
            }
            
            if showSidebar {
                SideBarView(selectedTab: $selectedTab, showSidebar: $showSidebar)
                    .transition(.move(edge: .leading))
                    .zIndex(1)
            }
            
            VStack {
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSidebar.toggle()
                        }
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(AppColors.primaryText)
                            .padding(12)
                            .background(
                                Circle()
                                    .fill(AppColors.cardBackground)
                                    .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 5, x: 0, y: 2)
                            )
                    }
                    .padding(.leading, 15)
                    .padding(.top, 10)
                    
                    Spacer()
                }
                
                Spacer()
            }
            .zIndex(2)
        }
        .sheet(item: $selectedEntryId) { entryId in
            EntryDetailView(viewModel: wishViewModel, entryId: entryId)
        }
    }
}

extension UUID: @retroactive Identifiable {
    public var id: UUID { self }
}

enum CategorySheetItem: Identifiable {
    case addCategory(editingCategory: Category?)
    case categoryEntries(categoryId: UUID?)
    
    var id: String {
        switch self {
        case .addCategory:
            return "addCategory"
        case .categoryEntries(let categoryId):
            return "categoryEntries-\(categoryId?.uuidString ?? "uncategorized")"
        }
    }
}

struct CategoriesView: View {
    @EnvironmentObject var wishViewModel: WishViewModel
    @State private var sheetItem: CategorySheetItem?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Categories")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("\(wishViewModel.categories.count) categories")
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.leading, 60)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if wishViewModel.categories.isEmpty {
                    EmptyCategoriesView {
                        sheetItem = .addCategory(editingCategory: nil)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(wishViewModel.categories) { category in
                                CategoryCard(
                                    category: category,
                                    entryCount: category.name == "Uncategorized" 
                                        ? wishViewModel.getUncategorizedEntries().count
                                        : wishViewModel.getEntries(for: category.id).count,
                                    onTap: {
                                        sheetItem = .categoryEntries(categoryId: category.id)
                                    },
                                    onEdit: category.name == "Uncategorized" ? nil : {
                                        sheetItem = .addCategory(editingCategory: category)
                                    },
                                    onDelete: category.name == "Uncategorized" ? nil : {
                                        wishViewModel.deleteCategory(category)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
                
                Spacer()
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { sheetItem = .addCategory(editingCategory: nil) }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("Add Category")
                                .font(.ubuntu(16, weight: .medium))
                        }
                        .foregroundColor(AppColors.buttonText)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(AppColors.buttonBackground)
                        .cornerRadius(25)
                        .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .sheet(item: $sheetItem) { item in
            switch item {
            case .addCategory(let editingCategory):
                AddCategoryView(
                    viewModel: wishViewModel,
                    editingCategory: editingCategory
                ) {
                    sheetItem = nil
                }
            case .categoryEntries(let categoryId):
                CategoryEntriesView(
                    viewModel: wishViewModel,
                    category: categoryId.flatMap { wishViewModel.getCategory(by: $0) }
                )
            }
        }
    }
}

struct EmptyCategoriesView: View {
    let onAddTap: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "folder")
                    .font(.system(size: 80))
                    .foregroundColor(AppColors.primaryText.opacity(0.6))
                
                VStack(spacing: 12) {
                    Text("No Categories")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Create categories to organize your entries")
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 40)
            }
            
            Button(action: onAddTap) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                    
                    Text("Create First Category")
                        .font(.ubuntu(18, weight: .medium))
                }
                .foregroundColor(AppColors.buttonText)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(AppColors.buttonBackground)
                .cornerRadius(12)
                .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            
            Spacer()
        }
    }
}

struct CategoryCard: View {
    let category: Category
    let entryCount: Int
    let onTap: () -> Void
    let onEdit: (() -> Void)?
    let onDelete: (() -> Void)?
    
    @State private var showingDeleteAlert = false
    
    private var isUncategorized: Bool {
        category.name == "Uncategorized"
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Circle()
                    .fill(category.color.color)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "folder.fill")
                            .foregroundColor(.white)
                            .font(.title3)
                    )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(category.name)
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Text("\(entryCount) entries")
                        .font(.ubuntu(14))
                        .foregroundColor(AppColors.secondaryText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                if !isUncategorized, let onEdit = onEdit, let onDelete = onDelete {
                    Menu {
                        Button(action: onEdit) {
                            Label("Edit", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive, action: { showingDeleteAlert = true }) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(AppColors.secondaryText)
                            .padding(8)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .alert("Delete Category", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete?()
            }
        } message: {
            Text("Are you sure you want to delete this category? Entries will be moved to uncategorized.")
        }
    }
}

struct UncategorizedCard: View {
    let entryCount: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Circle()
                    .fill(AppColors.secondaryText.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "folder.badge.questionmark")
                            .foregroundColor(AppColors.primaryText)
                            .font(.title3)
                    )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Uncategorized")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("\(entryCount) entries")
                        .font(.ubuntu(14))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AddCategoryView: View {
    @ObservedObject var viewModel: WishViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var categoryName: String = ""
    @State private var selectedColor: CategoryColor = .blue
    
    let editingCategory: Category?
    let onDismiss: () -> Void
    
    init(viewModel: WishViewModel, editingCategory: Category? = nil, onDismiss: @escaping () -> Void) {
        self.viewModel = viewModel
        self.editingCategory = editingCategory
        self.onDismiss = onDismiss
        if let category = editingCategory {
            self._categoryName = State(initialValue: category.name)
            self._selectedColor = State(initialValue: category.color)
        }
    }
    
    private var isUncategorized: Bool {
        editingCategory?.name == "Uncategorized"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text(editingCategory == nil ? "New Category" : "Edit Category")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Name")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        TextField("Category name", text: $categoryName)
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.primaryText)
                            .disabled(isUncategorized)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isUncategorized ? AppColors.cardBackground.opacity(0.5) : AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.cardBorder, lineWidth: 1)
                                    )
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Color")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                            ForEach(CategoryColor.allCases, id: \.self) { color in
                                ColorPickerButton(
                                    color: color,
                                    isSelected: selectedColor == color
                                ) {
                                    selectedColor = color
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: saveCategory) {
                        Text(editingCategory == nil ? "Create" : "Save Changes")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? AppColors.secondaryText : AppColors.buttonText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? AppColors.disabledButton : AppColors.buttonBackground)
                            )
                    }
                    .disabled(categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onDismiss()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                    .font(.ubuntu(16))
                }
            }
        }
    }
    
    private func saveCategory() {
        let trimmedName = categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        if let editing = editingCategory {
            guard editing.name != "Uncategorized" else {
                onDismiss()
                presentationMode.wrappedValue.dismiss()
                return
            }
            var updated = editing
            updated.name = trimmedName
            updated.color = selectedColor
            viewModel.updateCategory(updated)
        } else {
            let newCategory = Category(name: trimmedName, color: selectedColor)
            viewModel.addCategory(newCategory)
        }
        
        onDismiss()
        presentationMode.wrappedValue.dismiss()
    }
}

struct ColorPickerButton: View {
    let color: CategoryColor
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(color.color)
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .stroke(isSelected ? AppColors.primaryText : Color.clear, lineWidth: 3)
                )
                .overlay(
                    Group {
                        if isSelected {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .font(.title3)
                        }
                    }
                )
        }
    }
}

struct CategoryEntriesView: View {
    @ObservedObject var viewModel: WishViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let category: Category?
    @State private var selectedEntryId: UUID?
    
    private var entries: [WishEntry] {
        if let category = category {
            return viewModel.getEntries(for: category.id)
        } else {
            return viewModel.getUncategorizedEntries()
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                if entries.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "tray")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.primaryText.opacity(0.6))
                        
                        Text("No entries in this category")
                            .font(.ubuntu(18))
                            .foregroundColor(AppColors.secondaryText)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(entries) { entry in
                                WishEntryCard(entry: entry) {
                                    selectedEntryId = entry.id
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(category?.name ?? "Uncategorized")
                        .font(.ubuntu(17, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: 200)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
            .preferredColorScheme(.dark)
        }
        .sheet(item: $selectedEntryId) { entryId in
            EntryDetailView(viewModel: viewModel, entryId: entryId)
        }
    }
}

struct CalendarView: View {
    @EnvironmentObject var wishViewModel: WishViewModel
    @State private var selectedDate = Date()
    @State private var selectedEntryId: UUID?
    
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = 2
        return cal
    }
    
    private var entriesByDate: [Date: [WishEntry]] {
        Dictionary(grouping: wishViewModel.entries) { entry in
            calendar.startOfDay(for: entry.createdAt)
        }
    }
    
    private var entriesForSelectedDate: [WishEntry] {
        let dateKey = calendar.startOfDay(for: selectedDate)
        return entriesByDate[dateKey] ?? []
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Calendar")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("View entries by date")
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.leading, 60)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView {
                    VStack(spacing: 24) {
                        CalendarMonthView(
                            selectedDate: $selectedDate,
                            entriesByDate: entriesByDate,
                            calendar: calendar
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(formatDate(selectedDate))
                                    .font(.ubuntu(20, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                                
                                Text("\(entriesForSelectedDate.count) entries")
                                    .font(.ubuntu(14))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            .padding(.horizontal, 20)
                            
                            if entriesForSelectedDate.isEmpty {
                                VStack(spacing: 20) {
                                    Image(systemName: "calendar.badge.exclamationmark")
                                        .font(.system(size: 50))
                                        .foregroundColor(AppColors.primaryText.opacity(0.6))
                                    
                                    Text("No entries for this date")
                                        .font(.ubuntu(16))
                                        .foregroundColor(AppColors.secondaryText)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                            } else {
                                LazyVStack(spacing: 12) {
                                    ForEach(entriesForSelectedDate) { entry in
                                        WishEntryCard(entry: entry) {
                                            selectedEntryId = entry.id
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .sheet(item: $selectedEntryId) { entryId in
            EntryDetailView(viewModel: wishViewModel, entryId: entryId)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: date)
    }
}

struct CalendarMonthView: View {
    @Binding var selectedDate: Date
    let entriesByDate: [Date: [WishEntry]]
    let calendar: Calendar
    
    private var monthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }
    
    private var daysInMonth: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else {
            return []
        }
        
        let firstDay = calendar.startOfDay(for: monthInterval.start)
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let adjustedFirstWeekday = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        var days: [Date] = []
        
        for i in 0..<adjustedFirstWeekday {
            if let date = calendar.date(byAdding: .day, value: -(adjustedFirstWeekday - i), to: firstDay) {
                days.append(calendar.startOfDay(for: date))
            }
        }
        
        var currentDate = firstDay
        let monthEnd = calendar.date(byAdding: .month, value: 1, to: firstDay)!
        
        while currentDate < monthEnd {
            days.append(calendar.startOfDay(for: currentDate))
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            } else {
                break
            }
        }
        
        while days.count % 7 != 0 {
            if let lastDate = days.last,
               let nextDate = calendar.date(byAdding: .day, value: 1, to: lastDate) {
                days.append(calendar.startOfDay(for: nextDate))
            } else {
                break
            }
        }
        
        return days
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AppColors.primaryText)
                        .font(.title3)
                }
                
                Spacer()
                
                Text(monthYear)
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(AppColors.primaryText)
                        .font(.title3)
                }
            }
            
            let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
            HStack {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(Array(daysInMonth.enumerated()), id: \.offset) { index, date in
                    CalendarDayView(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        isCurrentMonth: calendar.isDate(date, equalTo: selectedDate, toGranularity: .month),
                        hasEntries: entriesByDate[calendar.startOfDay(for: date)] != nil,
                        entryCount: entriesByDate[calendar.startOfDay(for: date)]?.count ?? 0
                    ) {
                        selectedDate = date
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) {
            selectedDate = newDate
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let isCurrentMonth: Bool
    let hasEntries: Bool
    let entryCount: Int
    let action: () -> Void
    
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = 2
        return cal
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.ubuntu(14, weight: isSelected ? .bold : .regular))
                    .foregroundColor(
                        isSelected ? AppColors.primaryText :
                        isCurrentMonth ? AppColors.primaryText :
                        AppColors.secondaryText.opacity(0.5)
                    )
                
                if hasEntries {
                    HStack(spacing: 2) {
                        ForEach(0..<min(entryCount, 3), id: \.self) { _ in
                            Circle()
                                .fill(isSelected ? AppColors.primaryPurple : AppColors.primaryText.opacity(0.6))
                                .frame(width: 4, height: 4)
                        }
                    }
                }
            }
            .frame(width: 40, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? AppColors.primaryPurple.opacity(0.3) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension Notification.Name {
    static let entrySelected = Notification.Name("entrySelected")
}
