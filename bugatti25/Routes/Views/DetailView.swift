import SwiftUI

struct DetailView: View {
    let itemId: ItemReference
    @ObservedObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var noteText = ""
    
    private var item: AnyItem? {
        viewModel.item(by: itemId)
    }
    
    var body: some View {
        Group {
            if let item = item {
                detailContent(item: item)
            } else {
                itemNotFoundView
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let item = item {
                loadNote(for: item)
            }
        }
        .onDisappear {
            if let item = item {
                saveNote(for: item)
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditItemView(itemId: itemId, viewModel: viewModel)
        }
        .alert("Delete Item", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteItem()
            }
        } message: {
            Text("Are you sure you want to delete this item? This action cannot be undone.")
        }
    }
    
    private var itemNotFoundView: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 60))
                    .foregroundColor(.textSecondary)
                Text("Item not found")
                    .font(.playfairDisplay(.semibold, size: 20))
                    .foregroundColor(.primaryBlue)
                Button("Go Back") {
                    presentationMode.wrappedValue.dismiss()
                }
                .primaryButtonStyle()
            }
        }
    }
    
    private func detailContent(item: AnyItem) -> some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [itemColor(item), itemColor(item).opacity(0.7)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .shadow(color: itemColor(item).opacity(0.3), radius: 12, x: 0, y: 6)
                            
                            Image(systemName: itemIcon(item))
                                .font(.system(size: 48, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 8) {
                            Text(itemTitle(item))
                                .font(.playfairDisplay(.bold, size: 28))
                                .foregroundColor(.primaryBlue)
                                .multilineTextAlignment(.center)
                            
                            Text(itemCategory(item))
                                .font(.playfairDisplay(.medium, size: 16))
                                .foregroundColor(.textSecondary)
                        }
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        HStack {
                            Text("Status")
                                .font(.playfairDisplay(.semibold, size: 18))
                                .foregroundColor(.primaryBlue)
                            
                            Spacer()
                            
                            StatusBadge(isCompleted: itemIsCompleted(item), status: itemStatus(item))
                        }
                        
                        if let completionDate = itemCompletionDate(item) {
                            HStack {
                                Text("Completed")
                                    .font(.playfairDisplay(.medium, size: 16))
                                    .foregroundColor(.textSecondary)
                                
                                Spacer()
                                
                                Text(completionDate, style: .date)
                                    .font(.playfairDisplay(.medium, size: 16))
                                    .foregroundColor(.primaryBlue)
                            }
                        }
                        
                        if let frequency = itemFrequency(item) {
                            HStack {
                                Text("Frequency")
                                    .font(.playfairDisplay(.medium, size: 16))
                                    .foregroundColor(.textSecondary)
                                
                                Spacer()
                                
                                Text(frequency)
                                    .font(.playfairDisplay(.medium, size: 16))
                                    .foregroundColor(.primaryBlue)
                            }
                        }
                    }
                    .cardStyle()
                    .padding(.horizontal, 20)
                    
                    if let whyImportant = itemWhyImportant(item), !whyImportant.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Why This Matters")
                                .font(.playfairDisplay(.semibold, size: 18))
                                .foregroundColor(.primaryBlue)
                            
                            Text(whyImportant)
                                .font(.playfairDisplay(.regular, size: 16))
                                .foregroundColor(.textSecondary)
                                .lineLimit(nil)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .cardStyle()
                        .padding(.horizontal, 20)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Notes")
                            .font(.playfairDisplay(.semibold, size: 18))
                            .foregroundColor(.primaryBlue)
                        
                        TextField("Add your notes here...", text: $noteText, axis: .vertical)
                            .font(.playfairDisplay(.regular, size: 16))
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.8))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.primaryBlue.opacity(0.3), lineWidth: 1)
                                    }
                            )
                            .lineLimit(5...10)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cardStyle()
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 16) {
                        if !itemIsCompleted(item) {
                            Button {
                                markAsCompleted(item)
                            } label: {
                                Text("Mark as Completed")
                                    .font(.playfairDisplay(.semibold, size: 18))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 16)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(Color.primaryYellow)
                                            .shadow(color: Color.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
                                    )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        HStack(spacing: 16) {
                            Button {
                                showingEditView = true
                            } label: {
                                Text("Edit")
                                    .font(.playfairDisplay(.medium, size: 16))
                                    .foregroundColor(.primaryBlue)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.primaryBlue, lineWidth: 2)
                                            .background(Color.white.opacity(0.8))
                                    )
                            }
                            
                            Button {
                                showingDeleteAlert = true
                            } label: {
                                Text("Delete")
                                    .font(.playfairDisplay(.semibold, size: 16))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.red)
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
        }
    }
        
    private func itemTitle(_ item: AnyItem) -> String {
        switch item {
        case .place(let place): return place.name
        case .task(let task): return task.title
        }
    }
    
    private func itemCategory(_ item: AnyItem) -> String {
        switch item {
        case .place(let place): return place.category.rawValue
        case .task(let task): return task.category.rawValue
        }
    }
    
    private func itemIcon(_ item: AnyItem) -> String {
        switch item {
        case .place(let place): return place.category.icon
        case .task(let task): return task.category.icon
        }
    }
    
    private func itemColor(_ item: AnyItem) -> Color {
        switch item {
        case .place(_): return .primaryBlue
        case .task(_): return .primaryYellow
        }
    }
    
    private func itemIsCompleted(_ item: AnyItem) -> Bool {
        switch item {
        case .place(let place): return place.isCompleted
        case .task(let task): return task.isCompleted
        }
    }
    
    private func itemStatus(_ item: AnyItem) -> String {
        switch item {
        case .place(let place): return place.status.rawValue
        case .task(let task): return task.isCompleted ? "Completed" : "Pending"
        }
    }
    
    private func itemCompletionDate(_ item: AnyItem) -> Date? {
        switch item {
        case .place(let place): return place.completionDate
        case .task(let task): return task.completionDate
        }
    }
    
    private func itemFrequency(_ item: AnyItem) -> String? {
        switch item {
        case .place(_): return nil
        case .task(let task): return task.frequency.rawValue
        }
    }
    
    private func itemWhyImportant(_ item: AnyItem) -> String? {
        switch item {
        case .place(let place): return place.whyImportant
        case .task(let task): return task.whyImportant
        }
    }
    
    private func markAsCompleted(_ item: AnyItem) {
        withAnimation(.spring()) {
            switch item {
            case .place(let place): viewModel.markPlaceAsCompleted(place)
            case .task(let task): viewModel.markTaskAsCompleted(task)
            }
        }
    }
    
    private func deleteItem() {
        guard let item = item else { return }
        switch item {
        case .place(let place):
            viewModel.deletePlace(place)
        case .task(let task):
            viewModel.deleteTask(task)
        }
        presentationMode.wrappedValue.dismiss()
    }
    
    private func loadNote(for item: AnyItem) {
        switch item {
        case .place(let place): noteText = place.note ?? ""
        case .task(_): noteText = ""
        }
    }
    
    private func saveNote(for item: AnyItem) {
        switch item {
        case .place(let place):
            var updatedPlace = place
            updatedPlace.note = noteText.isEmpty ? nil : noteText
            viewModel.updatePlace(updatedPlace)
        case .task(_): break
        }
    }
}

struct StatusBadge: View {
    let isCompleted: Bool
    let status: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title3)
                .foregroundColor(isCompleted ? .successGreen : .primaryBlue)
            
            Text(status)
                .font(.playfairDisplay(.semibold, size: 16))
                .foregroundColor(isCompleted ? .successGreen : .primaryBlue)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(isCompleted ? Color.successGreen.opacity(0.2) : Color.primaryBlue.opacity(0.2))
        )
    }
}

struct EditItemView: View {
    let itemId: ItemReference
    @ObservedObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var selectedCategory: PlaceCategory = .walk
    @State private var selectedFrequency: TaskFrequency = .once
    @State private var whyImportant: String = ""
    
    private var item: AnyItem? {
        viewModel.item(by: itemId)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.playfairDisplay(.semibold, size: 16))
                                .foregroundColor(.primaryBlue)
                            
                            TextField("Enter name", text: $name)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.playfairDisplay(.semibold, size: 16))
                                .foregroundColor(.primaryBlue)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(PlaceCategory.allCases) { category in
                                    CategoryButton(
                                        category: category,
                                        isSelected: selectedCategory == category
                                    ) {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                        
                        if case .task = itemId {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Frequency")
                                    .font(.playfairDisplay(.semibold, size: 16))
                                    .foregroundColor(.primaryBlue)
                                
                                VStack(spacing: 8) {
                                    ForEach(TaskFrequency.allCases) { frequency in
                                        FrequencyButton(
                                            frequency: frequency,
                                            isSelected: selectedFrequency == frequency
                                        ) {
                                            selectedFrequency = frequency
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Why is this important? (Optional)")
                                .font(.playfairDisplay(.semibold, size: 16))
                                .foregroundColor(.primaryBlue)
                            
                            TextField("Enter your thoughts...", text: $whyImportant, axis: .vertical)
                                .textFieldStyle(CustomTextFieldStyle())
                                .lineLimit(3...6)
                        }
                    }
                    .cardStyle()
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.playfairDisplay(.medium, size: 16))
                    .foregroundColor(.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .font(.playfairDisplay(.semibold, size: 16))
                    .foregroundColor(name.isEmpty ? .textLight : .primaryYellow)
                    .disabled(name.isEmpty)
                }
            }
        }
        .onAppear {
            loadCurrentValues()
        }
    }
    
    private func loadCurrentValues() {
        guard let item = item else { return }
        switch item {
        case .place(let place):
            name = place.name
            selectedCategory = place.category
            whyImportant = place.whyImportant ?? ""
        case .task(let task):
            name = task.title
            selectedCategory = task.category
            selectedFrequency = task.frequency
            whyImportant = task.whyImportant ?? ""
        }
    }
    
    private func saveChanges() {
        guard !name.isEmpty, let item = item else { return }
        
        switch item {
        case .place(let place):
            var updatedPlace = place
            updatedPlace.name = name
            updatedPlace.category = selectedCategory
            updatedPlace.whyImportant = whyImportant.isEmpty ? nil : whyImportant
            viewModel.updatePlace(updatedPlace)
            
        case .task(let task):
            var updatedTask = task
            updatedTask.title = name
            updatedTask.category = selectedCategory
            updatedTask.frequency = selectedFrequency
            updatedTask.whyImportant = whyImportant.isEmpty ? nil : whyImportant
            viewModel.updateTask(updatedTask)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NavigationView {
        DetailView(
            itemId: .place(UUID()),
            viewModel: AppViewModel()
        )
    }
}
