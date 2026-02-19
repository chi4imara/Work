import SwiftUI

struct SkillDetailView: View {
    let skillId: UUID
    @ObservedObject private var viewModel = SkillsViewModel.shared
    @Environment(\.dismiss) private var dismiss
    @State private var skill: Skill?
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                if let skill = skill {
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(spacing: 20) {
                                Image(systemName: skill.icon)
                                    .font(.system(size: 80))
                                    .foregroundColor(Color.theme.primaryBlue)
                                    .frame(width: 140, height: 140)
                                    .background(Color.theme.lightBlue.opacity(0.2))
                                    .clipShape(Circle())
                                
                                Text(skill.name)
                                    .font(.custom("PlayfairDisplay-Bold", size: 32))
                                    .foregroundColor(Color.theme.primaryBlue)
                            }
                            .padding(.top, 40)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Progress")
                                    .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                                    .foregroundColor(Color.theme.primaryBlue)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("Overall Progress")
                                            .font(.custom("PlayfairDisplay-Medium", size: 16))
                                            .foregroundColor(Color.theme.darkGray)
                                        
                                        Spacer()
                                        
                                        Text("\(Int(skill.progress * 100))%")
                                            .font(.custom("PlayfairDisplay-Bold", size: 20))
                                            .foregroundColor(Color.theme.primaryBlue)
                                    }
                                    
                                    ProgressView(value: skill.progress)
                                        .progressViewStyle(LinearProgressViewStyle(tint: Color.theme.primaryYellow))
                                        .scaleEffect(x: 1, y: 3, anchor: .center)
                                }
                                .padding(20)
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Related Courses")
                                    .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                                    .foregroundColor(Color.theme.primaryBlue)
                                
                                LazyVStack(spacing: 12) {
                                    ForEach(getRelatedCourses(for: skill.name)) { course in
                                        CourseRow(course: course)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer(minLength: 40)
                        }
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.theme.primaryBlue))
                }
            }
            .navigationTitle("Skill Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                    .foregroundColor(Color.theme.primaryBlue)
                }
            }
        }
        .onAppear {
            loadSkill()
        }
    }
    
    private func loadSkill() {
        skill = viewModel.skills.first { $0.id == skillId }
    }
    
    private func getRelatedCourses(for skillName: String) -> [Course] {
        return CoursesViewModel.shared.courses.filter { $0.skill == skillName }
    }
}

struct CourseRow: View {
    let course: Course
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(course.title)
                    .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                    .foregroundColor(Color.theme.primaryBlue)
                    .lineLimit(2)
                
                HStack {
                    Text(course.duration)
                        .font(.custom("PlayfairDisplay-Regular", size: 12))
                        .foregroundColor(Color.theme.darkGray)
                    
                    Text("•")
                        .foregroundColor(Color.theme.darkGray)
                    
                    Text(course.level.rawValue)
                        .font(.custom("PlayfairDisplay-Regular", size: 12))
                        .foregroundColor(Color.theme.darkGray)
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    SkillDetailView(skillId: UUID())
}
