import SwiftUI

struct SetsView: View {
    @ObservedObject var setsStore: SetsStore
    @ObservedObject var jewelryStore: JewelryStore
    @State private var showingCreateSet = false
    @State private var selectedSetId: UUID?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HeaderView(
                    title: "Sets",
                    showAddButton: true,
                    onAddTapped: {
                        showingCreateSet = true
                    }
                )
                
                if setsStore.sets.isEmpty {
                    EmptySetsState {
                        showingCreateSet = true
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(setsStore.sets) { set in
                                SetCard(
                                    set: set,
                                    jewelryCount: set.jewelryIds.count,
                                    jewelries: setsStore.getJewelriesInSet(set, from: jewelryStore)
                                ) {
                                    selectedSetId = set.id
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(isPresented: $showingCreateSet) {
            CreateSetView(jewelryStore: jewelryStore, setsStore: setsStore)
        }
        .sheet(item: Binding(
            get: { selectedSetId.flatMap { id in setsStore.sets.first(where: { $0.id == id }) } },
            set: { _ in selectedSetId = nil }
        )) { set in
            SetDetailView(setId: set.id, jewelryStore: jewelryStore, setsStore: setsStore)
        }
    }
}

struct EmptySetsState: View {
    let onAddTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "square.stack.3d.up")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(ColorTheme.accentYellow)
                
                VStack(spacing: 12) {
                    Text("No sets yet")
                        .font(.lumierepolis(24, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text("Create your first set to organize your jewelry")
                        .font(.lumierepolis(16))
                        .foregroundColor(ColorTheme.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            
            Button(action: onAddTapped) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("New Set")
                }
                .font(.lumierepolis(16, weight: .bold))
                .foregroundColor(ColorTheme.buttonText)
                .padding(.horizontal, 30)
                .padding(.vertical, 16)
                .background(ColorTheme.buttonPrimary)
                .cornerRadius(25)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct SetCard: View {
    let set: JewelrySet
    let jewelryCount: Int
    let jewelries: [Jewelry]
    let onTap: () -> Void
    
    @State private var cardScale: CGFloat = 1.0
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(set.name)
                            .font(.lumierepolis(18, weight: .bold))
                            .foregroundColor(ColorTheme.primaryText)
                            .lineLimit(2)
                        
                        Text("\(jewelryCount) item\(jewelryCount == 1 ? "" : "s")")
                            .font(.lumierepolis(14))
                            .foregroundColor(ColorTheme.accentYellow)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                if !jewelries.isEmpty {
                    JewelryPreviewRow(jewelries: Array(jewelries.prefix(4)))
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(ColorTheme.cardBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(cardScale)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                cardScale = pressing ? 0.98 : 1.0
            }
        }, perform: {})
    }
}

struct JewelryPreviewRow: View {
    let jewelries: [Jewelry]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(jewelries.prefix(3), id: \.id) { jewelry in
                JewelryPreviewItem(jewelry: jewelry)
            }
            
            if jewelries.count > 3 {
                MoreItemsIndicator(count: jewelries.count - 3)
            }
            
            Spacer()
        }
    }
}

struct JewelryPreviewItem: View {
    let jewelry: Jewelry
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(ColorTheme.cardBackground)
                    .overlay(
                        Circle()
                            .stroke(ColorTheme.cardBorder, lineWidth: 1)
                    )
                    .frame(width: 40, height: 40)
                
                Image(systemName: jewelry.type.icon)
                    .font(.system(size: 16))
                    .foregroundColor(ColorTheme.accentYellow)
            }
            
            Text(jewelry.name)
                .font(.lumierepolis(10))
                .foregroundColor(ColorTheme.secondaryText)
                .lineLimit(1)
                .frame(width: 50)
        }
    }
}

struct MoreItemsIndicator: View {
    let count: Int
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(ColorTheme.cardBackground)
                    .overlay(
                        Circle()
                            .stroke(ColorTheme.cardBorder, lineWidth: 1)
                    )
                    .frame(width: 40, height: 40)
                
                Text("+\(count)")
                    .font(.lumierepolis(12, weight: .bold))
                    .foregroundColor(ColorTheme.accentYellow)
            }
            
            Text("more")
                .font(.lumierepolis(10))
                .foregroundColor(ColorTheme.secondaryText)
                .frame(width: 50)
        }
    }
}

#Preview {
    SetsView(setsStore: SetsStore(), jewelryStore: JewelryStore())
}
