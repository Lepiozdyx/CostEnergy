import Foundation

enum StorageKeys {
    static let devices = "devices"
    static let usageRecords = "usageRecords"
    static let appSettings = "appSettings"
    static let timerStates = "timerStates"
}

enum DefaultValues {
    static let propertyName = "My Property"
    static let currency = "USD"
    static let tariffRate = 0.12
}

enum SFSymbols {
    static let devices = "bolt"
    static let timer = "timer"
    static let statistics = "chart.bar.xaxis.ascending"
    static let settings = "gearshape.fill"
    static let add = "plus"
    static let edit = "square.and.pencil"
    static let delete = "trash"
    static let play = "play"
    static let stop = "stop"
    static let pause = "pause"
    static let resume = "play"
    static let save = "checkmark"
}

enum UsageTypes {
    static let shortTerm = "Short-term"
    static let longTerm = "Long-term"
    static let all = [shortTerm, longTerm]
}

enum NotificationNames {
    static let devicesDidUpdate = Notification.Name("devicesDidUpdate")
    static let settingsDidUpdate = Notification.Name("settingsDidUpdate")
    static let timersDidUpdate = Notification.Name("timersDidUpdate")
    static let deviceWillBeDeleted = Notification.Name("deviceWillBeDeleted")
    static let resetDataRequested = Notification.Name("resetDataRequested")
}

