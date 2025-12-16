import SwiftUI

struct ItemDetailView: View {
    @EnvironmentObject var itemStore: ItemStore
    @Environment(\.dismiss) private var dismiss
    
    let itemId: UUID
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var showingActionDialog = false
    
    private var item: Item? {
        itemStore.items.first { $0.id == itemId }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
            if let item = item {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        HeaderCard(item: item)
                        
                        DetailsSection(item: item)
                        
                        StoryCard(item: item)
                        
                        DatesCard(item: item)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            } else {
                VStack {
                    Text("Item not found")
                        .font(.playfairHeading(20))
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .navigationTitle(item?.name ?? "Item")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if let item = item {
                    Button(action: { showingActionDialog = true }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.textSecondary)
                    }
                    .confirmationDialog("Item Actions", isPresented: $showingActionDialog) {
                        Button("Edit") {
                            showingEditSheet = true
                        }
                        Button("Delete", role: .destructive) {
                            showingDeleteAlert = true
                        }
                        Button("Cancel", role: .cancel) { }
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingEditSheet) {
            if let item = item {
                AddEditItemView(item: item)
                    .environmentObject(itemStore)
            }
        }
        .alert("Delete Item", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let item = item {
                    itemStore.deleteItem(item)
                    dismiss()
                }
            }
        } message: {
            if let item = item {
                Text("Are you sure you want to delete \"\(item.name)\"? This action cannot be undone.")
            }
        }
    }
    
    @ViewBuilder
    private func HeaderCard(item: Item) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.name)
                        .font(.playfairTitleLarge(28))
                        .foregroundColor(.textPrimary)
                        .lineLimit(nil)
                    
                    HStack {
                        Image(systemName: "tag.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.primaryYellow)
                        
                        Text(item.category)
                            .font(.playfairHeadingMedium(16))
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.cardBorder, lineWidth: 1)
                )
        )
    }
    
    @ViewBuilder
    private func DetailsSection(item: Item) -> some View {
        VStack(spacing: 16) {
            HStack {
                Text("Details")
                    .font(.playfairHeading(22))
                    .foregroundColor(.textPrimary)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                DetailRow(
                    icon: "archivebox.fill",
                    title: "Category",
                    value: item.category
                )
                
                if let datePeriod = item.datePeriod, !datePeriod.isEmpty {
                    DetailRow(
                        icon: "calendar",
                        title: "Date/Period",
                        value: datePeriod
                    )
                }
                
                DetailRow(
                    icon: "clock.fill",
                    title: "Added",
                    value: DateFormatter.displayDateTime.string(from: item.dateAdded)
                )
            }
        }
    }
    
    @ViewBuilder
    private func StoryCard(item: Item) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "book.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.primaryYellow)
                
                Text("Story")
                    .font(.playfairHeading(20))
                    .foregroundColor(.textPrimary)
                
                Spacer()
            }
            
            Text(item.story)
                .font(.playfairBody(16))
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
                .lineLimit(nil)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.cardBorder, lineWidth: 1)
                )
        )
    }
    
    @ViewBuilder
    private func DatesCard(item: Item) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "calendar")
                    .font(.system(size: 18))
                    .foregroundColor(.primaryYellow)
                
                Text("Timeline")
                    .font(.playfairHeading(20))
                    .foregroundColor(.textPrimary)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                if let datePeriod = item.datePeriod, !datePeriod.isEmpty {
                    TimelineRow(
                        title: "Item Period",
                        value: datePeriod,
                        icon: "clock.arrow.circlepath"
                    )
                }
                
                TimelineRow(
                    title: "Added to Catalog",
                    value: DateFormatter.displayDateTime.string(from: item.dateAdded),
                    icon: "plus.circle.fill"
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.primaryYellow)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.playfairCaptionMedium(14))
                    .foregroundColor(.textTertiary)
                
                Text(value)
                    .font(.playfairBody(16))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct TimelineRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.accentGreen)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.playfairCaptionMedium(14))
                    .foregroundColor(.textTertiary)
                
                Text(value)
                    .font(.playfairBody(15))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

extension DateFormatter {
    static let displayDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
    let store = ItemStore()
    let previewItem = Item(
        name: "Grandfather's Watch",
        category: "Watches",
        story: "This beautiful pocket watch belonged to my grandfather. He received it as a wedding gift in 1952 and carried it with him every day until he passed away. The watch still keeps perfect time and has intricate engravings on the back case.",
        datePeriod: "1950s"
    )
    store.addItem(previewItem)
    
    return NavigationView {
        ItemDetailView(itemId: previewItem.id)
            .environmentObject(store)
    }
}
