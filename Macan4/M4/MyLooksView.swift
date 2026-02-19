import SwiftUI

struct MyLooksView: View {
    @EnvironmentObject var viewModel: MakeupLookViewModel
    @State private var showingAddLook = false
    @State private var showingFilters = false
    @State private var showingSortOptions = false
    @State private var selectedLookId: UUID?
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.filteredLooks.isEmpty {
                    emptyStateView
                } else {
                    looksListView
                }
            }
        }
        .sheet(isPresented: $showingAddLook) {
            AddEditLookView(isPresented: $showingAddLook)
                .environmentObject(viewModel)
        }
        .sheet(item: Binding(
            get: { selectedLookId.map { LookIdWrapper(id: $0) } },
            set: { selectedLookId = $0?.id }
        )) { wrapper in
            LookDetailView(lookId: wrapper.id)
                .environmentObject(viewModel)
        }
        .onAppear {
            viewModel.updateFilteredLooks()
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                Text("My Looks")
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        selectedTab = 2
                    }
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(AppColors.primaryBlue)
                        .font(.title2)
                }
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.secondaryText)
                
                TextField("Search by name or color", text: $viewModel.searchText)
                    .font(.playfairDisplay(16))
                    .onChange(of: viewModel.searchText) { _ in
                        viewModel.performSearch()
                    }
                
                if !viewModel.searchText.isEmpty {
                    Button(action: viewModel.clearSearch) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.backgroundWhite.opacity(0.8))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
            )
            
            HStack {
                Button(action: {
                    withAnimation {
                        selectedTab = 3
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Text("Filter")
                        if viewModel.filterOptions.isActive {
                            Circle()
                                .fill(AppColors.primaryYellow)
                                .frame(width: 8, height: 8)
                        }
                    }
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(AppColors.backgroundWhite.opacity(0.8))
                    .cornerRadius(20)
                }
                
                Spacer()
                
                Menu {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Button(action: {
                            viewModel.sortOption = option
                            viewModel.updateFilteredLooks()
                        }) {
                            HStack {
                                Text(option.displayName)
                                if viewModel.sortOption == option {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.up.arrow.down")
                        Text("Sort")
                    }
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(AppColors.backgroundWhite.opacity(0.8))
                    .cornerRadius(20)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "face.smiling")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryBlue.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No makeup ideas yet")
                    .font(.playfairDisplay(24, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Tap + to add your first makeup look and start building your beauty collection.")
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 40)
            
            Button(action: {
                withAnimation {
                    selectedTab = 2
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Add First Look")
                }
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(AppColors.contrastText)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(AppColors.primaryYellow)
                .cornerRadius(25)
                .shadow(color: AppColors.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.top, 8)
            
            Spacer()
        }
    }
    
    private var looksListView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(viewModel.filteredLooks) { look in
                    MakeupLookCard(look: look) {
                        selectedLookId = look.id
                    } onFavoriteToggle: {
                        viewModel.toggleFavorite(by: look.id)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

struct MakeupLookCard: View {
    let look: MakeupLook
    let onTap: () -> Void
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(look.name)
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(1)
                        
                        Text(look.category.displayName)
                            .font(.playfairDisplay(14, weight: .medium))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                    
                    Button(action: onFavoriteToggle) {
                        Image(systemName: look.isFavorite ? "star.fill" : "star")
                            .foregroundColor(look.isFavorite ? AppColors.primaryYellow : AppColors.secondaryText)
                            .font(.title3)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                if !look.colors.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(Array(look.colors.prefix(5)), id: \.self) { colorHex in
                            Circle()
                                .fill(ColorPalette.colorFromHex(colorHex))
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 1)
                                )
                        }
                        
                        if look.colors.count > 5 {
                            Text("+\(look.colors.count - 5)")
                                .font(.playfairDisplay(12, weight: .medium))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        
                        Spacer()
                    }
                }
                
                if !look.notes.isEmpty {
                    Text(look.notes)
                        .font(.playfairDisplay(14))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                HStack {
                    Spacer()
                    Text(look.dateCreated, style: .date)
                        .font(.playfairDisplay(12))
                        .foregroundColor(AppColors.secondaryText.opacity(0.8))
                }
            }
            .padding(16)
            .background(AppColors.backgroundWhite.opacity(0.9))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.primaryBlue.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

