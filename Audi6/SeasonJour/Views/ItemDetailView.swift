import SwiftUI

struct ItemDetailView: View {
    let itemId: UUID
    @ObservedObject var viewModel: SeasonItemViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var item: SeasonItem? {
        viewModel.getItem(byId: itemId)
    }
    
    var body: some View {
        Group {
            if let item = item {
                itemDetailContent(item: item)
            } else {
                Text("Item not found")
                    .font(FontManager.bauhausMedium(18))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
    }
    
    @ViewBuilder
    private func itemDetailContent(item: SeasonItem) -> some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(item.name)
                        .font(FontManager.bauhausBold(28))
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Image(systemName: item.season.icon)
                            .font(.system(size: 24))
                            .foregroundColor(AppColors.primaryBlue)
                        
                        Text(item.season.displayName)
                            .font(FontManager.bauhausMedium(20))
                            .foregroundColor(AppColors.primaryBlue)
                        
                        Spacer()
                        
                        if item.isFavorite {
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(AppColors.accentPink)
                                Text("Favorite")
                                    .font(FontManager.bauhausLight(16))
                                    .foregroundColor(AppColors.accentPink)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Comment")
                            .font(FontManager.bauhausMedium(18))
                            .foregroundColor(AppColors.primaryText)
                        
                        if item.comment.isEmpty {
                            Text("No comment added")
                                .font(FontManager.bauhausLight(16))
                                .foregroundColor(AppColors.secondaryText)
                                .italic()
                        } else {
                            Text(item.comment)
                                .font(FontManager.bauhausLight(16))
                                .foregroundColor(AppColors.primaryText)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            showingEditView = true
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Edit")
                            }
                            .font(FontManager.bauhausMedium(18))
                            .foregroundColor(AppColors.contrastText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.primaryBlue)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete Item")
                            }
                            .font(FontManager.bauhausMedium(18))
                            .foregroundColor(AppColors.contrastText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(12)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            EditItemView(itemId: itemId, viewModel: viewModel)
        }
        .alert("Delete Item", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteItem(byId: itemId)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this item? This action cannot be undone.")
        }
    }
}

#Preview {
    NavigationView {
        let viewModel = SeasonItemViewModel()
        let testItem = SeasonItem(name: "Light Trench Coat", season: .spring, comment: "Perfect for cool spring days", isFavorite: true)
        viewModel.addItem(testItem)
        return ItemDetailView(
            itemId: testItem.id,
            viewModel: viewModel
        )
    }
}
