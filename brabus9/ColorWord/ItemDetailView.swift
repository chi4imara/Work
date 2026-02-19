import SwiftUI

struct ItemDetailView: View {
    let itemId: UUID
    @ObservedObject var viewModel: CatalogViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var item: CatalogItem? {
        viewModel.items.first { $0.id == itemId }
    }
    
    var body: some View {
        Group {
            if let item = item {
                itemDetailContent(item: item)
            } else {
                Text("Item not found")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.primaryText)
            }
        }
    }
    
    private func itemDetailContent(item: CatalogItem) -> some View {
        ItemDetailContentView(
            item: item,
            viewModel: viewModel,
            onDismiss: { dismiss() }
        )
    }
}

struct ItemDetailContentView: View {
    let item: CatalogItem
    @ObservedObject var viewModel: CatalogViewModel
    let onDismiss: () -> Void
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Button(action: {
                        onDismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                            Text("Back")
                                .font(.ubuntu(16, weight: .medium))
                        }
                        .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                    
                    Text("Item")
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        onDismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                            Text("Back")
                                .font(.ubuntu(16, weight: .medium))
                        }
                        .foregroundColor(AppColors.secondaryText)
                    }
                    .opacity(0)
                    .disabled(true)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Content")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text(item.text)
                                .font(.ubuntu(18, weight: .regular))
                                .foregroundColor(AppColors.primaryText)
                                .lineSpacing(4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.cardBorder, lineWidth: 1)
                                        )
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Created:")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.secondaryText)
                                
                                Spacer()
                                
                                Text(item.dateCreated, style: .date)
                                    .font(.ubuntu(14, weight: .regular))
                                    .foregroundColor(AppColors.primaryText)
                            }
                            
                            HStack {
                                Text("Modified:")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.secondaryText)
                                
                                Spacer()
                                
                                Text(item.dateModified, style: .date)
                                    .font(.ubuntu(14, weight: .regular))
                                    .foregroundColor(AppColors.primaryText)
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.cardBackground.opacity(0.5))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            showingEditView = true
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Edit")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(AppColors.buttonText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.buttonBackground)
                            )
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Delete")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(AppColors.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.secondaryButtonBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.cardBorder, lineWidth: 1)
                                    )
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditView) {
            EditItemView(item: item, viewModel: viewModel)
        }
        .alert("Delete Item", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteItem(item)
                onDismiss()
            }
        } message: {
            Text("Are you sure you want to delete this item? This action cannot be undone.")
        }
    }
}

#Preview {
    let viewModel = CatalogViewModel()
    let sampleItem = CatalogItem(text: "Sample item text for preview")
    viewModel.addItem(sampleItem.text)
    
    return NavigationView {
        ItemDetailView(
            itemId: sampleItem.id,
            viewModel: viewModel
        )
    }
}
