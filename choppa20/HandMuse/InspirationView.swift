import SwiftUI

struct InspirationView: View {
    @StateObject private var viewModel = InspirationViewModel()
    @State private var showingAddInspiration = false
    @State private var selectedInspirationId: UUID?
    @State private var editingInspiration: Inspiration?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    searchView
                    
                    if viewModel.filteredInspirations.isEmpty {
                        emptyStateView
                    } else {
                        inspirationsListView
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddInspiration) {
            AddInspirationView(viewModel: viewModel)
        }
        .sheet(item: Binding(
            get: { selectedInspirationId.map { InspirationDetailItem(id: $0) } },
            set: { selectedInspirationId = $0?.id }
        )) { item in
            InspirationDetailView(inspirationId: item.id, viewModel: viewModel)
        }
        .sheet(item: $editingInspiration) { inspiration in
            EditInspirationView(inspiration: inspiration, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Inspiration")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Spacer()
            
            Button(action: {
                showingAddInspiration = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color.theme.primaryYellow)
                    .background(
                        Circle()
                            .fill(Color.theme.primaryText)
                            .frame(width: 32, height: 32)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var searchView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.theme.secondaryText)
            
            TextField("Search inspirations...", text: $viewModel.searchText)
                .font(.playfairDisplay(16))
                .foregroundColor(Color.theme.primaryText)
            
            if !viewModel.searchText.isEmpty {
                Button(action: {
                    viewModel.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.theme.secondaryText)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.cardBackground)
                .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.primaryPurple.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No inspirations yet")
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                
                Text("Collect and organize your creative inspirations and ideas here.")
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: {
                showingAddInspiration = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Add Inspiration")
                }
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(Color.theme.buttonText)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.theme.buttonBackground)
                        .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
                )
            }
            
            Spacer()
        }
    }
    
    private var inspirationsListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredInspirations) { inspiration in
                    InspirationCardView(inspiration: inspiration) {
                        selectedInspirationId = inspiration.id
                    } onDelete: {
                        viewModel.deleteInspiration(inspiration)
                    } onEdit: {
                        editingInspiration = inspiration
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
}

struct InspirationCardView: View {
    let inspiration: Inspiration
    let onTap: () -> Void
    let onDelete: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                Text(inspiration.title)
                    .font(.playfairDisplay(20, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.leading)
                
                if !inspiration.description.isEmpty {
                    Text(inspiration.description)
                        .font(.playfairDisplay(14))
                        .foregroundColor(Color.theme.secondaryText)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                }
                
                if !inspiration.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(inspiration.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.playfairDisplay(12, weight: .medium))
                                    .foregroundColor(Color.theme.primaryPurple)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.theme.lightPurple.opacity(0.3))
                                    )
                            }
                        }
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.theme.cardBackground)
                    .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button(action: onEdit) {
                Label("Edit", systemImage: "pencil")
            }
            
            Button(action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

#Preview {
    InspirationView()
}
