package Tools.Collections {
	import flash.utils.Dictionary;
	
	public class SetCollection {
		public var map : Dictionary;
        public var stringMap : Object;
        public var length : int;

		public function SetCollection() {
			map = new Dictionary();
            stringMap = new Object();
		}
		
		public function add(item : *) : void {
			if (item is String) {
				stringMap[item] = true;
			} else {
				map[item] = true;
			}
			length++;
		}
                
		public function has(item : *) : Boolean {
			if (item is String) {
				return stringMap[item] !== undefined;
			} else {
				return map[item] !== undefined;
			}
		}

		public function remove(item : *) : void {
			if (item is String) {
				if (stringMap[item] === undefined) return;
				delete stringMap[item];
			} else {
				if (map[item] === undefined) return;
				delete map[item];
			}
			length--;
		}
	}
}