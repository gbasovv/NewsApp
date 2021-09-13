//
//  GlobalFunctions.swift
//  NewsApp
//
//  Created by George on 8.09.21.
//

import UIKit

class GlobalFunctions {
    private init() { }
    static let shared = GlobalFunctions()
    
    func getPastDates(days: Int) -> String {
        let today = NSDate()
        let formatter = DateFormatter()
        
        return getDays(days: days, today: today, formatter: formatter)
    }
    
    func compareDates(_ first: String, _ second: String) -> Bool {
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let articleDate1 = formatterDate.date(from: first)
        let articleDate2 = formatterDate.date(from: second)
        guard let articleDate1 = articleDate1 else { return false }
        guard let articleDate2 = articleDate2 else { return false }
        let timeInterval1 = articleDate1.timeIntervalSince1970
        let timeInterval2 = articleDate2.timeIntervalSince1970
        let timeInt1 = Int(timeInterval1)
        let timeInt2 = Int(timeInterval2)
        return timeInt1 > timeInt2
    }
    
    func getDays(days: Int, today: NSDate, formatter: DateFormatter) -> String {
        let pastDays = today.addingTimeInterval(TimeInterval((-24 * days) * 60 * 60))
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: pastDays as Date)
        let date = formatter.date(from: myString)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let days = formatter.string(from: date!)
        return days
    }
    
    func formatDate(date: String) -> String {
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let currentdate = formatterDate.date(from: date)
        formatterDate.dateFormat = "yyyy-MM-dd HH:mm"
        guard let currentdate = currentdate else { return "" }
        let stringDate = formatterDate.string(from: currentdate)
        let date = formatterDate.date(from: stringDate)
        guard let date = date else { return "" }
        let formatDate = formatterDate.string(from: date)
        return formatDate
    }
}
