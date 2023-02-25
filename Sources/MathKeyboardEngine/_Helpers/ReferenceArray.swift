public class ReferenceArray<T : AnyObject> {
    public var asValueTypeArray = [T]()
    
    public init() { }

    private init(_ arr : ArraySlice<T>) {
        asValueTypeArray.append(contentsOf: arr)
    }
    public init(_ arr : T...) {
        asValueTypeArray.append(contentsOf: arr)
    }

    public subscript (i: Int) -> T {
        get { 
            return asValueTypeArray[i]
        }
        set (newValue) {
            asValueTypeArray[i] = newValue
        }
    }

    public func append(_ element : T) {
        asValueTypeArray.append(element)
    }

    public func insert(_ element : T, at: Int) {
        asValueTypeArray.insert(element, at: at)
    }

    public func remove(_ element : T) {
        asValueTypeArray.removeAll{ $0 === element }
    }

    public func indexOf(_ element : T) -> Int? {
        return asValueTypeArray.firstIndex{ $0 === element }
    }

    public var count : Int {
        return asValueTypeArray.count
    }

    public var isEmpty : Bool {
        return asValueTypeArray.isEmpty
    }

    public var last : T? {
        return asValueTypeArray.last
    }

    func firstAfterOrNil(_ element: T) -> T? {
        if let i = self.indexOf(element), i < self.count - 1 {
            return self[i + 1]
        } else {
            return nil
        }
    }

    func firstBeforeOrNil(_ element: T) -> T? {
        
        if let i = self.indexOf(element), i > 0 {
            return self[i - 1]
        } else {
            return nil
        }
    }

    func removeRange(start: Int, exclusiveEnd: Int) -> ReferenceArray<T> {
        let returnValue = ReferenceArray<T>(self.asValueTypeArray[start..<exclusiveEnd])
        asValueTypeArray.removeSubrange(start ..< exclusiveEnd)
        return returnValue
    }

    func contains(where predicate: (Array<T>.Element) throws -> Bool) rethrows -> Bool {
        try self.asValueTypeArray.contains(where : predicate)
    }

    func filter(where predicate: (Array<T>.Element) throws -> Bool) rethrows -> Bool {
        try self.asValueTypeArray.contains(where : predicate)
    }

    func replaceSubrange(_ subrange: ClosedRange<Int>, with newElements: ReferenceArray<T>) {
        self.asValueTypeArray.replaceSubrange(subrange, with: newElements.asValueTypeArray)
    }

    func removeLast() {
        _ = self.asValueTypeArray.removeLast()
    }
}