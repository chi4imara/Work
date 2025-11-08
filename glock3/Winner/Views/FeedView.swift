import SwiftUI

struct FeedView: View {
    @ObservedObject var store: VictoryStore
    @State private var showingAddVictory = false
    @State private var showingFilters = false
    @State private var selectedVictory: Victory?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(AppColors.textPrimary)
                            .frame(width: 44, height: 44)
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                            .opacity(0)
                    }
                    .disabled(true)
                    
                    Text("Small Wins")
                        .font(AppFonts.navigationTitle)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button {
                        showingAddVictory = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(AppColors.primaryYellow)
                            .frame(width: 44, height: 44)
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                    }
                    
                    Menu {
                        Button {
                            showingFilters = true
                        } label: {
                            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                        }
                        
                        if store.isFiltered {
                            Button {
                                store.resetFilters()
                            } label: {
                                Label("Reset Filters", systemImage: "xmark.circle")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title2)
                            .foregroundColor(AppColors.textPrimary)
                            .frame(width: 44, height: 44)
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                
                if store.filteredVictories.isEmpty {
                    EmptyStateView(
                        iconName: store.isFiltered ? "magnifyingglass" : "trophy",
                        title: store.isFiltered ? "No Results" : "No Victories Yet",
                        subtitle: store.isFiltered ? "Try adjusting your filters" : "Add your first small win!",
                        buttonTitle: store.isFiltered ? "Reset Filters" : "Add First Victory"
                    ) {
                        if store.isFiltered {
                            store.resetFilters()
                        } else {
                            showingAddVictory = true
                        }
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(store.filteredVictories) { victory in
                                VictoryCardView(victory: victory) {
                                    selectedVictory = victory
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        store.deleteVictory(victory)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddVictory) {
            AddEditVictoryView(store: store)
        }
        .sheet(isPresented: $showingFilters) {
            FiltersView(store: store)
        }
        .sheet(item: $selectedVictory) { victory in
            VictoryDetailView(victoryId: victory.id, store: store)
        }
    }
}

struct VictoryCardView: View {
    let victory: Victory
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(victory.title)
                            .font(AppFonts.cardTitle)
                            .foregroundColor(AppColors.textPrimary)
                            .multilineTextAlignment(.leading)
                        
                        if let category = victory.category {
                            Text("Category: \(category)")
                                .font(AppFonts.cardSubtitle)
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    Text(victory.date, style: .date)
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.textTertiary)
                }
                
                if let note = victory.note, !note.isEmpty {
                    Text(note)
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmptyStateView: View {
    let iconName: String
    let title: String
    let subtitle: String
    let buttonTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: iconName)
                .font(.system(size: 64))
                .foregroundColor(AppColors.textTertiary)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(subtitle)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: action) {
                Text(buttonTitle)
                    .font(AppFonts.buttonText)
                    .foregroundColor(.black)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(AppColors.primaryYellow)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    FeedView(store: VictoryStore())
}
