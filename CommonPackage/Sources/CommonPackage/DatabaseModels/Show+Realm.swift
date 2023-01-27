//
//  File.swift
//  
//
//  Created by Ramiro Lima on 26/01/23.
//

import Foundation
import RealmSwift

import Foundation

public class ShowRealm: Object {
	@Persisted(primaryKey: true) var id: String
	@Persisted var name: String
	@Persisted var image: Image?
	var genres = List<String>()
	@Persisted var summary: String?
	@Persisted var schedule: Schedule?
	
	
	public static func saveShow(id: Int, name: String, imageMedium: String? = nil, imageOriginal: String? = nil , genres: [String]?, summary: String? = nil, scheduleTime: String? = nil, scheduleDays: [String]? = nil) -> Bool {
		let show = ShowRealm()
		show.id = "\(id)"
		show.name = name
		let image = Image()
		image.medium = imageMedium
		image.original = imageOriginal
		show.image = image
		show.genres.append(objectsIn:genres ?? [])
		show.summary = summary
		let schedule = Schedule()
		schedule.days.append(objectsIn:scheduleDays ?? [])
		schedule.time = scheduleTime
		show.schedule = schedule
		
		return DatabaseService.saveObject(show)
		
	}
	
	public static func deleteShow(by id: Int) -> Bool {
		DatabaseService.deleteObject(ShowRealm.self, with: "\(id)")
	}
	
	public static func getAllShows() -> Results<ShowRealm>? {
		DatabaseService.getObjects(by: ShowRealm())
	}
	
	public static func deleteAllShows() -> Bool {
		DatabaseService.deleteAllOjects()
	}
	
	public static func findShow(by id: Int) -> ShowRealm? {
		DatabaseService.getObject(ShowRealm.self, with: "\(id)")
	}
	
}

public class Image: Object {
	@objc dynamic var medium: String? = nil
	@objc dynamic var original: String? = nil
}

public class Schedule: Object {
	@objc dynamic var time: String?
	var days = List<String>()
}
