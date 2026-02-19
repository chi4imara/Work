import SwiftUI
import StoreKit

struct BagDetailView: View {
    let bagId: UUID
    @ObservedObject var bagStore: BagStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var bag: Bag? {
        bagStore.bags.first { $0.id == bagId }
    }
    
    var body: some View {
        Group {
            if let bag = bag {
                bagDetailContent(bag: bag)
            } else {
                VStack {
                    Text("Bag not found")
                        .font(.bellGothic(16))
                        .foregroundColor(.appTextDark)
                    
                    Button("Close") {
                        dismiss()
                    }
                    .font(.bellGothic(16, weight: .bold))
                    .foregroundColor(.appPrimaryBlue)
                    .padding()
                }
            }
        }
    }
    
    @ViewBuilder
    private func bagDetailContent(bag: Bag) -> some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        if let image = bag.image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 250)
                                .clipped()
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        }
                        
                        VStack(spacing: 20) {
                            InfoCard {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Size")
                                                .font(.bellGothic(14))
                                                .foregroundColor(.appTextDark)
                                            Text(bag.size.displayName)
                                                .font(.bellGothic(18, weight: .bold))
                                                .foregroundColor(.appDarkBlue)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 4) {
                                            Text("Style")
                                                .font(.bellGothic(14))
                                                .foregroundColor(.appTextDark)
                                            Text(bag.style.displayName)
                                                .font(.bellGothic(18, weight: .bold))
                                                .foregroundColor(.appDarkBlue)
                                        }
                                    }
                                    
                                    Divider()
                                        .background(Color.appSoftGray)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Suitable For")
                                            .font(.bellGothic(14))
                                            .foregroundColor(.appTextDark)
                                        Text(bag.suitableFor)
                                            .font(.bellGothic(16))
                                            .foregroundColor(.appDarkBlue)
                                    }
                                }
                            }
                            
                            if !bag.notes.isEmpty {
                                InfoCard {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Notes")
                                            .font(.bellGothic(16, weight: .bold))
                                            .foregroundColor(.appDarkBlue)
                                        
                                        Text(bag.notes)
                                            .font(.bellGothic(14))
                                            .foregroundColor(.appTextDark)
                                            .lineSpacing(2)
                                    }
                                }
                            }
                            
                            VStack(spacing: 16) {
                                Button(action: {
                                    bagStore.toggleFavorite(for: bag)
                                }) {
                                    HStack {
                                        Image(systemName: bag.isFavorite ? "heart.fill" : "heart")
                                            .font(.system(size: 18, weight: .bold))
                                        Text(bag.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                                            .font(.bellGothic(16, weight: .bold))
                                    }
                                    .foregroundColor(bag.isFavorite ? .red : .appDarkBlue)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(bag.isFavorite ? Color.red.opacity(0.1) : Color.appAccentYellow)
                                    .cornerRadius(25)
                                    .shadow(color: (bag.isFavorite ? Color.red : Color.appAccentYellow).opacity(0.3), radius: 5, x: 0, y: 2)
                                }
                                
                                Button(action: {
                                    showingEditView = true
                                }) {
                                    HStack {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 18, weight: .bold))
                                        Text("Edit")
                                            .font(.bellGothic(16, weight: .bold))
                                    }
                                    .foregroundColor(.appDarkBlue)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.appLightBlue)
                                    .cornerRadius(25)
                                    .shadow(color: Color.appLightBlue.opacity(0.5), radius: 5, x: 0, y: 2)
                                }
                                
                                Button(action: {
                                    showingDeleteAlert = true
                                }) {
                                    HStack {
                                        Image(systemName: "trash")
                                            .font(.system(size: 18, weight: .bold))
                                        Text("Delete")
                                            .font(.bellGothic(16, weight: .bold))
                                    }
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(25)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .strokeBorder(Color.red.opacity(0.3), lineWidth: 1)
                                    )
                                }
                            }
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(bag.name)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                            Text("Back")
                                .font(.bellGothic(16))
                        }
                        .foregroundColor(.appPrimaryBlue)
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            if let currentBag = self.bag {
                AddEditBagView(bagStore: bagStore, bagToEdit: currentBag)
            }
        }
        .alert("Delete Bag", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let currentBag = self.bag {
                    bagStore.deleteBag(currentBag)
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this bag? This action cannot be undone.")
        }
    }
}

struct InfoCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
