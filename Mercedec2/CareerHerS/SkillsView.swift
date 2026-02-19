import SwiftUI

struct SkillsView: View {
    @ObservedObject private var viewModel = SkillsViewModel.shared
    @State private var selectedSkillId: UUID?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("My Skills")
                        .font(.custom("PlayfairDisplay-Bold", size: 28))
                        .foregroundColor(Color.theme.primaryBlue)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.showAddSkill = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Color.theme.primaryYellow)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.selectedSkills.isEmpty {
                    EmptySkillsView(viewModel: viewModel)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.selectedSkills) { skill in
                                SkillCard(skill: skill, viewModel: viewModel, onOpen: {
                                    selectedSkillId = skill.id
                                })
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showAddSkill) {
            AddSkillView(viewModel: viewModel)
        }
        .sheet(item: Binding(
            get: { selectedSkillId.map { SkillDetailItem(id: $0) } },
            set: { selectedSkillId = $0?.id }
        )) { item in
            SkillDetailView(skillId: item.id)
        }
    }
}

struct SkillDetailItem: Identifiable {
    let id: UUID
}

struct SkillCard: View {
    let skill: Skill
    let viewModel: SkillsViewModel
    let onOpen: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: skill.icon)
                .font(.system(size: 32))
                .foregroundColor(Color.theme.primaryBlue)
                .frame(width: 50, height: 50)
                .background(Color.theme.lightBlue.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 8) {
                Text(skill.name)
                    .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                    .foregroundColor(Color.theme.primaryBlue)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Progress")
                            .font(.custom("PlayfairDisplay-Medium", size: 12))
                            .foregroundColor(Color.theme.darkGray)
                        
                        Spacer()
                        
                        Text("\(Int(skill.progress * 100))%")
                            .font(.custom("PlayfairDisplay-SemiBold", size: 12))
                            .foregroundColor(Color.theme.primaryBlue)
                    }
                    
                    ProgressView(value: skill.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color.theme.primaryYellow))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                }
            }
            
            Spacer()
            
            Button(action: onOpen) {
                Text("Open")
                    .font(.custom("PlayfairDisplay-SemiBold", size: 14))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.theme.buttonGradient)
                    .cornerRadius(16)
            }
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct EmptySkillsView: View {
    let viewModel: SkillsViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "star.circle")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.primaryBlue.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No skills selected")
                    .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                    .foregroundColor(Color.theme.primaryBlue)
                
                Text("Add your first skill to start tracking progress")
                    .font(.custom("PlayfairDisplay-Regular", size: 16))
                    .foregroundColor(Color.theme.darkGray)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                viewModel.showAddSkill = true
            }) {
                Text("Add First Skill")
                    .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                    .foregroundColor(.white)
                    .frame(width: 160, height: 44)
                    .background(Color.theme.buttonGradient)
                    .cornerRadius(22)
            }
            
            Spacer()
        }
        .padding(40)
    }
}

struct AddSkillView: View {
    @ObservedObject var viewModel: SkillsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Choose skills you want to develop")
                            .font(.custom("PlayfairDisplay-Regular", size: 16))
                            .foregroundColor(Color.theme.darkGray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.skills) { skill in
                                SkillSelectionRow(skill: skill, viewModel: viewModel)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationTitle("Add Skills")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.custom("PlayfairDisplay-Medium", size: 16))
                    .foregroundColor(Color.theme.accentOrange)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                    .foregroundColor(Color.theme.primaryBlue)
                }
            }
        }
    }
}

struct SkillSelectionRow: View {
    let skill: Skill
    let viewModel: SkillsViewModel
    
    var body: some View {
        Button(action: {
            viewModel.toggleSkillSelection(skill)
        }) {
            HStack(spacing: 16) {
                Image(systemName: skill.icon)
                    .font(.system(size: 24))
                    .foregroundColor(Color.theme.primaryBlue)
                    .frame(width: 40, height: 40)
                    .background(Color.theme.lightBlue.opacity(0.2))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(skill.name)
                        .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                        .foregroundColor(Color.theme.primaryBlue)
                    
                    if skill.progress > 0 {
                        Text("Progress: \(Int(skill.progress * 100))%")
                            .font(.custom("PlayfairDisplay-Regular", size: 12))
                            .foregroundColor(Color.theme.darkGray)
                    }
                }
                
                Spacer()
                
                Image(systemName: skill.isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(skill.isSelected ? Color.theme.softGreen : Color.theme.darkGray.opacity(0.3))
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(skill.isSelected ? Color.theme.softGreen : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SkillsView()
}
