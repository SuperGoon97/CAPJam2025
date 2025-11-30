class_name ThrusterParticle extends Node3D

@onready var fire: GPUParticles3D = $Fire

func start():
	fire.emitting = true

func stop():
	fire.emitting = false
