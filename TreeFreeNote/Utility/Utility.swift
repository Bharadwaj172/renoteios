import Foundation

class Utility{
    func current_date() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return df.string(from: date)
    }
}
