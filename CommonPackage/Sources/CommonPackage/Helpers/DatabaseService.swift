//
//  File.swift
//  
//
//  Created by Ramiro Lima on 26/01/23.
//

import Foundation
import RealmSwift

public struct DatabaseService {
	
	static func saveObject(_ object: Object) -> Bool {
		do {
			let realm = try Realm()
			try realm.write {
				realm.add(object)
			}
			return true
		}catch _ {
			return false
		}
	}
	
	static func getObjects<T:Object>(by realmObject: T) -> Results<T>? {
		do {
			let realm = try Realm()
			let realmObjects = realm.objects(T.self)
			return realmObjects
		}
		catch _ {
			return nil
		}
	}
	
	static func deleteObject<T: Object>(_ objectType: T.Type, with primaryKey: String) -> Bool{
		do {
			let realm = try Realm()
			guard let objectToDelete = realm.object(ofType: objectType, forPrimaryKey: primaryKey) else { return false }
			
			try realm.write {
				realm.delete(objectToDelete)
			}
			return true
		}
		catch _ {
			return false
		}
	}
	
	static func getObject<T: Object>(_ objectType: T.Type, with primaryKey: String) -> T?{
		do {
			let realm = try Realm()
			return realm.object(ofType: objectType, forPrimaryKey: primaryKey)
		}
		catch _ {
			return nil
		}
	}
	
	static func deleteAllOjects() -> Bool{
		do {
			let realm = try Realm()
			try realm.write {
				realm.deleteAll()
			}
			return true
		}catch _ {
			return false
		}
		
	}
}
