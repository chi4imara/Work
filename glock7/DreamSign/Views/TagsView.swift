import SwiftUI

struct TagsView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var showingRenameTag = false
    @State private var newTagName = ""
    @State private var selectedTag: String?
    @State private var tagToRename: String?
    @State private var renameTagName = ""
    @State private var showingDeleteAlert = false
    @State private var tagToDelete: String?
    
    @Binding var showingAddTag: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if dataManager.tags.isEmpty {
                emptyStateView
            } else {
                tagsList
            }
        }
        .alert("Add New Tag", isPresented: $showingAddTag) {
            TextField("Tag name", text: $newTagName)
            Button("Add") {
                addNewTag()
            }
            Button("Cancel", role: .cancel) {
                newTagName = ""
            }
        }
        .alert("Rename Tag", isPresented: $showingRenameTag) {
            TextField("New name", text: $renameTagName)
            Button("Rename") {
                renameTag()
            }
            Button("Cancel", role: .cancel) {
                renameTagName = ""
                tagToRename = nil
            }
        }
        .alert("Delete Tag", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteTag()
            }
            Button("Cancel", role: .cancel) {
                tagToDelete = nil
            }
        } message: {
            if let tag = tagToDelete {
                let stats = dataManager.getTagStatistics(tag)
                if stats.total > 0 {
                    Text("Cannot delete '\(tag)' because it's used in \(stats.total) dream(s). Remove the tag from all dreams first.")
                } else {
                    Text("Are you sure you want to delete the tag '\(tag)'?")
                }
            }
        }
        .sheet(item: Binding<TagDetailWrapper?>(
            get: { selectedTag.map(TagDetailWrapper.init) },
            set: { _ in selectedTag = nil }
        )) { wrapper in
            TagDetailView(tagName: wrapper.tagName)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Manage Tags")
                .font(AppFonts.semiBold(18))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: {
                showingAddTag = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                    Text("Add Tag")
                        .font(AppFonts.medium(16))
                }
                .foregroundColor(AppColors.backgroundBlue)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.yellow)
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var tagsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(sortedTags, id: \.name) { tag in
                    TagRow(tag: tag) {
                        selectedTag = tag.name
                    } onRename: {
                        tagToRename = tag.name
                        renameTagName = tag.name
                        showingRenameTag = true
                    } onDelete: {
                        tagToDelete = tag.name
                        showingDeleteAlert = true
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .padding(.top, 10)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "tag")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 12) {
                Text("No tags yet")
                    .font(AppFonts.medium(18))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Create tags to organize your dreams by themes")
                    .font(AppFonts.regular(14))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                showingAddTag = true
            }) {
                Text("Add First Tag")
                    .font(AppFonts.semiBold(16))
                    .foregroundColor(AppColors.backgroundBlue)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.yellow)
                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var sortedTags: [Tag] {
        dataManager.tags.sorted { $0.name.lowercased() < $1.name.lowercased() }
    }
    
    private func addNewTag() {
        let trimmedName = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty {
            _ = dataManager.addTag(trimmedName)
        }
        newTagName = ""
    }
    
    private func renameTag() {
        guard let oldName = tagToRename else { return }
        let trimmedName = renameTagName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !trimmedName.isEmpty && trimmedName != oldName {
            _ = dataManager.renameTag(from: oldName, to: trimmedName)
        }
        
        renameTagName = ""
        tagToRename = nil
    }
    
    private func deleteTag() {
        guard let tagName = tagToDelete else { return }
        _ = dataManager.deleteTag(tagName)
        tagToDelete = nil
    }
}

struct TagRow: View {
    let tag: Tag
    let onTap: () -> Void
    let onRename: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGSize = .zero
    
    private var statistics: (total: Int, waiting: Int, fulfilled: Int, notFulfilled: Int) {
        DataManager.shared.getTagStatistics(tag.name)
    }
    
    var body: some View {
        ZStack {
            if offset.width < 0 {
                HStack {
                    Spacer()
                    Button(action: {
                        onDelete()
                    }) {
                        VStack {
                            Image(systemName: "trash")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                            Text("Delete")
                                .font(AppFonts.callout)
                                .foregroundColor(.white)
                        }
                        .frame(width: 80)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red)
                .cornerRadius(12)
            }
            
            if offset.width > 0 {
                HStack {
                    Button(action: onRename) {
                        VStack {
                            Image(systemName: "pencil")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                            Text("Edit")
                                .font(AppFonts.callout)
                                .foregroundColor(.white)
                        }
                        .frame(width: 80)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue)
                .cornerRadius(12)
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(tag.name)
                            .font(AppFonts.semiBold(16))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Text("\(statistics.total)")
                            .font(AppFonts.bold(16))
                            .foregroundColor(AppColors.yellow)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(AppColors.yellow.opacity(0.2))
                            )
                    }
                    
                    if statistics.total > 0 {
                        HStack(spacing: 16) {
                            StatisticItem(
                                title: "Waiting",
                                count: statistics.waiting,
                                color: AppColors.yellow
                            )
                            
                            StatisticItem(
                                title: "Fulfilled",
                                count: statistics.fulfilled,
                                color: AppColors.green
                            )
                            
                            StatisticItem(
                                title: "Not Fulfilled",
                                count: statistics.notFulfilled,
                                color: AppColors.red
                            )
                        }
                    } else {
                        Text("No dreams with this tag")
                            .font(AppFonts.regular(12))
                            .foregroundColor(AppColors.secondaryText.opacity(0.7))
                            .italic()
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
            )
            .offset(x: offset.width, y: 0)
            .highPriorityGesture(
                DragGesture(minimumDistance: 20)
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            if value.translation.width > 100 {
                                onRename()
                            } else if value.translation.width < -100 {
                                onDelete()
                            }
                            offset = .zero
                        }
                    }
            )
            .onTapGesture {
                onTap()
            }
        }
    }
}

struct StatisticItem: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(AppFonts.semiBold(14))
                .foregroundColor(color)
            
            Text(title)
                .font(AppFonts.regular(10))
                .foregroundColor(AppColors.secondaryText)
        }
    }
}

struct TagDetailWrapper: Identifiable {
    let id = UUID()
    let tagName: String
}

struct TagDetailView: View {
    let tagName: String
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var dataManager = DataManager.shared
    @State private var selectedDream: Dream?
    @State private var dreamToEdit: Dream?
    
    private var dreams: [Dream] {
        dataManager.getDreamsByTag(tagName)
    }
    
    private var statistics: (total: Int, waiting: Int, fulfilled: Int, notFulfilled: Int) {
        dataManager.getTagStatistics(tagName)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .opacity(0)
                    .disabled(true)
                    
                    Spacer()
                    
                    Text(tagName)
                        .font(AppFonts.bold(20))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                }
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom, 4)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Text("Tag Statistics")
                                .font(AppFonts.bold(18))
                                .foregroundColor(AppColors.primaryText)
                            
                            HStack(spacing: 20) {
                                StatCard(
                                    title: "Total",
                                    count: statistics.total,
                                    color: AppColors.teal
                                )
                                
                                StatCard(
                                    title: "Waiting",
                                    count: statistics.waiting,
                                    color: AppColors.yellow
                                )
                                
                                StatCard(
                                    title: "Fulfilled",
                                    count: statistics.fulfilled,
                                    color: AppColors.green
                                )
                                
                                StatCard(
                                    title: "Not Fulfilled",
                                    count: statistics.notFulfilled,
                                    color: AppColors.red
                                )
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.cardBackground)
                        )
                        
                        if dreams.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "moon.stars")
                                    .font(.system(size: 40, weight: .light))
                                    .foregroundColor(AppColors.secondaryText)
                                
                                Text("No dreams with this tag")
                                    .font(AppFonts.medium(16))
                                    .foregroundColor(AppColors.primaryText)
                            }
                            .padding(40)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                            )
                        } else {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Dreams (\(dreams.count))")
                                    .font(AppFonts.bold(18))
                                    .foregroundColor(AppColors.primaryText)
                                
                                LazyVStack(spacing: 12) {
                                    ForEach(dreams.sorted { $0.dreamDate > $1.dreamDate }) { dream in
                                        DreamCard(dream: dream) {
                                            selectedDream = dream
                                        } onEdit: {
                                            dreamToEdit = dream
                                        } onDelete: {
                                            dataManager.deleteDream(dream)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(item: Binding<Dream?>(
            get: { selectedDream },
            set: { _ in selectedDream = nil }
        )) { dream in
            DreamDetailView(dream: dream)
        }
        .sheet(item: Binding<Dream?>(
            get: { dreamToEdit },
            set: { _ in dreamToEdit = nil }
        )) { dream in
            AddEditDreamView(dream: dream) { updatedDream in
                dataManager.updateDream(updatedDream)
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(count)")
                .font(AppFonts.bold(20))
                .foregroundColor(color)
            
            Text(title)
                .font(AppFonts.medium(10))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.1))
        )
    }
}

