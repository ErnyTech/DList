module dlist.list;

import dlist.baselist;

interface List(T) {
    void add(T elem) @nogc;
    void add(size_t index, T elem) @nogc;
    void addAll(T[] otherArray) @nogc;
    void addAll(size_t index, T[] otherArray) @nogc;
    void addAll(List!T otherList) @nogc;
    void addAll(size_t index, List!T otherList) @nogc;
    size_t capacity() @nogc;
    void clear() @nogc;
    bool contains(T elem) @nogc;
    bool containsAll(T[] otherArray) @nogc;
    bool containsAll(List!T otherList) @nogc;
    T get(size_t index) @nogc;
    ref T getRef(size_t index) @nogc;
    long indexOf(T elem) @nogc;
    bool isEmpty() @nogc;
    long lastIndexOf(T elem) @nogc;
    size_t length() @nogc;
    void remove(size_t index) @nogc;
    void removeAll(T[] otherArray) @nogc;
    void removeAll(List!T otherList) @nogc;
    void reserve(size_t numReserve);
    void set(size_t index, T elem) @nogc;
    T[] subArray(size_t indexFrom, size_t toIndex) @nogc;
    T[] toArray() @nogc;

    mixin ListOperatorOverload!T;
}