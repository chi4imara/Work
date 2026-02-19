import SwiftUI

struct JewelryDetailView: View {
    let itemId: UUID
    @ObservedObject var store: JewelryStore
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var item: JewelryItem? {
        store.getItem(by: itemId)
    }
    
    var body: some View {
        Group {
            if let item = item {
                detailContent(for: item)
            } else {
                Text("Jewelry not found")
                    .font(.bauhausBold(size: 18))
                    .foregroundColor(AppColors.primaryWhite)
            }
        }
    }
    
    @ViewBuilder
    private func detailContent(for item: JewelryItem) -> some View {
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
                    
                    Text(item.name.count > 20 ? String(item.name.prefix(20)) + "..." : item.name)
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
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Name")
                                    .font(.bauhausBold(size: 14))
                                    .foregroundColor(AppColors.darkGray.opacity(0.7))
                                
                                Text(item.name)
                                    .font(.bauhausBold(size: 20))
                                    .foregroundColor(AppColors.darkGray)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Category")
                                    .font(.bauhausBold(size: 14))
                                    .foregroundColor(AppColors.darkGray.opacity(0.7))
                                
                                Text(item.displayCategory)
                                    .font(.bauhausRegular(size: 18))
                                    .foregroundColor(AppColors.darkGray)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.bauhausBold(size: 14))
                                    .foregroundColor(AppColors.darkGray.opacity(0.7))
                                
                                Text(item.description.isEmpty ? "No description" : item.description)
                                    .font(.bauhausRegular(size: 16))
                                    .foregroundColor(item.description.isEmpty ? AppColors.darkGray.opacity(0.6) : AppColors.darkGray)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Last Worn")
                                    .font(.bauhausBold(size: 14))
                                    .foregroundColor(AppColors.darkGray.opacity(0.7))
                                
                                Text(item.lastWornText)
                                    .font(.bauhausRegular(size: 16))
                                    .foregroundColor(item.hasBeenWorn ? AppColors.darkGray : AppColors.darkGray.opacity(0.6))
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.cardBackground)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        )
                        
                        VStack(spacing: 16) {
                            Button(action: {
                                store.markAsWornToday(item)
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle")
                                        .font(.system(size: 18, weight: .semibold))
                                    
                                    Text("Mark as worn today")
                                        .font(.bauhausBold(size: 16))
                                }
                                .foregroundColor(AppColors.buttonText)
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.buttonBackground)
                                        .shadow(radius: 3)
                                )
                            }
                            
                            Button(action: {
                                showingEditView = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 18, weight: .semibold))
                                    
                                    Text("Edit")
                                        .font(.bauhausBold(size: 16))
                                }
                                .foregroundColor(AppColors.primaryWhite)
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.darkGray)
                                        .shadow(radius: 3)
                                )
                            }
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(.system(size: 18, weight: .semibold))
                                    
                                    Text("Delete")
                                        .font(.bauhausBold(size: 16))
                                }
                                .foregroundColor(AppColors.primaryWhite)
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.deleteRed)
                                        .shadow(radius: 3)
                                )
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditView) {
            EditJewelryView(item: item, store: store)
        }
        .alert("Delete Jewelry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                store.deleteItem(item)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this jewelry item? This action cannot be undone.")
        }
    }
}

#Preview {
    let store = JewelryStore()
    let sampleItem = JewelryItem(
        name: "Diamond Earrings",
        category: .earrings,
        description: "Beautiful diamond earrings for special occasions",
        lastWornDate: Date()
    )
    store.addItem(sampleItem)
    
    return JewelryDetailView(itemId: sampleItem.id, store: store)
}
