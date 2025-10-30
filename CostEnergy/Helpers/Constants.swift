import Foundation

enum StorageKeys {
    static let devices = "devices"
    static let usageRecords = "usageRecords"
    static let appSettings = "appSettings"
}

enum DefaultValues {
    static let propertyName = "My Property"
    static let currency = "USD"
    static let tariffRate = 0.12
}

enum SFSymbols {
    static let devices = "bolt.fill"
    static let timer = "timer"
    static let statistics = "chart.bar.fill"
    static let settings = "gearshape.fill"
    static let add = "plus"
    static let edit = "pencil"
    static let delete = "trash"
    static let play = "play.fill"
    static let stop = "stop.fill"
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
}

