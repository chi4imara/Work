import SwiftUI

struct ScenarioDetailView: View {
    let scenario: PhotoshootScenario
    @EnvironmentObject var viewModel: PhotoshootViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            StaticBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    detailsView
                    
                    actionButtons
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
        .navigationTitle("Shoot Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            EditScenarioView(scenario: scenario)
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Delete Scenario"),
                message: Text("Are you sure you want to delete this photoshoot scenario? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    viewModel.deleteScenario(scenario)
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(scenario.theme)
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(.appPrimaryText)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 8) {
                        Image(systemName: scenario.category.icon)
                            .font(.system(size: 16))
                        Text(scenario.category.rawValue)
                            .font(.ubuntu(16, weight: .medium))
                    }
                    .foregroundColor(.appDarkBlue)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Image(systemName: scenario.status.icon)
                        .font(.system(size: 32))
                        .foregroundColor(scenario.status == .planned ? .appPlanned : .appCompleted)
                    
                    Text(scenario.status.rawValue)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(scenario.status == .planned ? .appPlanned : .appCompleted)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .appPrimary.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private var detailsView: some View {
        VStack(spacing: 20) {
            HStack(spacing: 16) {
                DetailCard(
                    icon: "location.fill",
                    title: "Location",
                    content: scenario.location.isEmpty ? "Not specified" : scenario.location,
                    isEmpty: scenario.location.isEmpty
                )
                
                DetailCard(
                    icon: "calendar",
                    title: "Date",
                    content: scenario.date.formatted(date: .abbreviated, time: .omitted),
                    isEmpty: false
                )
            }
            
            if !scenario.poses.isEmpty {
                DetailSection(
                    icon: "figure.walk",
                    title: "Poses",
                    content: scenario.poses
                )
            }
            
            if !scenario.props.isEmpty {
                DetailSection(
                    icon: "cube.box.fill",
                    title: "Props",
                    content: scenario.props
                )
            }
            
            if !scenario.comment.isEmpty {
                DetailSection(
                    icon: "text.bubble.fill",
                    title: "Notes",
                    content: scenario.comment
                )
            }
            
            DetailCard(
                icon: "clock.fill",
                title: "Created",
                content: scenario.createdAt.formatted(date: .abbreviated, time: .shortened),
                isEmpty: false
            )
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            if scenario.status == .planned {
                Button(action: {
                    viewModel.markAsCompleted(scenario)
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Mark as Completed")
                            .font(.ubuntu(16, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.appGreen)
                    )
                }
            }
            
            Button(action: {
                showingEditView = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(.appPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.appPrimary, lineWidth: 2)
                )
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.red, lineWidth: 2)
                )
            }
        }
        .padding(.top, 20)
    }
}

struct DetailCard: View {
    let icon: String
    let title: String
    let content: String
    let isEmpty: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.appPrimary)
                
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(.appPrimaryText)
            }
            
            Text(content)
                .font(.ubuntu(16))
                .foregroundColor(isEmpty ? .appSecondaryText : .appPrimaryText)
                .italic(isEmpty)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(16)
        .frame(maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.appLightGray, lineWidth: 1)
                }
        )
    }
}

struct DetailSection: View {
    let icon: String
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.appPrimary)
                
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.appPrimaryText)
            }
            
            Text(content)
                .font(.ubuntu(16))
                .foregroundColor(.appPrimaryText)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.appLightGray, lineWidth: 1)
                }
        )
    }
}

#Preview {
    NavigationView {
        ScenarioDetailView(
            scenario: PhotoshootScenario(
                theme: "Summer Evening by the Sea",
                location: "Beach Pier",
                date: Date(),
                poses: "Sitting on sand, back to sun, close-up in motion",
                props: "Blanket, glass, straw hat",
                comment: "Shoot closer to sunset"
            ),
        )
    }
}
