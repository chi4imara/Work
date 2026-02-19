import SwiftUI

struct DiaryView: View {
    @ObservedObject var viewModel: ManicureViewModel
    @State private var showingAddManicure = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Diary")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorManager.white)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddManicure = true
                    }) {
                        Image(systemName: "plus")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(ColorManager.yellow)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                
                if viewModel.filteredManicures.isEmpty {
                    EmptyStateView(
                        title: "No records yet",
                        subtitle: "Add your first manicure",
                        systemImage: "paintbrush.pointed"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.filteredManicures) { manicure in
                                NavigationLink(destination: ManicureDetailView(manicureId: manicure.id, viewModel: viewModel)) {
                                    ManicureCard(manicureId: manicure.id, viewModel: viewModel)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 10)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddManicure) {
            AddManicureView(viewModel: viewModel)
        }
    }
}

struct ManicureCard: View {
    let manicureId: UUID
    @ObservedObject var viewModel: ManicureViewModel
    
    private var manicure: Manicure? {
        viewModel.manicures.first { $0.id == manicureId }
    }
    
    var body: some View {
        Group {
            if let manicure = manicure {
                cardContent(manicure: manicure)
            }
        }
    }
    
    private func cardContent(manicure: Manicure) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(manicure.designName)
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(ColorManager.white)
                        .lineLimit(2)
                    
                    Text(manicure.colorsString)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(ColorManager.yellow)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    if manicure.isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundColor(ColorManager.yellow)
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(ColorManager.mediumGray)
                }
            }
            
            HStack {
                Label(manicure.master.name, systemImage: "person.fill")
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(ColorManager.white.opacity(0.8))
                
                Spacer()
                
                Text(manicure.dateString)
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(ColorManager.white.opacity(0.6))
            }
            
            if !manicure.notes.isEmpty {
                Text(manicure.notes)
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(ColorManager.white.opacity(0.7))
                    .lineLimit(2)
            }
        }
        .padding(16)
        .background(ColorManager.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(ColorManager.cardBorder, lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(ColorManager.mediumGray)
            
            TextField("Search by design or master", text: $text)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(ColorManager.white)
        }
        .padding(12)
        .background(ColorManager.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(ColorManager.cardBorder, lineWidth: 1)
        )
        .cornerRadius(10)
    }
}

struct EmptyStateView: View {
    let title: String
    let subtitle: String
    let systemImage: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: systemImage)
                .font(.system(size: 60))
                .foregroundColor(ColorManager.mediumGray)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(ColorManager.white)
                
                Text(subtitle)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.white.opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    DiaryView(viewModel: ManicureViewModel())
}
