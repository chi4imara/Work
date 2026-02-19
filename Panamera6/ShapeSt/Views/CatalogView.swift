import SwiftUI

struct CatalogView: View {
    @ObservedObject var viewModel: StyleViewModel
    @State private var isShowingNewStyle = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        Text("Style Catalog")
                            .font(.lumierepolis(size: 28, weight: .bold))
                            .foregroundColor(ColorTheme.white)
                        
                        Spacer()
                        
                        Button(action: { isShowingNewStyle = true }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(ColorTheme.white)
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle()
                                        .fill(ColorTheme.orange)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(ColorTheme.white.opacity(0.6))
                        
                        TextField("", text: $viewModel.searchText)
                            .font(.lumierepolis(size: 16))
                            .foregroundColor(ColorTheme.white)
                            .overlay(
                                Group {
                                    if viewModel.searchText.isEmpty {
                                        HStack {
                                            Text("Search styles...")
                                                .font(.lumierepolis(size: 16))
                                                .foregroundColor(ColorTheme.white.opacity(0.5))
                                            Spacer()
                                        }
                                    }
                                },
                                alignment: .leading
                            )
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(ColorTheme.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(ColorTheme.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                SortButton(
                                    title: option.displayName,
                                    isSelected: viewModel.selectedSortOption == option
                                ) {
                                    viewModel.selectedSortOption = option
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                    if viewModel.filteredStyles.isEmpty {
                        EmptyStateView {
                            isShowingNewStyle = true
                        }
                    } else {
                        StylesList(viewModel: viewModel)
                    }
            }
        }
        .sheet(isPresented: $isShowingNewStyle) {
            NewStyleView(viewModel: viewModel)
        }
    }
}

struct SortButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.lumierepolis(size: 14, weight: .regular))
                .foregroundColor(isSelected ? ColorTheme.white : ColorTheme.white.opacity(0.7))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isSelected ? ColorTheme.orange : ColorTheme.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(ColorTheme.white.opacity(0.2), lineWidth: 1)
                        )
                )
        }
    }
}

struct EmptyStateView: View {
    let onAddStyle: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "tray")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(ColorTheme.white.opacity(0.6))
                
                VStack(spacing: 8) {
                    Text("Catalog is empty")
                        .font(.lumierepolis(size: 24, weight: .bold))
                        .foregroundColor(ColorTheme.white)
                    
                    Text("Add your first style to get started")
                        .font(.lumierepolis(size: 16))
                        .foregroundColor(ColorTheme.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
            }
            
            Button(action: onAddStyle) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                    
                    Text("Add Style")
                        .font(.lumierepolis(size: 18, weight: .bold))
                }
                .foregroundColor(ColorTheme.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(ColorTheme.orange)
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct StylesList: View {
    @ObservedObject var viewModel: StyleViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredStyles, id: \.id) { style in
                    NavigationLink(destination: StyleDetailView(styleId: style.id, viewModel: viewModel)) {
                        StyleCard(styleId: style.id, viewModel: viewModel)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            viewModel.deleteStyle(byId: style.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
}

struct StyleCard: View {
    let styleId: UUID
    @ObservedObject var viewModel: StyleViewModel
    
    var style: Style? {
        viewModel.styles.first { $0.id == styleId }
    }
    
    var body: some View {
        Group {
            if let currentStyle = style {
                HStack(spacing: 16) {
                    Image(systemName: currentStyle.category == .haircut ? "scissors" : "mustache")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(ColorTheme.orange)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(ColorTheme.orange.opacity(0.2))
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(currentStyle.name)
                                .font(.lumierepolis(size: 18, weight: .bold))
                                .foregroundColor(ColorTheme.white)
                            
                            Spacer()
                            
                            if currentStyle.isFavorite {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(ColorTheme.orange)
                            }
                        }
                        
                        Text(currentStyle.category.displayName)
                            .font(.lumierepolis(size: 14))
                            .foregroundColor(ColorTheme.accent)
                        
                        Text("Length: \(currentStyle.length)")
                            .font(.lumierepolis(size: 12))
                            .foregroundColor(ColorTheme.white.opacity(0.7))
                        
                        if !currentStyle.shape.isEmpty {
                            Text(currentStyle.shape)
                                .font(.lumierepolis(size: 12))
                                .foregroundColor(ColorTheme.white.opacity(0.7))
                        }
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(ColorTheme.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(ColorTheme.white.opacity(0.1), lineWidth: 1)
                        )
                )
            }
        }
    }
}
