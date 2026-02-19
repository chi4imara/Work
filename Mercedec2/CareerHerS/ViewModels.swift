import Foundation
import SwiftUI
import StoreKit
import Combine

class AppViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var showOnboarding = false
    @Published var currentUser: User?
    
    init() {
        checkFirstLaunch()
        loadUserData()
    }
    
    private func checkFirstLaunch() {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if !hasLaunchedBefore {
            showOnboarding = true
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
    }
    
    private func loadUserData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isLoading = false
            if self.currentUser == nil {
                self.currentUser = User()
            }
        }
    }
    
    func completeOnboarding() {
        showOnboarding = false
    }
}

class CoursesViewModel: ObservableObject {
    @Published var courses: [Course] = [] {
        didSet {
            if !isInitializing {
                DataManager.shared.saveCourses(courses)
                updateProgress()
            }
        }
    }
    @Published var filteredCourses: [Course] = []
    @Published var currentFilter = CourseFilter()
    @Published var showFilters = false
    
    static let shared = CoursesViewModel()
    private var isInitializing = true
    
    init() {
        courses = DataManager.shared.loadCourses()
        filteredCourses = courses
        isInitializing = false
    }
    
    private func updateProgress() {
        ProgressViewModel.shared.updateFromCourses(courses)
    }
    
    func generateCoursesForSkill(_ skillName: String) {
        let skillCourses = getCoursesForSkill(skillName)
        for course in skillCourses {
            if !courses.contains(where: { $0.title == course.title }) {
                courses.append(course)
            }
        }
        applyFilter()
    }
    
    private func getCoursesForSkill(_ skillName: String) -> [Course] {
        switch skillName {
        case "Communication":
            return [
                Course(title: "Effective Communication Basics", skill: skillName, duration: "15 min", level: .beginner, description: "Learn the fundamentals of clear and effective communication"),
                Course(title: "Advanced Communication Strategies", skill: skillName, duration: "30 min", level: .intermediate, description: "Master advanced techniques for professional communication"),
                Course(title: "Public Speaking Mastery", skill: skillName, duration: "45 min", level: .advanced, description: "Develop confidence and skills for public speaking")
            ]
        case "Leadership":
            return [
                Course(title: "Leadership Fundamentals", skill: skillName, duration: "20 min", level: .beginner, description: "Discover key leadership principles and practices"),
                Course(title: "Team Management Essentials", skill: skillName, duration: "30 min", level: .intermediate, description: "Learn how to effectively manage and motivate teams"),
                Course(title: "Advanced Leadership Strategies", skill: skillName, duration: "1 hour", level: .advanced, description: "Advanced techniques for effective leadership")
            ]
        case "Time Management":
            return [
                Course(title: "Time Management Mastery", skill: skillName, duration: "25 min", level: .beginner, description: "Master the art of managing your time effectively"),
                Course(title: "Productivity Hacks", skill: skillName, duration: "20 min", level: .intermediate, description: "Learn proven techniques to boost your productivity"),
                Course(title: "Strategic Planning", skill: skillName, duration: "45 min", level: .advanced, description: "Develop strategic planning skills for long-term success")
            ]
        case "Confidence":
            return [
                Course(title: "Building Confidence", skill: skillName, duration: "15 min", level: .beginner, description: "Develop unshakeable self-confidence"),
                Course(title: "Overcoming Self-Doubt", skill: skillName, duration: "25 min", level: .intermediate, description: "Learn to overcome limiting beliefs and self-doubt"),
                Course(title: "Executive Presence", skill: skillName, duration: "40 min", level: .advanced, description: "Build executive presence and professional confidence")
            ]
        case "Emotional Intelligence":
            return [
                Course(title: "Emotional Intelligence Basics", skill: skillName, duration: "20 min", level: .beginner, description: "Understand and manage emotions effectively"),
                Course(title: "Empathy and Connection", skill: skillName, duration: "30 min", level: .intermediate, description: "Develop empathy and build stronger connections"),
                Course(title: "Advanced EQ Strategies", skill: skillName, duration: "50 min", level: .advanced, description: "Master emotional intelligence for leadership")
            ]
        default:
            return [
                Course(title: "Introduction to \(skillName)", skill: skillName, duration: "20 min", level: .beginner, description: "Get started with \(skillName.lowercased())"),
                Course(title: "\(skillName) Essentials", skill: skillName, duration: "30 min", level: .intermediate, description: "Master the essentials of \(skillName.lowercased())")
            ]
        }
    }
    
    func applyFilter() {
        filteredCourses = courses.filter { course in
            var matches = true
            
            if let skillType = currentFilter.skillType, !skillType.isEmpty {
                matches = matches && course.skill.lowercased().contains(skillType.lowercased())
            }
            
            if let level = currentFilter.level {
                matches = matches && course.level == level
            }
            
            if let timeFilter = currentFilter.timeAvailable {
                matches = matches && matchesTimeFilter(course: course, filter: timeFilter)
            }
            
            return matches
        }
        showFilters = false
    }
    
    private func matchesTimeFilter(course: Course, filter: TimeFilter) -> Bool {
        let duration = course.duration.lowercased()
        switch filter {
        case .short:
            return duration.contains("15 min") || duration.contains("10 min") || duration.contains("5 min")
        case .medium:
            return duration.contains("15 min") || duration.contains("20 min") || duration.contains("25 min") || duration.contains("30 min")
        case .long:
            return duration.contains("45 min") || duration.contains("1 hour") || duration.contains("hour")
        }
    }
    
    func resetFilter() {
        currentFilter = CourseFilter()
        filteredCourses = courses
        showFilters = false
    }
    
    func startCourse(_ course: Course) {
        guard let index = courses.firstIndex(where: { $0.id == course.id }) else { return }
        
        if !courses[index].isStarted {
            courses[index].isStarted = true
            courses[index].progress = 0.1
        } else {
            let step: Double = 0.2
            let newProgress = min(courses[index].progress + step, 1.0)
            courses[index].progress = newProgress
            if newProgress >= 1.0 && !courses[index].isCompleted {
                courses[index].isCompleted = true
                ProgressViewModel.shared.addAchievement(
                    Achievement(title: courses[index].title, skill: courses[index].skill, type: .courseCompleted)
                )
            }
        }
        updateSkillProgress(for: course.skill)
        updateProgress()
        applyFilter()
    }
    
    func updateCourseProgress(_ courseId: UUID, progress: Double) {
        if let index = courses.firstIndex(where: { $0.id == courseId }) {
            courses[index].progress = progress
            if progress >= 1.0 && !courses[index].isCompleted {
                courses[index].isCompleted = true
                ProgressViewModel.shared.addAchievement(
                    Achievement(title: courses[index].title, skill: courses[index].skill, type: .courseCompleted)
                )
                updateSkillProgress(for: courses[index].skill)
            }
            updateProgress()
        }
    }
    
    private func updateSkillProgress(for skillName: String) {
        let skillCourses = courses.filter { $0.skill == skillName }
        let totalProgress = skillCourses.reduce(0.0) { $0 + $1.progress }
        let averageProgress = skillCourses.isEmpty ? 0.0 : totalProgress / Double(skillCourses.count)
        
        if let skillIndex = SkillsViewModel.shared.skills.firstIndex(where: { $0.name == skillName }) {
            SkillsViewModel.shared.skills[skillIndex].progress = averageProgress
        }
    }
}

class SkillsViewModel: ObservableObject {
    @Published var skills: [Skill] = [] {
        didSet {
            if !isInitializing {
                DataManager.shared.saveSkills(skills)
                updateProgress()
            }
        }
    }
    @Published var showAddSkill = false
    
    static let shared = SkillsViewModel()
    private var isInitializing = true
    
    init() {
        skills = DataManager.shared.loadSkills()
        isInitializing = false
    }
    
    private func updateProgress() {
        ProgressViewModel.shared.updateFromSkills(skills)
    }
    
    func addSkillIfNeeded(_ skillName: String) {
        if !skills.contains(where: { $0.name == skillName }) {
            let icon = getIconForSkill(skillName)
            let newSkill = Skill(name: skillName, icon: icon, progress: 0.0, isSelected: true)
            skills.append(newSkill)
        } else {
            if let index = skills.firstIndex(where: { $0.name == skillName }) {
                skills[index].isSelected = true
            }
        }
    }
    
    private func getIconForSkill(_ skillName: String) -> String {
        switch skillName {
        case "Communication":
            return "message.circle"
        case "Leadership":
            return "person.3"
        case "Time Management":
            return "clock"
        case "Confidence":
            return "star.circle"
        case "Emotional Intelligence":
            return "heart.circle"
        default:
            return "star.circle"
        }
    }
    
    func addSkill(_ skill: Skill) {
        skills.append(skill)
    }
    
    func toggleSkillSelection(_ skill: Skill) {
        if let index = skills.firstIndex(where: { $0.id == skill.id }) {
            skills[index].isSelected.toggle()
        }
    }
    
    var selectedSkills: [Skill] {
        return skills.filter { $0.isSelected }
    }
}

class ProgressViewModel: ObservableObject {
    @Published var progressData: ProgressData? {
        didSet {
            if !isInitializing, let progress = progressData {
                DataManager.shared.saveProgress(progress)
            }
        }
    }
    @Published var achievements: [Achievement] = [] {
        didSet {
            if !isInitializing {
                DataManager.shared.saveAchievements(achievements)
            }
        }
    }
    
    static let shared = ProgressViewModel()
    private var isInitializing = true
    
    init() {
        achievements = DataManager.shared.loadAchievements()
        loadProgressData()
        isInitializing = false
        
        DispatchQueue.main.async {
            if self.progressData == nil {
                self.updateFromCourses(CoursesViewModel.shared.courses)
            }
        }
    }
    
    func updateFromCourses(_ courses: [Course]) {
        let completedCourses = courses.filter { $0.isCompleted }
        let totalTimeSpent = calculateTotalTimeSpent(courses: courses)
        let dailyActivity = generateDailyActivity(from: courses)
        let skillDistribution = calculateSkillDistribution(courses: courses, skills: SkillsViewModel.shared.skills)
        
        progressData = ProgressData(
            dailyActivity: dailyActivity,
            skillDistribution: skillDistribution,
            achievements: achievements,
            totalCoursesCompleted: completedCourses.count,
            totalTimeSpent: totalTimeSpent
        )
    }
    
    func updateFromSkills(_ skills: [Skill]) {
        guard let progress = progressData else {
            updateFromCourses(CoursesViewModel.shared.courses)
            return
        }
        
        let skillDistribution = calculateSkillDistribution(courses: CoursesViewModel.shared.courses, skills: skills)
        
        progressData = ProgressData(
            dailyActivity: progress.dailyActivity,
            skillDistribution: skillDistribution,
            achievements: achievements,
            totalCoursesCompleted: progress.totalCoursesCompleted,
            totalTimeSpent: progress.totalTimeSpent
        )
    }
    
    func addAchievement(_ achievement: Achievement) {
        if !achievements.contains(where: { $0.title == achievement.title }) {
            achievements.append(achievement)
            updateFromCourses(CoursesViewModel.shared.courses)
        }
    }
    
    private func loadProgressData() {
        if let saved = DataManager.shared.loadProgress() {
            progressData = saved
        } else {
            updateFromCourses(CoursesViewModel.shared.courses)
        }
    }
    
    private func calculateTotalTimeSpent(courses: [Course]) -> TimeInterval {
        return courses.reduce(0) { total, course in
            let duration = parseDuration(course.duration)
            return total + (duration * course.progress)
        }
    }
    
    private func parseDuration(_ duration: String) -> TimeInterval {
        let lowercased = duration.lowercased()
        if lowercased.contains("hour") {
            return 3600
        } else if let minutes = Int(lowercased.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
            return TimeInterval(minutes * 60)
        }
        return 0
    }
    
    private func generateDailyActivity(from courses: [Course]) -> [ActivityPoint] {
        let savedActivity = DataManager.shared.loadDailyActivity()
        let calendar = Calendar.current
        let today = Date()
        
        var activityMap: [Date: Double] = [:]
        
        for point in savedActivity {
            let day = calendar.startOfDay(for: point.date)
            activityMap[day] = (activityMap[day] ?? 0) + point.value
        }
        
        for course in courses where course.isStarted {
            let daysAgo = Int.random(in: 0..<30)
            if let date = calendar.date(byAdding: .day, value: -daysAgo, to: today) {
                let day = calendar.startOfDay(for: date)
                activityMap[day] = (activityMap[day] ?? 0) + course.progress * 2
            }
        }
        
        var activityPoints: [ActivityPoint] = []
        for i in 0..<30 {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let day = calendar.startOfDay(for: date)
                let value = activityMap[day] ?? 0
                activityPoints.append(ActivityPoint(date: day, value: min(value, 10)))
            }
        }
        
        let sorted = activityPoints.sorted { $0.date < $1.date }
        DataManager.shared.saveDailyActivity(sorted)
        return sorted
    }
    
    private func calculateSkillDistribution(courses: [Course], skills: [Skill]) -> [SkillProgress] {
        var skillTimeMap: [String: TimeInterval] = [:]
        var skillProgressMap: [String: Double] = [:]
        
        for skill in skills {
            skillTimeMap[skill.name] = 0
            skillProgressMap[skill.name] = skill.progress
        }
        
        for course in courses where course.isStarted {
            let duration = parseDuration(course.duration)
            let timeSpent = duration * course.progress
            skillTimeMap[course.skill] = (skillTimeMap[course.skill] ?? 0) + timeSpent
        }
        
        let totalTime = skillTimeMap.values.reduce(0, +)
        
        return skillTimeMap.map { skill, timeSpent in
            let percentage = totalTime > 0 ? (timeSpent / totalTime) * 100 : 0
            return SkillProgress(skill: skill, timeSpent: timeSpent, percentage: percentage)
        }
    }
}

class ProfileViewModel: ObservableObject {
    @Published var user: User {
        didSet {
            if !isInitializing {
                DataManager.shared.saveUser(user)
            }
        }
    }
    @Published var showGoalCreation = false
    @Published var showSettings = false
    
    static let shared = ProfileViewModel()
    private var isInitializing = true
    
    init(user: User? = nil) {
        if let savedUser = user ?? DataManager.shared.loadUser() {
            self.user = savedUser
        } else {
            self.user = User()
        }
        isInitializing = false
    }
    
    func saveProfile() {
        DataManager.shared.saveUser(user)
    }
    
    func syncNotificationSettingsWithSystem() {
        NotificationManager.shared.isAuthorized { [weak self] allowed in
            guard let self = self, !allowed else { return }
            var u = self.user
            u.notificationsEnabled = false
            u.weeklyReportEnabled = false
            self.user = u
        }
    }
    
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

class GoalCreationViewModel: ObservableObject {
    @Published var title = ""
    @Published var selectedSkill = ""
    @Published var deadline = Date()
    @Published var priority: Priority = .medium
    
    let availableSkills = ["Communication", "Leadership", "Time Management", "Confidence", "Emotional Intelligence"]
    
    func createGoal() -> Goal {
        let goal = Goal(
            title: title,
            skill: selectedSkill,
            deadline: deadline,
            priority: priority
        )
        
        SkillsViewModel.shared.addSkillIfNeeded(selectedSkill)
        CoursesViewModel.shared.generateCoursesForSkill(selectedSkill)
        
        return goal
    }
    
    func resetForm() {
        title = ""
        selectedSkill = ""
        deadline = Date()
        priority = .medium
    }
    
    var isFormValid: Bool {
        return !title.isEmpty && !selectedSkill.isEmpty
    }
}
