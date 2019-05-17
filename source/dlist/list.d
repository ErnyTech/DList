// Written in the D programming language.
/**
Main interface to implement lists with the DList API.

This module provides an abstraction between the implementation and the API

Copyright: Copyright 2019 Ernesto Castellotti <erny.castell@gmail.com>
License:   $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).
Authors:   $(HTTP github.com/ErnyTech, Ernesto Castellotti)
*/
module dlist.list;

import dlist.baselist;

interface List(T) {
    /**
     * Adds the specified item to the end of the list.
     *
     * This function could cause a memory reallocation if the capacity of the list is not sufficient to contain the item to be added.
     *
     * Params:
     *      elem = element to add to the list
     */
    void add(T elem) @nogc;
    
    /**
     * Adds the specified item to the list to the specified index.
     *
     * This function could cause a memory reallocation if the capacity of the list is not sufficient to contain the item to be added or index <= 
length of the list.
     *
     * Params:
     *      index = index in which to place the element
     *      elem = element to add to the list
     */
    void add(size_t index, T elem) @nogc;
    
    /**
     * Adds the elements contained in the array passed to the function at the end of the list.
     *
     * This function could cause a memory reallocation if the capacity of the list is not sufficient to contain the items.
     *
     * Params:
     *      otherArray = the array that contains the elements to add to the list
     */
    void addAll(T[] otherArray) @nogc;
    
    /**
     * Adds the elements contained in the array passed to the function the list to the specified index.
     * The first element of the array will be inserted at the specified index, then the other indexes of the other elements will be incremental
     *
     * This function could cause a memory reallocation if the capacity of the list is not sufficient to contain the items or index <= 
length of the list.
     *
     * Params:
     *      index = index in which to place the elements
     *      otherArray = the array that contains the elements to add to the list
     */
    void addAll(size_t index, T[] otherArray) @nogc;
    
    /**
     * Adds the elements contained in the DList passed to the function at the end of the list
     *
     * This function could cause a memory reallocation if the capacity of the list is not sufficient to contain the items
     *
     * Params:
     *      otherList = the DList that contains the elements to add to the list
     */
    void addAll(List!T otherList) @nogc;

    /**
     * Adds the elements contained in the DList passed to the function the list to the specified index.
     * The first element of the DList will be inserted at the specified index, then the other indexes of the other elements will be incremental
     *
     * This function could cause a memory reallocation if the capacity of the list is not sufficient to contain the items or index <= 
length of the list.
     *
     * Params:
     *      index = index in which to place the elements
     *      otherList = the DList that contains the elements to add to the list
     */
    void addAll(size_t index, List!T otherList) @nogc;
    
    /**
     * Returns the current capacity of the list.
     * This capacity is not the maximum that the DList can obtain, it only indicates the current availability without allocating further memory
     *
     * Returns:
     *      the capacity of the array
     */
    size_t capacity() @nogc;
    
    /**
     * Removes all the elements of the array and deallocate all the memory.
     */
    void clear() @nogc;
    
    /**
     * Returns true if the specified element is contained within the list.
     *
     * Params:
     *      elem = element whose presence in this list must be tested
     *
     * Returns:
     *      true if this list contains the specified element
     */
    bool contains(T elem) @nogc;
    
    /**
     * Returns true if the specified elements in the array are contained within the list.
     *
     * Params:
     *      otherArray = array containing the elements to be tested
     *
     * Returns:
     *      true if this list contains the specified elements
     */
    bool containsAll(T[] otherArray) @nogc;
    
    /**
     * Returns true if the specified elements in the DList are contained within the list.
     *
     * Params:
     *      otherList = DList containing the elements to be tested
     *
     * Returns:
     *      true if this list contains the specified elements
     */
    bool containsAll(List!T otherList) @nogc;
    
    /**
     * Returns the element contained in the list at the specified index.
     *
     * Params:
     *      index = the position of the list from which to take the element
     *
     * Returns:
     *      the element contained in the specified index
     */
    T get(size_t index) @nogc;
    
    /**
     * Returns by reference the element contained in the list at the specified index.
     *
     * Params:
     *      index = the position of the list from which to take the element
     *
     * Returns:
     *      the element contained in the specified index by reference
     */
    ref T getRef(size_t index) @nogc;
    
    /**
     * Returns the index of the first occurrence of the specified element in this list, or -1 if this list does not contain the element.
     *
     * Params:
     *      elem = element to search for
     *
     * Returns:
     *      the index of the first occurrence of the specified element or -1 if this list does not contain the element
     */
    long indexOf(T elem) @nogc;
    
    /**
     * Returns true if no element is present in the list.
     *
     * Returns:
     *      true if no element is present in the list
     */
    bool isEmpty() @nogc;
    
    /**
     * Returns the index of the last occurrence of the specified element in this list, or -1 if this list does not contain the element.
     *
     * Params:
     *      elem = element to search for
     *
     * Returns:
     *      the index of the last occurrence of the specified element or -1 if this list does not contain the element
     */
    long lastIndexOf(T elem) @nogc;
    
    /**
     * Returns the number of items in the list.
     *
     * Returns:
     *      the number of items in the list
     */
    size_t length() @nogc;
    
    /**
     * Remove the element at the specified index.
     *
     * This function could cause a memory reallocation.
     *
     * Params:
     *      index = the index of the element to be removed
     */
    void remove(size_t index) @nogc;
    
    /**
     * Removes all the elements contained in the array from the list (looking for their index).
     *
     * This function could cause a memory reallocation.
     *
     * Params:
     *      otherArray = the array of items that need to be removed
     */
    void removeAll(T[] otherArray) @nogc;
    
    /**
     * Removes all the elements contained in the DList from the list (looking for their index).
     *
     * This function could cause a memory reallocation.
     *
     * Params:
     *      otherList = the DList of items that need to be removed
     */
    void removeAll(List!T otherList) @nogc;
    
    /**
     * Asks the implementation of the list to increase the capacity of the list than specified, the implementation MAY increase the allocated memory but it is NOT REQUIRED to do so.
     * It is possible that in some implementations this method is simply ignored.
     *
     * This function could cause a memory reallocation.
     *
     * Params:
     *      numReserve = the amount of capacity to be increased
     */
    void reserve(size_t numReserve);
    
    /**
     * Replaces the element at the specified position with the specified element.
     *
     * Params:
     *      index = the position of the element to be replaced
     *      elem = the element that must be stored at the specified position
     */
    void set(size_t index, T elem) @nogc;
    
    /**
     * Generate and return an array from the specified portion of the list.
     *
     * Params:
     *      indexFrom = the initial index from which to start the array
     *      toIndex = the final index from which to finish the array
     *
     * Returns:
     *      the array specified by the range of index
     */
    T[] subArray(size_t indexFrom, size_t toIndex) @nogc;
    
    /**
     * Returns an array containing all the elements of the list
     *
     * Returns:
     *      an array containing all the elements of the list
     */
    T[] toArray() @nogc;

    mixin ListOperatorOverload!T;
}
