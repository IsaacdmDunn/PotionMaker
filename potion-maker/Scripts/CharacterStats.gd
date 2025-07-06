extends Node3D

var baseStats: Stats
var modifiedStats: Stats

var effects: Array[Effect]

func _init() -> void:
	modifiedStats = Stats.new()
