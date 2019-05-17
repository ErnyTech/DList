// Written in the D programming language.
/**
This module provides the necessary utility methods, to be used only internally
Copyright: Copyright 2019 Ernesto Castellotti <erny.castell@gmail.com>
License:   $(HTTP https://www.mozilla.org/en-US/MPL/2.0/, Mozilla Public License - Version 2.0).
Authors:   $(HTTP github.com/ErnyTech, Ernesto Castellotti)
*/
module dlist.baselist;

mixin template ListOperatorOverload(T) {
    @nogc final auto opBinary(string op)(T elem) if(op == "+" || op == "~") {
        add(elem);
        return this;
    }

    @nogc final auto opBinary(string op)(T[] otherArray) if(op == "+" || op == "~") {
        addAll(otherArray);
        return this;
    }

    @nogc final auto opBinary(string op)(List!T otherList) if(op == "+" || op == "~") {
        addAll(otherList);
        return this;
    }

    @nogc final ref auto opIndex(ulong index) {
        return getRef(index);
    }

    @nogc final auto opSlice(this T)(size_t a, size_t b) {
        return subArray(a, b);
    }

    @nogc final auto opSlice(this T)() {
        return opSlice!(T)(0, length);
    }

    final int opApply(scope int delegate(ref T) operations) {
        return opApply(operations);
    }

    @nogc final int opApply(scope int delegate(ref T) @nogc operations) {
        return opApply(operations);
    }

    final int opApply(scope int delegate(ulong index, ref T) operations) {
        return implOpApplyIndex(operations);
    }

    @nogc final int opApply(scope int delegate(ulong index, ref T) @nogc operations) {
        return implOpApplyIndex(operations);
    }

    final int implOpApply(O)(O operations) {
        int result = 0;

        foreach(elem; toArray) {
            result = operations(elem);

            if(result) {
                break;
            }
        }

        return result;
    }

    final int implOpApplyIndex(O)(O operations) {
        int result = 0;

        foreach(i, elem; toArray) {
            result = operations(i, elem);

            if(result) {
                break;
            }
        }

        return result;
    }

    final int opApplyReverse(int delegate(ref T) operations) {
        return implOpApplyReverse(operations);
    }

    @nogc final int opApplyReverse(int delegate(ref T) @nogc operations) {
        return implOpApplyReverse(operations);
    }

    final int opApplyReverse(scope int delegate(ulong index, ref T) operations) {
       return implOpApplyReverseIndex(operations);
    }

    @nogc final int opApplyReverse(scope int delegate(ulong index, ref T) @nogc operations) {
       return implOpApplyReverseIndex(operations);
    }

    final int implOpApplyReverse(O)(O operations) {
        int result = 0;

        foreach_reverse(elem; toArray) {
            result = operations(elem);

            if(result) {
                break;
            }
        }

        return result;
    }

    final int implOpApplyReverseIndex(O)(O operations) {
        int result = 0;

        foreach_reverse(i, elem; toArray) {
            result = operations(i, elem);

            if(result) {
                break;
            }
        }

        return result;
    }

    @nogc final auto opOpAssign(string op)(T elem) if(op == "+" || op == "~") {
        add(elem);
        return this;
    }

    @nogc final auto opOpAssign(string op)(T[] otherArray) if(op == "+" || op == "~") {
        addAll(elem);
        return this;
    }

    @nogc final auto opOpAssign(string op)(List!T otherList) if(op == "+" || op == "~") {
        addAll(otherList);
        return this;
    }
}

mixin template AllocatorInit(Allocator) {
    import stdx.allocator.common : stateSize;

	static if (stateSize!Allocator == 0) {
		alias allocator = Allocator.instance;
    } else {
		Allocator allocator;
    }
}

mixin template UseGC(T) {
	import std.traits : hasIndirections;
	enum useGC = hasIndirections!T;
}
