import SwiftUI

enum CategorySheetItem: Identifiable {
    case addCategory
    case categoryPlaces(Category)
    
    var id: String {
        switch self {
        case .addCategory:
            return "addCategory"
        case .categoryPlaces(let category):
            return "categoryPlaces_\(category.id)"
        }
    }
}

struct CategoriesView: View {
    @ObservedObject var viewModel: PlacesViewModel
    @State private var categoryToRename: Category?
    @State private var renameCategoryName = ""
    @State private var showingRenameAlert = false
    @State private var categoryToDelete: Category?
    @State private var showingDeleteAlert = false
    @State private var sheetItem: CategorySheetItem?
    
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.categories.isEmpty {
                    emptyStateView
                } else {
                    categoriesList
                }
            }
        }
        .onAppear {
            print("CategoriesView appeared. Categories count: \(viewModel.categories.count)")
        }
        .sheet(item: $sheetItem) { item in
            switch item {
            case .addCategory:
                AddCategoryView(viewModel: viewModel)
            case .categoryPlaces(let category):
                CategoryPlacesView(viewModel: viewModel, category: category)
            }
        }
        .alert("Rename Category", isPresented: $showingRenameAlert) {
            TextField("Category name", text: $renameCategoryName)
            Button("Cancel", role: .cancel) {
                renameCategoryName = ""
                categoryToRename = nil
            }
            Button("Rename") {
                if let category = categoryToRename,
                   !renameCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    viewModel.updateCategory(oldName: category.name, newName: renameCategoryName)
                    renameCategoryName = ""
                    categoryToRename = nil
                }
            }
        } message: {
            Text("Enter a new name for the category")
        }
        .alert("Delete Category", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                categoryToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let category = categoryToDelete {
                    viewModel.deleteCategory(category.name)
                    categoryToDelete = nil
                }
            }
        } message: {
            if let category = categoryToDelete {
                Text("Are you sure you want to delete '\(category.name)'?")
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Categories")
                .font(FontManager.largeTitle)
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Button(action: { 
                print("Add category button tapped")
                sheetItem = .addCategory 
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(ColorTheme.primaryBlue)
                    .clipShape(Circle())
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var categoriesList: some View {
        let _ = print("categoriesList: displaying \(viewModel.categories.count) categories")
        return ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.categories) { category in
                    CategoryCardView(category: category) {
                        print("Category card tapped: \(category.name)")
                        sheetItem = .categoryPlaces(category)
                    }
                    .contextMenu {
                        Button("Rename") {
                            categoryToRename = category
                            renameCategoryName = category.name
                            showingRenameAlert = true
                        }
                        
                        if viewModel.canDeleteCategory(category.name) {
                            Button("Delete", role: .destructive) {
                                categoryToDelete = category
                                showingDeleteAlert = true
                            }
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        if viewModel.canDeleteCategory(category.name) {
                            Button("Delete") {
                                categoryToDelete = category
                                showingDeleteAlert = true
                            }
                            .tint(.red)
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        Button("Rename") {
                            categoryToRename = category
                            renameCategoryName = category.name
                            showingRenameAlert = true
                        }
                        .tint(ColorTheme.primaryBlue)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "folder.circle")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.lightBlue)
            
            VStack(spacing: 12) {
                Text("No Categories Yet")
                    .font(FontManager.title2)
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Create categories to organize your places")
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 16) {
                Button(action: {
                    sheetItem = .addCategory
                }) {
                    Text("Add Category")
                        .font(FontManager.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(ColorTheme.primaryBlue)
                        .cornerRadius(12)
                        .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct CategoryCardView: View {
    let category: Category
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
            Image(systemName: "folder.fill")
                .font(.system(size: 24))
                .foregroundColor(ColorTheme.primaryBlue)
                .frame(width: 40, height: 40)
                .background(ColorTheme.lightBlue.opacity(0.3))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(FontManager.headline)
                    .foregroundColor(ColorTheme.primaryText)
                    .lineLimit(1)
                
                HStack {
                    Text("\(category.placesCount) place\(category.placesCount == 1 ? "" : "s")")
                        .font(FontManager.caption)
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    if !category.lastAddedPlace.isEmpty {
                        Text("•")
                            .font(FontManager.caption)
                            .foregroundColor(ColorTheme.secondaryText)
                        
                        Text("Last: \(category.lastAddedPlace)")
                            .font(FontManager.caption)
                            .foregroundColor(ColorTheme.blueText)
                            .lineLimit(1)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(ColorTheme.lightBlue)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CategoryPlacesView: View {
    @ObservedObject var viewModel: PlacesViewModel
    @Environment(\.presentationMode) var presentationMode
    var category: Category
    
    @State private var sheetItem: SheetItem?
    
    private var placesInCategory: [Place] {
        viewModel.places.filter { $0.category == category.name }
            .sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                if placesInCategory.isEmpty {
                    VStack(spacing: 30) {
                        Image(systemName: "location.circle")
                            .font(.system(size: 80, weight: .light))
                            .foregroundColor(ColorTheme.lightBlue)
                        
                        VStack(spacing: 12) {
                            Text("No Places in \(category.name)")
                                .font(FontManager.title2)
                                .foregroundColor(ColorTheme.primaryText)
                                .multilineTextAlignment(.center)
                            
                            Text("Add places to this category from the main screen")
                                .font(FontManager.body)
                                .foregroundColor(ColorTheme.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 40)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(placesInCategory) { place in
                                NavigationLink(destination: PlaceDetailView(
                                    viewModel: viewModel, 
                                    place: place, 
                                    category: category, 
                                    shouldDismissParent: true,
                                    onEditPlace: { place in
                                        sheetItem = .editPlace(place)
                                    }
                                )) {
                                    PlaceCardView(place: place)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle(category.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .sheet(item: $sheetItem) { item in
                switch item {
                case .addPlace:
                    AddEditPlaceView(viewModel: viewModel)
                case .editPlace(let place):
                    AddEditPlaceView(viewModel: viewModel, placeToEdit: place)
                case .filterSheet:
                    FilterSheetView(viewModel: viewModel)
                }
            }
        }
    }
}


