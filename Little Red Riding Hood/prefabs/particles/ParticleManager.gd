extends Node2D



var particles = {
    "blood": preload("res://prefabs/particles/BloodParticles.tscn")
   }

# Called when the node enters the scene tree for the first time.
func _ready():
    add_to_group("ParticleManager")

# Called every frame. 'delta' is the elapsed time since the previous frame.ddddd
#func _process(delta):
#	pass

#func spawn_blood():
#    var new_particle = particles["blood"].instance()
#    add_child(new_particle)
#    new_particle.emitting = true
    
    
func spawn_particle(particle_name, coordinates):
    if not particle_name in particles.keys():
        return
        
    var new_particle = particles[particle_name].instance()
    new_particle.position = coordinates
    add_child(new_particle)

    new_particle.emitting = true
    
