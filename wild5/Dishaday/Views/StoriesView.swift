import SwiftUI

struct StoriesView: View {
    @EnvironmentObject var itemStore: ItemStore
    @State private var showingAddItem = false
    @State private var selectedItemId: UUID?
    @State private var showingItemDetail = false
    
    private var itemsWithStories: [Item] {
        itemStore.itemsWithStories
    }
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
            VStack(spacing: 0) {
                HeaderView()
                
                if itemsWithStories.isEmpty {
                    EmptyStateView()
                } else {
                    StoriesListView()
                }
            }
        }
        .sheet(isPresented: $showingAddItem) {
            AddEditItemView(item: nil)
                .environmentObject(itemStore)
        }
        .sheet(isPresented: $showingItemDetail, onDismiss: {
            selectedItemId = nil
        }) {
            if let itemId = selectedItemId {
                NavigationView {
                    ItemDetailView(itemId: itemId)
                        .environmentObject(itemStore)
                }
            }
        }
        .onChange(of: selectedItemId) { newValue in
            showingItemDetail = newValue != nil
        }
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack {
            Text("Stories")
                .font(.playfairTitleLarge(28))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            if !itemsWithStories.isEmpty {
                Button(action: { showingAddItem = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.buttonText)
                        .frame(width: 40, height: 40)
                        .background(Color.buttonPrimary)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    @ViewBuilder
    private func EmptyStateView() -> some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "book")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(.textSecondary)
                
                VStack(spacing: 12) {
                    Text("No Stories Yet")
                        .font(.playfairHeading(24))
                        .foregroundColor(.textPrimary)
                    
                    Text("You haven't added any item descriptions yet.\nStart adding stories to your items.")
                        .font(.playfairBody(16))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                }
            }
            
            Button(action: { showingAddItem = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Add Item")
                        .font(.playfairHeading(18))
                }
                .foregroundColor(.buttonText)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.buttonPrimary)
                .cornerRadius(28)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func StoriesListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(itemsWithStories) { item in
                    StoryCardView(item: item) {
                        selectedItemId = item.id
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }
}

struct StoryCardView: View {
    let item: Item
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.playfairHeading(20))
                        .foregroundColor(.textPrimary)
                        .lineLimit(2)
                    
                    HStack(spacing: 8) {
                        Text(item.category)
                            .font(.playfairCaptionMedium(14))
                            .foregroundColor(.primaryYellow)
                        
                        if let datePeriod = item.datePeriod, !datePeriod.isEmpty {
                            Text("•")
                                .font(.playfairCaption(14))
                                .foregroundColor(.textTertiary)
                            
                            Text(datePeriod)
                                .font(.playfairCaption(14))
                                .foregroundColor(.textTertiary)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textTertiary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "quote.opening")
                        .font(.system(size: 14))
                        .foregroundColor(.accentPurple)
                    
                    Text("Story")
                        .font(.playfairCaptionMedium(14))
                        .foregroundColor(.textTertiary)
                    
                    Spacer()
                }
                
                Text(item.storyThreeLines)
                    .font(.playfairBodyItalic(16))
                    .foregroundColor(.textSecondary)
                    .lineLimit(3)
                    .lineSpacing(3)
                
                if item.story.components(separatedBy: .newlines).count > 3 {
                    HStack {
                        Spacer()
                        Text("Read more...")
                            .font(.playfairCaptionMedium(14))
                            .foregroundColor(.primaryYellow)
                    }
                }
            }
            
            HStack {
                Text("Added \(DateFormatter.displayDate.string(from: item.dateAdded))")
                    .font(.playfairSmall(12))
                    .foregroundColor(.textTertiary)
                
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
        .onTapGesture {
            onTap()
        }
    }
}

struct StoryDetailView: View {
    let item: Item
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(item.name)
                            .font(.playfairTitleLarge(32))
                            .foregroundColor(.textPrimary)
                            .lineLimit(nil)
                        
                        HStack {
                            Text(item.category)
                                .font(.playfairHeadingMedium(16))
                                .foregroundColor(.primaryYellow)
                            
                            if let datePeriod = item.datePeriod, !datePeriod.isEmpty {
                                Text("•")
                                    .font(.playfairBody(16))
                                    .foregroundColor(.textTertiary)
                                
                                Text(datePeriod)
                                    .font(.playfairBody(16))
                                    .foregroundColor(.textSecondary)
                            }
                        }
                    }
                    
                    Divider()
                        .background(Color.cardBorder)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "book.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.accentPurple)
                            
                            Text("The Story")
                                .font(.playfairHeading(22))
                                .foregroundColor(.textPrimary)
                            
                            Spacer()
                        }
                        
                        Text(item.story)
                            .font(.playfairBodyItalic(18))
                            .foregroundColor(.textSecondary)
                            .lineSpacing(6)
                            .lineLimit(nil)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Divider()
                            .background(Color.cardBorder)
                        
                        Text("Added to catalog on \(DateFormatter.displayDateTime.string(from: item.dateAdded))")
                            .font(.playfairCaption(14))
                            .foregroundColor(.textTertiary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
        .navigationTitle("Story")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(.textSecondary)
            }
        }
    }
}

#Preview {
    StoriesView()
        .environmentObject(ItemStore())
}
