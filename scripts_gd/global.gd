#This is where I will define global variables and functions

extends Node

func findNode(nodeName):
    return get_node('/root').find_node('rightHandGrab', true, false)