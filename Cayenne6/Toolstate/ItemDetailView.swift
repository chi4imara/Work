import SwiftUI

struct ItemDetailView: View {
    let item: GarageItem
    @ObservedObject var viewModel: GarageViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Image(systemName: categoryIcon(for: item.category))
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(AppColors.lightBlue)
                            .frame(width: 120, height: 120)
                            .background(
                                Circle()
                                    .fill(AppColors.cardBackground)
                            )
                        
                        Text(item.name)
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.white)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        DetailCard(
                            icon: "tag",
                            title: "Category",
                            value: item.category.displayName
                        )
                        
                        DetailCard(
                            icon: "location",
                            title: "Storage Location",
                            value: item.location
                        )
                        
                        if !item.condition.isEmpty {
                            DetailCard(
                                icon: "checkmark.seal",
                                title: "Condition",
                                value: item.condition
                            )
                        }
                        
                        if !item.comment.isEmpty {
                            DetailCard(
                                icon: "text.bubble",
                                title: "Comment",
                                value: item.comment,
                                isMultiline: true
                            )
                        }
                        
                        DetailCard(
                            icon: "calendar",
                            title: "Added",
                            value: formatDate(item.dateCreated)
                        )
                        
                        if item.dateModified != item.dateCreated {
                            DetailCard(
                                icon: "clock",
                                title: "Last Modified",
                                value: formatDate(item.dateModified)
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            showingEditView = true
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Edit Item")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(AppColors.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [AppColors.lightBlue, AppColors.orange]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Delete Item")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(AppColors.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.destructiveButton)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
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
                            .font(.system(size: 16, weight: .medium))
                        Text("Back")
                            .font(.ubuntu(16))
                    }
                    .foregroundColor(AppColors.lightBlue)
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
    
    private func categoryIcon(for category: ItemCategory) -> String {
        switch category {
        case .tools: return "wrench.and.screwdriver"
        case .carCare: return "drop"
        case .spareParts: return "gearshape"
        case .other: return "cube.box"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct DetailCard: View {
    let icon: String
    let title: String
    let value: String
    let isMultiline: Bool
    
    init(icon: String, title: String, value: String, isMultiline: Bool = false) {
        self.icon = icon
        self.title = title
        self.value = value
        self.isMultiline = isMultiline
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(AppColors.lightBlue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
                
                Text(value)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.white)
                    .fixedSize(horizontal: false, vertical: isMultiline)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
        )
    }
}
