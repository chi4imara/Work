import SwiftUI

struct MyPlacesView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var showingAddItem = false
    @State private var selectedFilter: FilterType = .all
    @State private var searchText = ""
    
    enum FilterType: String, CaseIterable {
        case all = "All"
        case wantToVisit = "Want to Visit"
        case done = "Done"
        case tasks = "Tasks"
    }
    
    var filteredItems: [AnyItem] {
        var items: [AnyItem] = []
        
        let placesToShow = viewModel.places.filter { place in
            switch selectedFilter {
            case .all:
                return true
            case .wantToVisit:
                return place.status == .wantToVisit
            case .done:
                return place.status == .done
            case .tasks:
                return false
            }
        }
        items.append(contentsOf: placesToShow.map { AnyItem.place($0) })
        
        if selectedFilter == .all || selectedFilter == .tasks {
            items.append(contentsOf: viewModel.dailyTasks.map { AnyItem.task($0) })
        }
        
        if !searchText.isEmpty {
            items = items.filter { item in
                switch item {
                case .place(let place):
                    return place.name.localizedCaseInsensitiveContains(searchText)
                case .task(let task):
                    return task.title.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
        
        return items
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        Text("My Places & Tasks")
                            .font(.playfairDisplay(.bold, size: 28))
                            .foregroundColor(.primaryBlue)
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddItem = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.primaryYellow)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.textSecondary)
                        
                        TextField("Search places and tasks...", text: $searchText)
                            .font(.playfairDisplay(.regular, size: 16))
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.8))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.primaryBlue.opacity(0.3), lineWidth: 1)
                            }
                    )
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(FilterType.allCases, id: \.self) { filter in
                                FilterButton(
                                    title: filter.rawValue,
                                    isSelected: selectedFilter == filter
                                ) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedFilter = filter
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.horizontal, -20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                if filteredItems.isEmpty {
                    Spacer()
                    
                    EmptyStateView(
                        title: searchText.isEmpty ? "No items yet" : "No results found",
                        subtitle: searchText.isEmpty ? "Add your first location or task and start exploring!" : "Try adjusting your search or filters",
                        systemImage: searchText.isEmpty ? "location.circle" : "magnifyingglass"
                    )
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredItems, id: \.id) { item in
                                NavigationLink(destination: DetailView(itemId: item.itemId, viewModel: viewModel)) {
                                    ItemCardView(item: item, viewModel: viewModel)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddItem) {
            AddTaskView(viewModel: viewModel)
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
                .font(.playfairDisplay(.medium, size: 14))
                .foregroundColor(isSelected ? .white : .primaryBlue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.primaryBlue : Color.white.opacity(0.8))
                        .overlay {
                            Capsule()
                            .stroke(Color.primaryBlue.opacity(0.3), lineWidth: isSelected ? 0 : 1)
                        }
                )
        }
    }
}

struct ItemCardView: View {
    let item: AnyItem
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(categoryColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: categoryIcon)
                    .font(.title3)
                    .foregroundColor(categoryColor)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(itemTitle)
                    .font(.playfairDisplay(.semibold, size: 16))
                    .foregroundColor(.primaryBlue)
                    .lineLimit(2)
                
                HStack {
                    Text(categoryName)
                        .font(.playfairDisplay(.regular, size: 14))
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    if let statusText = statusText {
                        Text(statusText)
                            .font(.playfairDisplay(.regular, size: 12))
                            .foregroundColor(.primaryYellow)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(Color.primaryYellow.opacity(0.2))
                            )
                    }
                }
            }
            
            if isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.successGreen)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .shadow(color: Color.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    private var itemTitle: String {
        switch item {
        case .place(let place):
            return place.name
        case .task(let task):
            return task.title
        }
    }
    
    private var categoryName: String {
        switch item {
        case .place(let place):
            return place.category.rawValue
        case .task(let task):
            return task.category.rawValue
        }
    }
    
    private var categoryIcon: String {
        switch item {
        case .place(let place):
            return place.category.icon
        case .task(let task):
            return task.category.icon
        }
    }
    
    private var categoryColor: Color {
        switch item {
        case .place(_):
            return .primaryBlue
        case .task(_):
            return .primaryYellow
        }
    }
    
    private var statusText: String? {
        switch item {
        case .place(let place):
            return place.status.rawValue
        case .task(let task):
            return task.frequency.rawValue
        }
    }
    
    private var isCompleted: Bool {
        switch item {
        case .place(let place):
            return place.isCompleted
        case .task(let task):
            return task.isCompleted
        }
    }
}

enum ItemReference: Hashable {
    case place(UUID)
    case task(UUID)
}

enum AnyItem {
    case place(Place)
    case task(DailyTask)
    
    var id: UUID {
        switch self {
        case .place(let place):
            return place.id
        case .task(let task):
            return task.id
        }
    }
    
    var itemId: ItemReference {
        switch self {
        case .place(let place):
            return .place(place.id)
        case .task(let task):
            return .task(task.id)
        }
    }
}

#Preview {
    NavigationView {
        MyPlacesView(viewModel: AppViewModel())
    }
}
