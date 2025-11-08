import SwiftUI

struct ListsView: View {
    @ObservedObject var viewModel: CollectionViewModel
    @State private var selectedTab = 0
    @State private var showingNewWishlistItem = false
    @State private var showingNewTransaction = false
    
    private let tabs = ["Wishlist", "Trade/Sale", "Transactions"]
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Lists")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        if selectedTab == 0 {
                            showingNewWishlistItem = true
                        } else if selectedTab == 2 {
                            showingNewTransaction = true
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Circle().fill(Color.white.opacity(0.2)))
                    }
                    .opacity(selectedTab == 1 ? 0 : 1)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(0..<tabs.count, id: \.self) { index in
                            TabButton(title: tabs[index], isSelected: selectedTab == index) {
                                selectedTab = index
                            }
                        }
                    }
                }
                .padding(.vertical, 16)
                
                Group {
                    switch selectedTab {
                    case 0:
                        wishlistView
                    case 1:
                        tradeView
                    case 2:
                        transactionsView
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewWishlistItem) {
            NewWishlistItemView(viewModel: viewModel, isPresented: $showingNewWishlistItem)
        }
        .sheet(isPresented: $showingNewTransaction) {
            NewTransactionView(viewModel: viewModel, isPresented: $showingNewTransaction)
        }
        .onReceive(viewModel.$wishlistItems) { _ in
        }
        .onReceive(viewModel.$transactions) { _ in
        }
    }
    
    private var wishlistView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if viewModel.wishlistItems.isEmpty {
                    emptyWishlistView
                } else {
                    ForEach(viewModel.wishlistItems) { item in
                        WishlistItemCard(item: item, viewModel: viewModel)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var tradeView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if viewModel.tradeItems.isEmpty {
                    emptyTradeView
                } else {
                    ForEach(viewModel.tradeItems) { item in
                        TradeItemCard(item: item, viewModel: viewModel)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var transactionsView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if viewModel.transactions.isEmpty {
                    emptyTransactionsView
                } else {
                                    ForEach(viewModel.transactions.sorted(by: { $0.date > $1.date })) { transaction in
                    TransactionCard(transaction: transaction, viewModel: viewModel)
                }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyWishlistView: some View {
        VStack(spacing: 20) {
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            
            Image(systemName: "heart")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.6))
            
            Text("No Wishlist Items")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text("Add items you want to acquire")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Button(action: { showingNewWishlistItem = true }) {
                Text("Add Wishlist Item")
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
    
    private var emptyTradeView: some View {
        VStack(spacing: 20) {
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            
            Image(systemName: "arrow.2.squarepath")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.6))
            
            Text("No Items for Trade")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text("Mark items as 'For Trade' in your collection")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var emptyTransactionsView: some View {
        VStack(spacing: 20) {
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            
            Image(systemName: "doc.text")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.6))
            
            Text("No Transactions")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text("Track your purchases, sales, and trades")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Button(action: { showingNewTransaction = true }) {
                Text("Add Transaction")
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

struct WishlistItemCard: View {
    let item: WishlistItem
    @ObservedObject var viewModel: CollectionViewModel
    @State private var showingCreateItem = false
    @State private var showingDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.cardText)
                    
                    if !item.series.isEmpty {
                        Text(item.series)
                            .font(.callout)
                            .foregroundColor(.cardSecondaryText)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    PriorityBadge(priority: item.priority)
                    
                    if let targetPrice = item.targetPrice {
                        Text("$\(String(format: "%.0f", targetPrice))")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(.accentGreen)
                    }
                }
            }
            
            if !item.notes.isEmpty {
                Text(item.notes)
                    .font(.caption)
                    .foregroundColor(.cardSecondaryText)
                    .lineLimit(2)
            }
            
            HStack {
                Button("View Details") {
                    showingDetail = true
                }
                .font(.callout)
                .foregroundColor(.blue)
                
                Spacer()
                
                Button("Mark Acquired") {
                    showingCreateItem = true
                }
                .font(.callout)
                .foregroundColor(.accentGreen)
                
                Button("Remove") {
                    viewModel.deleteWishlistItem(item)
                }
                .font(.callout)
                .foregroundColor(.red)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardGradient)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .onTapGesture {
            showingDetail = true
        }
        .sheet(isPresented: $showingCreateItem) {
            CreateItemFromWishlistView(
                wishlistItem: item,
                viewModel: viewModel,
                isPresented: $showingCreateItem
            )
        }
        .sheet(isPresented: $showingDetail) {
            WishlistItemDetailView(
                wishlistItem: item,
                viewModel: viewModel,
                isPresented: $showingDetail
            )
        }
    }
}

struct TradeItemCard: View {
    let item: CollectionItem
    @ObservedObject var viewModel: CollectionViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.cardText)
                    
                    Text("\(item.condition) • \(item.category)")
                        .font(.callout)
                        .foregroundColor(.cardSecondaryText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    if let value = item.currentValue {
                        Text("$\(String(format: "%.0f", value))")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.accentGreen)
                    }
                    
                    if !item.storageLocation.isEmpty {
                        Text(item.storageLocation)
                            .font(.caption)
                            .foregroundColor(.cardSecondaryText)
                    }
                }
            }
            
            HStack {
                Button("Remove from Trade") {
                    var updatedItem = item
                    updatedItem.isForTrade = false
                    viewModel.updateItem(updatedItem)
                }
                .font(.callout)
                .foregroundColor(.accentOrange)
                
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

struct TransactionCard: View {
    let transaction: Transaction
    @ObservedObject var viewModel: CollectionViewModel
    @State private var showingDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(transaction.itemName.isEmpty ? "General Transaction" : transaction.itemName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.cardText)
                    
                    Text(transaction.type.rawValue)
                        .font(.callout)
                        .foregroundColor(.cardSecondaryText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(transaction.amount >= 0 ? "+" : "")$\(String(format: "%.0f", transaction.amount))")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(transaction.amount >= 0 ? .accentGreen : .red)
                    
                    Text(DateFormatter.short.string(from: transaction.date))
                        .font(.caption)
                        .foregroundColor(.cardSecondaryText)
                }
            }
            
            if !transaction.counterparty.isEmpty {
                Text("With: \(transaction.counterparty)")
                    .font(.callout)
                    .foregroundColor(.cardSecondaryText)
            }
            
            if !transaction.notes.isEmpty {
                Text(transaction.notes)
                    .font(.caption)
                    .foregroundColor(.cardSecondaryText)
                    .lineLimit(2)
            }
            
            HStack {
                Button("View Details") {
                    showingDetail = true
                }
                .font(.callout)
                .foregroundColor(.blue)
                
                Spacer()
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardGradient)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .onTapGesture {
            showingDetail = true
        }
        .sheet(isPresented: $showingDetail) {
            TransactionDetailView(
                transaction: transaction,
                viewModel: viewModel,
                isPresented: $showingDetail
            )
        }
    }
}

struct PriorityBadge: View {
    let priority: Priority
    
    var body: some View {
        Text(priority.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(priorityColor)
            )
    }
    
    private var priorityColor: Color {
        switch priority {
        case .low:
            return .gray
        case .medium:
            return .accentOrange
        case .high:
            return .red
        }
    }
}

struct NewWishlistItemView: View {
    @ObservedObject var viewModel: CollectionViewModel
    @Binding var isPresented: Bool
    @State private var name = ""
    @State private var series = ""
    @State private var year: Int?
    @State private var targetPrice: Double?
    @State private var priority = Priority.medium
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGradient
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Button("Cancel") {
                            isPresented = false
                        }
                        .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("New Wishlist Item")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button("Save") {
                            let newItem = WishlistItem(
                                name: name,
                                series: series,
                                year: year,
                                targetPrice: targetPrice,
                                priority: priority,
                                notes: notes
                            )
                            viewModel.addWishlistItem(newItem)
                            isPresented = false
                        }
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .disabled(name.isEmpty)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            FormSection(title: "Wishlist Item") {
                                VStack(spacing: 16) {
                                    FormField(label: "Name", text: $name, placeholder: "Item name")
                                    FormField(label: "Series/Edition", text: $series, placeholder: "Series or edition")
                                    
                                    HStack(spacing: 12) {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Year")
                                                .font(.callout)
                                                .foregroundColor(.white.opacity(0.8))
                                            
                                            TextField("Year", value: $year, format: .number)
                                                .foregroundColor(.white)
                                                .foregroundStyle(.white, Color.gray.opacity(0.6))
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 12)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(Color.white.opacity(0.2))
                                                )
                                                .keyboardType(.numberPad)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Target Price")
                                                .font(.callout)
                                                .foregroundColor(.white.opacity(0.8))
                                            
                                            TextField("Price", value: $targetPrice, format: .number)
                                                .foregroundColor(.white)
                                                .foregroundStyle(.white, Color.gray)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 12)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(Color.white.opacity(0.2))
                                                )
                                                .keyboardType(.decimalPad)
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Priority")
                                            .font(.callout)
                                            .foregroundColor(.white.opacity(0.8))
                                        
                                        Menu {
                                            ForEach(Priority.allCases, id: \.self) { p in
                                                Button(p.rawValue) {
                                                    priority = p
                                                }
                                            }
                                        } label: {
                                            HStack {
                                                Text(priority.rawValue)
                                                    .foregroundColor(.white)
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
                                        Text("Notes")
                                            .font(.callout)
                                            .foregroundColor(.white.opacity(0.8))
                                        
                                        TextEditor(text: $notes)
                                            .foregroundColor(.white)
                                            .padding(12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.white.opacity(0.2))
                                            )
                                            .frame(minHeight: 80)
                                            .scrollContentBackground(.hidden)
                                            .colorScheme(.dark)
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct NewTransactionView: View {
    @ObservedObject var viewModel: CollectionViewModel
    @Binding var isPresented: Bool
    @State private var type = TransactionType.purchase
    @State private var itemName = ""
    @State private var amount: Double = 0
    @State private var counterparty = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGradient
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Button("Cancel") {
                            isPresented = false
                        }
                        .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("New Transaction")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button("Save") {
                            let transaction = Transaction(
                                type: type,
                                itemName: itemName,
                                amount: type == .sale ? amount : -amount,
                                counterparty: counterparty,
                                notes: notes
                            )
                            viewModel.addTransaction(transaction)
                            isPresented = false
                        }
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            FormSection(title: "Transaction Details") {
                                VStack(spacing: 16) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Type")
                                            .font(.callout)
                                            .foregroundColor(.white.opacity(0.8))
                                        
                                        Menu {
                                            ForEach(TransactionType.allCases, id: \.self) { t in
                                                Button(t.rawValue) {
                                                    type = t
                                                }
                                            }
                                        } label: {
                                            HStack {
                                                Text(type.rawValue)
                                                    .foregroundColor(.white)
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
                                    
                                    FormField(label: "Item Name", text: $itemName, placeholder: "Item or description")
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Amount")
                                            .font(.callout)
                                            .foregroundColor(.white.opacity(0.8))
                                        
                                        TextField("Amount", value: $amount, format: .number)
                                            .foregroundColor(.white)
                                            .foregroundStyle(.white, Color.gray)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.white.opacity(0.2))
                                            )
                                            .keyboardType(.decimalPad)
                                    }
                                    
                                    FormField(label: "Counterparty", text: $counterparty, placeholder: "Store, person, etc.")
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Notes")
                                            .font(.callout)
                                            .foregroundColor(.white.opacity(0.8))
                                        
                                        TextEditor(text: $notes)
                                            .foregroundColor(.white)
                                            .padding(12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.white.opacity(0.2))
                                            )
                                            .frame(minHeight: 80)
                                            .scrollContentBackground(.hidden)
                                            .colorScheme(.dark)
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CreateItemFromWishlistView: View {
    let wishlistItem: WishlistItem
    @ObservedObject var viewModel: CollectionViewModel
    @Binding var isPresented: Bool
    
    @State private var name: String
    @State private var category: String
    @State private var series: String
    @State private var year: Int?
    @State private var purchasePrice: Double?
    @State private var notes: String
    @State private var removeFromWishlist = false
    
    init(wishlistItem: WishlistItem, viewModel: CollectionViewModel, isPresented: Binding<Bool>) {
        self.wishlistItem = wishlistItem
        self.viewModel = viewModel
        self._isPresented = isPresented
        
        self._name = State(initialValue: wishlistItem.name)
        self._category = State(initialValue: "Other")
        self._series = State(initialValue: wishlistItem.series)
        self._year = State(initialValue: wishlistItem.year)
        self._purchasePrice = State(initialValue: wishlistItem.targetPrice)
        self._notes = State(initialValue: "Created from wishlist: \(wishlistItem.notes)")
    }
    
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
                        
                        Text("Update Wishlist Item")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button("Update") {
                            updateWishlistItem()
                        }
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .disabled(name.isEmpty)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            FormSection(title: "Item Information") {
                                VStack(spacing: 16) {
                                    FormField(label: "Name", text: $name, placeholder: "Item name")
                                    
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
                                                Text(category)
                                                    .foregroundColor(.white)
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
                                    
                                    FormField(label: "Series/Edition", text: $series, placeholder: "Series or edition")
                                    
                                    HStack(spacing: 12) {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Year")
                                                .font(.callout)
                                                .foregroundColor(.white.opacity(0.8))
                                            
                                            TextField("Year", value: $year, format: .number)
                                                .foregroundColor(.white)
                                                .foregroundStyle(.white, Color.gray.opacity(0.6))
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 12)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(Color.white.opacity(0.2))
                                                )
                                                .keyboardType(.numberPad)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Purchase Price")
                                                .font(.callout)
                                                .foregroundColor(.white.opacity(0.8))
                                            
                                            TextField("Price", value: $purchasePrice, format: .number)
                                                .foregroundColor(.white)
                                                .foregroundStyle(.white, Color.gray.opacity(0.6))
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 12)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(Color.white.opacity(0.2))
                                                )
                                                .keyboardType(.decimalPad)
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Notes")
                                            .font(.callout)
                                            .foregroundColor(.white.opacity(0.8))
                                        
                                        TextEditor(text: $notes)
                                            .foregroundColor(.white)
                                            .padding(12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.white.opacity(0.2))
                                            )
                                            .frame(minHeight: 80)
                                            .scrollContentBackground(.hidden)
                                            .colorScheme(.dark)
                                    }
                                    
                                    HStack {
                                        Text("Remove from Wishlist after update")
                                            .font(.callout)
                                            .foregroundColor(.white.opacity(0.8))
                                        
                                        Spacer()
                                        
                                        Toggle("", isOn: $removeFromWishlist)
                                            .toggleStyle(SwitchToggleStyle(tint: .accentGreen))
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.1))
                                    )
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func updateWishlistItem() {
        var updatedWishlistItem = wishlistItem
        updatedWishlistItem.name = name
        updatedWishlistItem.series = series
        updatedWishlistItem.year = year
        updatedWishlistItem.targetPrice = purchasePrice
        updatedWishlistItem.notes = notes
        
        viewModel.updateWishlistItem(updatedWishlistItem)
        
        if removeFromWishlist {
            viewModel.deleteWishlistItem(wishlistItem)
        }
        
        isPresented = false
    }
}

#Preview {
    ListsView(viewModel: CollectionViewModel())
}
