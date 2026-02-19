import SwiftUI

struct CoursesView: View {
    @ObservedObject private var viewModel = CoursesViewModel.shared
    @State private var selectedCourseId: UUID?
    @State private var showGoalCreation = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Recommended for growth")
                            .font(.custom("PlayfairDisplay-Bold", size: 28))
                            .foregroundColor(Color.theme.primaryBlue)
                        
                        Text("Courses that help achieve your goals")
                            .font(.custom("PlayfairDisplay-Regular", size: 16))
                            .foregroundColor(Color.theme.darkGray)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.showFilters.toggle()
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 20))
                            .foregroundColor(Color.theme.primaryBlue)
                            .padding(12)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if viewModel.filteredCourses.isEmpty {
                    EmptyCoursesView(viewModel: viewModel, showGoalCreation: $showGoalCreation)
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.filteredCourses) { course in
                                CourseCard(course: course, viewModel: viewModel, onTap: {
                                    selectedCourseId = course.id
                                })
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showFilters) {
            CourseFiltersView(viewModel: viewModel)
        }
        .sheet(isPresented: $showGoalCreation) {
            GoalCreationView()
        }
        .sheet(item: Binding(
            get: { selectedCourseId.map { CourseDetailItem(id: $0) } },
            set: { selectedCourseId = $0?.id }
        )) { item in
            CourseDetailView(courseId: item.id)
        }
    }
}

struct CourseDetailItem: Identifiable {
    let id: UUID
}

struct CourseCard: View {
    let course: Course
    let viewModel: CoursesViewModel
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(course.title)
                        .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                        .foregroundColor(Color.theme.primaryBlue)
                        .lineLimit(2)
                    
                    Text(course.skill)
                        .font(.custom("PlayfairDisplay-Medium", size: 14))
                        .foregroundColor(Color.theme.accentOrange)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.theme.accentOrange.opacity(0.1))
                        .cornerRadius(12)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(course.duration)
                        .font(.custom("PlayfairDisplay-Medium", size: 12))
                        .foregroundColor(Color.theme.darkGray)
                    
                    Text(course.level.rawValue)
                        .font(.custom("PlayfairDisplay-Regular", size: 12))
                        .foregroundColor(Color.theme.primaryBlue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.theme.lightBlue.opacity(0.3))
                        .cornerRadius(8)
                }
            }
            
            if course.isStarted {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Progress")
                            .font(.custom("PlayfairDisplay-Medium", size: 12))
                            .foregroundColor(Color.theme.darkGray)
                        
                        Spacer()
                        
                        Text("\(Int(course.progress * 100))%")
                            .font(.custom("PlayfairDisplay-SemiBold", size: 12))
                            .foregroundColor(Color.theme.primaryBlue)
                    }
                    
                    ProgressView(value: course.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color.theme.primaryYellow))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                }
            }
            
            Text(course.description)
                .font(.custom("PlayfairDisplay-Regular", size: 14))
                .foregroundColor(Color.theme.darkGray)
                .lineLimit(2)
            
            HStack(spacing: 12) {
                Button(action: onTap) {
                    HStack {
                        Text("Details")
                            .font(.custom("PlayfairDisplay-SemiBold", size: 14))
                            .foregroundColor(Color.theme.primaryBlue)
                        
                        Image(systemName: "info.circle")
                            .font(.system(size: 14))
                            .foregroundColor(Color.theme.primaryBlue)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.white)
                    .cornerRadius(22)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color.theme.primaryBlue, lineWidth: 2)
                    )
                }
                
                Button(action: {
                    viewModel.startCourse(course)
                }) {
                    HStack {
                        Text(course.isStarted ? "Continue" : "Start")
                            .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                            .foregroundColor(.white)
                        
                        Image(systemName: course.isStarted ? "play.circle.fill" : "play.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.theme.buttonGradient)
                    .cornerRadius(22)
                }
            }
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct EmptyCoursesView: View {
    let viewModel: CoursesViewModel
    @Binding var showGoalCreation: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.primaryBlue.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No suitable courses found")
                    .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                    .foregroundColor(Color.theme.primaryBlue)
                
                Text("Try changing your goals or filters")
                    .font(.custom("PlayfairDisplay-Regular", size: 16))
                    .foregroundColor(Color.theme.darkGray)
            }
            
            Button(action: {
                showGoalCreation = true
            }) {
                Text("Change Goals")
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

struct CourseFiltersView: View {
    @ObservedObject var viewModel: CoursesViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let skillTypes = ["Communication", "Leadership", "Time Management", "Confidence", "Emotional Intelligence"]
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Skill Type")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                .foregroundColor(Color.theme.primaryBlue)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                ForEach(skillTypes, id: \.self) { skill in
                                    Button(action: {
                                        if viewModel.currentFilter.skillType == skill {
                                            viewModel.currentFilter.skillType = nil
                                        } else {
                                            viewModel.currentFilter.skillType = skill
                                        }
                                    }) {
                                        Text(skill)
                                            .font(.custom("PlayfairDisplay-Medium", size: 14))
                                            .foregroundColor(viewModel.currentFilter.skillType == skill ? .white : Color.theme.primaryBlue)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .frame(maxWidth: .infinity)
                                            .background(viewModel.currentFilter.skillType == skill ? Color.theme.primaryBlue : Color.white)
                                            .cornerRadius(20)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.theme.primaryBlue, lineWidth: 1)
                                            )
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Level")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                .foregroundColor(Color.theme.primaryBlue)
                            
                            HStack(spacing: 8) {
                                ForEach(CourseLevel.allCases, id: \.self) { level in
                                    Button(action: {
                                        if viewModel.currentFilter.level == level {
                                            viewModel.currentFilter.level = nil
                                        } else {
                                            viewModel.currentFilter.level = level
                                        }
                                    }) {
                                        Text(level.rawValue)
                                            .font(.custom("PlayfairDisplay-Medium", size: 14))
                                            .foregroundColor(viewModel.currentFilter.level == level ? .white : Color.theme.primaryBlue)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(viewModel.currentFilter.level == level ? Color.theme.primaryBlue : Color.white)
                                            .cornerRadius(20)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.theme.primaryBlue, lineWidth: 1)
                                            )
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Available Time")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                .foregroundColor(Color.theme.primaryBlue)
                            
                            VStack(spacing: 8) {
                                ForEach(TimeFilter.allCases, id: \.self) { timeFilter in
                                    Button(action: {
                                        if viewModel.currentFilter.timeAvailable == timeFilter {
                                            viewModel.currentFilter.timeAvailable = nil
                                        } else {
                                            viewModel.currentFilter.timeAvailable = timeFilter
                                        }
                                    }) {
                                        HStack {
                                            Text(timeFilter.rawValue)
                                                .font(.custom("PlayfairDisplay-Medium", size: 14))
                                                .foregroundColor(viewModel.currentFilter.timeAvailable == timeFilter ? .white : Color.theme.primaryBlue)
                                            
                                            Spacer()
                                            
                                            if viewModel.currentFilter.timeAvailable == timeFilter {
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(viewModel.currentFilter.timeAvailable == timeFilter ? Color.theme.primaryBlue : Color.white)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.theme.primaryBlue, lineWidth: 1)
                                        )
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        viewModel.resetFilter()
                        dismiss()
                    }
                    .font(.custom("PlayfairDisplay-Medium", size: 16))
                    .foregroundColor(Color.theme.accentOrange)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        viewModel.applyFilter()
                        dismiss()
                    }
                    .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                    .foregroundColor(Color.theme.primaryBlue)
                }
            }
        }
    }
}

#Preview {
    CoursesView()
}
