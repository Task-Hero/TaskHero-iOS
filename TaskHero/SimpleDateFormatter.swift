//
//  SimpleDateFormatter.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 12/6/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

//
//  dateFormatter.swift
//  tweet_beat
//
//  Created by Sahil Agarwal on 10/31/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class SimpleDateFormatter: NSObject {
    
    static func getTimeAgoSimple(date: Date) -> String {
        let currentDate = Date()
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
        let components = Calendar.current.dateComponents(unitFlags, from: date)
        let currentDateComponents = Calendar.current.dateComponents(unitFlags, from: currentDate)
        
        if (components.year == currentDateComponents.year && components.month == currentDateComponents.month) {
            
            if ((currentDateComponents.day! - components.day!) > 21) {
                // do nothing
            } else if ((currentDateComponents.day! - components.day!) > 14) {
                return "3wk ago"
            } else if ((currentDateComponents.day! - components.day!) > 7) {
                return "2wk ago"
            } else {
                if (currentDateComponents.day! == components.day) {
                    if (currentDateComponents.hour! == components.hour) {
                        return "\(currentDateComponents.minute! - components.minute!)m ago"
                    }
                    return "\(currentDateComponents.hour! - components.hour!)h ago"
                } else {
                    return "\(currentDateComponents.day! - components.day!)d ago"
                }
            }
        }
        
        return "\(components.month!)/\(components.day!)/\(components.year!)"
    }
    
    static func getTimestamp(date: Date) -> String {
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
        let components = Calendar.current.dateComponents(unitFlags, from: date)
        var timeOfDay = "AM"
        var hour = components.hour
        
        if (components.hour! > 12) {
            timeOfDay = "PM"
            hour = components.hour! - 12
        } else if (components.hour! == 0) {
            hour = 12
        }
        
        return "\(components.month!)/\(components.day!)/\(components.year!), \(hour!):\(components.minute!) \(timeOfDay)"
    }
}



