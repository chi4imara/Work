import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HobbyViewModel
    @State private var showingAddHobby = false
    @State private var showingDeleteAlert = false
    @State private var hobbyToDelete: Hobby?
    @State private var showingRenameAlert = false
    @State private var hobbyToRename: Hobby?
    @State private var newHobbyName = ""
    
    var body: some View {
        ZStack {
            WebPatternBackground()
                
                if viewModel.hobbies.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            headerView
                            
                            overallProgressView
                            
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.hobbies) { hobby in
                                    HobbyCard(hobby: hobby, viewModel: viewModel)
                                        .onTapGesture {
                                            viewModel.selectedHobby = hobby
                                        }
                                        .contextMenu {
                                            Button("Rename") {
                                                hobbyToRename = hobby
                                                newHobbyName = hobby.name
                                                showingRenameAlert = true
                                            }
                                            
                                            Button("Delete", role: .destructive) {
                                                hobbyToDelete = hobby
                                                showingDeleteAlert = true
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.bottom, 100)
                    }
                }
                
                Spacer()
        }
        .sheet(isPresented: $showingAddHobby) {
            AddHobbyView(viewModel: viewModel)
        }
        .alert("Delete Hobby", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let hobby = hobbyToDelete {
                    viewModel.deleteHobby(hobby)
                }
            }
        } message: {
            Text("Are you sure you want to delete this hobby? All sessions will be lost.")
        }
        .alert("Rename Hobby", isPresented: $showingRenameAlert) {
            TextField("Hobby name", text: $newHobbyName)
            Button("Cancel", role: .cancel) { }
            Button("Save") {
                if let hobby = hobbyToRename, !newHobbyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    viewModel.updateHobbyName(hobby, newName: newHobbyName.trimmingCharacters(in: .whitespacesAndNewlines))
                }
            }
        } message: {
            Text("Enter a new name for your hobby")
        }
        .overlay(
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showingAddHobby = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [ColorTheme.primaryBlue, ColorTheme.darkBlue]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                            .shadow(color: ColorTheme.primaryBlue.opacity(0.4), radius: 15, x: 0, y: 8)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 30)
                }
            }
        )
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Hobbies")
                    .font(FontManager.title)
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Track your passion journey")
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var overallProgressView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Overall Progress")
                    .font(FontManager.headline)
                    .foregroundColor(ColorTheme.primaryText)
                Spacer()
            }
            
            HStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(ColorTheme.lightBlue.opacity(0.3), lineWidth: 8)
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .trim(from: 0, to: viewModel.overallProgress)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [ColorTheme.primaryBlue, ColorTheme.darkBlue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1.0), value: viewModel.overallProgress)
                    
                    Text("\(Int(viewModel.overallProgress * 100))%")
                        .font(FontManager.subheadline)
                        .foregroundColor(ColorTheme.primaryBlue)
                        .fontWeight(.bold)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(ColorTheme.primaryBlue)
                        Text("Total Sessions: \(viewModel.totalSessions)")
                            .font(FontManager.body)
                            .foregroundColor(ColorTheme.primaryText)
                    }
                    
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(ColorTheme.success)
                        Text("Active Hobbies: \(viewModel.activeHobbies)")
                            .font(FontManager.body)
                            .foregroundColor(ColorTheme.primaryText)
                    }
                    
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(ColorTheme.accent)
                        Text("Total Time: \(viewModel.totalTimeFormatted)")
                            .font(FontManager.body)
                            .foregroundColor(ColorTheme.primaryText)
                    }
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(ColorTheme.cardGradient)
        .cornerRadius(16)
        .shadow(color: ColorTheme.lightBlue.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            headerView
            
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorTheme.lightBlue.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "book.closed.fill")
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(ColorTheme.lightBlue)
            }
            
            VStack(spacing: 12) {
                Text("No hobbies yet")
                    .font(FontManager.headline)
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Add your first hobby to start tracking your progress and building consistent habits.")
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: {
                showingAddHobby = true
            }) {
                Text("Create Hobby")
                    .font(FontManager.subheadline)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [ColorTheme.primaryBlue, ColorTheme.darkBlue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            
            Spacer()
            Spacer()
            Spacer()
        }
    }
}
