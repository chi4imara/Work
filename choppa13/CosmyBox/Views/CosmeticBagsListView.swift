import SwiftUI

enum CosmeticBagsSheetItem: Identifiable {
    case createBag
    case editBag(CosmeticBag)
    
    var id: String {
        switch self {
        case .createBag:
            return "createBag"
        case .editBag(let bag):
            return "editBag-\(bag.id.uuidString)"
        }
    }
}

struct CosmeticBagsListView: View {
    @ObservedObject var viewModel: CosmeticBagViewModel
    @State private var sheetItem: CosmeticBagsSheetItem?
    @State private var bagToDelete: CosmeticBag?
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 8) {
                        Text("My Cosmetic Bags")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(Color.theme.primaryWhite)
                        
                        Text("Catalog by purpose")
                            .font(.ubuntu(16, weight: .regular))
                            .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                        sheetItem = .createBag
                    }) {
                        HStack {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .medium))
                            Text("Create Cosmetic Bag")
                                .font(.ubuntu(16, weight: .medium))
                        }
                        .foregroundColor(Color.theme.primaryWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.theme.buttonGradient)
                        .cornerRadius(25)
                        .shadow(color: Color.theme.primaryPurple.opacity(0.3), radius: 6, x: 0, y: 3)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 8)
                    
                    if viewModel.cosmeticBags.isEmpty {
                        EmptyBagsView {
                            sheetItem = .createBag
                        }
                    } else {
                        BagsListContent(
                            bags: viewModel.cosmeticBags,
                            viewModel: viewModel,
                            onEdit: { bag in
                                sheetItem = .editBag(bag)
                            },
                            onDelete: { bag in
                                bagToDelete = bag
                                showingDeleteAlert = true
                            }
                        )
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(item: $sheetItem) { item in
            switch item {
            case .createBag:
                CreateCosmeticBagView(viewModel: viewModel)
            case .editBag(let bag):
                CreateCosmeticBagView(viewModel: viewModel, bagToEdit: bag)
            }
        }
        .alert("Delete Cosmetic Bag", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let bag = bagToDelete {
                    viewModel.deleteCosmeticBag(bag)
                }
            }
        } message: {
            Text("Are you sure you want to delete this cosmetic bag? This action cannot be undone.")
        }
    }
}

struct EmptyBagsView: View {
    let onCreateTap: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "bag.fill")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(Color.theme.primaryYellow)
                
                VStack(spacing: 12) {
                    Text("No cosmetic bags yet")
                        .font(.ubuntu(22, weight: .bold))
                        .foregroundColor(Color.theme.primaryWhite)
                    
                    Text("Create your first one — for example, \"Daily\" or \"Travel\".")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 40)
                
                Button(action: onCreateTap) {
                    HStack {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .medium))
                        Text("Create Cosmetic Bag")
                            .font(.ubuntu(16, weight: .medium))
                    }
                    .foregroundColor(Color.theme.primaryWhite)
                    .frame(width: 200, height: 50)
                    .background(Color.theme.buttonGradient)
                    .cornerRadius(25)
                    .shadow(color: Color.theme.primaryPurple.opacity(0.3), radius: 6, x: 0, y: 3)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct BagsListContent: View {
    let bags: [CosmeticBag]
    let viewModel: CosmeticBagViewModel
    let onEdit: (CosmeticBag) -> Void
    let onDelete: (CosmeticBag) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(bags) { bag in
                    NavigationLink(destination: CosmeticBagDetailView(viewModel: viewModel, bag: bag)) {
                        CosmeticBagCard(
                            bag: bag,
                            onEdit: { onEdit(bag) },
                            onDelete: { onDelete(bag) }
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 200)
        }
        .padding(.bottom, -100)
    }
}

struct CosmeticBagCard: View {
    let bag: CosmeticBag
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            HStack {
                VStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.theme.primaryWhite)
                    Text("Edit")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(Color.theme.primaryWhite)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.theme.accentOrange)
                .cornerRadius(16)
                .padding(.leading, 20)
                
                Spacer()
            }
            .opacity(offset > 10 ? min(offset / 100, 1.0) : 0.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: offset)
            
            HStack {
                Spacer()
                
                VStack {
                    Image(systemName: "trash")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.theme.primaryWhite)
                    Text("Delete")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(Color.theme.primaryWhite)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.theme.accentRed)
                .cornerRadius(16)
                .padding(.trailing, 20)
            }
            .opacity(offset < -10 ? min(abs(offset) / 100, 1.0) : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: offset)
            
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(bag.colorTag.color)
                    .frame(width: 6, height: 60)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(bag.name)
                            .font(.ubuntu(18, weight: .bold))
                            .foregroundColor(Color.theme.darkGray)
                        
                        Spacer()
                        
                        if bag.isActive {
                            Text("Active")
                                .font(.ubuntu(12, weight: .medium))
                                .foregroundColor(Color.theme.accentGreen)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.theme.accentGreen.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                    
                    Text(bag.purpose.displayName)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(Color.theme.darkGray.opacity(0.7))
                    
                    Text("\(bag.productCount) products")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(bag.colorTag.color)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.darkGray.opacity(0.5))
            }
            .padding(20)
            .frame(height: 100)
            .background(Color.theme.cardGradient)
            .cornerRadius(16)
            .shadow(color: Color.theme.primaryPurple.opacity(0.1), radius: 8, x: 0, y: 4)
            .offset(x: offset, y: 0)
            .highPriorityGesture(
            DragGesture(minimumDistance: 30)
                .onChanged { value in
                    let translation: CGFloat = value.translation.width
                    if translation > 0 {
                        let ratio: CGFloat = translation / 200.0
                        let clampedRatio = ratio.clamped(to: 0.0...0.5)
                        let resistance: CGFloat = 1.0 - clampedRatio
                        offset = min(translation * resistance, 100)
                    } else {
                        let ratio: CGFloat = abs(translation) / 200.0
                        let clampedRatio = ratio.clamped(to: 0.0...0.5)
                        let resistance: CGFloat = 1.0 - clampedRatio
                        offset = max(translation * resistance, -100)
                    }
                }
                .onEnded { value in
                    let translation = value.translation.width
                    let velocity = value.predictedEndTranslation.width - value.translation.width
                    
                    let threshold: CGFloat = 60
                    let velocityThreshold: CGFloat = 300
                    
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        if abs(velocity) > velocityThreshold {
                            if velocity > 0 {
                                offset = 0
                                onEdit()
                            } else {
                                offset = 0
                                onDelete()
                            }
                        } else if translation > threshold {
                            offset = 0
                            onEdit()
                        } else if translation < -threshold {
                            offset = 0
                            onDelete()
                        } else {
                            offset = 0
                        }
                    }
                }
            )
        }
    }
}

#Preview {
    CosmeticBagsListView(viewModel: CosmeticBagViewModel())
}
