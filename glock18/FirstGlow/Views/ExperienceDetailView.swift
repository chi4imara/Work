import SwiftUI

struct ExperienceDetailView: View {
    let experienceId: UUID
    @ObservedObject var store: FirstExperienceStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var experience: FirstExperience? {
        store.experiences.first { $0.id == experienceId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackgroundView()
                
                if let experience = experience {
                    VStack(spacing: 0) {
                        headerView
                        
                        ScrollView {
                            VStack(spacing: 32) {
                                mainContentCard
                                
                                actionButtons
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 100)
                        }
                    }
                } else {
                    VStack {
                        Text("Experience not found")
                            .font(FontManager.title2)
                            .foregroundColor(AppColors.pureWhite)
                        
                        Button("Go Back") {
                            dismiss()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .padding(.top, 20)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditView) {
            if let experience = experience {
                AddEditExperienceView(store: store, experienceToEdit: experience)
            }
        }
        .alert("Delete Experience", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let experience = experience {
                    store.deleteExperience(experience)
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this experience? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Back")
                            .font(FontManager.callout)
                    }
                    .foregroundColor(AppColors.pureWhite)
                }
                
                Spacer()
                
                Text("Experience Details")
                    .font(FontManager.title2)
                    .foregroundColor(AppColors.pureWhite)
                
                Spacer()
                
                Menu {
                    Button("Edit") {
                        showingEditView = true
                    }
                    
                    Button("Delete", role: .destructive) {
                        showingDeleteAlert = true
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.pureWhite)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(AppColors.pureWhite.opacity(0.1))
                        )
                }
            }
            
            Divider()
                .background(AppColors.pureWhite.opacity(0.3))
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var mainContentCard: some View {
        VStack(alignment: .leading, spacing: 24) {
            if let experience = experience {
                Text(experience.title)
                    .font(FontManager.title1)
                    .foregroundColor(AppColors.darkGray)
                    .multilineTextAlignment(.leading)
                
                VStack(spacing: 20) {
                    if let category = experience.category {
                        DetailRow(
                            icon: "tag.fill",
                            label: "Category",
                            value: category,
                            color: AppColors.lightPurple
                        )
                    }
                    
                    DetailRow(
                        icon: "calendar",
                        label: "Date",
                        value: DateFormatter.detailFormatter.string(from: experience.date),
                        color: AppColors.softPink
                    )
                    
                    if let place = experience.place, !place.isEmpty {
                        DetailRow(
                            icon: "location.fill",
                            label: "Place",
                            value: place,
                            color: AppColors.mintGreen
                        )
                    }
                    
                    if let note = experience.note, !note.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "note.text")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppColors.peachOrange)
                                    .frame(width: 24, height: 24)
                                
                                Text("Note")
                                    .font(FontManager.headline)
                                    .foregroundColor(AppColors.mediumGray)
                            }
                            
                            Text(note)
                                .font(FontManager.body)
                                .foregroundColor(AppColors.darkGray)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
            }
        }
        .padding(24)
        .cardBackground()
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            Button(action: {
                showingEditView = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .medium))
                    Text("Edit Experience")
                        .font(FontManager.buttonText)
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(PrimaryButtonStyle())
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                    Text("Delete Experience")
                        .font(FontManager.buttonText)
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(SecondaryButtonStyle())
        }
    }
}

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(FontManager.caption1)
                    .foregroundColor(AppColors.mediumGray)
                
                Text(value)
                    .font(FontManager.body)
                    .foregroundColor(AppColors.darkGray)
            }
            
            Spacer()
        }
    }
}

extension DateFormatter {
    static let detailFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter
    }()
}
