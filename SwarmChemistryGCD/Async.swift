//
//  Async.swift
//
//  Created by Tobias DM on 15/07/14.
//
//	OS X 10.10+ and iOS 8.0+
//	Only use with ARC
//
//	The MIT License (MIT)
//	Copyright (c) 2014 Tobias Due Munk
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy of
//	this software and associated documentation files (the "Software"), to deal in
//	the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//	the Software, and to permit persons to whom the Software is furnished to do so,
//	subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//	FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//	COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//	IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import Foundation

// HACK: For Beta 5, 6
prefix func +(v: qos_class_t) -> Int {
	return Int(v.value)
}

private class GCD {
	
	/* dispatch_get_queue() */
	class func mainQueue() -> DispatchQueue {
		return DispatchQueue.main
		// Could use return dispatch_get_global_queue(+qos_class_main(), 0)
	}
	class func userInteractiveQueue() -> DispatchQueue {
		return DispatchQueue.global(priority: +DispatchQoS.QoSClass.userInteractive)
	}
	class func userInitiatedQueue() -> DispatchQueue {
		 return DispatchQueue.global(priority: +DispatchQoS.QoSClass.userInitiated)
	}
	class func defaultQueue() -> DispatchQueue {
		return DispatchQueue.global(priority: +DispatchQoS.QoSClass.default)
	}
	class func utilityQueue() -> DispatchQueue {
		return DispatchQueue.global(priority: +DispatchQoS.QoSClass.utility)
	}
	class func backgroundQueue() -> DispatchQueue {
		return DispatchQueue.global(priority: +DispatchQoS.QoSClass.background)
	}
}


open class Async {

	
	/* dispatch_async() */

	fileprivate class func async(_ block: ()->(), inQueue queue: DispatchQueue) -> DispatchBlock {
		// Create a new block (Qos Class) from block to allow adding a notification to it later (see DispatchBlock)
		// Create block with the "inherit" type
		let _block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, block)
		// Add block to queue
		queue.async(execute: _block)
		// Wrap block in a struct since dispatch_block_t can't be extended
		return DispatchBlock(_block)
	}
	class func main(_ block: ()->()) -> DispatchBlock {
		return Async.async(block, inQueue: GCD.mainQueue())
	}
	class func userInteractive(_ block: ()->()) -> DispatchBlock {
		return Async.async(block, inQueue: GCD.userInteractiveQueue())
	}
	class func userInitiated(_ block: ()->()) -> DispatchBlock {
		return Async.async(block, inQueue: GCD.userInitiatedQueue())
	}
	class func default_(_ block: ()->()) -> DispatchBlock {
		return Async.async(block, inQueue: GCD.defaultQueue())
	}
	class func utility(_ block: ()->()) -> DispatchBlock {
		return Async.async(block, inQueue: GCD.utilityQueue())
	}
	class func background(_ block: ()->()) -> DispatchBlock {
		return Async.async(block, inQueue: GCD.backgroundQueue())
	}
	class func customQueue(_ queue: DispatchQueue, block: ()->()) -> DispatchBlock {
		return Async.async(block, inQueue: queue)
	}


	/* dispatch_after() */

	fileprivate class func after(_ seconds: Double, block: ()->(), inQueue queue: DispatchQueue) -> DispatchBlock {
		let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
		let time = DispatchTime.now() + Double(nanoSeconds) / Double(NSEC_PER_SEC)
		return at(time, block: block, inQueue: queue)
	}
	fileprivate class func at(_ time: DispatchTime, block: ()->(), inQueue queue: DispatchQueue) -> DispatchBlock {
		// See Async.async() for comments
		let _block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, block)
		queue.asyncAfter(deadline: time, execute: _block)
		return DispatchBlock(_block)
	}
	class func main(#after: Double, _ block: ()->()) -> DispatchBlock {
		return Async.after(after, block: block, inQueue: GCD.mainQueue())
	}
	class func userInteractive(#after: Double, _ block: ()->()) -> DispatchBlock {
		return Async.after(after, block: block, inQueue: GCD.userInteractiveQueue())
	}
	class func userInitiated(#after: Double, _ block: ()->()) -> DispatchBlock {
		return Async.after(after, block: block, inQueue: GCD.userInitiatedQueue())
	}
	class func default_(#after: Double, _ block: ()->()) -> DispatchBlock {
		return Async.after(after, block: block, inQueue: GCD.defaultQueue())
	}
	class func utility(#after: Double, _ block: ()->()) -> DispatchBlock {
		return Async.after(after, block: block, inQueue: GCD.utilityQueue())
	}
	class func background(#after: Double, _ block: ()->()) -> DispatchBlock {
		return Async.after(after, block: block, inQueue: GCD.backgroundQueue())
	}
	class func customQueue(#after: Double, _ queue: DispatchQueue, block: ()->()) -> DispatchBlock {
		return Async.after(after, block: block, inQueue: queue)
	}
}


// Wrapper since non-nominal type 'dispatch_block_t' cannot be extended (extension dispatch_block_t {})
public struct DispatchBlock {
	
	fileprivate let block: ()->()
	
	init(_ block: @escaping ()->()) {
		self.block = block
	}


	/* dispatch_async() */
	
	fileprivate func chain(block chainingBlock: ()->(), runInQueue queue: DispatchQueue) -> DispatchBlock {
		// See Async.async() for comments
		let _chainingBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, chainingBlock)
		dispatch_block_notify(self.block, queue, _chainingBlock)
		return DispatchBlock(_chainingBlock)
	}
	
	func main(_ chainingBlock: ()->()) -> DispatchBlock {
		return chain(block: chainingBlock, runInQueue: GCD.mainQueue())
	}
	func userInteractive(_ chainingBlock: ()->()) -> DispatchBlock {
		return chain(block: chainingBlock, runInQueue: GCD.userInteractiveQueue())
	}
	func userInitiated(_ chainingBlock: ()->()) -> DispatchBlock {
		return chain(block: chainingBlock, runInQueue: GCD.userInitiatedQueue())
	}
	func default_(_ chainingBlock: ()->()) -> DispatchBlock {
		return chain(block: chainingBlock, runInQueue: GCD.defaultQueue())
	}
	func utility(_ chainingBlock: ()->()) -> DispatchBlock {
		return chain(block: chainingBlock, runInQueue: GCD.utilityQueue())
	}
	func background(_ chainingBlock: ()->()) -> DispatchBlock {
		return chain(block: chainingBlock, runInQueue: GCD.backgroundQueue())
	}
	func customQueue(_ queue: DispatchQueue, chainingBlock: ()->()) -> DispatchBlock {
		return chain(block: chainingBlock, runInQueue: queue)
	}

	
	/* dispatch_after() */

	fileprivate func after(_ seconds: Double, block chainingBlock: ()->(), runInQueue queue: DispatchQueue) -> DispatchBlock {
		
		// Create a new block (Qos Class) from block to allow adding a notification to it later (see DispatchBlock)
		// Create block with the "inherit" type
		let _chainingBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, chainingBlock)
		
		// Wrap block to be called when previous block is finished
		let chainingWrapperBlock: ()->() = {
			// Calculate time from now
			let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
			let time = DispatchTime.now() + Double(nanoSeconds) / Double(NSEC_PER_SEC)
			queue.asyncAfter(deadline: time, execute: _chainingBlock)
		}
		// Create a new block (Qos Class) from block to allow adding a notification to it later (see DispatchBlock)
		// Create block with the "inherit" type
		let _chainingWrapperBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, chainingWrapperBlock)
		// Add block to queue *after* previous block is finished
		dispatch_block_notify(self.block, queue, _chainingWrapperBlock)
		// Wrap block in a struct since dispatch_block_t can't be extended
		return DispatchBlock(_chainingBlock)
	}
	func main(#after: Double, _ block: ()->()) -> DispatchBlock {
		return self.after(after, block: block, runInQueue: GCD.mainQueue())
	}
	func userInteractive(#after: Double, _ block: ()->()) -> DispatchBlock {
		return self.after(after, block: block, runInQueue: GCD.userInteractiveQueue())
	}
	func userInitiated(#after: Double, _ block: ()->()) -> DispatchBlock {
		return self.after(after, block: block, runInQueue: GCD.userInitiatedQueue())
	}
	func default_(#after: Double, _ block: ()->()) -> DispatchBlock {
		return self.after(after, block: block, runInQueue: GCD.defaultQueue())
	}
	func utility(#after: Double, _ block: ()->()) -> DispatchBlock {
		return self.after(after, block: block, runInQueue: GCD.utilityQueue())
	}
	func background(#after: Double, _ block: ()->()) -> DispatchBlock {
		return self.after(after, block: block, runInQueue: GCD.backgroundQueue())
	}
	func customQueue(#after: Double, _ queue: DispatchQueue, block: ()->()) -> DispatchBlock {
		return self.after(after, block: block, runInQueue: queue)
	}


	/* cancel */

	func cancel() {
		dispatch_block_cancel(block)
	}
	

	/* wait */

	/// If optional parameter forSeconds is not provided, use DISPATCH_TIME_FOREVER
	func wait(_ seconds: Double = 0.0) {
		if seconds != 0.0 {
			let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
			let time = DispatchTime.now() + Double(nanoSeconds) / Double(NSEC_PER_SEC)
			dispatch_block_wait(block, time)
		} else {
			dispatch_block_wait(block, DispatchTime.distantFuture)
		}
	}
}

// Convenience
extension qos_class_t {

	// Calculated property
	var description: String {
		get {
			switch +self {
				case +qos_class_main(): return "Main"
				case +DispatchQoS.QoSClass.userInteractive: return "User Interactive"
				case +DispatchQoS.QoSClass.userInitiated: return "User Initiated"
				case +DispatchQoS.QoSClass.default: return "Default"
				case +DispatchQoS.QoSClass.utility: return "Utility"
				case +DispatchQoS.QoSClass.background: return "Background"
				case +DispatchQoS.QoSClass.unspecified: return "Unspecified"
				default: return "Unknown"
			}
		}
	}
}
