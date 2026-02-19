import SwiftUI

struct IdeaDetailsView: View {
    let idea: NailIdea
    @ObservedObject var viewModel: NailIdeasViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var showingStatusPicker = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Text(idea.name)
                                .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                                .multilineTextAlignment(.center)
                            
                            HStack(spacing: 8) {
                                Image(systemName: idea.status.icon)
                                    .font(.system(size: 18))
                                Text(idea.status.rawValue)
                                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                            }
                            .foregroundColor(AppColors.accentYellow)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.accentYellow.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                        
                        VStack(spacing: 16) {
                            DetailCard(title: "Main Color", content: idea.mainColor.isEmpty ? "Not specified" : idea.mainColor)
                            
                            if !idea.additionalColors.isEmpty {
                                DetailCard(title: "Additional Colors", content: idea.additionalColors)
                            }
                            
                            DetailCard(title: "Design Type", content: idea.designType.rawValue)
                            
                            DetailCard(title: "Season / Event", content: idea.seasonEvent.rawValue)
                            
                            if !idea.comment.isEmpty {
                                DetailCard(title: "Comment", content: idea.comment)
                            }
                            
                            DetailCard(title: "Date Added", content: DateFormatter.longDate.string(from: idea.dateAdded))
                        }
                        
                        VStack(spacing: 12) {
                            Button(action: { showingStatusPicker = true }) {
                                HStack {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                    Text("Change Status")
                                        .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                }
                                .foregroundColor(AppColors.primaryBlue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(AppColors.accentYellow)
                                .cornerRadius(12)
                            }
                            
                            Button(action: { showingEditView = true }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Edit Idea")
                                        .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                }
                                .foregroundColor(AppColors.primaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.cardBorder, lineWidth: 1)
                                        )
                                )
                            }
                            
                            Button(action: { showingDeleteAlert = true }) {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Delete Idea")
                                        .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.red.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Idea Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $showingEditView) {
            EditIdeaView(idea: idea, viewModel: viewModel)
        }
        .alert("Delete Idea", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteIdea(idea)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this idea? This action cannot be undone.")
        }
        .actionSheet(isPresented: $showingStatusPicker) {
            ActionSheet(
                title: Text("Change Status"),
                buttons: IdeaStatus.allCases.map { status in
                    .default(Text("\(status.rawValue)")) {
                        viewModel.changeIdeaStatus(idea, to: status)
                    }
                } + [.cancel()]
            )
        }
    }
}

struct DetailCard: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(FontManager.playfairDisplay(size: 14, weight: .semibold))
                .foregroundColor(AppColors.accentYellow)
            
            Text(content)
                .font(FontManager.playfairDisplay(size: 16))
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
}

extension DateFormatter {
    static let longDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

#Preview {
    IdeaDetailsView(
        idea: NailIdea(
            name: "Golden Autumn",
            mainColor: "Warm golden",
            additionalColors: "Beige, orange",
            designType: .gradient,
            seasonEvent: .autumn,
            comment: "Add glossy top coat"
        ),
        viewModel: NailIdeasViewModel()
    )
}
