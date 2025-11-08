import SwiftUI

struct SetsView: View {
    @ObservedObject var viewModel: CollectionViewModel
    @State private var selectedTab = 0
    @State private var showingNewSet = false
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Sets & Statistics")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                HStack(spacing: 0) {
                    TabButton(title: "Sets", isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }
                    
                    TabButton(title: "Statistics", isSelected: selectedTab == 1) {
                        selectedTab = 1
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                if selectedTab == 0 {
                    setsView
                } else {
                    statisticsView
                }
            }
        }
        .sheet(isPresented: $showingNewSet) {
            NewSetView(viewModel: viewModel, isPresented: $showingNewSet)
        }
    }
    
    private var setsView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if viewModel.sets.isEmpty {
                    emptySetView
                } else {
                    ForEach(viewModel.sets) { set in
                        SetCard(set: set)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var statisticsView: some View {
        ScrollView {
            VStack(spacing: 24) {
                StatisticsCard(title: "Collection Summary") {
                    VStack(spacing: 16) {
                        StatRow(label: "Total Items", value: "\(viewModel.statistics.totalItems)")
                        StatRow(label: "Total Value", value: "$\(String(format: "%.0f", viewModel.statistics.totalValue))")
                        StatRow(label: "Purchase Cost", value: "$\(String(format: "%.0f", viewModel.statistics.totalPurchasePrice))")
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        HStack {
                            Text("Profit/Loss")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Spacer()
                            
                            Text("\(viewModel.statistics.profitLoss >= 0 ? "+" : "")$\(String(format: "%.0f", viewModel.statistics.profitLoss))")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(viewModel.statistics.profitLoss >= 0 ? .accentGreen : .red)
                        }
                        
                        StatRow(label: "Average Value", value: "$\(String(format: "%.0f", viewModel.statistics.averageValue))")
                        StatRow(label: "Duplicates", value: "\(viewModel.statistics.duplicatesCount)")
                    }
                }
                
                if !viewModel.statistics.categoryCounts.isEmpty {
                    StatisticsCard(title: "Categories") {
                        VStack(spacing: 12) {
                            ForEach(Array(viewModel.statistics.categoryCounts.sorted(by: { $0.value > $1.value })), id: \.key) { category, count in
                                HStack {
                                    Text(category)
                                        .font(.callout)
                                        .foregroundColor(.white.opacity(0.8))
                                    
                                    Spacer()
                                    
                                    Text("\(count)")
                                        .font(.callout)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                    
                                    ProgressView(value: Double(count), total: Double(viewModel.statistics.totalItems))
                                        .progressViewStyle(LinearProgressViewStyle(tint: .accentGreen))
                                        .frame(width: 60)
                                }
                            }
                        }
                    }
                }
                
                if !viewModel.items.isEmpty {
                    StatisticsCard(title: "Recent Activity") {
                        VStack(spacing: 12) {
                            ForEach(Array(viewModel.items.sorted(by: { $0.dateAdded > $1.dateAdded }).prefix(5))) { item in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(item.name)
                                            .font(.callout)
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                        
                                        Text("Added \(RelativeDateTimeFormatter().localizedString(for: item.dateAdded, relativeTo: Date()))")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                    
                                    Spacer()
                                    
                                    if let value = item.currentValue {
                                        Text("$\(String(format: "%.0f", value))")
                                            .font(.callout)
                                            .fontWeight(.medium)
                                            .foregroundColor(.accentGreen)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptySetView: some View {
        VStack(spacing: 20) {
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.6))
            
            Text("No Sets Created")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text("Create sets to organize your collection items")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Button(action: { showingNewSet = true }) {
                Text("Create Set")
                    .font(.headline)
                    .foregroundColor(.primaryBlue)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .primaryBlue : .white.opacity(0.7))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.white : Color.clear)
                )
                .padding(.horizontal,10)
        }
    }
}

struct SetCard: View {
    let set: CollectionSet
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(set.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.cardText)
                    
                    Text(set.category)
                        .font(.callout)
                        .foregroundColor(.cardSecondaryText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(set.completedItems)/\(set.totalItems)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.accentGreen)
                    
                    Text("\(String(format: "%.0f", set.completionPercentage))%")
                        .font(.callout)
                        .foregroundColor(.cardSecondaryText)
                }
            }
            
            ProgressView(value: set.completionPercentage, total: 100)
                .progressViewStyle(LinearProgressViewStyle(tint: .accentGreen))
            
            HStack {
                if set.isComplete {
                    Badge(text: "Complete", color: .accentGreen)
                } else {
                    Badge(text: "In Progress", color: .accentOrange)
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardGradient)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

struct StatisticsCard<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            content
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
        )
    }
}

struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.callout)
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
    }
}

struct NewSetView: View {
    @ObservedObject var viewModel: CollectionViewModel
    @Binding var isPresented: Bool
    @State private var name = ""
    @State private var category = ""
    @State private var totalItems = 1
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGradient
                    .ignoresSafeArea()
    
                VStack(spacing: 24) {
                    HStack {
                        Button("Cancel") {
                            isPresented = false
                        }
                        .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("New Set")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button("Save") {
                            let newSet = CollectionSet(name: name, category: category, totalItems: totalItems)
                            viewModel.addSet(newSet)
                            isPresented = false
                        }
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .disabled(name.isEmpty || category.isEmpty)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    
                    FormSection(title: "Set Information") {
                        VStack(spacing: 16) {
                            FormField(label: "Set Name", text: $name, placeholder: "Enter set name")
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Category")
                                    .font(.callout)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Menu {
                                    ForEach(viewModel.categories, id: \.self) { cat in
                                        Button(cat) {
                                            category = cat
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(category.isEmpty ? "Select category" : category)
                                            .foregroundColor(category.isEmpty ? .white.opacity(0.6) : .white)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.2))
                                    )
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Total Items")
                                    .font(.callout)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                TextField("Total items in set", value: $totalItems, format: .number)
                                    .foregroundColor(.white)
                                    .foregroundStyle(.white, Color.gray)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.2))
                                    )
                                    .keyboardType(.numberPad)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SetsView(viewModel: CollectionViewModel())
}
