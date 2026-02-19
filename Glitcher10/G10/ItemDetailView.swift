import SwiftUI

struct ItemDetailView: View {
    let itemId: UUID
    @ObservedObject var viewModel: ShoppingViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var item: ShoppingItem? {
        viewModel.items.first { $0.id == itemId }
    }
    
    var body: some View {
        Group {
            if let item = item {
                itemDetailContent(item: item)
            } else {
                Text("Item not found")
                    .foregroundColor(ColorManager.white)
            }
        }
    }
    
    private func itemDetailContent(item: ShoppingItem) -> some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(ColorManager.cardGradient)
                                .frame(width: 80, height: 80)
                                .shadow(color: ColorManager.darkBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                            
                            Image(systemName: categoryIcon(for: item.category))
                                .font(.system(size: 35))
                                .foregroundColor(ColorManager.lightBlue)
                        }
                        
                        Text(item.name)
                            .font(FontManager.ubuntu(size: 24, weight: .bold))
                            .foregroundColor(ColorManager.white)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        DetailRow(
                            icon: "folder",
                            title: "Category",
                            value: item.category,
                            color: ColorManager.lightBlue
                        )
                        
                        Divider()
                            .background(ColorManager.white.opacity(0.2))
                        
                        DetailRow(
                            icon: "number",
                            title: "Quantity",
                            value: item.quantity,
                            color: ColorManager.orange
                        )
                        
                        Divider()
                            .background(ColorManager.white.opacity(0.2))
                        
                        DetailRow(
                            icon: "text.bubble",
                            title: "Comment",
                            value: item.comment.isEmpty ? "No comment added." : item.comment,
                            color: ColorManager.white.opacity(0.8)
                        )
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(ColorManager.cardGradient)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            showingEditView = true
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Edit")
                            }
                            .font(FontManager.ubuntu(size: 18, weight: .medium))
                            .foregroundColor(ColorManager.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(ColorManager.buttonGradient)
                            .cornerRadius(16)
                            .shadow(color: ColorManager.lightBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete Item")
                            }
                            .font(FontManager.ubuntu(size: 18, weight: .medium))
                            .foregroundColor(ColorManager.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [ColorManager.error, Color.red.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: ColorManager.error.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(FontManager.ubuntu(size: 16))
                    .foregroundColor(ColorManager.lightBlue)
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditItemView(item: item, viewModel: viewModel)
        }
        .alert("Delete Item", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteItem(item)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this item? This action cannot be undone.")
        }
    }
    
    private func categoryIcon(for category: String) -> String {
        switch category.lowercased() {
        case "oils", "oil":
            return "drop.fill"
        case "parts", "part":
            return "gearshape.fill"
        case "tools", "tool":
            return "wrench.fill"
        case "materials", "material":
            return "cube.fill"
        default:
            return "tag.fill"
        }
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(FontManager.ubuntu(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.white.opacity(0.7))
                
                Text(value)
                    .font(FontManager.ubuntu(size: 16))
                    .foregroundColor(ColorManager.white)
                    .lineLimit(nil)
            }
            
            Spacer()
        }
    }
}

#Preview {
    NavigationView {
        let previewItem = ShoppingItem(
            name: "Motor Oil 5W-30",
            category: "Oils",
            quantity: "1",
            comment: "For winter maintenance"
        )
        let viewModel = ShoppingViewModel()
        viewModel.addItem(previewItem)
        return ItemDetailView(
            itemId: previewItem.id,
            viewModel: viewModel
        )
    }
}
