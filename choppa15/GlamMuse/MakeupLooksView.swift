import SwiftUI

struct MakeupLooksView: View {
    @StateObject private var viewModel = MakeupLooksViewModel()
    @State private var showingCreateLook = false
    @State private var selectedLook: MakeupLook?
    @State private var lookToEdit: MakeupLook?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchAndFiltersView
                
                if viewModel.filteredLooks.isEmpty {
                    emptyStateView
                } else {
                    looksListView
                }
            }
        }
        .sheet(isPresented: $showingCreateLook) {
            CreateEditLookView(viewModel: viewModel, lookToEdit: lookToEdit)
        }
        .onChange(of: showingCreateLook) { isShowing in
            if !isShowing {
                lookToEdit = nil
            }
        }
        .sheet(item: $selectedLook) { look in
            LookDetailView(lookId: look.id, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("My Looks")
                .font(.ubuntu(32, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text("Makeup ideas catalog")
                .font(.ubuntu(16))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
    
    private var searchAndFiltersView: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.secondaryText)
                
                TextField("Search by name or shade...", text: $viewModel.searchText)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.primaryText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.cardBackground.opacity(0.2))
            .cornerRadius(12)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    CategoryFilterButton(
                        title: "All",
                        isSelected: viewModel.selectedCategory == nil
                    ) {
                        viewModel.selectedCategory = nil
                    }
                    
                    ForEach(MakeupCategory.allCases, id: \.self) { category in
                        CategoryFilterButton(
                            title: category.rawValue,
                            icon: category.icon,
                            isSelected: viewModel.selectedCategory == category
                        ) {
                            viewModel.selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, -20)
            
            Button(action: { showingCreateLook = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("New Look")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(AppColors.buttonPrimary)
                .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "paintbrush.pointed")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 8) {
                Text("No makeup ideas yet")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add your first look — start with your favorite shades")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingCreateLook = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("New Look")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .frame(width: 200, height: 44)
                .background(AppColors.buttonPrimary)
                .cornerRadius(12)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 70)
    }
    
    private var looksListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredLooks) { look in
                    MakeupLookCard(look: look) {
                        selectedLook = look
                    } onEdit: {
                        lookToEdit = look
                        showingCreateLook = true
                    } onDelete: {
                        viewModel.deleteLook(look)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
}

struct CategoryFilterButton: View {
    let title: String
    let icon: String?
    let isSelected: Bool
    let action: () -> Void
    
    init(title: String, icon: String? = nil, isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14))
                }
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
            }
            .foregroundColor(isSelected ? AppColors.primaryText : AppColors.secondaryText)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? AppColors.buttonPrimary : AppColors.cardBackground.opacity(0.2))
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct MakeupLookCard: View {
    let look: MakeupLook
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var cardHeight: CGFloat = 0
    
    private let actionWidth: CGFloat = 120
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .trailing) {
                HStack(spacing: 0) {
                    Button(action: {
                        withAnimation(.spring()) {
                            offset = 0
                        }
                        onEdit()
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "pencil")
                                .font(.system(size: 20, weight: .medium))
                            Text("Edit")
                                .font(.ubuntu(12, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .frame(width: actionWidth / 2)
                        .frame(maxHeight: .infinity)
                        .background(Color.blue)
                    }
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            offset = 0
                        }
                        onDelete()
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "trash")
                                .font(.system(size: 20, weight: .medium))
                            Text("Delete")
                                .font(.ubuntu(12, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .frame(width: actionWidth / 2)
                        .frame(maxHeight: .infinity)
                        .background(Color.red)
                    }
                }
                .frame(height: cardHeight > 0 ? cardHeight : nil)
                .cornerRadius(12)
                .opacity(offset < 0 ? 1 : 0)
                
                Button(action: {
                    if offset == 0 {
                        onTap()
                    } else {
                        withAnimation(.spring()) {
                            offset = 0
                        }
                    }
                }) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(look.name)
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(AppColors.darkText)
                                    .lineLimit(1)
                                
                                HStack(spacing: 6) {
                                    Image(systemName: look.category.icon)
                                        .font(.system(size: 12))
                                    Text(look.category.rawValue)
                                        .font(.ubuntu(12, weight: .medium))
                                }
                                .foregroundColor(AppColors.accent)
                            }
                            
                            Spacer()
                            
                            Text(DateFormatter.shortDate.string(from: look.dateCreated))
                                .font(.ubuntu(12))
                                .foregroundColor(AppColors.darkText.opacity(0.6))
                        }
                        
                        if !look.mainShades.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Main shades:")
                                    .font(.ubuntu(12, weight: .medium))
                                    .foregroundColor(AppColors.darkText.opacity(0.7))
                                
                                Text(look.mainShades.joined(separator: ", "))
                                    .font(.ubuntu(14))
                                    .foregroundColor(AppColors.darkText)
                                    .lineLimit(2)
                            }
                        }
                        
                        if !look.result.isEmpty {
                            Text(look.result)
                                .font(.ubuntu(14))
                                .foregroundColor(AppColors.darkText.opacity(0.8))
                                .lineLimit(2)
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppColors.cardBackground)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .background(
                        GeometryReader { cardGeometry in
                            Color.clear
                                .onAppear {
                                    cardHeight = cardGeometry.size.height
                                }
                                .onChange(of: cardGeometry.size.height) { newHeight in
                                    cardHeight = newHeight
                                }
                        }
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(height: cardHeight > 0 ? cardHeight : nil)
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

#Preview {
    MakeupLooksView()
}
