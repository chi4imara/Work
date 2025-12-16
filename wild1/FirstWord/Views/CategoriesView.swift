import SwiftUI

struct CategoriesView: View {
    @StateObject private var entryStore = EntryStore()
    @State private var showingAddCategory = false
    @State private var newCategoryName = ""
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Categories")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(Color.theme.textPrimary)
                    
                    Spacer()
                    
                    Button(action: { showingAddCategory = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color.theme.textPrimary)
                            .frame(width: 40, height: 40)
                            .background(Color.theme.buttonSecondary)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                if entryStore.allCategories.isEmpty {
                    EmptyCategoriesView(showingAddCategory: $showingAddCategory)
                } else {
                    CategoryListView(entryStore: entryStore)
                }
                
                Spacer()
            }
        }
        .alert("Add Category", isPresented: $showingAddCategory) {
            TextField("Category name", text: $newCategoryName)
            Button("Cancel", role: .cancel) {
                newCategoryName = ""
            }
            Button("Add") {
                let name = newCategoryName
                newCategoryName = ""
                entryStore.addCustomCategory(name)
            }
            .disabled(newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        } message: {
            Text("Enter a name for the new category")
        }
    }
}

struct CategoryListView: View {
    @ObservedObject var entryStore: EntryStore
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(entryStore.allCategories, id: \.self) { category in
                    CategoryCardView(
                        category: category,
                        entryCount: entryStore.entriesForCategory(category).count,
                        lastEntry: entryStore.entriesForCategory(category).sorted { $0.date > $1.date }.first,
                        entryStore: entryStore
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 200)
        }
        .padding(.bottom, -100)
    }
}

struct CategoryCardView: View {
    let category: Category
    let entryCount: Int
    let lastEntry: Entry?
    @ObservedObject var entryStore: EntryStore
    
    @State private var showingRenameAlert = false
    @State private var newCategoryName = ""
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(category.color)
                    .frame(width: 16, height: 16)
                
                Text(category.displayName)
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(Color.theme.textPrimary)
                
                if category.isCustom {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.theme.primaryPurple)
                }
                
                Spacer()
                
                Text("\(entryCount)")
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(Color.theme.textSecondary)
            }
            
            if let lastEntry = lastEntry {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Latest:")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(Color.theme.textSecondary)
                    
                    Text(lastEntry.phrase)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(Color.theme.textPrimary)
                        .lineLimit(2)
                    
                    Text(lastEntry.date.formattedShort())
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(Color.theme.textSecondary)
                }
            } else {
                Text("No entries yet")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(Color.theme.textSecondary)
                    .italic()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.theme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    category.isCustom ? 
                        LinearGradient(colors: [Color.theme.primaryPurple.opacity(0.5), Color.theme.primaryBlue.opacity(0.3)], startPoint: .leading, endPoint: .trailing) :
                        LinearGradient(colors: [Color.theme.cardBorder], startPoint: .leading, endPoint: .trailing),
                    lineWidth: category.isCustom ? 2 : 1
                )
        )
        .contextMenu {
            if category.isCustom {
                Button("Rename Category") {
                    newCategoryName = category.displayName
                    showingRenameAlert = true
                }
                
                if entryCount == 0 {
                    Button("Delete Category", role: .destructive) {
                        showingDeleteAlert = true
                    }
                }
            }
        }
        .alert("Rename Category", isPresented: $showingRenameAlert) {
            TextField("Category name", text: $newCategoryName)
            Button("Cancel", role: .cancel) {
                newCategoryName = ""
            }
            Button("Rename") {
                entryStore.renameCustomCategory(category, to: newCategoryName)
                newCategoryName = ""
            }
            .disabled(newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        } message: {
            Text("Enter a new name for the category")
        }
        .alert("Delete Category", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                entryStore.deleteCustomCategory(category)
            }
        } message: {
            Text("Are you sure you want to delete this category? This action cannot be undone.")
        }
    }
}

struct EmptyCategoriesView: View {
    @Binding var showingAddCategory: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "folder")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.textSecondary)
            
            VStack(spacing: 16) {
                Text("Categories haven't been created yet")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(Color.theme.textPrimary)
                    .multilineTextAlignment(.center)
                
                Button("Add First Category") {
                    showingAddCategory = true
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 200, height: 50)
                .background(Color.theme.buttonPrimary)
                .cornerRadius(25)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    CategoriesView()
}
