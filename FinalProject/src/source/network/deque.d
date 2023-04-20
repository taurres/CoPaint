module network.deque;

import std.stdio;
import std.exception;
import core.exception : AssertError;

/**
    The following is an interface for a Deque data structure.
    Generally speaking we call these containers.

    Observe how this interface is a templated (i.e. Container(T)),
    where 'T' is a placeholder for a data type.
*/
interface Container(T){
    /// Element is on the front of collection
    void push_front(T x);
    /// Element is on the back of the collection
    void push_back(T x);
    /// Element is removed from front and returned
    /// assert size > 0 before operation
    T pop_front();
    /// Element is removed from back and returned
    /// assert size > 0 before operation
    T pop_back();
    /// Retrieve reference to element at position at index
    /// assert pos is between [0 .. $] and size > 0
    ref T at(size_t pos);
    /// Retrieve reference to element at back of position
    /// assert size > 0 before operation
    ref T back();
    /// Retrieve element at front of position
    /// assert size > 0 before operation
    ref T front();
    /// Retrieve number of elements currently in container
    size_t size();
    /// clear all elements in container
    void clear();
}

/**
    A Deque is a double-ended queue in which we can push and
    pop elements.

    Note: Remember we could implement Deque as either a class or
          a struct depending on how we want to extend or use it.
          Either is fine for this assignment.
*/
class Deque(T) : Container!(T) {
    struct CNode {
        T value;
        CNode* prev;
        CNode* next;
    }

    CNode* head;
    CNode* tail;
    size_t len;

    this() {
        this.head = null;
        this.tail = null;
        this.len = 0;
    }

    void push_front(T x) {
        auto cnode = new CNode();
        cnode.value = x;
        cnode.prev = null;
        cnode.next = this.head;

        if (this.head != null) {
            this.head.prev = cnode;
        }

        this.head = cnode;

        if (this.tail == null) {
            this.tail = cnode;
        }

        this.len += 1;
    }

    void push_back(T x) {
        auto cnode = new CNode();
        cnode.value = x;
        cnode.prev = this.tail;
        cnode.next = null;

        if (this.tail != null) {
            this.tail.next = cnode;
        }

        this.tail = cnode;

        if (this.head == null) {
            this.head = cnode;
        }

        this.len += 1;
    }

    T pop_front() {
        assert (this.size > 0);

        T element = this.head.value;

        CNode* temp = this.head;

        this.head = this.head.next;
        if (this.len > 1) {
            this.head.prev = null;
        }
        temp.next = null;

        this.len -= 1;

        return element;
    }

    T pop_back() {
        assert (this.size > 0);

        T element = this.tail.value;

        CNode* temp = this.tail;

        this.tail = this.tail.prev;
        if (this.len > 1) {
            this.tail.next = null;
        }
        temp.prev = null;

        this.len -= 1;

        return element;
    }

    ref T at(size_t pos) {
        assert (this.size > 0 && pos >= 0 && pos < this.size);

        size_t idx = 0;
        auto ptr = head;

        while (idx < pos) {
            ptr = ptr.next;
            idx += 1;
        }

        return ptr.value;
    }

    ref T back() {
        assert (this.size > 0);

        return this.tail.value;
    }

    ref T front() {
        assert (this.size > 0);

        return this.head.value;
    }

    size_t size() {
        return this.len;
    }

    void clear() {
        int size = cast(int)this.size();
        for (int i = 0; i < size; i++) {
            this.pop_back();
        }
    }
}
