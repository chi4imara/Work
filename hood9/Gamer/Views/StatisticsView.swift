import SwiftUI

struct StatisticsView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var selectedGameIdForPlayerStats: UUID?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Statistics")
                        .font(AppFonts.bold(size: 23))
                        .foregroundColor(AppColors.primaryText)
                        .padding(.leading, 60)
                    
                    Spacer()
                }
                .padding()
                .padding(.top, 4)
                
                if dataManager.sessions.isEmpty && dataManager.games.isEmpty {
                    EmptyStateView(
                        icon: "chart.bar.fill",
                        title: "No Data",
                        subtitle: "Add games and sessions to see statistics",
                        action: nil,
                        actionTitle: nil
                    )
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            SummarySection(
                                gamesCount: dataManager.games.filter { $0.isActive }.count,
                                sessionsCount: dataManager.sessions.count,
                                uniquePlayersCount: uniquePlayersCount,
                                avgDuration: averageDuration
                            )
                            
                            if !dataManager.sessions.isEmpty {
                                TopGamesSection(sessions: dataManager.sessions, games: dataManager.games)
                                
                                TopPlayersSection(sessions: dataManager.sessions)
                                
                                TopLocationsSection(sessions: dataManager.sessions)
                                
                                PlayerStatsByGameSection(
                                    selectedGameId: $selectedGameIdForPlayerStats,
                                    sessions: dataManager.sessions,
                                    games: dataManager.games
                                )
                                
                                WeeklyStatsSection(sessions: dataManager.sessions)
                                
                                TagsStatsSection(games: dataManager.games, sessions: dataManager.sessions)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
    private var allPlayerNames: [String] {
        dataManager.sessions.flatMap { $0.players }
    }
    
    private var uniquePlayersCount: Int {
        Set(allPlayerNames).count
    }
    
    private var averageDuration: Int? {
        let durations = dataManager.sessions.compactMap { $0.duration }
        guard !durations.isEmpty else { return nil }
        return durations.reduce(0, +) / durations.count
    }
}

struct SummarySection: View {
    let gamesCount: Int
    let sessionsCount: Int
    let uniquePlayersCount: Int
    let avgDuration: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Summary")
                .font(AppFonts.semiBold(size: 20))
                .foregroundColor(AppColors.primaryText)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                StatCard(title: "Games in Collection", value: "\(gamesCount)")
                StatCard(title: "Total Sessions", value: "\(sessionsCount)")
                StatCard(title: "Unique Players", value: "\(uniquePlayersCount)")
                if let avg = avgDuration {
                    StatCard(title: "Avg Duration", value: "\(avg) min")
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(AppFonts.bold(size: 24))
                .foregroundColor(AppColors.primaryBlue)
            Text(title)
                .font(AppFonts.regular(size: 13))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct TopGamesSection: View {
    let sessions: [GameSession]
    let games: [Game]
    
    private var gameCounts: [UUID: Int] {
        var counts: [UUID: Int] = [:]
        for session in sessions {
            counts[session.gameId, default: 0] += 1
        }
        return counts
    }
    
    private var lastDates: [UUID: Date] {
        var dates: [UUID: Date] = [:]
        for session in sessions {
            if let existing = dates[session.gameId] {
                dates[session.gameId] = max(existing, session.date)
            } else {
                dates[session.gameId] = session.date
            }
        }
        return dates
    }
    
    private var gameData: [(game: Game, count: Int, lastDate: Date)] {
        let counts = gameCounts
        let dates = lastDates
        
        return counts.compactMap { gameId, count in
            guard let game = games.first(where: { $0.id == gameId }),
                  let lastDate = dates[gameId] else { return nil }
            return (game, count, lastDate)
        }
    }
    
    private var sortedGameData: [(game: Game, count: Int, lastDate: Date)] {
        gameData.sorted { $0.count > $1.count || ($0.count == $1.count && $0.game.name < $1.game.name) }
    }
    
    var topGames: [(game: Game, count: Int, lastDate: Date)] {
        Array(sortedGameData.prefix(5))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top Games by Sessions")
                .font(AppFonts.semiBold(size: 20))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 10) {
                ForEach(0..<topGames.count, id: \.self) { index in
                    let item = topGames[index]
                    HStack {
                        Text("#\(index + 1)")
                            .font(AppFonts.semiBold(size: 16))
                            .foregroundColor(AppColors.accentOrange)
                            .frame(width: 35)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.game.name)
                                .font(AppFonts.medium(size: 15))
                                .foregroundColor(AppColors.primaryText)
                            Text("Last: \(item.lastDate.formatted(date: .abbreviated, time: .omitted))")
                                .font(AppFonts.regular(size: 12))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        
                        Spacer()
                        
                        Text("\(item.count)")
                            .font(AppFonts.bold(size: 18))
                            .foregroundColor(AppColors.primaryBlue)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                }
            }
        }
    }
}

struct TopPlayersSection: View {
    let sessions: [GameSession]
    
    private var playerWins: [String: Int] {
        var wins: [String: Int] = [:]
        for session in sessions {
            if session.winner != "Draw" {
                wins[session.winner, default: 0] += 1
            }
        }
        return wins
    }
    
    private var playerGames: [String: Int] {
        var games: [String: Int] = [:]
        for session in sessions {
            for player in session.players {
                games[player, default: 0] += 1
            }
        }
        return games
    }
    
    private var playerData: [(name: String, wins: Int, games: Int, winrate: Double)] {
        let wins = playerWins
        let games = playerGames
        
        return wins.map { name, winCount in
            let gameCount = games[name] ?? 0
            let winrate = gameCount > 0 ? (Double(winCount) / Double(gameCount) * 100) : 0
            return (name, winCount, gameCount, winrate)
        }
    }
    
    private var sortedPlayerData: [(name: String, wins: Int, games: Int, winrate: Double)] {
        playerData.sorted { $0.wins > $1.wins || ($0.wins == $1.wins && $0.name < $1.name) }
    }
    
    var topPlayers: [(name: String, wins: Int, games: Int, winrate: Double)] {
        Array(sortedPlayerData.prefix(5))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top Players by Wins")
                .font(AppFonts.semiBold(size: 20))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 10) {
                ForEach(0..<topPlayers.count, id: \.self) { index in
                    let player = topPlayers[index]
                    HStack {
                        Text("#\(index + 1)")
                            .font(AppFonts.semiBold(size: 16))
                            .foregroundColor(AppColors.accentOrange)
                            .frame(width: 35)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(player.name)
                                .font(AppFonts.medium(size: 15))
                                .foregroundColor(AppColors.primaryText)
                            Text("\(player.wins) wins / \(player.games) games")
                                .font(AppFonts.regular(size: 12))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        
                        Spacer()
                        
                        Text(String(format: "%.0f%%", player.winrate))
                            .font(AppFonts.bold(size: 18))
                            .foregroundColor(AppColors.primaryBlue)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                }
            }
        }
    }
}

struct TopLocationsSection: View {
    let sessions: [GameSession]
    
    private var locationCounts: [String: Int] {
        var counts: [String: Int] = [:]
        for session in sessions where !session.location.isEmpty {
            counts[session.location, default: 0] += 1
        }
        return counts
    }
    
    private var locationData: [(location: String, count: Int)] {
        locationCounts.map { ($0.key, $0.value) }
    }
    
    private var sortedLocationData: [(location: String, count: Int)] {
        locationData.sorted { $0.count > $1.count || ($0.count == $1.count && $0.location < $1.location) }
    }
    
    var topLocations: [(location: String, count: Int)] {
        Array(sortedLocationData.prefix(5))
    }
    
    var body: some View {
        if !topLocations.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Top Locations")
                    .font(AppFonts.semiBold(size: 20))
                    .foregroundColor(AppColors.primaryText)
                
                VStack(spacing: 10) {
                    ForEach(0..<topLocations.count, id: \.self) { index in
                        let item = topLocations[index]
                        HStack {
                            Text("#\(index + 1)")
                                .font(AppFonts.semiBold(size: 16))
                                .foregroundColor(AppColors.accentOrange)
                                .frame(width: 35)
                            
                            Text(item.location)
                                .font(AppFonts.medium(size: 15))
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            Text("\(item.count)")
                                .font(AppFonts.bold(size: 18))
                                .foregroundColor(AppColors.primaryBlue)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
}

struct PlayerStatsByGameSection: View {
    @Binding var selectedGameId: UUID?
    let sessions: [GameSession]
    let games: [Game]
    
    private var gameSessions: [GameSession] {
        guard let gameId = selectedGameId else { return [] }
        return sessions.filter { $0.gameId == gameId }
    }
    
    private var playerWins: [String: Int] {
        var wins: [String: Int] = [:]
        for session in gameSessions {
            if session.winner != "Draw" {
                wins[session.winner, default: 0] += 1
            }
        }
        return wins
    }
    
    private var playerGames: [String: Int] {
        var games: [String: Int] = [:]
        for session in gameSessions {
            for player in session.players {
                games[player, default: 0] += 1
            }
        }
        return games
    }
    
    private var playerStatsData: [(name: String, wins: Int, games: Int, winrate: Double)] {
        let wins = playerWins
        let games = playerGames
        
        return wins.map { name, winCount in
            let gameCount = games[name] ?? 0
            let winrate = gameCount > 0 ? (Double(winCount) / Double(gameCount) * 100) : 0
            return (name, winCount, gameCount, winrate)
        }
    }
    
    var playerStats: [(name: String, wins: Int, games: Int, winrate: Double)] {
        playerStatsData.sorted { $0.wins > $1.wins || ($0.wins == $1.wins && $0.name < $1.name) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Player Stats by Game")
                .font(AppFonts.semiBold(size: 20))
                .foregroundColor(AppColors.primaryText)
            
            Menu {
                ForEach(games) { game in
                    Button(game.name) {
                        selectedGameId = game.id
                    }
                }
            } label: {
                HStack {
                    if let gameId = selectedGameId,
                       let game = games.first(where: { $0.id == gameId }) {
                        Text(game.name)
                            .font(AppFonts.regular(size: 16))
                            .foregroundColor(AppColors.primaryText)
                    } else {
                        Text("Select a game")
                            .font(AppFonts.regular(size: 16))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(AppColors.primaryBlue)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
            }
            
            if !playerStats.isEmpty {
                VStack(spacing: 10) {
                    ForEach(playerStats, id: \.name) { player in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(player.name)
                                    .font(AppFonts.medium(size: 15))
                                    .foregroundColor(AppColors.primaryText)
                                Text("\(player.wins) wins / \(player.games) games")
                                    .font(AppFonts.regular(size: 12))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            
                            Spacer()
                            
                            Text(String(format: "%.0f%%", player.winrate))
                                .font(AppFonts.bold(size: 18))
                                .foregroundColor(AppColors.primaryBlue)
                        }
                        .padding()
                        .background(AppColors.lightBlue.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
}

struct WeeklyStatsSection: View {
    let sessions: [GameSession]
    
    private var calendar: Calendar {
        Calendar.current
    }
    
    private var now: Date {
        Date()
    }
    
    private var weekData: [Int: (count: Int, totalDuration: Int)] {
        var data: [Int: (count: Int, totalDuration: Int)] = [:]
        
        for session in sessions {
            let weeksDiff = calendar.dateComponents([.weekOfYear], from: session.date, to: now).weekOfYear ?? 0
            if weeksDiff >= 0 && weeksDiff < 12 {
                data[weeksDiff, default: (0, 0)].count += 1
                if let duration = session.duration {
                    data[weeksDiff, default: (0, 0)].totalDuration += duration
                }
            }
        }
        
        return data
    }
    
    private var weekOffsets: [Int] {
        Array(0..<12)
    }
    
    private var weekRanges: [String] {
        weekOffsets.map { weekOffset in
            let weekDate = calendar.date(byAdding: .weekOfYear, value: -weekOffset, to: now) ?? now
            let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: weekDate)) ?? weekDate
            let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart) ?? weekStart
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d"
            return "\(dateFormatter.string(from: weekStart)) - \(dateFormatter.string(from: weekEnd))"
        }
    }
    
    private var weekCounts: [Int] {
        let data = weekData
        return weekOffsets.map { data[$0]?.count ?? 0 }
    }
    
    private var weekAvgDurations: [Int] {
        let data = weekData
        return weekOffsets.map { weekOffset in
            let weekInfo = data[weekOffset] ?? (0, 0)
            return weekInfo.count > 0 ? weekInfo.totalDuration / weekInfo.count : 0
        }
    }
    
    var weeklyData: [(weekRange: String, count: Int, avgDuration: Int)] {
        let ranges = weekRanges
        let counts = weekCounts
        let durations = weekAvgDurations
        
        return zip(zip(ranges, counts), durations).map { (rangeCount, duration) in
            let (range, count) = rangeCount
            return (range, count, duration)
        }.reversed()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Weekly Stats (Last 12 Weeks)")
                .font(AppFonts.semiBold(size: 20))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 10) {
                ForEach(weeklyData, id: \.weekRange) { week in
                    HStack {
                        Text(week.weekRange)
                            .font(AppFonts.regular(size: 14))
                            .foregroundColor(AppColors.primaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("\(week.count) sessions")
                            .font(AppFonts.medium(size: 14))
                            .foregroundColor(AppColors.primaryBlue)
                        
                        if week.avgDuration > 0 {
                            Text("• \(week.avgDuration) min avg")
                                .font(AppFonts.regular(size: 13))
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                }
            }
        }
    }
}

struct TagsStatsSection: View {
    let games: [Game]
    let sessions: [GameSession]
    
    private var tagGameCounts: [String: Set<UUID>] {
        var counts: [String: Set<UUID>] = [:]
        for game in games {
            for tag in game.tags {
                counts[tag, default: []].insert(game.id)
            }
        }
        return counts
    }
    
    private var tagSessionCounts: [String: Int] {
        var counts: [String: Int] = [:]
        for session in sessions {
            if let game = games.first(where: { $0.id == session.gameId }) {
                for tag in game.tags {
                    counts[tag, default: 0] += 1
                }
            }
        }
        return counts
    }
    
    private var tagData: [(tag: String, gamesCount: Int, sessionsCount: Int)] {
        let gameCounts = tagGameCounts
        let sessionCounts = tagSessionCounts
        
        return gameCounts.map { tag, gameIds in
            (tag, gameIds.count, sessionCounts[tag] ?? 0)
        }
    }
    
    var tagStats: [(tag: String, gamesCount: Int, sessionsCount: Int)] {
        tagData.sorted { $0.sessionsCount > $1.sessionsCount || ($0.sessionsCount == $1.sessionsCount && $0.tag < $1.tag) }
    }
    
    var body: some View {
        if !tagStats.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Tags Stats")
                    .font(AppFonts.semiBold(size: 20))
                    .foregroundColor(AppColors.primaryText)
                
                VStack(spacing: 10) {
                    ForEach(tagStats, id: \.tag) { stat in
                        HStack {
                            Text(stat.tag)
                                .font(AppFonts.medium(size: 15))
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            Text("\(stat.gamesCount) games")
                                .font(AppFonts.regular(size: 13))
                                .foregroundColor(AppColors.secondaryText)
                            
                            Text("•")
                                .foregroundColor(AppColors.secondaryText)
                            
                            Text("\(stat.sessionsCount) sessions")
                                .font(AppFonts.medium(size: 13))
                                .foregroundColor(AppColors.primaryBlue)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
}




