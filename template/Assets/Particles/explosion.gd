extends Node3D

@onready var sparks: GPUParticles3D = $Sparks
@onready var smoke: GPUParticles3D = $Smoke
@onready var fire: GPUParticles3D = $Fire

func _ready() -> void:
	sparks.emitting = true
	smoke.emitting = true
	fire.emitting = true
	var new_promise:Promise = Promise.new([sparks.finished,smoke.finished,fire.finished])
	await new_promise.all
	queue_free()
