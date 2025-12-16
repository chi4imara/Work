import SwiftUI

struct EntryDetailView: View {
    let entry: WeatherEntry
    @ObservedObject var viewModel: WeatherEntriesViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    @State private var showingEditSheet = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text(entry.formattedDate)
                            .font(AppFonts.title2)
                            .foregroundColor(AppColors.textPrimary)
                        
                        HStack {
                            Text(entry.category.name)
                                .font(AppFonts.caption1)
                                .foregroundColor(AppColors.buttonText)
                                .padding(.horizontal, AppSpacing.sm)
                                .padding(.vertical, AppSpacing.xs)
                                .background(
                                    RoundedRectangle(cornerRadius: AppCornerRadius.small)
                                        .fill(AppColors.primaryPurple)
                                )
                            
                            Spacer()
                        }
                    }
                    .padding(AppSpacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                            .fill(AppColors.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                            )
                    )
                    
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Weather Description")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(entry.description)
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.textPrimary)
                            .lineSpacing(4)
                    }
                    .padding(AppSpacing.md)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                            .fill(AppColors.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                            )
                    )
                    
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Entry Details")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.textPrimary)
                        
                        VStack(spacing: AppSpacing.sm) {
                            HStack {
                                Text("Created:")
                                    .font(AppFonts.callout)
                                    .foregroundColor(AppColors.textSecondary)
                                Spacer()
                                Text(formatDate(entry.createdAt))
                                    .font(AppFonts.callout)
                                    .foregroundColor(AppColors.textPrimary)
                            }
                            
                            HStack {
                                Text("Weather Date:")
                                    .font(AppFonts.callout)
                                    .foregroundColor(AppColors.textSecondary)
                                Spacer()
                                Text(formatDate(entry.date))
                                    .font(AppFonts.callout)
                                    .foregroundColor(AppColors.textPrimary)
                            }
                            
                            HStack {
                                Text("Word Count:")
                                    .font(AppFonts.callout)
                                    .foregroundColor(AppColors.textSecondary)
                                Spacer()
                                Text("\(entry.description.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.count)")
                                    .font(AppFonts.callout)
                                    .foregroundColor(AppColors.textPrimary)
                            }
                        }
                    }
                    .padding(AppSpacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                            .fill(AppColors.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                            )
                    )
                    
                    Spacer(minLength: 100) 
                }
                .padding(AppSpacing.md)
            }
        }
        .navigationTitle("Entry Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { showingEditSheet = true }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive, action: { showingDeleteAlert = true }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(AppColors.textPrimary)
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            CreateEntryView(
                viewModel: CreateEntryViewModel(
                    weatherEntriesViewModel: viewModel,
                    editingEntry: entry
                )
            )
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteEntry(entry)
                presentationMode.wrappedValue.dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this entry? This action cannot be undone.")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationView {
        EntryDetailView(
            entry: WeatherEntry(
                description: "Today was a beautiful sunny day with clear blue skies. The temperature was perfect for a walk in the park, and there was a gentle breeze that made everything feel fresh and alive.",
                category: WeatherCategory.sunny
            ),
            viewModel: WeatherEntriesViewModel()
        )
    }
}
