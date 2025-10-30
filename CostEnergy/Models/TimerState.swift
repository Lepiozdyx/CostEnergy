import Foundation

struct TimerState: Identifiable, Codable {
    let id: UUID
    let deviceID: UUID
    var startDate: Date
    var pausedDate: Date?
    var accumulatedTime: TimeInterval
    var isPaused: Bool
    var isRunning: Bool
    
    init(
        id: UUID = UUID(),
        deviceID: UUID,
        startDate: Date = Date(),
        pausedDate: Date? = nil,
        accumulatedTime: TimeInterval = 0,
        isPaused: Bool = false,
        isRunning: Bool = true
    ) {
        self.id = id
        self.deviceID = deviceID
        self.startDate = startDate
        self.pausedDate = pausedDate
        self.accumulatedTime = accumulatedTime
        self.isPaused = isPaused
        self.isRunning = isRunning
    }
    
    func totalElapsedTime(currentDate: Date = Date()) -> TimeInterval {
        var total = accumulatedTime
        
        if isRunning && !isPaused {
            total += currentDate.timeIntervalSince(startDate)
        }
        
        return total
    }
    
    mutating func pause(at date: Date = Date()) {
        guard isRunning && !isPaused else { return }
        
        let elapsedSinceStart = date.timeIntervalSince(startDate)
        accumulatedTime += elapsedSinceStart
        pausedDate = date
        isPaused = true
    }
    
    mutating func resume(at date: Date = Date()) {
        guard isRunning && isPaused else { return }
        
        isPaused = false
        pausedDate = nil
    }
}

