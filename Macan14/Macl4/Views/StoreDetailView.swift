import SwiftUI

struct StoreDetailView: View {
    let storeId: UUID
    @ObservedObject var viewModel: StoreViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var store: Store? {
        viewModel.stores.first(where: { $0.id == storeId })
    }
    
    var body: some View {
        if let store = store {
            NavigationView {
                ZStack {
                    AnimatedBackground()
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            RadialGradient(
                                                colors: [
                                                    Color.appAccent.opacity(0.3),
                                                    Color.appPrimary.opacity(0.1)
                                                ],
                                                center: .center,
                                                startRadius: 30,
                                                endRadius: 80
                                            )
                                        )
                                        .frame(width: 120, height: 120)
                                    
                                    Image(systemName: store.type == .online ? "globe" : "storefront")
                                        .font(.system(size: 40, weight: .medium))
                                        .foregroundColor(.appPrimary)
                                }
                                
                                VStack(spacing: 8) {
                                    Text(store.name)
                                        .font(.ubuntu(28, weight: .bold))
                                        .foregroundColor(.appText)
                                        .multilineTextAlignment(.center)
                                    
                                    HStack(spacing: 16) {
                                        Label(store.type.displayName, systemImage: "tag")
                                        Label(store.category.displayName, systemImage: "folder")
                                    }
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(.appTextSecondary)
                                }
                            }
                            .padding(.top, 20)
                            
                            VStack(spacing: 16) {
                                DetailCardView(
                                    title: "Store Type",
                                    value: store.type.displayName,
                                    icon: "storefront",
                                    color: .appPrimary
                                )
                                
                                DetailCardView(
                                    title: "Category",
                                    value: store.category.displayName,
                                    icon: "folder.fill",
                                    color: .appAccent
                                )
                                
                                DetailCardView(
                                    title: "Price Level",
                                    value: store.priceLevel.displayName,
                                    icon: "dollarsign.circle.fill",
                                    color: .appSuccess
                                )
                                
                                if !store.review.isEmpty {
                                    ReviewCardView(review: store.review)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                Button(action: { showingEditView = true }) {
                                    HStack {
                                        Image(systemName: "pencil")
                                        Text("Edit Store")
                                    }
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(
                                        LinearGradient(
                                            colors: [Color.appPrimary, Color.appAccent],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(25)
                                    .shadow(color: Color.appShadow, radius: 10, x: 0, y: 5)
                                }
                                
                                Button(action: { showingDeleteAlert = true }) {
                                    HStack {
                                        Image(systemName: "trash")
                                        Text("Delete Store")
                                    }
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.appError)
                                }
                            }
                            .padding(.horizontal, 40)
                            .padding(.bottom, 40)
                        }
                        .padding(.top, 20)
                    }
                }
                .navigationBarHidden(true)
                .overlay(
                    VStack {
                        HStack {
                            Button(action: { dismiss() }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.appTextSecondary)
                            }
                            
                            Spacer()
                            
                            Text("Store Details")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(.appText)
                            
                            Spacer()
                            
                            Color.clear
                                .frame(width: 28, height: 28)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        Spacer()
                    },
                    alignment: .top
                )
            }
            .sheet(isPresented: $showingEditView) {
                EditStoreView(storeId: storeId, viewModel: viewModel)
            }
            .alert("Delete Store", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    viewModel.deleteStore(store)
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete \(store.name)? This action cannot be undone.")
            }
        }
    }
}

struct DetailCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(.appTextSecondary)
                
                Text(value)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.appText)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.appCardBackground)
        .cornerRadius(16)
        .shadow(color: Color.appShadow, radius: 8, x: 0, y: 4)
    }
}

struct ReviewCardView: View {
    let review: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "quote.bubble.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.appAccent)
                
                Text("Your Review")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.appText)
                
                Spacer()
            }
            
            Text(review)
                .font(.ubuntu(15))
                .foregroundColor(.appTextSecondary)
                .lineLimit(nil)
        }
        .padding(16)
        .background(Color.appCardBackground)
        .cornerRadius(16)
        .shadow(color: Color.appShadow, radius: 8, x: 0, y: 4)
    }
}

#Preview {
    let store = Store(
        name: "Zara",
        type: .boutique,
        category: .clothing,
        priceLevel: .medium,
        review: "Great selection of basic items with frequent sales. Love their minimalist style."
    )
    let viewModel = StoreViewModel()
    viewModel.addStore(store)
    return StoreDetailView(storeId: store.id, viewModel: viewModel)
}
