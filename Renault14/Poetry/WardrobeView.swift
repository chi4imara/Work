import SwiftUI

private struct CategoryDetailPresenter: Identifiable {
    let id: UUID
}

struct WardrobeView: View {
    @EnvironmentObject var viewModel: WardrobeViewModel
    @State private var showingAddItem = false
    @State private var showingAddCategory = false
    @State private var showingCreateTodaysOutfit = false
    @State private var selectedCategoryId: CategoryDetailPresenter?
    @State private var showingCreateOutfit = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.greeting)
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("What to wear today?")
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                
                if viewModel.isEmpty {
                    EmptyStateView(
                        title: "Add your first item and create an outfit",
                        systemImage: "tshirt.fill"
                    ) {
                        showingAddItem = true
                    }
                } else {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Clothing Categories")
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                            Spacer()
                            Button("Add Category") {
                                showingAddCategory = true
                            }
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(AppColors.primary)
                        }
                        .padding(.horizontal, 20)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(viewModel.categories) { category in
                                CategoryCard(
                                    category: category,
                                    itemCount: viewModel.itemsInCategory(category.name).count
                                ) {
                                    selectedCategoryId = CategoryDetailPresenter(id: category.id)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Today's Outfit")
                            .font(.ubuntu(20, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                            .padding(.horizontal, 20)
                        
                        TodaysOutfitCard(onCreateTapped: {
                            showingCreateTodaysOutfit = true
                        })
                            .padding(.horizontal, 20)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Outfit Journal")
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                            Spacer()
                            Button(action: {
                                showingCreateOutfit = true
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppColors.primary)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        if viewModel.outfits.isEmpty {
                            Text("No outfits created yet")
                                .font(.ubuntu(14))
                                .foregroundColor(AppColors.textSecondary)
                                .padding(.horizontal, 20)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.outfits.prefix(5)) { outfit in
                                        OutfitThumbnail(outfit: outfit)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 120)
        }
        .sheet(isPresented: $showingAddItem) {
            AddItemView()
        }
        .sheet(isPresented: $showingAddCategory) {
            AddCategoryView()
        }
        .sheet(item: $selectedCategoryId) { presenter in
            CategoryDetailView(categoryId: presenter.id)
        }
        .sheet(isPresented: $showingCreateTodaysOutfit) {
            AddOutfitView(defaultName: "Today's Look")
        }
        .sheet(isPresented: $showingCreateOutfit) {
            AddOutfitView()
        }
    }
}

struct CategoryCard: View {
    let category: Category
    let itemCount: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: "tshirt.fill")
                    .font(.system(size: 30))
                    .foregroundColor(AppColors.accent)
                
                VStack(spacing: 4) {
                    Text(category.name)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    Text("\(itemCount) items")
                        .font(.ubuntu(12))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
                    .shadow(color: AppColors.shadow, radius: 8, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TodaysOutfitCard: View {
    var onCreateTapped: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.fill")
                .font(.system(size: 40))
                .foregroundColor(AppColors.primary)
            
            Text("Create Today's Look")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
            
            Button {
                onCreateTapped()
            } label: {
                Text("Choose Items")
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(AppColors.primary)
                    .cornerRadius(20)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadow, radius: 8, x: 0, y: 2)
        )
    }
}

struct OutfitThumbnail: View {
    let outfit: Outfit
    
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.primary.opacity(0.2))
                .frame(width: 80, height: 80)
                .overlay(
                    OutfitPhotoView(imageName: outfit.imageName, placeholderSize: 24, cornerRadius: 12)
                )
                .clipped()
            
            Text(outfit.name)
                .font(.ubuntu(12))
                .foregroundColor(AppColors.textPrimary)
                .lineLimit(1)
        }
        .frame(width: 80)
    }
}

struct EmptyStateView: View {
    let title: String
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: systemImage)
                .font(.system(size: 60))
                .foregroundColor(AppColors.textSecondary)
            
            Text(title)
                .font(.ubuntu(16))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button {
                action()
            } label: {
                Text("Get Started")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(AppColors.primary)
                    .cornerRadius(25)
            }
        }
        .padding(.vertical, 60)
    }
}

#Preview {
    WardrobeView()
        .environmentObject(WardrobeViewModel())
}
