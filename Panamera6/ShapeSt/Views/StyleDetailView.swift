import SwiftUI

struct StyleDetailView: View {
    let styleId: UUID
    @ObservedObject var viewModel: StyleViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingEditView = false
    @State private var isShowingDeleteAlert = false
    
    var style: Style? {
        viewModel.styles.first { $0.id == styleId }
    }
    
    var body: some View {
        Group {
            if let currentStyle = style {
                ZStack {
                    ColorTheme.backgroundGradient
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            HStack {
                                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(ColorTheme.white)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.toggleFavorite(for: currentStyle)
                                }) {
                                    Image(systemName: currentStyle.isFavorite ? "heart.fill" : "heart")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(currentStyle.isFavorite ? ColorTheme.orange : ColorTheme.white)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                            
                            VStack(spacing: 20) {
                                VStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(ColorTheme.orange.opacity(0.2))
                                            .frame(width: 100, height: 100)
                                        
                                        Image(systemName: currentStyle.category == .haircut ? "scissors" : "mustache")
                                            .font(.system(size: 40, weight: .medium))
                                            .foregroundColor(ColorTheme.orange)
                                    }
                                    
                                    VStack(spacing: 8) {
                                        Text(currentStyle.name)
                                            .font(.lumierepolis(size: 28, weight: .bold))
                                            .foregroundColor(ColorTheme.white)
                                            .multilineTextAlignment(.center)
                                        
                                        HStack {
                                            Text(currentStyle.category.displayName)
                                                .font(.lumierepolis(size: 16))
                                                .foregroundColor(ColorTheme.accent)
                                            
                                            if currentStyle.isFavorite {
                                                Image(systemName: "heart.fill")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(ColorTheme.orange)
                                            }
                                        }
                                    }
                                }
                                
                                VStack(spacing: 16) {
                                    DetailCard(title: "Length", value: currentStyle.length, icon: "ruler")
                                    DetailCard(title: "Shape", value: currentStyle.shape, icon: "scissors.badge.ellipsis")
                                    
                                    if !currentStyle.description.isEmpty {
                                        DescriptionCard(description: currentStyle.description)
                                    } else {
                                        EmptyDescriptionCard()
                                    }
                                }
                                
                                VStack(spacing: 12) {
                                    Button(action: { isShowingEditView = true }) {
                                        HStack {
                                            Image(systemName: "pencil")
                                                .font(.system(size: 16, weight: .medium))
                                            
                                            Text("Edit Style")
                                                .font(.lumierepolis(size: 18, weight: .bold))
                                        }
                                        .foregroundColor(ColorTheme.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(ColorTheme.orange)
                                        )
                                    }
                                    
                                    Button(action: {
                                        viewModel.toggleFavorite(for: currentStyle)
                                    }) {
                                        HStack {
                                            Image(systemName: currentStyle.isFavorite ? "heart.slash" : "heart")
                                                .font(.system(size: 16, weight: .medium))
                                            
                                            Text(currentStyle.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                                                .font(.lumierepolis(size: 16))
                                        }
                                        .foregroundColor(ColorTheme.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(ColorTheme.cardBackground)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(ColorTheme.white.opacity(0.2), lineWidth: 1)
                                                )
                                        )
                                    }
                                    
                                    Button(action: {
                                        isShowingDeleteAlert = true
                                    }) {
                                        HStack {
                                            Image(systemName: "trash")
                                                .font(.system(size: 16, weight: .medium))
                                            
                                            Text("Delete Style")
                                                .font(.lumierepolis(size: 16))
                                        }
                                        .foregroundColor(ColorTheme.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color.red.opacity(0.2))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.red.opacity(0.5), lineWidth: 1)
                                                )
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 40)
                        }
                    }
                }
                .navigationBarHidden(true)
                .sheet(isPresented: $isShowingEditView) {
                    EditStyleView(styleId: currentStyle.id, viewModel: viewModel)
                }
                .alert("Delete Style", isPresented: $isShowingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        viewModel.deleteStyle(byId: currentStyle.id)
                        presentationMode.wrappedValue.dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete \"\(currentStyle.name)\"? This action cannot be undone.")
                }
            } else {
                Text("Style not found")
                    .foregroundColor(ColorTheme.white)
            }
        }
    }
}

struct DetailCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(ColorTheme.orange)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.lumierepolis(size: 14))
                    .foregroundColor(ColorTheme.white.opacity(0.7))
                
                Text(value)
                    .font(.lumierepolis(size: 18, weight: .bold))
                    .foregroundColor(ColorTheme.white)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorTheme.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct DescriptionCard: View {
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "note.text")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(ColorTheme.orange)
                
                Text("Description")
                    .font(.lumierepolis(size: 16, weight: .bold))
                    .foregroundColor(ColorTheme.white)
                
                Spacer()
            }
            
            Text(description)
                .font(.lumierepolis(size: 16))
                .foregroundColor(ColorTheme.white.opacity(0.9))
                .lineLimit(nil)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorTheme.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct EmptyDescriptionCard: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "note.text")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(ColorTheme.orange.opacity(0.6))
                
                Text("Description")
                    .font(.lumierepolis(size: 16, weight: .bold))
                    .foregroundColor(ColorTheme.white.opacity(0.6))
                
                Spacer()
            }
            
            Text("No description added")
                .font(.lumierepolis(size: 14))
                .foregroundColor(ColorTheme.white.opacity(0.5))
                .italic()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardBackground.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorTheme.white.opacity(0.05), lineWidth: 1)
                )
        )
    }
}
