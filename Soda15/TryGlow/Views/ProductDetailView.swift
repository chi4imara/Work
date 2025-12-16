import SwiftUI

struct ProductDetailView: View {
    let product: BeautyProduct
    @ObservedObject var viewModel: BeautyProductViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingEdit = false
    @State private var showingDeleteAlert = false
    
    private let colorManager = ColorManager.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                colorManager.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: product.category.icon)
                                    .font(.system(size: 24))
                                    .foregroundColor(colorManager.primaryWhite)
                                
                                Text(product.category.rawValue)
                                    .font(.custom("PlayfairDisplay-Medium", size: 16))
                                    .foregroundColor(colorManager.primaryWhite)
                                
                                Spacer()
                            }
                            
                            Text(product.name)
                                .font(.custom("PlayfairDisplay-Bold", size: 28))
                                .foregroundColor(colorManager.primaryWhite)
                                .multilineTextAlignment(.leading)
                        }
                        
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Rating")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                .foregroundColor(colorManager.primaryWhite)
                            
                            HStack(spacing: 4) {
                                ForEach(1...5, id: \.self) { star in
                                    Image(systemName: star <= product.rating ? "star.fill" : "star")
                                        .font(.system(size: 20))
                                        .foregroundColor(star <= product.rating ? colorManager.primaryYellow : colorManager.primaryWhite.opacity(0.3))
                                }
                                
                                Text("(\(product.rating)/5)")
                                    .font(.custom("PlayfairDisplay-Medium", size: 16))
                                    .foregroundColor(colorManager.primaryWhite)
                                    .padding(.leading, 8)
                                
                                Spacer()
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Impressions")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                .foregroundColor(colorManager.primaryWhite)
                            
                            Text(product.description.isEmpty ? "No description provided." : product.description)
                                .font(.custom("PlayfairDisplay-Regular", size: 16))
                                .foregroundColor(colorManager.primaryWhite)
                                .opacity(product.description.isEmpty ? 0.7 : 1.0)
                                .italic(product.description.isEmpty)
                                .multilineTextAlignment(.leading)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                .foregroundColor(colorManager.primaryWhite)
                            
                            Text(product.comment.isEmpty ? "No comments yet." : product.comment)
                                .font(.custom("PlayfairDisplay-Regular", size: 16))
                                .foregroundColor(colorManager.primaryWhite)
                                .opacity(product.comment.isEmpty ? 0.7 : 1.0)
                                .italic(product.comment.isEmpty)
                                .multilineTextAlignment(.leading)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date Added")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                .foregroundColor(colorManager.primaryWhite)
                            
                            Text(product.dateAdded, style: .date)
                                .font(.custom("PlayfairDisplay-Regular", size: 16))
                                .foregroundColor(colorManager.primaryWhite.opacity(0.8))
                        }
                        
                        VStack(spacing: 15) {
                            Button(action: {
                                showingEdit = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 16))
                                    
                                    Text("Edit")
                                        .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                }
                                .foregroundColor(colorManager.secondaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(colorManager.primaryWhite)
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.2), radius: 5)
                            }
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(.system(size: 16))
                                    
                                    Text("Delete")
                                        .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                }
                                .foregroundColor(colorManager.primaryWhite)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(colorManager.secondaryPink.opacity(0.8))
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.2), radius: 5)
                            }
                        }
                        .padding(.top, 20)
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Discovery Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(colorManager.primaryWhite)
                }
            }
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $showingEdit) {
            EditProductView(product: product, viewModel: viewModel)
        }
        .alert("Delete this discovery?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteProduct(product)
                dismiss()
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
}

#Preview {
    ProductDetailView(
        product: BeautyProduct(
            name: "Vitamin C Serum",
            category: .skincare,
            description: "Light texture, absorbs quickly, skin feels soft after application",
            rating: 5,
            comment: "Use every morning, excellent results."
        ),
        viewModel: BeautyProductViewModel()
    )
}
