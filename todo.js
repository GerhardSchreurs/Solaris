/*
Hangar -> _fleet (new Ship.Kestrel(), new Ship.Torus())
IShip -> _nodes
Kestrel.as -> IShip.addNode()
Kestrel.as -> IShip.initNodes();

IShip.initLayout {
	//Zet node.TOPLNode, node.MIDLnode, etc
}
*/



node.id
node.parentNode
node.connectedNodes[]

//IShip
var openNodes:Vector<Node>;

public function pathFind():void {
	//get connected nodes
	
	//add startNode to openNodes
	openNodes.push(startNode);
	
}

public function pathFindOpenNodes():void {
	var attachedNode:Node;
	var attachedNodes:Vector<Node>;
	
	for (var i:int = 0; i<openNodes.length; i++) {
		attachedNode = openNodes[i];
		
		if (attachedNode == stopNode) {
			trace('attachedNode == stopNode');
			break;
		} else if (attachedNode.isDeadEnd) {
			trace('attachedNode.isDeadEnd');
		} else if (attachedNode.parentNode != null) {
			trace('attachedNode.parentNode != null');
		} else {
			attachedNodes.push(attachedNode);
		}
	}
	
	openNodes = attachedNodes;
}




public function pathFind():void { 
	trace("");
	trace("=======================================");
	trace("");
	
	var startNode:Node = _selectedCrewMember.node;
	var stopNode:Node = _selectedNode;
	var currentNode:Node = startNode;
	
	var x:Node = currentNode.pathFind(startNode, stopNode);
	
	startNode.parentNode = null;
	
	tracePath();
	
	for (var i:Number = 0; i < _nodes.length; i++) {
		_nodes[i].clearNode();
	}
}


