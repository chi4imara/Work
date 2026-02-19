import SwiftUI

private struct RitualDetailItem: Identifiable {
    let id: UUID
}

struct MyRitualsView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @State private var showingAddRitual = false
    @State private var selectedRitualItem: RitualDetailItem?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HeaderSection(showingAddRitual: $showingAddRitual)
                
                if viewModel.rituals.isEmpty {
                    EmptyStateView(showingAddRitual: $showingAddRitual)
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppSpacing.md) {
                            ForEach(viewModel.rituals) { ritual in
                                RitualRowView(
                                    ritual: ritual,
                                    viewModel: viewModel,
                                    onTap: {
                                        selectedRitualItem = RitualDetailItem(id: ritual.id)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(item: $selectedRitualItem) { item in
            RitualDetailView(ritualId: item.id, viewModel: viewModel)
        }
        .sheet(isPresented: $showingAddRitual) {
            AddRitualView(viewModel: viewModel)
        }
    }
}

struct HeaderSection: View {
    @Binding var showingAddRitual: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text("My Rituals")
                    .font(AppFonts.playfairBold(size: 28))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Build healthy habits for your wellbeing")
                    .font(AppFonts.playfairRegular(size: 16))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Button(action: {
                showingAddRitual = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.primary)
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.lg)
        .padding(.bottom, AppSpacing.md)
    }
}

struct EmptyStateView: View {
    @Binding var showingAddRitual: Bool
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(width: 120, height: 120)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                
                Image(systemName: "sparkles")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppColors.primary)
                    .scaleEffect(isAnimating ? 1.0 : 0.9)
                    .animation(
                        Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(0.5),
                        value: isAnimating
                    )
            }
            
            VStack(spacing: AppSpacing.md) {
                Text("Create Your First Ritual")
                    .font(AppFonts.playfairBold(size: 24))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Add your first ritual and start taking care of yourself. Small steps lead to big changes.")
                    .font(AppFonts.playfairRegular(size: 16))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.lg)
            }
            
            Button(action: {
                showingAddRitual = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                    
                    Text("Add First Ritual")
                        .font(AppFonts.playfairSemiBold(size: 18))
                        .foregroundColor(.white)
                }
                .frame(width: 200, height: 56)
                .background(
                    LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(AppRadius.lg)
                .shadow(color: AppColors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .scaleEffect(isAnimating ? 1.0 : 0.95)
            .animation(
                Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(1.0),
                value: isAnimating
            )
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.md)
        .onAppear {
            isAnimating = true
        }
    }
}

struct RitualRowView: View {
    let ritual: Ritual
    let viewModel: MoodViewModel
    let onTap: () -> Void
    @State private var isAnimating = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(ritual.category.color.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: ritual.category.systemImage)
                        .font(.system(size: 20))
                        .foregroundColor(ritual.category.color)
                }
                
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(ritual.name)
                        .font(AppFonts.playfairSemiBold(size: 16))
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    HStack {
                        Text(ritual.category.displayName)
                            .font(AppFonts.playfairRegular(size: 12))
                            .foregroundColor(AppColors.textSecondary)
                        
                        Text("•")
                            .font(AppFonts.playfairRegular(size: 12))
                            .foregroundColor(AppColors.textSecondary)
                        
                        Text(ritual.frequency.displayName)
                            .font(AppFonts.playfairRegular(size: 12))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    if ritual.streak > 0 {
                        HStack(spacing: AppSpacing.xs) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.orange)
                            
                            Text("\(ritual.streak) day streak")
                                .font(AppFonts.playfairMedium(size: 12))
                                .foregroundColor(.orange)
                        }
                    }
                }
                
                Spacer()
                
                VStack(spacing: AppSpacing.xs) {
                    Button(action: {
                        withAnimation(AppAnimations.bouncy) {
                            isAnimating = true
                            viewModel.toggleRitualCompletion(ritual)
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isAnimating = false
                        }
                    }) {
                        Image(systemName: ritual.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 24))
                            .foregroundColor(ritual.isCompleted ? AppColors.success : AppColors.textSecondary)
                            .scaleEffect(isAnimating ? 1.2 : 1.0)
                    }
                    
                    if ritual.isCompleted {
                        Text("Done!")
                            .font(AppFonts.playfairMedium(size: 10))
                            .foregroundColor(AppColors.success)
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(AppSpacing.md)
            .background(
                ritual.isCompleted ? 
                AppColors.success.opacity(0.05) : AppColors.cardBackground
            )
            .cornerRadius(AppRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .stroke(
                        ritual.isCompleted ? AppColors.success.opacity(0.3) : Color.clear,
                        lineWidth: 1
                    )
            )
            .shadow(color: AppColors.primary.opacity(0.05), radius: 3, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
}

struct RitualDetailView: View {
    let ritualId: UUID
    @ObservedObject var viewModel: MoodViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    @State private var showingEditView = false
    
    private var ritual: Ritual? {
        viewModel.rituals.first { $0.id == ritualId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                if let ritual = ritual {
                    ScrollView {
                        VStack(spacing: AppSpacing.lg) {
                            VStack(spacing: AppSpacing.md) {
                                ZStack {
                                    Circle()
                                        .fill(ritual.category.color.opacity(0.1))
                                        .frame(width: 80, height: 80)
                                    
                                    Image(systemName: ritual.category.systemImage)
                                        .font(.system(size: 35))
                                        .foregroundColor(ritual.category.color)
                                }
                                
                                Text(ritual.name)
                                    .font(AppFonts.playfairBold(size: 24))
                                    .foregroundColor(AppColors.textPrimary)
                                    .multilineTextAlignment(.center)
                                
                                HStack {
                                    Text(ritual.category.displayName)
                                        .font(AppFonts.playfairMedium(size: 16))
                                        .foregroundColor(AppColors.textSecondary)
                                    
                                    Text("•")
                                        .foregroundColor(AppColors.textSecondary)
                                    
                                    Text(ritual.frequency.displayName)
                                        .font(AppFonts.playfairMedium(size: 16))
                                        .foregroundColor(AppColors.textSecondary)
                                }
                            }
                            .padding(.top, AppSpacing.lg)
                            
                            HStack(spacing: AppSpacing.lg) {
                                StatCard(
                                    title: "Current Streak",
                                    value: "\(ritual.streak)",
                                    icon: "flame.fill",
                                    color: .orange
                                )
                                
                                StatCard(
                                    title: "Total Days",
                                    value: "\(ritual.completionDates.count)",
                                    icon: "calendar.badge.checkmark",
                                    color: AppColors.primary
                                )
                            }
                            .padding(.horizontal, AppSpacing.md)
                            
                            if !ritual.description.isEmpty {
                                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                    Text("Why This Matters")
                                        .font(AppFonts.playfairSemiBold(size: 18))
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    Text(ritual.description)
                                        .font(AppFonts.playfairRegular(size: 16))
                                        .foregroundColor(AppColors.textSecondary)
                                        .lineLimit(nil)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(AppSpacing.md)
                                .background(AppColors.cardBackground)
                                .cornerRadius(AppRadius.md)
                                .padding(.horizontal, AppSpacing.md)
                            }
                            
                            VStack(spacing: AppSpacing.md) {
                                Button(action: {
                                    showingEditView = true
                                }) {
                                    HStack {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                        
                                        Text("Edit Ritual")
                                            .font(AppFonts.playfairSemiBold(size: 16))
                                            .foregroundColor(.white)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.primary)
                                    .cornerRadius(AppRadius.md)
                                }
                                
                                Button(action: {
                                    showingDeleteAlert = true
                                }) {
                                    HStack {
                                        Image(systemName: "trash")
                                            .font(.system(size: 16))
                                            .foregroundColor(.red)
                                        
                                        Text("Delete Ritual")
                                            .font(AppFonts.playfairMedium(size: 16))
                                            .foregroundColor(.red)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(AppRadius.md)
                                }
                            }
                            .padding(.horizontal, AppSpacing.md)
                        }
                        .padding(.bottom, AppSpacing.xl)
                    }
                } else {
                    VStack(spacing: AppSpacing.lg) {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 50))
                            .foregroundColor(AppColors.textSecondary)
                        Text("Ritual not found")
                            .font(AppFonts.playfairSemiBold(size: 18))
                            .foregroundColor(AppColors.textPrimary)
                        Button("Close") {
                            dismiss()
                        }
                        .font(AppFonts.playfairMedium(size: 16))
                        .foregroundColor(AppColors.primary)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .font(AppFonts.playfairMedium(size: 16))
                    .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .alert("Delete Ritual", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let ritual = ritual {
                    viewModel.deleteRitual(ritual)
                }
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this ritual? This action cannot be undone.")
        }
        .sheet(isPresented: $showingEditView) {
            EditRitualView(ritualId: ritualId, viewModel: viewModel)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(AppFonts.playfairBold(size: 20))
                .foregroundColor(AppColors.textPrimary)
            
            Text(title)
                .font(AppFonts.playfairRegular(size: 12))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .cornerRadius(AppRadius.md)
    }
}

struct EditRitualView: View {
    let ritualId: UUID
    let viewModel: MoodViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var ritualName: String
    @State private var selectedCategory: Ritual.RitualCategory
    @State private var selectedFrequency: Ritual.Frequency
    @State private var ritualDescription: String
    
    private var ritual: Ritual? {
        viewModel.rituals.first { $0.id == ritualId }
    }
    
    init(ritualId: UUID, viewModel: MoodViewModel) {
        self.ritualId = ritualId
        self.viewModel = viewModel
        let r = viewModel.rituals.first { $0.id == ritualId }
        self._ritualName = State(initialValue: r?.name ?? "")
        self._selectedCategory = State(initialValue: r?.category ?? .meditation)
        self._selectedFrequency = State(initialValue: r?.frequency ?? .daily)
        self._ritualDescription = State(initialValue: r?.description ?? "")
    }
    
    var isFormValid: Bool {
        !ritualName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        VStack(spacing: AppSpacing.lg) {
                            FormSection(title: "Ritual Name") {
                                TextField("Enter ritual name", text: $ritualName)
                                    .font(AppFonts.playfairRegular(size: 16))
                                    .padding(AppSpacing.md)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(AppRadius.md)
                            }
                            
                            FormSection(title: "Category") {
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: AppSpacing.sm) {
                                    ForEach(Ritual.RitualCategory.allCases, id: \.self) { category in
                                        CategoryButton(
                                            category: category,
                                            isSelected: selectedCategory == category,
                                            action: {
                                                withAnimation(AppAnimations.bouncy) {
                                                    selectedCategory = category
                                                }
                                            }
                                        )
                                    }
                                }
                            }
                            
                            FormSection(title: "Frequency") {
                                VStack(spacing: AppSpacing.sm) {
                                    ForEach(Ritual.Frequency.allCases, id: \.self) { frequency in
                                        FrequencyButton(
                                            frequency: frequency,
                                            isSelected: selectedFrequency == frequency,
                                            action: {
                                                withAnimation(AppAnimations.smooth) {
                                                    selectedFrequency = frequency
                                                }
                                            }
                                        )
                                    }
                                }
                            }
                            
                            FormSection(title: "Why is this important? (Optional)") {
                                TextField("Describe why this ritual matters to you", text: $ritualDescription, axis: .vertical)
                                    .font(AppFonts.playfairRegular(size: 14))
                                    .padding(AppSpacing.md)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(AppRadius.md)
                                    .lineLimit(3...6)
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        Button(action: {
                            updateRitual()
                        }) {
                            Text("Update Ritual")
                                .font(AppFonts.playfairSemiBold(size: 18))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    isFormValid ? AppColors.primary : AppColors.textSecondary.opacity(0.3)
                                )
                                .cornerRadius(AppRadius.lg)
                        }
                        .disabled(!isFormValid)
                        .padding(.horizontal, AppSpacing.md)
                    }
                    .padding(.bottom, AppSpacing.xl)
                }
            }
            .navigationTitle("Edit Ritual")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(AppFonts.playfairMedium(size: 16))
                    .foregroundColor(AppColors.textSecondary)
                }
            }
        }
    }
    
    private func updateRitual() {
        guard var existingRitual = ritual else { dismiss(); return }
        existingRitual.name = ritualName.trimmingCharacters(in: .whitespacesAndNewlines)
        existingRitual.category = selectedCategory
        existingRitual.frequency = selectedFrequency
        existingRitual.description = ritualDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateRitual(existingRitual)
        dismiss()
    }
}

#Preview {
    MyRitualsView()
}
