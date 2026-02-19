import SwiftUI

struct OutfitsView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingAddOutfit = false
    @State private var searchText = ""
    
    private var filteredOutfits: [Outfit] {
        if searchText.isEmpty {
            return appState.outfits
        } else {
            return appState.outfits.filter { outfit in
                outfit.name.localizedCaseInsensitiveContains(searchText) ||
                outfit.notes.localizedCaseInsensitiveContains(searchText) ||
                outfit.items.contains { $0.name.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HeaderView()
                
                SearchBarView()
                
                if filteredOutfits.isEmpty {
                    EmptyStateView()
                } else {
                    OutfitsGridView()
                }
            }
        }
        .sheet(isPresented: $showingAddOutfit) {
            AddOutfitView()
                .environmentObject(appState)
        }
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Outfits")
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(appState.outfits.count) outfits created")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Button(action: { showingAddOutfit = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(AppColors.yellow)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    @ViewBuilder
    private func SearchBarView() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.secondaryText)
            
            TextField("Search outfits...", text: $searchText)
                .font(.ubuntu(16))
                .foregroundColor(AppColors.primaryText)
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    @ViewBuilder
    private func OutfitsGridView() -> some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 1), spacing: 16) {
                ForEach(filteredOutfits) { outfit in
                    OutfitDetailCard(outfitId: outfit.id)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    @ViewBuilder
    private func EmptyStateView() -> some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: searchText.isEmpty ? "person" : "magnifyingglass")
                    .font(.system(size: 64))
                    .foregroundColor(AppColors.secondaryText)
                
                VStack(spacing: 8) {
                    Text(searchText.isEmpty ? "No Outfits Yet" : "No Results Found")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(searchText.isEmpty ? 
                         "Create your first outfit combination" :
                         "Try adjusting your search terms")
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                }
                
                if searchText.isEmpty {
                    Button("Create First Outfit") {
                        showingAddOutfit = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            .padding(40)
            
            Spacer()
        }
    }
}

struct OutfitDetailCard: View {
    let outfitId: UUID
    @EnvironmentObject var appState: AppState
    @State private var showingDetail = false
    
    private var outfit: Outfit? {
        appState.outfit(byId: outfitId)
    }
    
    var body: some View {
        Group {
            if let outfit = outfit {
                Button(action: { showingDetail = true }) {
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(outfit.name)
                                    .font(.ubuntu(20, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                                    .lineLimit(2)
                                Text("\(outfit.items.count) items")
                                    .font(.ubuntu(14))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            Spacer()
                            VStack(spacing: 8) {
                                if outfit.isFavorite {
                                    Image(systemName: "heart.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(AppColors.pink)
                                }
                                if let lastWorn = outfit.lastWorn {
                                    Text("Last worn")
                                        .font(.ubuntu(10))
                                        .foregroundColor(AppColors.secondaryText)
                                    Text(formatDate(lastWorn))
                                        .font(.ubuntu(10, weight: .medium))
                                        .foregroundColor(AppColors.yellow)
                                }
                            }
                        }
                        HStack(spacing: 12) {
                            ForEach(outfit.items.prefix(5)) { item in
                                VStack(spacing: 4) {
                                    Image(systemName: item.category.icon)
                                        .font(.system(size: 20))
                                        .foregroundColor(AppColors.yellow)
                                    Text(item.name)
                                        .font(.ubuntu(8))
                                        .foregroundColor(AppColors.primaryText)
                                        .lineLimit(1)
                                }
                                .frame(width: 50)
                            }
                            if outfit.items.count > 5 {
                                VStack {
                                    Image(systemName: "ellipsis")
                                        .font(.system(size: 16))
                                        .foregroundColor(AppColors.secondaryText)
                                    Text("+\(outfit.items.count - 5)")
                                        .font(.ubuntu(8))
                                        .foregroundColor(AppColors.secondaryText)
                                }
                                .frame(width: 50)
                            }
                            Spacer()
                        }
                        if !outfit.notes.isEmpty {
                            HStack {
                                Text(outfit.notes)
                                    .font(.ubuntu(12))
                                    .foregroundColor(AppColors.secondaryText)
                                    .lineLimit(2)
                                Spacer()
                            }
                        }
                        HStack {
                            Spacer()
                            Button {
                                appState.markOutfitAsWorn(outfit)
                                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                impactFeedback.impactOccurred()
                            } label: {
                                Text("Wear Today")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.accentText)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(AppColors.yellow)
                                    .cornerRadius(16)
                            }
                        }
                    }
                    .padding(20)
                    .cardStyle()
                }
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $showingDetail) {
                    OutfitDetailView(outfitId: outfitId)
                        .environmentObject(appState)
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct OutfitDetailView: View {
    let outfitId: UUID
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState
    
    private var outfit: Outfit? {
        appState.outfit(byId: outfitId)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                if let outfit = outfit {
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(spacing: 12) {
                                Text(outfit.name)
                                    .font(.ubuntu(28, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                                    .multilineTextAlignment(.center)
                                HStack(spacing: 20) {
                                    VStack {
                                        Text("\(outfit.items.count)")
                                            .font(.ubuntu(20, weight: .bold))
                                            .foregroundColor(AppColors.yellow)
                                        Text("Items")
                                            .font(.ubuntu(12))
                                            .foregroundColor(AppColors.secondaryText)
                                    }
                                    if let lastWorn = outfit.lastWorn {
                                        VStack {
                                            Text("Last Worn")
                                                .font(.ubuntu(12))
                                                .foregroundColor(AppColors.secondaryText)
                                            Text(formatDate(lastWorn))
                                                .font(.ubuntu(14, weight: .medium))
                                                .foregroundColor(AppColors.primaryText)
                                        }
                                    }
                                }
                            }
                            .padding(.top, 20)
                            
                            VStack(spacing: 20) {
                                Text("Items in this Outfit")
                                    .font(.ubuntu(20, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 20)

                                ForEach(WardrobeItem.ClothingCategory.allCases, id: \.self) { category in
                                    let categoryItems = outfit.items.filter { $0.category == category }
                                    if !categoryItems.isEmpty {
                                        OutfitCategorySection(category: category, items: categoryItems)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if !outfit.notes.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Notes")
                                        .font(.ubuntu(18, weight: .bold))
                                        .foregroundColor(AppColors.primaryText)
                                    Text(outfit.notes)
                                        .font(.ubuntu(14))
                                        .foregroundColor(AppColors.secondaryText)
                                        .padding(16)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(AppColors.cardBackground)
                                        .cornerRadius(12)
                                }
                                .padding(.horizontal, 20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Button {
                                appState.markOutfitAsWorn(outfit)
                                dismiss()
                            } label: {
                                Text("Wear This Outfit Today")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(AppColors.accentText)
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 16)
                                    .frame(maxWidth: .infinity)
                                    .background(AppColors.yellow)
                                    .cornerRadius(25)
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer(minLength: 50)
                        }
                    }
                } else {
                    VStack(spacing: 16) {
                        Text("Outfit not found")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        Button("Done") { dismiss() }
                            .buttonStyle(SecondaryButtonStyle())
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.yellow)
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct OutfitCategorySection: View {
    let category: WardrobeItem.ClothingCategory
    let items: [WardrobeItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: category.icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.yellow)
                
                Text(category.rawValue)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(items) { item in
                        OutfitItemCard(item: item)
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
            }
        }
    }
}

struct OutfitItemCard: View {
    let item: WardrobeItem
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: item.category.icon)
                .font(.system(size: 24))
                .foregroundColor(AppColors.yellow)
            
            Text(item.name)
                .font(.ubuntu(10, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            Text(item.color)
                .font(.ubuntu(8))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(12)
        .frame(width: 80, height: 80)
        .cardStyle()
    }
}

#Preview {
    OutfitsView()
        .environmentObject(AppState())
}
