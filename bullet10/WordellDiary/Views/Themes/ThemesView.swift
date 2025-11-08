import SwiftUI

struct ThemesView: View {
    @ObservedObject var viewModel: DiaryViewModel
    @Binding var showingNewEntry: Bool
    
    @State private var showingAddTheme = false
    @State private var editingTheme: CustomTheme?
    @State private var builtInThemes: [String] = []
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Themes & Inspiration")
                    .font(AppFonts.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primaryBlue)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 20)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Built-in Themes")
                                .font(AppFonts.headline)
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.primaryBlue)
                            
                            Spacer()
                            
                            Button("Refresh") {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    builtInThemes = viewModel.getBuiltInThemes()
                                }
                            }
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.accentYellow)
                        }
                        
                        LazyVStack(spacing: 12) {
                            ForEach(builtInThemes, id: \.self) { theme in
                                ThemeCard(
                                    text: theme,
                                    isCustom: false,
                                    onTap: {
                                        insertThemeIntoNewEntry(theme)
                                    },
                                    onLongPress: {
                                    },
                                    onEdit: { },
                                    onDelete: { }
                                )
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("My Themes")
                                .font(AppFonts.headline)
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.primaryBlue)
                            
                            Spacer()
                            
                            Button(action: { showingAddTheme = true }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(AppColors.accentYellow)
                            }
                        }
                        
                        if viewModel.customThemes.isEmpty {
                            EmptyCustomThemesView(showingAddTheme: $showingAddTheme)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.customThemes) { theme in
                                    ThemeCard(
                                        text: theme.text,
                                        isCustom: true,
                                        onTap: { editingTheme = theme },
                                        onLongPress: {
                                            insertThemeIntoNewEntry(theme.text)
                                        },
                                        onEdit: { editingTheme = theme },
                                        onDelete: { viewModel.deleteCustomTheme(theme) }
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 110)
            }
        }
        .onAppear {
            if builtInThemes.isEmpty {
                builtInThemes = viewModel.getBuiltInThemes()
            }
        }
        .sheet(isPresented: $showingAddTheme) {
            AddThemeView(viewModel: viewModel)
        }
        .sheet(item: $editingTheme) { theme in
            EditThemeView(theme: theme, viewModel: viewModel)
        }
    }
    
    private func insertThemeIntoNewEntry(_ themeText: String) {
        showingNewEntry = true
    }
}

struct ThemeCard: View {
    let text: String
    let isCustom: Bool
    let onTap: () -> Void
    let onLongPress: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var showingDeleteConfirmation = false
    @State private var isPressed = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: isCustom ? "person.crop.circle" : "lightbulb")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(AppColors.primaryBlue)
                .frame(width: 24, height: 24)
                
            VStack(alignment: .leading, spacing: 4) {
                Text(text)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.darkGray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                
                if isCustom {
                    Text("Tap to edit • Long press to use")
                        .font(AppFonts.small)
                        .foregroundColor(AppColors.darkGray.opacity(0.6))
                } else {
                    Text("Long press to use in new entry")
                        .font(AppFonts.small)
                        .foregroundColor(AppColors.darkGray.opacity(0.6))
                }
            }
            
            Spacer()
            
            if isCustom {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.darkGray.opacity(0.5))
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.darkGray.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .onTapGesture {
            onTap()
        }
        .offset(x: dragOffset.width, y: 0)
        .background {
            if isCustom && dragOffset.width < -50 {
                HStack {
                    Spacer()
                    
                    Button(action: { showingDeleteConfirmation = true }) {
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(AppColors.warningRed)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 20)
                }
            }
        }
        .highPriorityGesture(
            DragGesture(minimumDistance: 20)
                .onChanged { value in
                    if isCustom && value.translation.width < 0 {
                        dragOffset = value.translation
                    }
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        if isCustom && value.translation.width < -100 {
                            showingDeleteConfirmation = true
                        }
                        dragOffset = .zero
                    }
                }
        )
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 1, maximumDistance: 5)
                .onEnded { _ in
                    onLongPress()
                }
        )
        .alert("Delete Theme", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this theme?")
        }
    }
}

struct EmptyCustomThemesView: View {
    @Binding var showingAddTheme: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "lightbulb.slash")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(AppColors.darkGray.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No custom themes yet")
                    .font(AppFonts.body)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.darkGray)
                
                Text("Add a few phrases to inspire yourself when creating entries.")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.darkGray.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            Button("Add Theme") {
                showingAddTheme = true
            }
            .font(AppFonts.body)
            .foregroundColor(AppColors.primaryBlue)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(AppColors.primaryBlue, lineWidth: 1)
            }
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
    }
}

struct AddThemeView: View {
    @ObservedObject var viewModel: DiaryViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var themeText = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.mainBackgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Theme Text")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.primaryBlue)
                        
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.cardGradient)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.lightPurple, lineWidth: 1)
                                }
                                .frame(minHeight: 120)
                            
                            if themeText.isEmpty {
                                Text("Enter your inspiration theme...")
                                    .font(AppFonts.body)
                                    .foregroundColor(AppColors.darkGray.opacity(0.5))
                                    .padding(16)
                            }
                            
                            TextEditor(text: $themeText)
                                .font(AppFonts.body)
                                .padding(12)
                                .background(Color.clear)
                                .onChange(of: themeText) { newValue in
                                    if newValue.count > 160 {
                                        themeText = String(newValue.prefix(160))
                                    }
                                }
                                .scrollContentBackground(.hidden)
                        }
                        
                        HStack {
                            Text("Minimum 3 characters")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.darkGray.opacity(0.7))
                            
                            Spacer()
                            
                            Text("\(themeText.count)/160")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.darkGray.opacity(0.7))
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("Add Theme")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.darkGray)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTheme()
                    }
                    .font(AppFonts.body)
                    .fontWeight(.medium)
                    .foregroundColor(themeText.trimmingCharacters(in: .whitespacesAndNewlines).count < 3 ? .gray : AppColors.primaryBlue)
                    .disabled(themeText.trimmingCharacters(in: .whitespacesAndNewlines).count < 3)
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func saveTheme() {
        let trimmedText = themeText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.count < 3 {
            errorMessage = "Theme must be at least 3 characters long."
            showingError = true
            return
        }
        
        let theme = CustomTheme(text: trimmedText)
        viewModel.addCustomTheme(theme)
        dismiss()
    }
}

struct EditThemeView: View {
    let theme: CustomTheme
    @ObservedObject var viewModel: DiaryViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var themeText: String
    @State private var showingError = false
    @State private var errorMessage = ""
    
    init(theme: CustomTheme, viewModel: DiaryViewModel) {
        self.theme = theme
        self.viewModel = viewModel
        self._themeText = State(initialValue: theme.text)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.mainBackgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Theme Text")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.primaryBlue)
                        
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.cardGradient)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.lightPurple, lineWidth: 1)
                                }
                                .frame(minHeight: 120)
                            
                            TextEditor(text: $themeText)
                                .font(AppFonts.body)
                                .padding(12)
                                .background(Color.clear)
                                .onChange(of: themeText) { newValue in
                                    if newValue.count > 160 {
                                        themeText = String(newValue.prefix(160))
                                    }
                                }
                                .scrollContentBackground(.hidden)
                        }
                        
                        HStack {
                            Text("Minimum 3 characters")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.darkGray.opacity(0.7))
                            
                            Spacer()
                            
                            Text("\(themeText.count)/160")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.darkGray.opacity(0.7))
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("Edit Theme")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.darkGray)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTheme()
                    }
                    .font(AppFonts.body)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.primaryBlue)
                    .disabled(themeText.trimmingCharacters(in: .whitespacesAndNewlines).count < 3)
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func saveTheme() {
        let trimmedText = themeText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.count < 3 {
            errorMessage = "Theme must be at least 3 characters long."
            showingError = true
            return
        }
        
        var updatedTheme = theme
        updatedTheme.text = trimmedText
        viewModel.updateCustomTheme(updatedTheme)
        dismiss()
    }
}

#Preview {
    ThemesView(viewModel: DiaryViewModel(), showingNewEntry: .constant(false))
        .background(AppColors.mainBackgroundGradient)
}
