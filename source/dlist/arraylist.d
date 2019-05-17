// Written in the D programming language.
/**
This module provides an implementation of DList
Copyright: Copyright 2019 Ernesto Castellotti <erny.castell@gmail.com>
License:   $(HTTP https://www.mozilla.org/en-US/MPL/2.0/, Mozilla Public License - Version 2.0).
Authors:   $(HTTP github.com/ErnyTech, Ernesto Castellotti)
*/
module dlist.arraylist;
import stdx.allocator.mallocator : Mallocator;
import dlist.list : List;
import dlist.baselist : AllocatorInit, UseGC;

enum DEFAULT_CAPACITY = 1;
enum BIG_ARRAY = 512;
enum BIG_ARRAY_INCREASE_CAPACITY = 1024;
/**
 * ArrayList is a DList implementation of an array with resizable dimensions without using the GC
 */
class ArrayList(T, Allocator = Mallocator) : List!T {
    private T[] data;
    private size_t size = 0;
    mixin AllocatorInit!Allocator;
    mixin UseGC!T;

    /**
     * Initialize ArrayList with the default capacity size (10).
     *
     * This function cause a memory allocation.
     */
    this() @nogc {
        import stdx.allocator : makeArray;

        this.data = this.allocator.makeArray!T(DEFAULT_CAPACITY);

        static if (useGC) {
            import core.memory : GC;
            GC.addRange(this.data.ptr, this.length * T.sizeof);
        }
    }

    /**
     * Initialize ArrayList by adding the specified array to the top of the list, the capacity of the list will be equal to the length of the specified array.
     *
     * This function cause a memory allocation.
     *
     * Params:
     *      initialArray = the array containing the initial elements
     */
    this(T[] initialArray) @nogc {
        import stdx.allocator : makeArray;

        this.data = this.allocator.makeArray!T(initialArray.length);
        this.data[0..initialArray.length] = initialArray[0..initialArray.length];
        this.size += initialArray.length;

        static if (useGC) {
            import core.memory : GC;
            GC.addRange(this.data.ptr, this.length * T.sizeof);
        }
    }

    /**
     * Initialize ArrayList by adding the specified DList to the top of the list, the capacity of the list will be equal to the length of the specified DList.
     *
     * This function cause a memory allocation.
     *
     * Params:
     *      initialList = the DList containing the initial elements
     */
    this(List!T initialList) @nogc {
        import stdx.allocator : makeArray;

        this.data = this.allocator.makeArray!T(initialList.length);
        this.data[0..initialList.length] = initialList.toArray[0..initialList.length];
        this.size += initialList.length;

        static if (useGC) {
            import core.memory : GC;
            GC.addRange(this.data.ptr, this.length * T.sizeof);
        }
    }

    /**
     * Initialize ArrayList with the specified capacity size.
     *
     * This function cause a memory allocation.
     *
     * Params:
     *      initialCapacity = the initial capacity of the list
     */
    this(size_t initialCapacity) @nogc {
        import stdx.allocator : makeArray;

        this.data = this.allocator.makeArray!T(initialCapacity);

        static if (useGC) {
            import core.memory : GC;
            GC.addRange(this.data.ptr, this.length * T.sizeof);
        }
    }

    /**
     * Destroys the list and disallocates all previously allocated memory.
     */
    ~this() @nogc {
        clear();
    }

    void add(T elem) @nogc {
        ensureCapacity(this.size + 1);
        this.data[this.size] = elem;
        this.size += 1;
    }

    void add(size_t index, T elem) @nogc {
        import core.stdc.string : memcpy;

        if (index < this.size) {
            ensureCapacity(this.size + 1);
            memcpy(&(this.data[index + 1]), &(this.data[index]), (this.size - index) * T.sizeof);
            this.data[index] = elem;
            this.size += 1;

            static if (useGC) {
                import core.memory: GC;
                GC.removeRange(this.data.ptr);
            }

        } else {
            ensureCapacity(index + 1);
            this.data[index] = elem;
            this.size = index + 1;
        }
    }

    void addAll(T[] otherArray) @nogc {
        ensureCapacity(this.size + otherArray.length);
        this.data[this.size .. this.size + otherArray.length] = otherArray[0.. otherArray.length];
        this.size += otherArray.length;
    }

    void addAll(size_t index, T[] otherArray) @nogc {
        foreach(i, elem; otherArray) {
            add(index + i, elem);
        }
    }

    void addAll(List!T otherList) @nogc {
        addAll(otherList.toArray);
    }

    void addAll(size_t index, List!T otherList) @nogc {
        addAll(index, otherList.toArray);
    }

    size_t capacity() @nogc {
        return this.data.length;
    }

    void clear() @nogc {
        import stdx.allocator : dispose;
        import stdx.allocator.mallocator : Mallocator;

        static if (useGC) {
            import core.memory : GC;
            GC.removeRange(this.data.ptr);
        }

        this.size = 0;
        this.allocator.dispose(this.data);
    }

    bool contains(T elem) @nogc {
        return indexOf(elem) >= 0;
    }

    bool containsAll(T[] otherArray) @nogc {
        foreach(elem; otherArray) {
            if(!contains(elem)) {
                return false;
            }
        }

        return true;
    }

    bool containsAll(List!T otherList) @nogc {
        return containsAll(otherList.toArray);
    }

    T get(size_t index) @nogc {
        return this.data[index];
    }

    ref T getRef(size_t index) @nogc {
        return this.data[index];
    }

    long indexOf(T elem) @nogc {
        foreach(i, arrayElem; this.data) {
            if(arrayElem == elem) {
                return i;
            }
        }

        return -1;
    }

    bool isEmpty() @nogc {
        return this.size == 0;
    }

    long lastIndexOf(T elem) @nogc {
        foreach_reverse(i, arrayElem; this.data) {
            if(arrayElem == elem) {
                return i;
            }
        }

        return -1;
    }

    size_t length() @nogc {
        return this.size;
    }

    void remove(size_t index) @nogc {
        import stdx.allocator : shrinkArray;
        import std.algorithm.mutation : remove;

        this.data.remove(index);
        this.size -= 1;
        this.allocator.shrinkArray(this.data, 1);

        static if (useGC) {
            import core.memory: GC;

            GC.removeRange(this.data.ptr);
            GC.addRange(this.data.ptr, this.data.length * T.sizeof);
        }
    }

    void removeAll(T[] otherArray) @nogc {
        foreach(elem; otherArray) {
            auto index = indexOf(elem);

            if(index >= 0) {
                remove(index);
            }
        }
    }

    void removeAll(List!T otherList) @nogc {
        removeAll(otherList.toArray);
    }

    void set(size_t index, T elem) @nogc {
        this.data[index] = elem;
    }

    void reserve(size_t numReserve) @nogc {
        ensureCapacity(this.size + numReserve);
    }
 
    T[] subArray(size_t indexFrom, size_t toIndex) @nogc {
        return this.data[indexFrom .. toIndex];
    }

    T[] toArray() @nogc {
        return subArray(0, this.size);
    }

    private void ensureCapacity(size_t minCapacity) @nogc {
        import stdx.allocator : expandArray;

        if (minCapacity <= this.data.length) {
            return;
        }

        auto newCapacity = this.data.length > BIG_ARRAY ? this.data.length + BIG_ARRAY_INCREASE_CAPACITY : this.data.length << 1;

        if (minCapacity > newCapacity) {
            newCapacity = minCapacity;
        }

        auto deltaSize = newCapacity - this.data.length;
        this.allocator.expandArray(this.data, deltaSize);

        static if (useGC) {
            import core.memory: GC;

            GC.addRange(this.data.ptr, this.data.length * T.sizeof);
        }
    }
}
