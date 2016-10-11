/**
 * Swift implementation
 */

struct VNode {
	let nodeType: Int // immutable
	let nodeName: Any     // immutable, String or Function
	var props: [String: Any] // dictionary
	var children: [Any] // mmutable
}

func Node (nodeType: Int, nodeName: Any, props: [String: Any], children: [VNode]) -> VNode {
	return VNode(nodeType: nodeType, nodeName: nodeName, props: props, children: children);
}

// an emptyNode
var emptyNode: VNode = Node(0, "", [:], [])

// diff and determine the least amount of actions to update the view
func reconciler (newNode: VNode, oldNode: VNode) -> Int {
	// remove
	if newNode.nodeType == 0 {
		return 1
	}
	// add
	if oldNode.nodeType == 0 {
		return 2
	}
	// text
	if newNode.nodeType == 3 && oldNode.nodeType == 3 {
		// text update
		if newNode.children[0] !== oldNode.children[0] {
			return 3
		}
	}
	// keys
	else if newNode.props.key != oldNode.props.key {
		return 5
	}
	// replace
	else if newNode.nodeName != oldNode.nodeName {
		return 4
	}
	// recursive
	else {
		// extractNode will handle when newNode.nodeName is a component constructor instead of a string
		var currentNode: VNode = extractNode(newNode)

		// identical, exit early
		if currentNode == oldNode {
			return 0
		}

		// if not text patch props
		if oldNode.nodeType == 1 {
			patchProps(currentNode, oldNode)
		}

		var currentChildren: [VNode] = currentNode.children
		var oldChildren: [Vnode] = oldName.children

		var newLength: Int = currentChildren.count
		var oldLength: Int = currentChildren.count

		// remove all children
		if newLength == 0 {
			// but only if old children is not already cleared
			if oldLength != 0 {
				// clearChildren calls native api(s)
				clearChildren(oldNode)
				oldNode.children = currentChildren
			}
		} else {
			var deleteCount: Int = 0

			for var i: Int = 0; i < newLength || i < oldLength; i = i + 1 {
			    var newChild: VNode
			    var oldChild: VNode

			    if newLength >= i { // currentChildren has an element at that index
			    	newChild = currentChildren[i]
			    } else { // element does not exist, assign an emptyNode
			    	newChild = emptyNode
			    }

			    if oldLength >= i { // oldChildren has an element at that index
			    	oldChild = oldChildren[i]
			    } else { // element does not exist, assign an emptyNode
			    	oldChild = emptyNode
			    }

			    var action: Int = reconciler(newChild, oldChild)

			    if action != 0 {
			    	var index: Int = i - deleteCount

			    	switch action {
			    		// remove operation
			    		case 1: {
			    			// removeNode calls native api(s)
			    			removeNode(oldNode, index)
			    			oldchildren.removeAtIndex(index)
			    			deleteCount = deleteCount + 1
			    		}
			    		// add operation
			    		case 2: {
			    			// addNode calls native api(s)
			    			addNode(oldNode, newChild, index)
			    			oldchildren.insert(newChild, atIndex: index)
			    			deleteCount = deleteCount - 1
			    		}
			    		// text operation
			    		case 3: {
			    			// updateText calls native api(s)
			    			updateText(newChild, oldChild)
			    			oldChild.children[0] = newChild.children[0]
			    		}
			    		// replace operation
			    		case 4: {
			    			// replaceNode calls native api(s)
			    			replaceNode(newChild, oldChild)
			    			oldchildren[index] = newChild
			    		}
			    		// key operation
			    		case 5: {
			    			// code block
			    		}
			    	}
			    }
			}
		}
	}

	return 0
}

// patch props
func patchProps (newNode: VNode, oldNode: VNode) {
	var diff: [Any] = diffProps(newNode.props, oldNode.props)
	var length: Int = diff.count

	if length != 0 {
		for var i = 0; i < length; i = i + 1 {
			var prop = diff[i]

			// patchProp calls native api(s)
			patchProp(oldNode, prop[0], prop[1], prop[2], prop[3])
		}

		oldNode.props = newNode.props
	}
}

// diff props
func diffProps (newProps: [String: Any], oldProps: [String: Any]) -> [Any] {
	var diff: [Any] = []
	var NS: Any = oldProps.xmlns

	for (newName, newValue) in newProps {
	    diff += diffNewProps(newProps, oldProps, newName, newValue, NS)
	}

	for (oldName, oldValue) in oldProps {
	    diff += diffoldProps(newProps, oldProps, oldName, oldValue, NS)
	}

	return diff
}

// diff new props
func diffNewProps (newProps: [String: Any], oldProps: [String: Any], newName: String, newValue: String, NS: String) -> [Any] {
	var diff: [Any] = []
	var oldValue: Any?

	// if the newProp's key is in oldProps assign oldValue to it
	if oldProps[newName] != nil {
	    oldValue = oldProps[newName]!
	} else {
		oldValue = nil
	}

	if newValue != nil && oldValue !== newValue) {
		diff += ["setAttribute", newName, newValue, NS]
	}

	return diff
}

// diff old props
func diffOldProps (newProps: [String: Any], oldProps: [String: Any], oldName: String, oldValue: String, NS: String) -> [Any] {
	var diff: [Any] = []

	if newProps[oldName] == nil {
		diff += ["removeAttribute", newName, newValue, NS]
	}

	return diff
}


// a text node
var textNode = Node(3, "Text", [:], ["Hello World"])
// an element node NavBar with one single child TextNode
var oldNode = Node(1, "NavBar", ["state": "active"], [textNode])
var newNode = Node(1, "NavBar", ["state": "active"], [textNode])

reconciler(newNode, oldNode)