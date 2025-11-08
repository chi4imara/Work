import SwiftUI

struct ItemDetailView: View {
    @ObservedObject var viewModel: CollectionViewModel
    @State var item: CollectionItem
    @Binding var isPresented: Bool
    @State private var isEditing = false
    @State private var showingDeleteAlert = false
    
    private var isNewItem: Bool {
        !viewModel.items.contains { $0.id == item.id }
    }
    
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
                        
                        Text(isNewItem ? "Add Item" : item.name)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        HStack {
                            if !isNewItem && !isEditing {
                                Button("Edit") {
                                    isEditing = true
                                }
                                .foregroundColor(.white)
                            }
                            
                            if isEditing || isNewItem {
                                Button("Save") {
                                    saveItem()
                                }
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            if isEditing || isNewItem {
                                editingView
                            } else {
                                viewingView
                            }
                        }
                        .padding(20)
                        .padding(.bottom, 100)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .alert("Delete Item", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteItem(item)
                isPresented = false
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this item? This action cannot be undone.")
        }
        .onAppear {
            if isNewItem {
                isEditing = true
            }
        }
    }
    
    private var viewingView: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.cardText)
                        
                        if !item.series.isEmpty {
                            Text(item.series)
                                .font(.headline)
                                .foregroundColor(.cardSecondaryText)
                        }
                    }
                    
                    Spacer()
                    
                    if let value = item.currentValue {
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("$\(String(format: "%.0f", value))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.accentGreen)
                            
                            if let profit = item.profitLoss {
                                Text("\(profit >= 0 ? "+" : "")$\(String(format: "%.0f", profit))")
                                    .font(.callout)
                                    .foregroundColor(profit >= 0 ? .accentGreen : .red)
                            }
                        }
                    }
                }
                
                HStack {
                    PropertyTag(text: item.condition, color: .accentOrange)
                    PropertyTag(text: item.category, color: .accentPurple)
                    if item.quantity > 1 {
                        PropertyTag(text: "Qty: \(item.quantity)", color: .lightBlue)
                    }
                    Spacer()
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardGradient)
            )
            
            if !item.manufacturer.isEmpty || !item.country.isEmpty || item.year != nil {
                DetailSection(title: "Basic Info") {
                    VStack(spacing: 12) {
                        if !item.manufacturer.isEmpty {
                            DetailRow(label: "Manufacturer", value: item.manufacturer)
                        }
                        if !item.country.isEmpty {
                            DetailRow(label: "Country", value: item.country)
                        }
                        if let year = item.year {
                            DetailRow(label: "Year", value: String(year))
                        }
                        if !item.number.isEmpty {
                            DetailRow(label: "Number/Article", value: item.number)
                        }
                    }
                }
            }
            
            if item.purchasePrice != nil || item.currentValue != nil {
                DetailSection(title: "Financial") {
                    VStack(spacing: 12) {
                        if let purchasePrice = item.purchasePrice {
                            DetailRow(label: "Purchase Price", value: "$\(String(format: "%.0f", purchasePrice))")
                        }
                        if let purchaseDate = item.purchaseDate {
                            DetailRow(label: "Purchase Date", value: DateFormatter.short.string(from: purchaseDate))
                        }
                        if !item.purchaseSource.isEmpty {
                            DetailRow(label: "Source", value: item.purchaseSource)
                        }
                        if let currentValue = item.currentValue {
                            DetailRow(label: "Current Value", value: "$\(String(format: "%.0f", currentValue))")
                        }
                    }
                }
            }
            
            DetailSection(title: "Storage & Status") {
                VStack(spacing: 12) {
                    if !item.storageLocation.isEmpty {
                        DetailRow(label: "Location", value: item.storageLocation)
                    }
                    
                    HStack {
                        Text("Status")
                            .font(.callout)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            if item.isForTrade {
                                Badge(text: "For Trade", color: .accentPurple)
                            }
                            if item.needsVerification {
                                Badge(text: "Needs Check", color: .accentOrange)
                            }
                            if item.isExclusive {
                                Badge(text: "Exclusive", color: .accentGreen)
                            }
                        }
                    }
                }
            }
            
            if !item.notes.isEmpty {
                DetailSection(title: "Notes") {
                    Text(item.notes)
                        .font(.body)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            VStack(spacing: 12) {
                Button(action: { showingDeleteAlert = true }) {
                    Text("Delete Item")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.red)
                        )
                }
            }
        }
    }
    
    private var editingView: some View {
        VStack(spacing: 24) {
            FormSection(title: "Basic Information") {
                VStack(spacing: 16) {
                    FormField(label: "Name", text: $item.name, placeholder: "Item name")
                    
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Menu {
                                ForEach(viewModel.categories, id: \.self) { category in
                                    Button(category) {
                                        item.category = category
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(item.category.isEmpty ? "Select category" : item.category)
                                        .foregroundColor(item.category.isEmpty ? .white.opacity(0.6) : .white)
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
                            Text("Condition")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Menu {
                                ForEach(viewModel.conditions, id: \.self) { condition in
                                    Button(condition) {
                                        item.condition = condition
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(item.condition)
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
                    }
                    
                    FormField(label: "Series/Edition", text: $item.series, placeholder: "Series or edition")
                    FormField(label: "Number/Article", text: $item.number, placeholder: "Number or article")
                    
                    HStack(spacing: 12) {
                        FormField(label: "Manufacturer", text: $item.manufacturer, placeholder: "Manufacturer")
                        FormField(label: "Country", text: $item.country, placeholder: "Country")
                    }
                    
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Year")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.8))
                            
                            TextField("Year", value: $item.year, format: .number)
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
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Quantity")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.8))
                            
                            TextField("Quantity", value: $item.quantity, format: .number)
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
            }
            
            FormSection(title: "Financial Information") {
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Purchase Price")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.8))
                            
                            TextField("0", value: $item.purchasePrice, format: .number)
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
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Current Value")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.8))
                            
                            TextField("0", value: $item.currentValue, format: .number)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.2))
                                )
                                .keyboardType(.decimalPad)
                        }
                    }
                    
                    FormField(label: "Purchase Source", text: $item.purchaseSource, placeholder: "Store, market, etc.")
                }
            }
            
            FormSection(title: "Storage & Status") {
                VStack(spacing: 16) {
                    FormField(label: "Storage Location", text: $item.storageLocation, placeholder: "Room/Shelf/Box")
                    
                    VStack(spacing: 12) {
                        Toggle("For Trade/Sale", isOn: $item.isForTrade)
                            .foregroundColor(.white)
                        
                        Toggle("Needs Verification", isOn: $item.needsVerification)
                            .foregroundColor(.white)
                        
                        Toggle("Exclusive/Limited", isOn: $item.isExclusive)
                            .foregroundColor(.white)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .accentGreen))
                }
            }
            
            FormSection(title: "Notes") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Additional Notes")
                        .font(.callout)
                        .foregroundColor(.white.opacity(0.8))
                    
                    TextEditor(text: $item.notes)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.2))
                        )
                        .frame(minHeight: 100)
                        .scrollContentBackground(.hidden)
                        .colorScheme(.dark)
                }
            }
        }
    }
    
    private func saveItem() {
        if isNewItem {
            viewModel.addItem(item)
        } else {
            viewModel.updateItem(item)
        }
        isPresented = false
    }
}

struct DetailSection<Content: View>: View {
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

struct FormSection<Content: View>: View {
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

struct DetailRow: View {
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

struct FormField: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.callout)
                .foregroundColor(.white.opacity(0.8))
            
            TextField(placeholder, text: $text)
                .foregroundColor(.white)
                .foregroundStyle(.white, Color.gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.2))
                )
        }
    }
}

extension DateFormatter {
    static let short: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

#Preview {
    ItemDetailView(
        viewModel: CollectionViewModel(),
        item: CollectionItem(name: "Sample Item", category: "Figures"),
        isPresented: .constant(true)
    )
}
