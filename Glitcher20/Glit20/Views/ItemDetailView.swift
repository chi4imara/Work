import SwiftUI

struct ItemDetailView: View {
    let itemId: UUID
    @ObservedObject var viewModel: WardrobeViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    
    private var item: WardrobeItem? {
        viewModel.getItem(by: itemId)
    }
    
    var body: some View {
        Group {
            if let item = item {
                ZStack {
                    AppColorScheme.backgroundGradient
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 16) {
                                Text(item.name)
                                    .font(FontManager.playfairDisplay(size: 24, weight: .bold))
                                    .foregroundColor(Color.textPrimary)
                                    .lineLimit(nil)
                                
                                HStack {
                                    Text("Category:")
                                        .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                        .foregroundColor(Color.textSecondary)
                                    
                                    Text(item.category)
                                        .font(FontManager.playfairDisplay(size: 16))
                                        .foregroundColor(Color.primaryYellow)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(Color.primaryYellow.opacity(0.2))
                                        .cornerRadius(8)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Description:")
                                        .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                        .foregroundColor(Color.textSecondary)
                                    
                                    Text(item.description.isEmpty ? "No description available" : item.description)
                                        .font(FontManager.playfairDisplay(size: 16))
                                        .foregroundColor(item.description.isEmpty ? Color.textSecondary : Color.textPrimary)
                                        .lineLimit(nil)
                                }
                                
                                HStack {
                                    Text("Status:")
                                        .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                        .foregroundColor(Color.textSecondary)
                                    
                                    Text(item.isPurchased ? "Purchased" : "Not purchased")
                                        .font(FontManager.playfairDisplay(size: 16))
                                        .foregroundColor(item.isPurchased ? Color.secondaryGreen : Color.accentRed)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(AppColorScheme.cardGradient)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.cardBorder, lineWidth: 1)
                            )
                            
                            HStack {
                                Text("Mark as purchased")
                                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                                    .foregroundColor(Color.textPrimary)
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.togglePurchased(item)
                                }) {
                                    Image(systemName: item.isPurchased ? "checkmark.circle.fill" : "circle")
                                        .font(.title)
                                        .foregroundColor(item.isPurchased ? Color.secondaryGreen : Color.textSecondary)
                                }
                            }
                            .padding()
                            .background(AppColorScheme.cardGradient)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.cardBorder, lineWidth: 1)
                            )
                            
                            VStack(spacing: 16) {
                                Button(action: {
                                    showingEditView = true
                                }) {
                                    Text("Edit")
                                        .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                                        .foregroundColor(Color.primaryPurple)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 56)
                                        .background(Color.primaryYellow)
                                        .cornerRadius(16)
                                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                                }
                                
                                Button(action: deleteItem) {
                                    Text("Delete")
                                        .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                                        .foregroundColor(Color.primaryWhite)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 56)
                                        .background(Color.accentRed)
                                        .cornerRadius(16)
                                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                                }
                            }
                            
                            Spacer(minLength: 50)
                        }
                        .padding()
                    }
                }
                .navigationTitle(item.name.count > 20 ? String(item.name.prefix(20)) + "..." : item.name)
                .navigationBarTitleDisplayMode(.inline)
                .preferredColorScheme(.dark)
                .sheet(isPresented: $showingEditView) {
                    EditItemView(itemId: itemId, viewModel: viewModel)
                }
            } else {
                Text("Item not found")
                    .font(FontManager.playfairDisplay(size: 18))
                    .foregroundColor(Color.textSecondary)
            }
        }
    }
    
    private func deleteItem() {
        viewModel.deleteItem(by: itemId)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NavigationView {
        let viewModel = WardrobeViewModel()
        let item = WardrobeItem(name: "White Shirt", category: "Tops", description: "A classic white shirt for formal occasions")
        viewModel.addItem(item)
        return ItemDetailView(
            itemId: item.id,
            viewModel: viewModel
        )
    }
}
