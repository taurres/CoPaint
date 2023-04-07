import std.stdio;
import std.exception;

interface Container(T){
    // Element is on the front of collection
    void push_front(T x);
    // Element is on the back of the collection
    void push_back(T x);
    // Element is removed from front and returned
    // assert size > 0 before operation
    T pop_front();
    // Element is removed from back and returned
    // assert size > 0 before operation
    T pop_back();
    // Retrieve reference to element at position at index
    // assert pos is between [0 .. $] and size > 0
    ref T at(size_t pos);
    // Retrieve reference to element at back of position
    // assert size > 0 before operation
    ref T back();
    // Retrieve element at front of position
    // assert size > 0 before operation
    ref T front();
    // Retrieve number of elements currently in container
    size_t size();
}

/*
    A Deque is a double-ended queue in which we can push and
    pop elements.
    
    Note: Remember we could implement Deque as either a class or
          a struct depending on how we want to extend or use it.
          Either is fine for this assignment.
*/
class Deque(T) : Container!(T){
    
    // List that represents the dequeue.
    T[] queue;

    // The push_front method appends the value x of type T to the beginning of the queue.
    void push_front(T x) {
        queue = x ~ queue; 
    }

    // The push_back method appends the value x of type T to the end of the queue.
    void push_back(T x) {
        queue = queue ~ x; 
    }

    // The pop_front method removes an element from the front of the queue and returns it.
    T pop_front() {
        assert(queue.length > 0, "Cannot pop from an empty queue!");
        auto front = queue[0];
        queue = queue[1..$];
        return front;
    }

    // The pop_back method removes an element from the end of the queue and returns it.
    T pop_back(){
        assert(queue.length > 0, "Cannot pop from an empty queue!");
        
        auto back = queue[queue.length - 1];
        queue = queue[0..queue.length - 1];
        return back;
    }

    // size_t is an alias to one of the unsigned integral basic types, and represents a type that is large enough to represent an offset into all addressable memory
    // The at method returns the reference of a value at the position passed to the method.
    ref T at(size_t pos) {
        assert(queue.length > 0, "The queue is empty!");
        assert(pos >= 0 && pos < queue.length, "Out of bound: The pos passes does not exist!");
        T* ptr = &queue[pos];
        return *ptr;
    }

    // The back method returns the reference of last element of the queue
    ref T back() {
        assert(queue.length > 0, "The queue is empty!");
        T* ptr = &queue[queue.length - 1]; 
        return *ptr;
    }
    
    // The front method returns the reference of first element of the queue
    ref T front() {
        assert(queue.length > 0, "The queue is empty!");
        T* ptr = &queue[0]; 
        return *ptr;
    }

    // The size method returns the number of elements currently in the queue
    size_t size() {
        return queue.length;
    }
}