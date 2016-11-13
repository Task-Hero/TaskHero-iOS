//
//  ParseAPIKey.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/12/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit
import Parse

class ParseAPIKey: NSObject {
    
    static var config = ParseClientConfiguration(block: {
        (ParseMutableClientConfiguration) -> Void in
        ParseMutableClientConfiguration.applicationId = "task_hero_app";
        ParseMutableClientConfiguration.clientKey = "sanDiego";
        ParseMutableClientConfiguration.server = "https://salty-plains-70360.herokuapp.com/parse";
    });

}
