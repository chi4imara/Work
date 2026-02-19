import SwiftUI

struct CourseDetailView: View {
    let courseId: UUID
    @ObservedObject private var viewModel = CoursesViewModel.shared
    @Environment(\.dismiss) private var dismiss
    @State private var course: Course?
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                if let course = course {
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 20) {
                                Text(course.title)
                                    .font(.custom("PlayfairDisplay-Bold", size: 28))
                                    .foregroundColor(Color.theme.primaryBlue)
                                    .lineLimit(nil)
                                
                                HStack(spacing: 12) {
                                    Text(course.skill)
                                        .font(.custom("PlayfairDisplay-Medium", size: 14))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.theme.accentOrange)
                                        .cornerRadius(12)
                                    
                                    Text(course.duration)
                                        .font(.custom("PlayfairDisplay-Medium", size: 14))
                                        .foregroundColor(Color.theme.darkGray)
                                    
                                    Text("•")
                                        .foregroundColor(Color.theme.darkGray)
                                    
                                    Text(course.level.rawValue)
                                        .font(.custom("PlayfairDisplay-Medium", size: 14))
                                        .foregroundColor(Color.theme.primaryBlue)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.theme.lightBlue.opacity(0.3))
                                        .cornerRadius(8)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            if course.isStarted {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("Your Progress")
                                            .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                            .foregroundColor(Color.theme.primaryBlue)
                                        
                                        Spacer()
                                        
                                        Text("\(Int(course.progress * 100))%")
                                            .font(.custom("PlayfairDisplay-Bold", size: 18))
                                            .foregroundColor(Color.theme.primaryBlue)
                                    }
                                    
                                    ProgressView(value: course.progress)
                                        .progressViewStyle(LinearProgressViewStyle(tint: Color.theme.primaryYellow))
                                        .scaleEffect(x: 1, y: 3, anchor: .center)
                                }
                                .padding(20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                                .padding(.horizontal, 20)
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("About This Course")
                                    .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                                    .foregroundColor(Color.theme.primaryBlue)
                                
                                Text(course.description.isEmpty ? "This course will help you develop essential skills in \(course.skill.lowercased()). Complete interactive exercises and track your progress as you learn." : course.description)
                                    .font(.custom("PlayfairDisplay-Regular", size: 16))
                                    .foregroundColor(Color.theme.darkGray)
                                    .lineSpacing(4)
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                            .padding(.horizontal, 20)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("What You'll Learn")
                                    .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                                    .foregroundColor(Color.theme.primaryBlue)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    LearningPoint(text: "Master key concepts and techniques")
                                    LearningPoint(text: "Practice with real-world examples")
                                    LearningPoint(text: "Track your progress and achievements")
                                    LearningPoint(text: "Apply skills in practical scenarios")
                                }
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                            .padding(.horizontal, 20)
                            
                            Button(action: {
                                viewModel.startCourse(course)
                                loadCourse()
                            }) {
                                HStack {
                                    Text(course.isStarted ? "Continue Learning" : "Start Course")
                                        .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                        .foregroundColor(.white)
                                    
                                    Image(systemName: course.isStarted ? "play.circle.fill" : "play.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.theme.buttonGradient)
                                .cornerRadius(28)
                                .shadow(color: Color.theme.primaryYellow.opacity(0.3), radius: 10, x: 0, y: 5)
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
            .navigationTitle("Course Details")
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
            loadCourse()
        }
    }
    
    private func loadCourse() {
        course = viewModel.courses.first { $0.id == courseId }
    }
}

struct LearningPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(Color.theme.softGreen)
            
            Text(text)
                .font(.custom("PlayfairDisplay-Regular", size: 16))
                .foregroundColor(Color.theme.darkGray)
        }
    }
}

#Preview {
    CourseDetailView(courseId: UUID())
}
