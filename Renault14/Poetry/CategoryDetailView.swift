import SwiftUI

struct CategoryDetailView: View {
    let categoryId: UUID
    @EnvironmentObject var viewModel: WardrobeViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingAddItem = false
    
    private var category: Category? {
        viewModel.category(byId: categoryId)
    }
    
    private var categoryItems: [WardrobeItem] {
        guard let category = category else { return [] }
        return viewModel.itemsInCategory(category.name)
    }
    
    var body: some View {
        Group {
            if let category = category {
                categoryContent(category: category)
            } else {
                Text("Category not found")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.textSecondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func categoryContent(category: Category) -> some View {
        NavigationView {
            ZStack {
                AppColors.gradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        Image(systemName: "folder.fill")
                            .font(.system(size: 50))
                            .foregroundColor(AppColors.primary)
                        
                        VStack(spacing: 8) {
                            Text(category.name)
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("\(categoryItems.count) items")
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.textSecondary)
                            
                            Text(category.isRepeating ? "Repeating Category" : "One-time Category")
                                .font(.ubuntu(14))
                                .foregroundColor(AppColors.accent)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.accent.opacity(0.1))
                                )
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    
                    if categoryItems.isEmpty {
                        Spacer()
                        EmptyStateView(
                            title: "No items in this category yet",
                            systemImage: "tshirt"
                        ) {
                            showingAddItem = true
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                ForEach(categoryItems) { item in
                                    ItemCard(item: item)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
            .navigationTitle("Category Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddItem = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.primary)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddItem) {
            AddItemView()
        }
    }
}

struct ItemCard: View {
    let item: WardrobeItem
    
    var body: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.primary.opacity(0.1))
                .frame(height: 100)
                .overlay(
                    ItemPhotoView(imageName: item.imageName, placeholderIcon: "tshirt.fill", placeholderSize: 30, cornerRadius: 12)
                )
                .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(2)
                
                HStack {
                    Text(item.color)
                        .font(.ubuntu(12))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Spacer()
                    
                    if let size = item.size {
                        Text("Size \(size)")
                            .font(.ubuntu(10))
                            .foregroundColor(AppColors.accent)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(AppColors.accent.opacity(0.1))
                            )
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadow, radius: 6, x: 0, y: 2)
        )
    }
}

#Preview {
    let vm = WardrobeViewModel()
    return CategoryDetailView(categoryId: vm.categories.first!.id)
        .environmentObject(vm)
}
