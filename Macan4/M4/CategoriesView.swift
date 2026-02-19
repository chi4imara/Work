import SwiftUI

struct CategoriesView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MakeupLookViewModel
    @State private var selectedCategory: MakeupCategory?
    @State private var selectedLookId: UUID?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("Categories")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(MakeupCategory.allCases, id: \.self) { category in
                            CategoryCard(
                                category: category,
                                count: viewModel.getLooksCount(for: category)
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .sheet(item: $selectedCategory) { category in
            CategoryLooksView(category: category, selectedLookId: $selectedLookId)
                .environmentObject(viewModel)
        }
        .sheet(item: Binding(
            get: { selectedLookId.map { LookIdWrapper(id: $0) } },
            set: { selectedLookId = $0?.id }
        )) { wrapper in
            LookDetailView(lookId: wrapper.id)
                .environmentObject(viewModel)
        }
    }
}

struct CategoryCard: View {
    let category: MakeupCategory
    let count: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: category.icon)
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 60, height: 60)
                    .background(AppColors.primaryBlue.opacity(0.1))
                    .cornerRadius(30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.displayName)
                        .font(.playfairDisplay(20, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(count == 1 ? "\(count) look" : "\(count) looks")
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(AppColors.secondaryText)
                    .font(.title3)
            }
            .padding(20)
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

struct CategoryLooksView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MakeupLookViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let category: MakeupCategory
    @Binding var selectedLookId: UUID?
    
    private var categoryLooks: [MakeupLook] {
        viewModel.getLooksForCategory(category)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                if categoryLooks.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(categoryLooks) { look in
                                MakeupLookCard(look: look) {
                                    dismiss()
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
            .navigationTitle(category.displayName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: category.icon)
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryBlue.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No \(category.displayName.lowercased()) looks yet")
                    .font(.playfairDisplay(24, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Create your first \(category.displayName.lowercased()) makeup look to see it here.")
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

extension MakeupCategory: Identifiable {
    var id: String { self.rawValue }
}

#Preview {
    CategoriesView()
        .environmentObject(MakeupLookViewModel())
}
