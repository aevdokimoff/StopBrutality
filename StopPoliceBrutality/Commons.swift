//
//  Commons.swift
//  EpiTracker
//
//  Created by Artem on 26.05.20.
//  Copyright © 2020 Artem. All rights reserved.
//

import Foundation

let debugPosts: [Post] = [
    Post(title: "Stop it!", date: "Today at 14:47", descr: "It's just awful! We have to stop it now! We have to get together now", commentsCount: 14, imageName: "post1"),
    Post(title: "Warning", date: "Today at 15:14", descr: "Careful, it's unbearable to be near 5th Avenue right now. Stay with each other.", commentsCount: 37, imageName: "post2"),
    Post(title: "Oooh", date: "Today at 17:23", descr: "Please, be safe! It's dangerous outside right now.", commentsCount: 49, imageName: "post3")
]

func checkCaseAddedOnce() -> Bool {
    let key = "isCaseAddedOnce"
    return UserDefaults.standard.object(forKey: key) != nil && UserDefaults.standard.bool(forKey: key)
}

func checkIsInAddedCaseMode() -> Bool {
    let key = "isInAddedCaseMode"
    return UserDefaults.standard.object(forKey: key) != nil && UserDefaults.standard.bool(forKey: key)
}
