import SwiftUI

struct WishlistItemDetailView: View {
    let item: WishlistItem
    @ObservedObject var viewModel: CollectionViewModel
    @Binding var isPresented: Bool
    @State private var isEditing = false
    @State private var showingDeleteAlert = false
    @State private var showingCreateItem = false
    
    @State private var name: String
    @State private var series: String
    @State private var year: Int?
    @State private var targetPrice: Double?
    @State private var priority: Priority
    @State private var notes: String
    
    init(wishlistItem: WishlistItem, viewModel: CollectionViewModel, isPresented: Binding<Bool>) {
        self.item = wishlistItem
        self.viewModel = viewModel
        self._isPresented = isPresented
        
        self._name = State(initialValue: wishlistItem.name)
        self._series = State(initialValue: wishlistItem.series)
        self._year = State(initialValue: wishlistItem.year)
        self._targetPrice = State(initialValue: wishlistItem.targetPrice)
        self._priority = State(initialValue: wishlistItem.priority)
        self._notes = State(initialValue: wishlistItem.notes)
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
                        
                        Text(isEditing ? "Edit Wishlist Item" : "Wishlist Item")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        HStack {
                            if !isEditing {
                                Button("Edit") {
                                    isEditing = true
                                }
                                .foregroundColor(.white)
                            } else {
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
                            if isEditing {
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
        .alert("Delete Wishlist Item", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteWishlistItem(item)
                isPresented = false
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this wishlist item? This action cannot be undone.")
        }
        .sheet(isPresented: $showingCreateItem) {
            CreateItemFromWishlistView(
                wishlistItem: item,
                viewModel: viewModel,
                isPresented: $showingCreateItem
            )
        }
    }
    
    private var viewingView: some View {
        VStack(spacing: 24) {
            FormSection(title: "Item Information") {
                VStack(spacing: 16) {
                    DetailRow(label: "Name", value: item.name)
                    DetailRow(label: "Series/Edition", value: item.series.isEmpty ? "Not specified" : item.series)
                    DetailRow(label: "Year", value: item.year?.description ?? "Not specified")
                    DetailRow(label: "Target Price", value: item.targetPrice != nil ? "$\(String(format: "%.0f", item.targetPrice!))" : "Not specified")
                    DetailRow(label: "Priority", value: item.priority.rawValue)
                    DetailRow(label: "Date Added", value: DateFormatter.short.string(from: item.dateAdded))
                }
            }
            
            if !item.notes.isEmpty {
                FormSection(title: "Notes") {
                    Text(item.notes)
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            FormSection(title: "Actions") {
                VStack(spacing: 16) {
                    Button("Mark as Acquired") {
                        showingCreateItem = true
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.accentGreen)
                    )
                    
                    Button("Delete Item") {
                        showingDeleteAlert = true
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.red)
                    )
                }
            }
        }
    }
    
    private var editingView: some View {
        VStack(spacing: 24) {
            FormSection(title: "Item Information") {
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
        }
    }
    
    private func saveItem() {
        var updatedItem = item
        updatedItem.name = name
        updatedItem.series = series
        updatedItem.year = year
        updatedItem.targetPrice = targetPrice
        updatedItem.priority = priority
        updatedItem.notes = notes
        
        print("Saving wishlist item: \(updatedItem.name), series: \(updatedItem.series), year: \(updatedItem.year ?? 0), price: \(updatedItem.targetPrice ?? 0), priority: \(updatedItem.priority.rawValue), notes: \(updatedItem.notes)")
        
        viewModel.updateWishlistItem(updatedItem)
        
        isEditing = false
    }
}

#Preview {
    WishlistItemDetailView(
        wishlistItem: WishlistItem(name: "Sample Item", series: "Series 1", priority: .high),
        viewModel: CollectionViewModel(),
        isPresented: .constant(true)
    )
}
