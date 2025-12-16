import SwiftUI

struct GiftsListView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingFilters = false
    @State private var showingAddGift = false
    @State private var selectedCategories: Set<UUID> = []
    @State private var selectedStatus: Gift.GiftStatus? = nil
    @State private var searchText = ""
    
    @Binding var selectedTab: Int
    
    private var filteredGifts: [Gift] {
        var gifts = dataManager.gifts
        
        if !selectedCategories.isEmpty {
            gifts = gifts.filter { selectedCategories.contains($0.categoryId) }
        }
        
        if let status = selectedStatus {
            gifts = gifts.filter { $0.status == status }
        }
        
        if !searchText.isEmpty {
            gifts = gifts.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.person.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return gifts.sorted { $0.createdAt > $1.createdAt }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("My Gifts")
                            .font(.appTitle(28))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        HStack {
                            Button(action: {
                                withAnimation {
                                    selectedTab = 3
                                }
                            }) {
                                Image(systemName: "plus")
                                    .font(.appTitle(28))
                                    .foregroundColor(AppColors.primaryText)
                            }
                            
                            Button(action: { showingFilters = true }) {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                    .font(.appTitle(28))
                                    .foregroundColor(AppColors.primaryText)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    SearchBar(text: $searchText)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    
                    if filteredGifts.isEmpty {
                        EmptyStateView(
                            icon: "gift",
                            title: dataManager.gifts.isEmpty ? "No Gifts Yet" : "No Results Found",
                            subtitle: dataManager.gifts.isEmpty ?
                            "Add your first gift idea to get started" :
                                "Try adjusting your search or filters",
                            buttonTitle: dataManager.gifts.isEmpty ? "Add First Gift" : "Clear Filters",
                            buttonAction: {
                                if dataManager.gifts.isEmpty {
                                    withAnimation {
                                        selectedTab = 3
                                    }
                                } else {
                                    clearFilters()
                                }
                            }
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredGifts) { gift in
                                    NavigationLink(destination: GiftDetailView(gift: gift)) {
                                        GiftCardView(gift: gift)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingFilters) {
            FiltersView(
                selectedCategories: $selectedCategories,
                selectedStatus: $selectedStatus,
                isPresented: $showingFilters
            )
        }
        .sheet(isPresented: $showingAddGift) {
            AddEditGiftView(isPresented: $showingAddGift)
        }
    }
    
    private func clearFilters() {
        selectedCategories.removeAll()
        selectedStatus = nil
        searchText = ""
    }
}

struct GiftCardView: View {
    let gift: Gift
    @EnvironmentObject var dataManager: DataManager
    @State private var showingDeleteAlert = false
    @State private var showingEditSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(gift.title)
                        .font(.appHeadline(18))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(2)
                    
                    if !gift.person.isEmpty {
                        Text("For: \(gift.person)")
                            .font(.appBody(14))
                            .foregroundColor(AppColors.secondaryText.opacity(0.7))
                    }
                }
                
                Spacer()
                
                Text(gift.status.displayName)
                    .font(.appCaption(12))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(gift.status == .planned ? AppColors.plannedStatus : AppColors.boughtStatus)
                    .cornerRadius(12)
            }
            
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: dataManager.getCategoryIcon(for: gift.categoryId))
                        .foregroundColor(AppColors.primaryPurple)
                        .font(.system(size: 14))
                    
                    Text(dataManager.getCategoryName(for: gift.categoryId))
                        .font(.appCaption(14))
                        .foregroundColor(AppColors.secondaryText.opacity(0.8))
                }
                
                Spacer()
                
                Text(DateFormatter.shortDate.string(from: gift.createdAt))
                    .font(.appCaption(12))
                    .foregroundColor(AppColors.secondaryText.opacity(0.6))
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .swipeActions(edge: .trailing) {
            Button("Delete") {
                showingDeleteAlert = true
            }
            .tint(AppColors.deleteRed)
        }
        .swipeActions(edge: .leading) {
            Button("Edit") {
                showingEditSheet = true
            }
            .tint(AppColors.editBlue)
        }
        .alert("Delete Gift?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                dataManager.deleteGift(gift)
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone.")
        }
        .sheet(isPresented: $showingEditSheet) {
            AddEditGiftView(gift: gift, isPresented: $showingEditSheet)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.secondaryText.opacity(0.6))
            
            TextField("Search gifts...", text: $text)
                .font(.appBody(16))
                .foregroundColor(AppColors.secondaryText)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.secondaryText.opacity(0.6))
                }
            }
        }
        .padding(12)
        .background(AppColors.cardBackground)
        .cornerRadius(10)
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    let buttonTitle: String
    let buttonAction: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryText.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.appTitle(24))
                    .foregroundColor(AppColors.primaryText)
                
                Text(subtitle)
                    .font(.appBody(16))
                    .foregroundColor(AppColors.primaryText.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            Button(action: buttonAction) {
                Text(buttonTitle)
                    .font(.appHeadline(16))
                    .foregroundColor(AppColors.primaryBlue)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppColors.primaryText)
                    .cornerRadius(20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}
