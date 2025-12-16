import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var selectedTab: TabItem = .sets
    
    var body: some View {
        ZStack {
            if appViewModel.showOnboarding {
                OnboardingView(appViewModel: appViewModel)
            } else {
                mainContent
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private var mainContent: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .sets:
                    NavigationStack {
                        MySetsView(appViewModel: appViewModel)
                            .navigationBarHidden(true)
                    }
                case .products:
                    NavigationStack {
                        ProductsView(appViewModel: appViewModel)
                            .navigationBarHidden(true)
                    }
                case .notes:
                    NotesView(appViewModel: appViewModel)
                case .search:
                    NavigationStack {
                        SearchView(appViewModel: appViewModel)
                            .navigationBarHidden(true)
                    }
                case .settings:
                    SettingsView()
                }
            }
            
        VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

struct SearchView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var searchText = ""
    @State private var selectedNoteId: UUID?
    
    private var searchResults: (sets: [CosmeticSet], products: [Product], notes: [Note]) {
        if searchText.isEmpty {
            return ([], [], [])
        }
        
        let sets = appViewModel.cosmeticSets.filter { 
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.comment.localizedCaseInsensitiveContains(searchText)
        }
        
        let products = appViewModel.products.filter { 
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.comment.localizedCaseInsensitiveContains(searchText)
        }
        
        let notes = appViewModel.notes.filter { 
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.content.localizedCaseInsensitiveContains(searchText)
        }
        
        return (sets, products, notes)
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                Text("Search")
                    .font(.titleLarge)
                    .foregroundColor(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.textSecondary)
                    
                    TextField("Search sets, products, notes...", text: $searchText)
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.cardBorder, lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                if searchText.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(.textSecondary)
                        
                        Text("Start typing to search")
                            .font(.titleMedium)
                            .foregroundColor(.textPrimary)
                        
                        Text("Find your sets, products, and notes")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            let results = searchResults
                            
                            if !results.sets.isEmpty {
                                SearchSection(title: "Sets") {
                                    ForEach(results.sets) { set in
                                        NavigationLink(destination: SetDetailView(appViewModel: appViewModel, setId: set.id)) {
                                            SetCardView(set: set) {}
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            
                            if !results.products.isEmpty {
                                SearchSection(title: "Products") {
                                    ForEach(results.products) { product in
                                        NavigationLink(destination: ProductDetailView(productId: product.id, appViewModel: appViewModel)) {
                                            ProductCardView(product: product) {
                                                appViewModel.deleteProduct(product)
                                            }
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            
                            if !results.notes.isEmpty {
                                SearchSection(title: "Notes") {
                                    ForEach(results.notes) { note in
                                        NoteCardView(note: note, onTap: {
                                            selectedNoteId = note.id
                                        }, onDelete: {
                                            appViewModel.deleteNote(note)
                                        })
                                    }
                                }
                            }
                            
                            if results.sets.isEmpty && results.products.isEmpty && results.notes.isEmpty {
                                VStack(spacing: 20) {
                                    Image(systemName: "questionmark.circle")
                                        .font(.system(size: 60, weight: .light))
                                        .foregroundColor(.textSecondary)
                                    
                                    Text("No results found")
                                        .font(.titleMedium)
                                        .foregroundColor(.textPrimary)
                                    
                                    Text("Try different keywords")
                                        .font(.bodyMedium)
                                        .foregroundColor(.textSecondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 60)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(item: Binding(
            get: { selectedNoteId.map { NoteIdentifier(id: $0) } },
            set: { selectedNoteId = $0?.id }
        )) { identifier in
            NoteDetailView(noteId: identifier.id, appViewModel: appViewModel)
        }
    }
}

struct SearchSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.titleSmall)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                content
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppViewModel())
}
