import std.stdio;
import std.exception;
import core.exception : AssertError;
import network.deque;

unittest{
    auto myDeque = new Deque!(int);
    myDeque.push_front(1);
    auto element = myDeque.pop_front();
    assert(element == 1);
}

// ##============ Muskaan's test cases ===============

// This unit test, tests if the size method returns the correct number of elements in the queue.
unittest {
    auto myDeque = new Deque!(string);
    myDeque.push_back("Hello");
    myDeque.push_back("Muskaan");
    myDeque.push_back(",");
    myDeque.push_back("How");
    myDeque.push_back("are");
    myDeque.push_back("you");
    myDeque.push_back("?");

    writeln("Unit Test 1");
    assert(myDeque.size == 7);
}

// This unit test, tests if the pop_back method removes and returns the last element of the queue.
unittest {
    auto myDeque = new Deque!(string);
    myDeque.push_back("Hello");
    myDeque.push_back("Muskaan");
    myDeque.push_back(",");
    myDeque.push_back("How");
    myDeque.push_back("are");
    myDeque.push_back("you");
    myDeque.push_back("?");
   
    auto element = myDeque.pop_back();
    writeln("Unit Test 2");
    
    assert(element == "?");
    assert(myDeque.size == 6, "Length of the degueue should decrease by 1");
}

// This unit test, tests if the pop_back method throws an error if the queue is empty.
unittest {
    auto myDeque = new Deque!(string);
    writeln("Unit Test 3");
    assertThrown!AssertError(myDeque.pop_back());
}

// This unit test, tests if the pop_front method throws an error if the queue is empty.
unittest {
    auto myDeque = new Deque!(string);
    writeln("Unit Test 4");
    assertThrown!AssertError(myDeque.pop_front());
}

// This unit test, tests if the pop_front method removes and returns the first element of the queue.
unittest {
    auto myDeque = new Deque!(string);
    myDeque.push_back("Hello");
    myDeque.push_back("Muskaan");
   
    auto element = myDeque.pop_front();
    writeln("Unit Test 5");
    
    assert(element == "Hello");
    assert(myDeque.size == 1, "Length of the degueue should decrease by 1");
}


// This unit test, tests if the at method returns the correct value present at this position.
unittest {
    auto myDeque = new Deque!(int);
    myDeque.push_back(1);
    myDeque.push_back(2);
    myDeque.push_back(3);
    myDeque.push_back(4);
    myDeque.push_back(5);

    writeln("Unit Test 6");
    auto element = myDeque.at(0);
    assert(element == 1);
}

// This unit test, tests if the at method throws an error if the queue is empty.
unittest {
    auto myDeque = new Deque!(string);
    writeln("Unit Test 7");
    assertThrown!AssertError(myDeque.at(2));
}

// This unit test, tests if the front and back method returns the correct value present at the first and last position respectively.
unittest {
    auto myDeque = new Deque!(int);
    myDeque.push_back(1);
    myDeque.push_back(2);
    myDeque.push_back(3);
    myDeque.push_back(4);

    
    writeln("Unit Test 8");
  
    assert(myDeque.front == 1);
    assert(myDeque.back == 4);
}

// This unit test, tests if the back method throws an error if the queue is empty.
unittest {
    auto myDeque = new Deque!(string);
    writeln("Unit Test 9");
    assertThrown!AssertError(myDeque.back());
}

// This unit test, tests if the front method throws an error if the queue is empty.
unittest {
    auto myDeque = new Deque!(string);
    writeln("Unit Test 10");
    assertThrown!AssertError(myDeque.front());
}

// This unit test, tests if the push_back method adds the element at the end of the queue.
unittest {
    auto myDeque = new Deque!(int);
    myDeque.push_back(1);
    myDeque.push_back(1);
    myDeque.push_back(1);
    myDeque.push_back(5);

    
    writeln("Unit Test 11");
    auto element = myDeque.at(3);
    assert(element == 5);
}

// This unit test, tests if the push_front method adds the element at the front of the queue.
unittest {
    auto myDeque = new Deque!(int);
    myDeque.push_back(1);
    myDeque.push_back(1);
    myDeque.push_back(1);
    myDeque.push_front(5);

    
    writeln("Unit Test 12");
    assert(myDeque.front == 5);
}