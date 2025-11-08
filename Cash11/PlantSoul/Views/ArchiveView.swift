import SwiftUI

struct ArchiveView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var searchText = ""
    @State private var selectedFilter: ArchiveFilter = .all
    @State private var showingClearAllConfirmation = false
    @State private var selectedItems: Set<String> = []
    @State private var isSelectionMode = false
    @State private var selectedArchiveItem: ArchiveItem?
    @State private var refreshTrigger = false
    
    enum ArchiveFilter: String, CaseIterable {
        case all = "All"
        case plants = "Plants"
        case tasks = "Tasks"
        case instructions = "Instructions"
    }
    
    var filteredItems: [ArchiveItem] {
        var items: [ArchiveItem] = []
        
        if selectedFilter == .all || selectedFilter == .plants {
            items.append(contentsOf: appViewModel.archivedPlants.map { ArchiveItem.plant($0) })
        }
        
        if selectedFilter == .all || selectedFilter == .tasks {
            items.append(contentsOf: appViewModel.archivedTasks.map { ArchiveItem.task($0) })
        }
        
        if selectedFilter == .all || selectedFilter == .instructions {
            items.append(contentsOf: appViewModel.archivedInstructions.map { ArchiveItem.instruction($0) })
        }
        
        if !searchText.isEmpty {
            items = items.filter { item in
                switch item {
                case .plant(let plant):
                    return plant.name.localizedCaseInsensitiveContains(searchText)
                case .task(let task):
                    return task.plantName.localizedCaseInsensitiveContains(searchText) ||
                           task.type.rawValue.localizedCaseInsensitiveContains(searchText)
                case .instruction(let instruction):
                    return instruction.title.localizedCaseInsensitiveContains(searchText) ||
                           instruction.description.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
        
        return items.sorted { item1, item2 in
            let date1 = item1.archiveDate
            let date2 = item2.archiveDate
            return date1 > date2
        }
    }
    
    var body: some View {
        ZStack {
            ColorScheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchBarView
                
                filterButtonsView
                
                archiveListView
            }
        }
        .alert("Clear Archive", isPresented: $showingClearAllConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Clear All", role: .destructive) {
                clearAllArchive()
            }
        } message: {
            Text("This will permanently delete all archived items. This action cannot be undone.")
        }
        .sheet(item: $selectedArchiveItem) { item in
            ArchiveDetailView(
                item: item,
                appViewModel: appViewModel,
                onItemChanged: {
                    refreshTrigger.toggle()
                }
            )
        }
    }
    
    private var headerView: some View {
        HStack {
            if isSelectionMode {
                Button("Cancel") {
                    isSelectionMode = false
                    selectedItems.removeAll()
                }
                .foregroundColor(ColorScheme.lightText)
            } else {
                Text("Archive")
                    .font(FontManager.title)
                    .fontWeight(.bold)
                    .foregroundColor(ColorScheme.lightText)
            }
            
            Spacer()
            
            if isSelectionMode {
                Button("Delete Selected") {
                    deleteSelectedItems()
                }
                .foregroundColor(ColorScheme.error)
                .disabled(selectedItems.isEmpty)
            } else {
                Menu {
                    Button("Clear All Archive") {
                        showingClearAllConfirmation = true
                    }
                    Button("Select Items") {
                        isSelectionMode = true
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .foregroundColor(ColorScheme.lightText)
                }
            }
        }
        .padding(.horizontal, DesignConstants.largePadding)
        .padding(.vertical, DesignConstants.mediumPadding)
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(ColorScheme.mediumGray)
            
            TextField("", text: $searchText)
                .font(FontManager.body)
                .foregroundColor(ColorScheme.primaryText)
                .overlay(
                    HStack {
                        Text("Search archive...")
                            .font(FontManager.body)
                            .foregroundColor(.gray)
                            .opacity(searchText.isEmpty ? 1 : 0)
                            .allowsHitTesting(false)
                        
                        Spacer()
                    }
                )
        }
        .padding(DesignConstants.mediumPadding)
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .fill(ColorScheme.cardGradient)
        )
        .padding(.horizontal, DesignConstants.largePadding)
        .padding(.bottom, DesignConstants.mediumPadding)
    }
    
    private var filterButtonsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignConstants.smallPadding) {
                ForEach(ArchiveFilter.allCases, id: \.self) { filter in
                    FilterButton(
                        title: filter.rawValue,
                        icon: iconForFilter(filter),
                        isSelected: selectedFilter == filter
                    ) {
                        selectedFilter = filter
                    }
                }
            }
            .padding(.horizontal, DesignConstants.largePadding)
        }
        .padding(.bottom, DesignConstants.mediumPadding)
    }
    
    private var archiveListView: some View {
        Group {
            if filteredItems.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    LazyVStack(spacing: DesignConstants.mediumPadding) {
                        ForEach(filteredItems, id: \.id) { item in
                            ArchiveItemRowView(
                                item: item,
                                appViewModel: appViewModel,
                                isSelected: selectedItems.contains(item.id),
                                isSelectionMode: isSelectionMode,
                                onSelectionToggle: { itemId in
                                    if selectedItems.contains(itemId) {
                                        selectedItems.remove(itemId)
                                    } else {
                                        selectedItems.insert(itemId)
                                    }
                                },
                                onItemTap: { archiveItem in
                                    selectedArchiveItem = archiveItem
                                }
                            )
                        }
                    }
                    .padding(.horizontal, DesignConstants.largePadding)
                    .padding(.bottom, 100)
                }
            }
        }
        .id(refreshTrigger)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: DesignConstants.largePadding) {
            Image(systemName: "archivebox.fill")
                .font(.system(size: 60))
                .foregroundColor(ColorScheme.accent.opacity(0.6))
            
            Text("Archive is empty")
                .font(FontManager.headline)
                .foregroundColor(ColorScheme.lightText)
            
            Text("Archived items will appear here")
                .font(FontManager.body)
                .foregroundColor(ColorScheme.lightText.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(DesignConstants.largePadding)
    }
    
    private func iconForFilter(_ filter: ArchiveFilter) -> String {
        switch filter {
        case .all:
            return "square.grid.2x2"
        case .plants:
            return "leaf.fill"
        case .tasks:
            return "checkmark.circle"
        case .instructions:
            return "book.fill"
        }
    }
    
    private func clearAllArchive() {
        for plant in appViewModel.archivedPlants {
            appViewModel.plantViewModel.permanentDeletePlant(plant)
        }
        for task in appViewModel.archivedTasks {
            appViewModel.taskViewModel.permanentDeleteTask(task)
        }
        for instruction in appViewModel.archivedInstructions {
            appViewModel.instructionViewModel.permanentDeleteInstruction(instruction)
        }
        refreshTrigger.toggle()
    }
    
    private func deleteSelectedItems() {
        for itemId in selectedItems {
            if let item = filteredItems.first(where: { $0.id == itemId }) {
                switch item {
                case .plant(let plant):
                    appViewModel.plantViewModel.permanentDeletePlant(plant)
                case .task(let task):
                    appViewModel.taskViewModel.permanentDeleteTask(task)
                case .instruction(let instruction):
                    appViewModel.instructionViewModel.permanentDeleteInstruction(instruction)
                }
            }
        }
        selectedItems.removeAll()
        isSelectionMode = false
        refreshTrigger.toggle()
    }
}

enum ArchiveItem: Identifiable {
    case plant(Plant)
    case task(Task)
    case instruction(Instruction)
    
    var id: String {
        switch self {
        case .plant(let plant):
            return "plant_\(plant.id)"
        case .task(let task):
            return "task_\(task.id)"
        case .instruction(let instruction):
            return "instruction_\(instruction.id)"
        }
    }
    
    var archiveDate: Date {
        switch self {
        case .plant(let plant):
            return plant.dateAdded
        case .task(let task):
            return task.completedDate ?? task.date
        case .instruction(let instruction):
            return instruction.dateCreated
        }
    }
}

struct ArchiveItemRowView: View {
    let item: ArchiveItem
    @ObservedObject var appViewModel: AppViewModel
    let isSelected: Bool
    let isSelectionMode: Bool
    let onSelectionToggle: (String) -> Void
    let onItemTap: (ArchiveItem) -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingRestoreConfirmation = false
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        Button(action: {
            if !isSelectionMode {
                onItemTap(item)
            }
        }) {
            HStack(spacing: DesignConstants.mediumPadding) {
                if isSelectionMode {
                    Button(action: { onSelectionToggle(item.id) }) {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                            .foregroundColor(isSelected ? ColorScheme.accent : ColorScheme.mediumGray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Image(systemName: iconForItem(item))
                    .font(.title2)
                    .foregroundColor(colorForItem(item))
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(colorForItem(item).opacity(0.2))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(titleForItem(item))
                        .font(FontManager.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(ColorScheme.primaryText)
                        .lineLimit(2)
                    
                    Text(subtitleForItem(item))
                        .font(FontManager.caption)
                        .foregroundColor(ColorScheme.secondaryText)
                    
                    Text("Archived \(item.archiveDate, formatter: relativeDateFormatter)")
                        .font(FontManager.caption)
                        .foregroundColor(ColorScheme.mediumGray)
                }
                
                Spacer()
                
                if !isSelectionMode {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(ColorScheme.mediumGray)
                }
            }
            .padding(DesignConstants.mediumPadding)
            .background(
                RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                    .fill(ColorScheme.cardGradient.opacity(0.7))
                    .shadow(
                        color: ColorScheme.darkBlue.opacity(DesignConstants.shadowOpacity / 2),
                        radius: DesignConstants.shadowRadius / 2,
                        x: 0,
                        y: 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .alert("Restore Item", isPresented: $showingRestoreConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Restore") {
                restoreItem()
            }
        } message: {
            Text("This item will be restored to its original location.")
        }
        .alert("Delete Permanently", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteItem()
            }
        } message: {
            Text("This item will be permanently deleted. This action cannot be undone.")
        }
    }
    
    private func iconForItem(_ item: ArchiveItem) -> String {
        switch item {
        case .plant:
            return "leaf.fill"
        case .task(let task):
            return task.type.icon
        case .instruction(let instruction):
            return instruction.type.icon
        }
    }
    
    private func colorForItem(_ item: ArchiveItem) -> Color {
        switch item {
        case .plant:
            return ColorScheme.softGreen
        case .task(let task):
            return colorForTaskType(task.type)
        case .instruction(let instruction):
            return colorForTaskType(instruction.type)
        }
    }
    
    private func titleForItem(_ item: ArchiveItem) -> String {
        switch item {
        case .plant(let plant):
            return plant.name
        case .task(let task):
            return "\(task.plantName) - \(task.type.rawValue)"
        case .instruction(let instruction):
            return instruction.title
        }
    }
    
    private func subtitleForItem(_ item: ArchiveItem) -> String {
        switch item {
        case .plant(let plant):
            return plant.category.displayName
        case .task(let task):
            return "Task"
        case .instruction(let instruction):
            return instruction.type.rawValue
        }
    }
    
    private func colorForTaskType(_ type: TaskType) -> Color {
        switch type {
        case .watering:
            return ColorScheme.lightBlue
        case .fertilizing:
            return ColorScheme.softGreen
        case .repotting:
            return ColorScheme.warmYellow
        case .cleaning:
            return ColorScheme.lightBlue
        case .generalCare:
            return ColorScheme.softGreen
        }
    }
    
    private func restoreItem() {
        switch item {
        case .plant(let plant):
            appViewModel.plantViewModel.restorePlant(plant)
        case .task(let task):
            appViewModel.taskViewModel.restoreTask(task)
        case .instruction(let instruction):
            appViewModel.instructionViewModel.restoreInstruction(instruction)
        }
    }
    
    private func deleteItem() {
        switch item {
        case .plant(let plant):
            appViewModel.plantViewModel.permanentDeletePlant(plant)
        case .task(let task):
            appViewModel.taskViewModel.permanentDeleteTask(task)
        case .instruction(let instruction):
            appViewModel.instructionViewModel.permanentDeleteInstruction(instruction)
        }
    }
    
    private let relativeDateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
}

struct ArchiveDetailView: View {
    let item: ArchiveItem
    @ObservedObject var appViewModel: AppViewModel
    let onItemChanged: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingDeleteConfirmation = false
    @State private var showingRestoreConfirmation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorScheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DesignConstants.largePadding) {
                        headerSection
                        
                        contentSection
                        
                        actionButtonsSection
                    }
                    .padding(DesignConstants.largePadding)
                }
            }
            .navigationTitle("Archive Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(ColorScheme.lightText)
                }
            }
        }
        .alert("Delete Permanently", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteItem()
                onItemChanged()
                dismiss()
            }
        } message: {
            Text("This item will be permanently deleted. This action cannot be undone.")
        }
        .alert("Restore Item", isPresented: $showingRestoreConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Restore") {
                restoreItem()
                onItemChanged()
                dismiss()
            }
        } message: {
            Text("This item will be restored to its original location.")
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: DesignConstants.mediumPadding) {
            Image(systemName: iconForItem(item))
                .font(.system(size: 60))
                .foregroundColor(colorForItem(item))
                .frame(width: 100, height: 100)
                .background(
                    Circle()
                        .fill(colorForItem(item).opacity(0.2))
                )
            
            VStack(spacing: 8) {
                Text(titleForItem(item))
                    .font(Font.custom("Poppins-Bold", size: 24))
                    .foregroundColor(ColorScheme.lightText)
                    .multilineTextAlignment(.center)
                
                Text(subtitleForItem(item))
                    .font(Font.custom("Poppins-Regular", size: 16))
                    .foregroundColor(ColorScheme.lightText.opacity(0.8))
                
                Text("Archived \(item.archiveDate, formatter: relativeDateFormatter)")
                    .font(Font.custom("Poppins-Regular", size: 14))
                    .foregroundColor(ColorScheme.lightText.opacity(0.6))
            }
        }
        .padding(DesignConstants.largePadding)
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.largeCornerRadius)
                .fill(ColorScheme.cardGradient.opacity(0.3))
        )
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: DesignConstants.mediumPadding) {
            Text("Details")
                .font(Font.custom("Poppins-Bold", size: 20))
                .foregroundColor(ColorScheme.lightText)
            
            VStack(alignment: .leading, spacing: DesignConstants.mediumPadding) {
                switch item {
                case .plant(let plant):
                    plantDetailsView(plant)
                case .task(let task):
                    taskDetailsView(task)
                case .instruction(let instruction):
                    instructionDetailsView(instruction)
                }
            }
        }
        .padding(DesignConstants.largePadding)
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.largeCornerRadius)
                .fill(ColorScheme.cardGradient.opacity(0.3))
        )
    }
    
    private func plantDetailsView(_ plant: Plant) -> some View {
        VStack(alignment: .leading, spacing: DesignConstants.mediumPadding) {
            DetailRow(title: "Category", value: plant.category.displayName)
            DetailRow(title: "Added", value: plant.dateAdded, formatter: dateFormatter)
            
            if !plant.notes.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes")
                        .font(Font.custom("Poppins-Medium", size: 16))
                        .foregroundColor(ColorScheme.lightText)
                    
                    Text(plant.notes)
                        .font(Font.custom("Poppins-Regular", size: 14))
                        .foregroundColor(ColorScheme.lightText.opacity(0.8))
                }
            }
        }
    }
    
    private func taskDetailsView(_ task: Task) -> some View {
        VStack(alignment: .leading, spacing: DesignConstants.mediumPadding) {
            DetailRow(title: "Plant", value: task.plantName)
            DetailRow(title: "Type", value: task.type.rawValue)
            DetailRow(title: "Scheduled", value: task.date, formatter: dateFormatter)
            
            if let time = task.time {
                DetailRow(title: "Time", value: time, formatter: timeFormatter)
            }
            
            if !task.description.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(Font.custom("Poppins-Medium", size: 16))
                        .foregroundColor(ColorScheme.lightText)
                    
                    Text(task.description)
                        .font(Font.custom("Poppins-Regular", size: 14))
                        .foregroundColor(ColorScheme.lightText.opacity(0.8))
                }
            }
        }
    }
    
    private func instructionDetailsView(_ instruction: Instruction) -> some View {
        VStack(alignment: .leading, spacing: DesignConstants.mediumPadding) {
            DetailRow(title: "Type", value: instruction.type.rawValue)
            DetailRow(title: "Created", value: instruction.dateCreated, formatter: dateFormatter)
            
            if !instruction.description.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(Font.custom("Poppins-Medium", size: 16))
                        .foregroundColor(ColorScheme.lightText)
                    
                    Text(instruction.description)
                        .font(Font.custom("Poppins-Regular", size: 14))
                        .foregroundColor(ColorScheme.lightText.opacity(0.8))
                }
            }
        }
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: DesignConstants.mediumPadding) {
            Button(action: {
                showingRestoreConfirmation = true
            }) {
                HStack {
                    Image(systemName: "arrow.uturn.backward")
                    Text("Restore Item")
                }
                .font(Font.custom("Poppins-Medium", size: 16))
                .fontWeight(.semibold)
                .foregroundColor(ColorScheme.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignConstants.mediumPadding)
                .background(
                    RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                        .fill(ColorScheme.accent)
                )
            }
            
            Button(action: {
                showingDeleteConfirmation = true
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete Permanently")
                }
                .font(Font.custom("Poppins-Medium", size: 16))
                .fontWeight(.semibold)
                .foregroundColor(ColorScheme.error)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignConstants.mediumPadding)
                .background(
                    RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                        .stroke(ColorScheme.error, lineWidth: 1)
                )
            }
        }
    }
    
    private func iconForItem(_ item: ArchiveItem) -> String {
        switch item {
        case .plant:
            return "leaf.fill"
        case .task(let task):
            return task.type.icon
        case .instruction(let instruction):
            return instruction.type.icon
        }
    }
    
    private func colorForItem(_ item: ArchiveItem) -> Color {
        switch item {
        case .plant:
            return ColorScheme.softGreen
        case .task(let task):
            return colorForTaskType(task.type)
        case .instruction(let instruction):
            return colorForTaskType(instruction.type)
        }
    }
    
    private func titleForItem(_ item: ArchiveItem) -> String {
        switch item {
        case .plant(let plant):
            return plant.name
        case .task(let task):
            return "\(task.plantName) - \(task.type.rawValue)"
        case .instruction(let instruction):
            return instruction.title
        }
    }
    
    private func subtitleForItem(_ item: ArchiveItem) -> String {
        switch item {
        case .plant(let plant):
            return plant.category.displayName
        case .task(let task):
            return "Task"
        case .instruction(let instruction):
            return instruction.type.rawValue
        }
    }
    
    private func colorForTaskType(_ type: TaskType) -> Color {
        switch type {
        case .watering:
            return ColorScheme.lightBlue
        case .fertilizing:
            return ColorScheme.softGreen
        case .repotting:
            return ColorScheme.warmYellow
        case .cleaning:
            return ColorScheme.lightBlue
        case .generalCare:
            return ColorScheme.softGreen
        }
    }
    
    private func restoreItem() {
        switch item {
        case .plant(let plant):
            appViewModel.plantViewModel.restorePlant(plant)
        case .task(let task):
            appViewModel.taskViewModel.restoreTask(task)
        case .instruction(let instruction):
            appViewModel.instructionViewModel.restoreInstruction(instruction)
        }
    }
    
    private func deleteItem() {
        switch item {
        case .plant(let plant):
            appViewModel.plantViewModel.permanentDeletePlant(plant)
        case .task(let task):
            appViewModel.taskViewModel.permanentDeleteTask(task)
        case .instruction(let instruction):
            appViewModel.instructionViewModel.permanentDeleteInstruction(instruction)
        }
    }
    
    private let relativeDateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}

struct DetailRow: View {
    let title: String
    let value: String
    let formatter: DateFormatter?
    
    init(title: String, value: String, formatter: DateFormatter? = nil) {
        self.title = title
        self.value = value
        self.formatter = formatter
    }
    
    init(title: String, value: Date, formatter: DateFormatter) {
        self.title = title
        self.value = formatter.string(from: value)
        self.formatter = nil
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(Font.custom("Poppins-Medium", size: 16))
                .foregroundColor(ColorScheme.lightText.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(Font.custom("Poppins-Regular", size: 16))
                .foregroundColor(ColorScheme.lightText)
        }
    }
}

#Preview {
    ArchiveView(appViewModel: AppViewModel())
}

