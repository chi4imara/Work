import SwiftUI

struct CategoryJewelryView: View {
    let categoryName: String
    let store: JewelryStore
    @Environment(\.presentationMode) var presentationMode
    
    var categoryItems: [JewelryItem] {
        store.getItemsByCategory(categoryName)
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.primaryWhite)
                    }
                    
                    Spacer()
                    
                    Text(categoryName)
                        .font(.bauhausBold(size: 20))
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.clear)
                    }
                    .disabled(true)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if categoryItems.isEmpty {
                    EmptyCategoryView(categoryName: categoryName)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(categoryItems) { item in
                                NavigationLink(destination: JewelryDetailView(itemId: item.id, store: store)) {
                                    JewelryCard(item: item, store: store)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct EmptyCategoryView: View {
    let categoryName: String
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(AppColors.accentYellow)
            
            Text("No jewelry in this category")
                .font(.bauhausBold(size: 20))
                .foregroundColor(AppColors.primaryWhite)
                .multilineTextAlignment(.center)
            
            Text("Add some \(categoryName.lowercased()) to see them here")
                .font(.bauhausRegular(size: 16))
                .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    CategoryJewelryView(categoryName: "Earrings", store: JewelryStore())
}
