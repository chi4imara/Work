import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: StyleViewModel
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Categories")
                        .font(.lumierepolis(size: 28, weight: .bold))
                        .foregroundColor(ColorTheme.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                if viewModel.styles.isEmpty {
                    EmptyCategoriesView()
                } else {
                    CategoriesList(viewModel: viewModel)
                }
            }
        }
    }
}

struct EmptyCategoriesView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "folder")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(ColorTheme.white.opacity(0.6))
                
                VStack(spacing: 8) {
                    Text("No Categories Available")
                        .font(.lumierepolis(size: 24, weight: .bold))
                        .foregroundColor(ColorTheme.white)
                    
                    Text("Add styles to see categories here")
                        .font(.lumierepolis(size: 16))
                        .foregroundColor(ColorTheme.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct CategoriesList: View {
    @ObservedObject var viewModel: StyleViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                CategorySection(title: "Main Categories") {
                    VStack(spacing: 12) {
                        let haircutCount = viewModel.styles.filter { $0.category == .haircut }.count
                        let beardCount = viewModel.styles.filter { $0.category == .beard }.count
                        
                        if haircutCount > 0 {
                            NavigationLink(destination: CategoryDetailView(
                                title: "Haircuts",
                                styles: viewModel.styles.filter { $0.category == .haircut },
                                viewModel: viewModel
                            )) {
                                CategoryRow(
                                    title: "Haircuts",
                                    count: haircutCount,
                                    icon: "scissors",
                                    color: ColorTheme.orange
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        if beardCount > 0 {
                            NavigationLink(destination: CategoryDetailView(
                                title: "Beards",
                                styles: viewModel.styles.filter { $0.category == .beard },
                                viewModel: viewModel
                            )) {
                                CategoryRow(
                                    title: "Beards",
                                    count: beardCount,
                                    icon: "mustache",
                                    color: ColorTheme.accent
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                let lengthGroups = Dictionary(grouping: viewModel.styles, by: { $0.length })
                if !lengthGroups.isEmpty {
                    CategorySection(title: "By Length") {
                        VStack(spacing: 12) {
                            ForEach(lengthGroups.keys.sorted(), id: \.self) { length in
                                if let styles = lengthGroups[length], !length.isEmpty {
                                    NavigationLink(destination: CategoryDetailView(
                                        title: "Length: \(length)",
                                        styles: styles,
                                        viewModel: viewModel
                                    )) {
                                        CategoryRow(
                                            title: "Length: \(length)",
                                            count: styles.count,
                                            icon: "ruler",
                                            color: ColorTheme.lightBlue
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                }
                
                let shapeGroups = Dictionary(grouping: viewModel.styles, by: { $0.shape })
                if !shapeGroups.isEmpty {
                    CategorySection(title: "By Shape") {
                        VStack(spacing: 12) {
                            ForEach(shapeGroups.keys.sorted(), id: \.self) { shape in
                                if let styles = shapeGroups[shape], !shape.isEmpty {
                                    NavigationLink(destination: CategoryDetailView(
                                        title: "Shape: \(shape)",
                                        styles: styles,
                                        viewModel: viewModel
                                    )) {
                                        CategoryRow(
                                            title: "Shape: \(shape)",
                                            count: styles.count,
                                            icon: "scissors.badge.ellipsis",
                                            color: ColorTheme.darkGray
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
}

struct CategorySection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.lumierepolis(size: 20, weight: .bold))
                .foregroundColor(ColorTheme.white)
                .padding(.horizontal, 4)
            
            content
        }
    }
}

struct CategoryRow: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(title == "Haircuts" ? color : .white)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(color.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.lumierepolis(size: 18, weight: .bold))
                    .foregroundColor(ColorTheme.white)
                
                Text("\(count) style\(count == 1 ? "" : "s")")
                    .font(.lumierepolis(size: 14))
                    .foregroundColor(ColorTheme.white.opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(ColorTheme.white.opacity(0.6))
        }
        .padding(16)
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

struct CategoryDetailView: View {
    let title: String
    let styles: [Style]
    @ObservedObject var viewModel: StyleViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(ColorTheme.white)
                    }
                    
                    Spacer()
                    
                    Text(title)
                        .font(.lumierepolis(size: 20, weight: .bold))
                        .foregroundColor(ColorTheme.white)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color.clear)
                    }
                    .disabled(true)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                if styles.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: "tray")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(ColorTheme.white.opacity(0.6))
                        
                        Text("No styles in this category")
                            .font(.lumierepolis(size: 18, weight: .bold))
                            .foregroundColor(ColorTheme.white)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(styles, id: \.id) { style in
                                NavigationLink(destination: StyleDetailView(styleId: style.id, viewModel: viewModel)) {
                                    StyleCard(styleId: style.id, viewModel: viewModel)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        viewModel.deleteStyle(byId: style.id)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100) 
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}
