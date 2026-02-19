import SwiftUI

struct PurchaseDetailView: View {
    let purchaseId: UUID
    @ObservedObject var viewModel: PurchaseViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var purchase: Purchase? {
        viewModel.getPurchase(by: purchaseId)
    }
    
    var body: some View {
        Group {
            if let purchase = purchase {
                ZStack {
                    ColorTheme.backgroundGradient
                        .ignoresSafeArea()
                    
                    ForEach(0..<5, id: \.self) { index in
                        Circle()
                            .fill(ColorTheme.white.opacity(0.1))
                            .frame(width: CGFloat.random(in: 6...15))
                            .position(
                                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                                y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                            )
                            .animation(
                                Animation.linear(duration: Double.random(in: 6...12))
                                    .repeatForever(autoreverses: false),
                                value: UUID()
                            )
                    }
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(ColorTheme.yellow)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(purchase.date, style: .date)
                                            .font(.ubuntu(18, weight: .medium))
                                            .foregroundColor(ColorTheme.white)
                                        
                                        Text(purchase.date, style: .time)
                                            .font(.ubuntu(14, weight: .regular))
                                            .foregroundColor(ColorTheme.white.opacity(0.7))
                                    }
                                    
                                    Spacer()
                                }
                                .padding(20)
                                .background(ColorTheme.cardBackground.opacity(0.1))
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(ColorTheme.white.opacity(0.2), lineWidth: 1)
                                )
                            }
                            
                            DetailSectionView(
                                title: "What bought",
                                content: purchase.whatBought,
                                icon: "bag.fill"
                            )
                            
                            if !purchase.whereBought.isEmpty {
                                DetailSectionView(
                                    title: "Where bought",
                                    content: purchase.whereBought,
                                    icon: "location.fill"
                                )
                            }
                            
                            if !purchase.whyBought.isEmpty {
                                DetailSectionView(
                                    title: "Why bought",
                                    content: purchase.whyBought,
                                    icon: "questionmark.circle.fill"
                                )
                            }
                            
                            VStack(spacing: 16) {
                                Button(action: {
                                    showingEditView = true
                                }) {
                                    HStack {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 16, weight: .medium))
                                        Text("Edit")
                                            .font(.ubuntu(16, weight: .medium))
                                    }
                                    .foregroundColor(ColorTheme.primaryBlue)
                                    .frame(height: 48)
                                    .frame(maxWidth: .infinity)
                                    .background(ColorTheme.white)
                                    .cornerRadius(24)
                                    .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
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
                                    .foregroundColor(ColorTheme.white)
                                    .frame(height: 48)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red.opacity(0.8))
                                    .cornerRadius(24)
                                    .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
                                }
                            }
                            .padding(.top, 20)
                            
                            Spacer(minLength: 50)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
                .navigationTitle("Purchase")
                .navigationBarTitleDisplayMode(.inline)
                .preferredColorScheme(.dark)
                .sheet(isPresented: $showingEditView) {
                    AddEditPurchaseView(viewModel: viewModel, purchaseToEdit: purchase)
                }
                .alert("Delete Purchase", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        viewModel.deletePurchase(purchase)
                        presentationMode.wrappedValue.dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete this purchase? This action cannot be undone.")
                }
            } else {
                ZStack {
                    ColorTheme.backgroundGradient
                        .ignoresSafeArea()
                    
                    VStack(spacing: 24) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(ColorTheme.white.opacity(0.7))
                        
                        Text("Purchase not found")
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(ColorTheme.white)
                    }
                }
                .navigationTitle("Purchase")
                .navigationBarTitleDisplayMode(.inline)
                .preferredColorScheme(.dark)
            }
        }
    }
}

struct DetailSectionView: View {
    let title: String
    let content: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorTheme.yellow)
                
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.white.opacity(0.8))
                
                Spacer()
            }
            
            Text(content)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(ColorTheme.white)
                .lineSpacing(2)
        }
        .padding(20)
        .background(ColorTheme.cardBackground.opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.white.opacity(0.2), lineWidth: 1)
        )
    }
}
