//
//  File.swift
//  
//
//  Created by Ramiro Lima on 23/01/23.
//

import Foundation

public class Observable<ValueType> {
	public typealias Observer = (ValueType) -> Void
	
	public var observers: [Observer] = []
	public var value: ValueType {
		didSet {
			for observer in observers {
				observer(value)
			}
		}
	}
	
	public init(_ defaultValue: ValueType) {
		value = defaultValue
	}
	
	public func addObserver(_ observer: @escaping Observer) {
		observers.append(observer)
	}
}
