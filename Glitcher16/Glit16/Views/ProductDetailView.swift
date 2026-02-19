import SwiftUI

struct ProductDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var productViewModel: ProductViewModel
    
    let productId: UUID
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var product: Product? {
        productViewModel.getProduct(by: productId)
    }
    
    var body: some View {
        Group {
            if let product = product {
                NavigationView {
                    ZStack {
                        AppColorScheme.background
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(spacing: 25) {
                                VStack(spacing: 20) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Category")
                                            .font(.playfairDisplay(14, weight: .medium))
                                            .foregroundColor(.textSecondary)
                                        
                                        Text(product.category)
                                            .font(.playfairDisplay(18, weight: .semibold))
                                            .foregroundColor(.textPrimary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Divider()
                                        .background(Color.cardBorder)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Rating")
                                            .font(.playfairDisplay(14, weight: .medium))
                                            .foregroundColor(.textSecondary)
                                        
                                        HStack(spacing: 4) {
                                            ForEach(1...5, id: \.self) { star in
                                                Image(systemName: star <= product.rating ? "star.fill" : "star")
                                                    .font(.title3)
                                                    .foregroundColor(star <= product.rating ? .primaryYellow : .textSecondary)
                                            }
                                            
                                            Text("(\(product.rating)/5)")
                                                .font(.playfairDisplay(16, weight: .medium))
                                                .foregroundColor(.textSecondary)
                                                .padding(.leading, 8)
                                            
                                            Spacer()
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Divider()
                                        .background(Color.cardBorder)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Expiration Date")
                                            .font(.playfairDisplay(14, weight: .medium))
                                            .foregroundColor(.textSecondary)
                                        
                                        HStack {
                                            Text("Valid until: \(product.formattedExpirationDate)")
                                                .font(.playfairDisplay(18, weight: .semibold))
                                                .foregroundColor(product.isExpired ? .red : 
                                                               product.isExpiringSoon ? .orange : .textPrimary)
                                            
                                            Spacer()
                                            
                                            if product.isExpired {
                                                Text("Expired")
                                                    .font(.playfairDisplay(12, weight: .medium))
                                                    .foregroundColor(.red)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background(Color.red.opacity(0.2))
                                                    .cornerRadius(6)
                                            } else if product.isExpiringSoon {
                                                Text("Expires Soon")
                                                    .font(.playfairDisplay(12, weight: .medium))
                                                    .foregroundColor(.orange)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background(Color.orange.opacity(0.2))
                                                    .cornerRadius(6)
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Divider()
                                        .background(Color.cardBorder)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Comment")
                                            .font(.playfairDisplay(14, weight: .medium))
                                            .foregroundColor(.textSecondary)
                                        
                                        if product.comment.isEmpty {
                                            Text("No comment available")
                                                .font(.playfairDisplay(16, weight: .regular))
                                                .foregroundColor(.textSecondary)
                                                .italic()
                                        } else {
                                            Text(product.comment)
                                                .font(.playfairDisplay(16, weight: .regular))
                                                .foregroundColor(.textPrimary)
                                                .lineSpacing(4)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(20)
                                .background(AppColorScheme.cardGradient)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.cardBorder, lineWidth: 1)
                                )
                                
                                VStack(spacing: 15) {
                                    Button(action: {
                                        showingEditView = true
                                    }) {
                                        HStack {
                                            Image(systemName: "pencil")
                                                .font(.title3)
                                            
                                            Text("Edit")
                                                .font(.playfairDisplay(18, weight: .semibold))
                                        }
                                        .foregroundColor(.primaryPink)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(Color.primaryYellow)
                                        .cornerRadius(25)
                                    }
                                    
                                    Button(action: {
                                        showingDeleteAlert = true
                                    }) {
                                        HStack {
                                            Image(systemName: "trash")
                                                .font(.title3)
                                            
                                            Text("Delete")
                                                .font(.playfairDisplay(18, weight: .semibold))
                                        }
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(Color.buttonDanger)
                                        .cornerRadius(25)
                                    }
                                }
                                .padding(.top, 10)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                        }
                    }
                    .navigationTitle(product.name)
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Back") {
                                dismiss()
                            }
                            .foregroundColor(.textSecondary)
                        }
                    }
                    .preferredColorScheme(.dark)
                }
                .sheet(isPresented: $showingEditView) {
                    EditProductView(product: product)
                        .environmentObject(productViewModel)
                }
                .alert("Delete Product", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        productViewModel.deleteProduct(product)
                        dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete \"\(product.name)\"? This action cannot be undone.")
                }
            } else {
                NavigationView {
                    ZStack {
                        AppColorScheme.background
                            .ignoresSafeArea()
                        
                        VStack(spacing: 20) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 60))
                                .foregroundColor(.textSecondary)
                            
                            Text("Product not found")
                                .font(.playfairDisplay(24, weight: .bold))
                                .foregroundColor(.textPrimary)
                            
                            Text("This product may have been deleted")
                                .font(.playfairDisplay(16, weight: .regular))
                                .foregroundColor(.textSecondary)
                            
                            Button("Back") {
                                dismiss()
                            }
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(.primaryPink)
                            .frame(width: 200, height: 50)
                            .background(Color.primaryYellow)
                            .cornerRadius(25)
                            .padding(.top, 20)
                        }
                    }
                    .navigationTitle("Error")
                    .navigationBarTitleDisplayMode(.inline)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        dismiss()
                    }
                }
            }
        }
    }
}
